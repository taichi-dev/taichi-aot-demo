%.frag.spv : %.frag
	glslc --target-env=vulkan1.1 $< -o $@

%.vert.spv : %.vert
	glslc --target-env=vulkan1.1 $< -o $@

all: box.frag.spv surface.frag.spv surface.vert.spv

clean:
	rm -f *.spv
