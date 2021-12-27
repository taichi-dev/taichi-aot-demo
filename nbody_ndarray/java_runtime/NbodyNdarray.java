package com.example.mpm88ndarray;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.opengl.GLES32;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.stream.Collectors;

public class NbodyNdarray implements GLSurfaceView.Renderer {
    private Context context;
    private int render_program;
    private int global_tmp_buf;
    private int[] arg_buf;
    private int buf_cnt;
    private int color_buf;
    private Program[] programs;
    private Ndarray[] ndarrays;
    private final int NDARRAY_SIZE = 3;
    private final int NUM_PARTICLE = 500;
    private final String[] kernel_names = {"initialize", "compute_force"};

    private IntBuffer args;
    private FloatBuffer color;

    public NbodyNdarray(Context _context) {
        context = _context;
        // Open Json file.
        JSONParser parser = new JSONParser();
        InputStream jsonfile = this.context.getResources().openRawResource(R.raw.metadata);
        JSONObject nbody;
        try {
            nbody = (JSONObject) parser.parse(new InputStreamReader(jsonfile, "utf-8"));
            jsonfile.close();
        } catch (Exception e) {
            Log.e("ERR", "NbodyNdarray: exception when parsing json: " + e);
            return;
        }

        // -----------------------------------------------------------------------------------------
        // Parse Json data.
        parseJsonData(nbody);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        // Compile compute shaders and link compute programs.
        compileComputeShaders();
        // Compile render shaders and link render program.
        compileRenderShaders();
        // Fill some data to buffers.
        fillData();
        // Generate SSBOs.
        generateSSBO();
        // Run init kernel once at the beginning.
        init();
    }

    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) {
        GLES32.glViewport(0, 0, width, height);
    }

    @Override
    public void onDrawFrame(GL10 gl) {
        // Clear color.
        GLES32.glClearColor(0f, 0f, 0f, 1f);
        GLES32.glClear(GLES32.GL_COLOR_BUFFER_BIT);

        // Run substep kernel, pass in the number of substep you want to run per frame.
        substep(10);

        // Render point to the screen.
        render();
    }

    private void parseJsonData(JSONObject nbody) {
        JSONObject json_programs = (JSONObject) ((JSONObject) nbody.get("aot_data")).get("kernels");
        programs = new Program[json_programs.size()];
        ndarrays = new Ndarray[NDARRAY_SIZE];
        for (int i = 0; i < json_programs.size(); i++) {
            // Initialize program & kernel data structure.
            JSONObject cur_json_program = (JSONObject) json_programs.get(kernel_names[i]);
            JSONArray json_kernels = (JSONArray) cur_json_program.get("tasks");
            Kernel[] kernels = new Kernel[json_kernels.size()];
            Iterator json_kernel_iterator = json_kernels.iterator();
            int k = 0;
            while (json_kernel_iterator.hasNext()) {
                JSONObject cur_json_kernel = (JSONObject) json_kernel_iterator.next();
                kernels[k] = new Kernel(
                        (String) cur_json_kernel.get("name"),
                        ((Long) cur_json_kernel.get("workgroup_size")).intValue(),
                        ((Long) cur_json_kernel.get("num_groups")).intValue()
                );
                k++;
            }

            JSONObject json_bind_idx = (JSONObject) cur_json_program.get("used.arr_arg_to_bind_idx");
            Integer[] bind_idx = new Integer[json_bind_idx.size()];
            for (int j = 0; j < json_bind_idx.size(); j++) {
                bind_idx[j] = ((Long) json_bind_idx.get(String.valueOf(j))).intValue();
            }
            programs[i] = new Program(kernels, bind_idx);

            // Initialize ndarray data structure.
            JSONObject json_cur_ndarrays = (JSONObject) cur_json_program.get("arr_args");
            for (int j = 0; j < json_cur_ndarrays.size(); j++) {
                JSONObject json_ndarray = (JSONObject) json_cur_ndarrays.get(String.valueOf(j));
                int dim = ((Long) json_ndarray.get("field_dim")).intValue();
                int[] shape = new int[dim];
                // Hardcode every shape you want to the specific ndarray.
                for (int d = 0; d < dim; d++) {
                    shape[d] = NUM_PARTICLE;
                }
                JSONArray json_element_array = (JSONArray) json_ndarray.get("element_shape");
                int[] element_shape = new int[json_element_array.size()];
                Iterator json_element_array_iterator = json_element_array.iterator();
                int c = 0;
                while (json_element_array_iterator.hasNext()) {
                    element_shape[c] = ((Long) json_element_array_iterator.next()).intValue();
                    c++;
                }
                int total_size = 1;
                for (int z = 0; z < shape.length; z++) {
                    total_size *= shape[z];
                }
                for (int z = 0; z < element_shape.length; z++) {
                    total_size *= element_shape[z];
                }
                ndarrays[j] = new Ndarray(
                        dim,
                        ((Long) json_ndarray.get("shape_offset_in_bytes_in_args_buf")).intValue(),
                        total_size * 4,
                        shape,
                        element_shape
                );
            }
        }
    }

    private void generateSSBO() {
        int[] temp = new int[1];
        GLES32.glGenBuffers(1, temp, 0);
        color_buf = temp[0];
        GLES32.glGenBuffers(1, temp, 0);
        global_tmp_buf = temp[0];
        for (int i = 0; i < ndarrays.length; i++) {
            GLES32.glGenBuffers(1, temp, 0);
            ndarrays[i].setSsbo(temp[0]);
        }

        arg_buf = new int[32];
        buf_cnt = 0;
        GLES32.glGenBuffers(32, arg_buf, 0);

        for (int i = 0; i < 32; i++) {
            GLES32.glBindBuffer(GLES32.GL_SHADER_STORAGE_BUFFER, arg_buf[i]);
            GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 64*5, args, GLES32.GL_STATIC_READ);
        }
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    private void compileComputeShaders() {
        for (int i = 0; i < programs.length; i++) {
            Kernel[] cur_kernels = programs[i].getKernels();
            for (int j = 0; j < cur_kernels.length; j++) {
                int shader = GLES32.glCreateShader(GLES32.GL_COMPUTE_SHADER);
                InputStream raw_shader = this.context.getResources().openRawResource(this.context.getResources().getIdentifier(
                        cur_kernels[j].getName(), "raw", this.context.getPackageName()
                ));
                String string_shader = new BufferedReader(
                        new InputStreamReader(raw_shader, StandardCharsets.UTF_8))
                        .lines()
                        .collect(Collectors.joining("\n"));
                try {
                    raw_shader.close();
                } catch (Exception e) {
                    Log.e("ERR", "onSurfaceCreated: error in closing input stream: " + e);
                    return;
                }

                GLES32.glShaderSource(shader, string_shader);
                GLES32.glCompileShader(shader);
                final int[] compileStatus = new int[1];
                GLES32.glGetShaderiv(shader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);
                if (compileStatus[0] == 0) {
                    GLES32.glDeleteShader(shader);
                    shader = 0;
                }
                if (shader == 0) {
                    throw new RuntimeException("Error creating compute shader: " + GLES32.glGetShaderInfoLog(shader));
                }

                int shader_program = GLES32.glCreateProgram();
                GLES32.glAttachShader(shader_program, shader);
                GLES32.glLinkProgram(shader_program);
                final int[] linkStatus = new int[1];
                GLES32.glGetProgramiv(shader_program, GLES32.GL_LINK_STATUS, linkStatus, 0);
                if (linkStatus[0] == 0) {
                    GLES32.glDeleteProgram(shader_program);
                    shader_program = 0;
                }
                if (shader_program == 0) {
                    throw new RuntimeException("Error creating program: " + GLES32.glGetProgramInfoLog(shader_program));
                }
                cur_kernels[j].setShader_program(shader_program);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void compileRenderShaders() {
        int mVertShader = GLES32.glCreateShader(GLES32.GL_VERTEX_SHADER);
        int mFragShader = GLES32.glCreateShader(GLES32.GL_FRAGMENT_SHADER);
        InputStream rawVertShader = this.context.getResources().openRawResource(R.raw.vertshader);
        String stringVertShader = new BufferedReader(
                new InputStreamReader(rawVertShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        InputStream rawFragShader = this.context.getResources().openRawResource(R.raw.fragshader);
        String stringFragShader = new BufferedReader(
                new InputStreamReader(rawFragShader, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        try {
            rawVertShader.close();
            rawFragShader.close();
        } catch (Exception e) {
            System.out.println(e.toString());
            return;
        }
        GLES32.glShaderSource(mVertShader, stringVertShader);
        GLES32.glCompileShader(mVertShader);
        final int[] compileStatus = new int[1];
        GLES32.glGetShaderiv(mVertShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);

        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mVertShader);
            mVertShader = 0;
        }
        if (mVertShader == 0)
        {
            throw new RuntimeException("Error creating vertex shader.");
        }
        GLES32.glShaderSource(mFragShader, stringFragShader);
        GLES32.glCompileShader(mFragShader);
        GLES32.glGetShaderiv(mFragShader, GLES32.GL_COMPILE_STATUS, compileStatus, 0);

        // If the compilation failed, delete the shader.
        if (compileStatus[0] == 0)
        {
            GLES32.glDeleteShader(mFragShader);
            mFragShader = 0;
        }
        if (mFragShader == 0)
        {
            throw new RuntimeException("Error creating fragment shader.");
        }
        render_program = GLES32.glCreateProgram();
        if (render_program != 0) {
            GLES32.glAttachShader(render_program, mVertShader);
            GLES32.glAttachShader(render_program, mFragShader);
            GLES32.glLinkProgram(render_program);
            final int[] linkStatus = new int[1];
            GLES32.glGetProgramiv(render_program, GLES32.GL_LINK_STATUS, linkStatus, 0);

            // If the link failed, delete the program.
            if (linkStatus[0] == 0)
            {
                GLES32.glDeleteProgram(render_program);
                render_program = 0;
            }
        }
        if (render_program == 0)
        {
            throw new RuntimeException("Error creating program.");
        }
    }

    private void fillData() {
        // Fill shape info into arg buffer.
        int[] data = new int[8*8+16];
        for (int i = 0; i < ndarrays.length; i++) {
            int[] shape = ndarrays[i].getShape();
            int[] element_shape = ndarrays[i].getElement_shape();
            int offset = ndarrays[i].getShape_offset() / 4;
            for (int j = 0; j < shape.length; j++) {
                data[offset + j] = shape[j];
            }
            for (int j = 0; j < element_shape.length; j++) {
                data[offset + j + shape.length] = element_shape[j];
            }
        }
        args = ByteBuffer.allocateDirect(data.length*4).order(ByteOrder.nativeOrder()).asIntBuffer();
        args.put(data).position(0);

        // Fill color info into color buffer.
        float[] data_v = new float[NUM_PARTICLE*4];
        for (int i = 0 ; i < NUM_PARTICLE*4; i++) {
            data_v[i] = 0.9f;
        }
        color = ByteBuffer.allocateDirect(data_v.length * 4).order(ByteOrder.nativeOrder()).asFloatBuffer();
        color.put(data_v).position(0);
    }

    private void init() {
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 1, global_tmp_buf);
        GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, 80, null, GLES32.GL_STATIC_COPY);
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 2, arg_buf[buf_cnt]);
        buf_cnt++;
        Integer[] bind_idx = programs[0].getBind_idx();
        for (int i = 0; i < bind_idx.length; i++) {
            GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, bind_idx[i], ndarrays[i].getSsbo());
            if (!ndarrays[i].init) {
                GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, ndarrays[i].getTotal_size(), null, GLES32.GL_DYNAMIC_COPY);
                ndarrays[i].init = true;
            }
        }
        Kernel[] init_kernel = programs[0].getKernels();
        for (int i = 0; i < init_kernel.length; i++) {
            GLES32.glUseProgram(init_kernel[i].getShader_program());
            GLES32.glMemoryBarrierByRegion(GLES32.GL_SHADER_STORAGE_BARRIER_BIT);
            GLES32.glDispatchCompute(init_kernel[i].getNum_groups(), 1, 1);
        }
        for (int i = 0; i < bind_idx.length; i++) {
            GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, bind_idx[i], 0);
        }
    }

    private void substep(int step) {
        if (buf_cnt == 32) buf_cnt = 0;
        GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, 2, arg_buf[buf_cnt]);
        buf_cnt++;
        Integer[] bind_idx = programs[1].getBind_idx();
        Kernel[] substep_kernel = programs[1].getKernels();
        for (int j = 0; j < bind_idx.length; j++) {
            GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, bind_idx[j], ndarrays[j].getSsbo());
            if (!ndarrays[j].init) {
                GLES32.glBufferData(GLES32.GL_SHADER_STORAGE_BUFFER, ndarrays[j].getTotal_size(), null, GLES32.GL_DYNAMIC_COPY);
                ndarrays[j].init = true;
            }
        }
        for (int i = 0; i < step; i++) {
            for (int j = 0; j < substep_kernel.length; j++) {
                GLES32.glUseProgram(substep_kernel[j].getShader_program());
                GLES32.glMemoryBarrierByRegion(GLES32.GL_SHADER_STORAGE_BARRIER_BIT);
                GLES32.glDispatchCompute(substep_kernel[j].getNum_groups(), 1, 1);
            }
        }
        for (int j = 0; j < bind_idx.length; j++) {
            GLES32.glBindBufferBase(GLES32.GL_SHADER_STORAGE_BUFFER, bind_idx[j], 0);
        }
    }

    private void render() {
        //GLES32.glMemoryBarrier(GLES32.GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT);

        GLES32.glUseProgram(render_program);
        GLES32.glBindBuffer(GLES32.GL_ARRAY_BUFFER, ndarrays[0].getSsbo());
        GLES32.glEnableVertexAttribArray(0);
        GLES32.glVertexAttribPointer(0, 2, GLES32.GL_FLOAT, false, 2*4, 0);

        GLES32.glBindBuffer(GLES32.GL_ARRAY_BUFFER, color_buf);
        GLES32.glBufferData(GLES32.GL_ARRAY_BUFFER, NUM_PARTICLE*4*4, color, GLES32.GL_STATIC_DRAW);
        GLES32.glEnableVertexAttribArray(1);
        GLES32.glVertexAttribPointer(1, 4, GLES32.GL_FLOAT, false, 4*4, 0);

        GLES32.glDrawArrays(GLES32.GL_POINTS, 0, NUM_PARTICLE);
    }
}
