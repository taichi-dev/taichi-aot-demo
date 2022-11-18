package com.example.mpm88ndarray;

public class Kernel {
    private String name;
    private int workgroup_size;
    private int num_groups;
    private int shader_program;

    public Kernel(String name, int workgroup_size, int num_groups) {
        this.name = name;
        this.workgroup_size = workgroup_size;
        this.num_groups = num_groups;
    }

    public String getName() {
        return name;
    }

    public int getWorkgroup_size() {
        return workgroup_size;
    }

    public int getNum_groups() {
        return num_groups;
    }

    public int getShader_program() {
        return shader_program;
    }

    public void setShader_program(int shader_program) {
        this.shader_program = shader_program;
    }
}
