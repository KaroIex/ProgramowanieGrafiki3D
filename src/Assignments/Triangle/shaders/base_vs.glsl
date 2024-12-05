#version 420

layout(location=0) in  vec4 a_vertex_position;
layout(location=1) in  vec2 a_vertex_texcoord;

out vec2 vertex_texcoords;

uniform Transformations {
    mat4 PVM;
 };

void main() {
    gl_Position = PVM * a_vertex_position;

    vertex_texcoords = a_vertex_texcoord;
}
