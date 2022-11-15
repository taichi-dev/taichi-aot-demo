#pragma once
#include "draws/draw_points.hpp"
#include "draws/draw_particles.hpp"
#include "draws/draw_mesh.hpp"
#include "draws/draw_texture.hpp"

namespace ti {
namespace aot_demo {

class Renderer;

class GraphicsRuntime : public ti::Runtime {
  template<class T>
  friend class InteropHelper;
  
  template<class T>
  friend class TextureHelper;
  
  std::shared_ptr<Renderer> renderer_;

public:
  GraphicsRuntime() : ti::Runtime() {}
  GraphicsRuntime(const std::shared_ptr<Renderer>& renderer);

  ti::NdArray<float> allocate_vertex_buffer(
    uint32_t vertex_count,
    uint32_t vertex_component_count,
    bool host_access = false
  );
  ti::NdArray<uint32_t> allocate_index_buffer(
    uint32_t index_count,
    uint32_t index_component_count,
    bool host_access = false
  );

  // Add your drawing functions here.
  DrawPointsBuilder draw_points(
    const ti::NdArray<float>& positions
  ) {
    return DrawPointsBuilder(renderer_, positions);
  }
  DrawParticlesBuilder draw_particles(
    const ti::NdArray<float>& positions
  ) {
    return DrawParticlesBuilder(renderer_, positions);
  }
  DrawMeshBuilder draw_mesh(
    const ti::NdArray<float>& positions,
    const ti::NdArray<uint32_t>& indices
  ) {
    return DrawMeshBuilder(renderer_, positions, indices);
  }
  DrawTextureBuilder draw_texture(
    const ti::Texture& texture
  ) {
    return DrawTextureBuilder(renderer_, texture);
  }
};

} // namespace aot_demo
} // namespace ti
