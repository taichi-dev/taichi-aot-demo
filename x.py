import taichi.aot.dr.gfxruntime140 as dr
import taichi.aot.sr.gfxruntime140 as sr
import taichi as ti
import json

def load_text(filename):
    with open(filename) as f:
        return f.read()

metadata_s = load_text('4_texture_fractal/assets/fractal/metadata.json')
metadata_j = json.loads(metadata_s)
metadata_dr = dr.from_json_metadata(metadata_j)
metadata_sr = sr.from_dr_metadata(metadata_dr)

graphs_s = load_text('4_texture_fractal/assets/fractal/graphs.json')
graphs_j = json.loads(graphs_s)
graphs_dr = [dr.from_json_graph(graph) for graph in graphs_j]
graphs_sr = [sr.from_dr_graph(metadata_sr, graph) for graph in graphs_dr]

graphs_dr2 = [sr.to_dr_graph(graph) for graph in graphs_sr]
graphs_j2 = [dr.to_json_graph(graph) for graph in graphs_dr2]
graphs_s2 = json.dumps(graphs_j2, indent=2)
with open('4_texture_fractal/assets/fractal/graphs2.json', 'w') as f:
    f.write(graphs_s2)
