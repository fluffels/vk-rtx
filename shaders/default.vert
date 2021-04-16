#version 450
#extension GL_ARB_separate_shader_objects : enable

#include "quaternions.glsl"
#include "uniforms.glsl"

layout(location=0) in vec4 inPosition;

void main() {
    vec4 p = inPosition;
    p -= uniforms.eye;
    p = rotate_vertex_position(uniforms.rotation, p);
    p = uniforms.proj * p;
    gl_Position = p;
}
