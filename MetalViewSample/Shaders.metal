//
//  Shaders.metal
//  MetalViewSample
//
//  Created by Zorana Curkovic on 08/01/2021.
//

#include <metal_stdlib>
using namespace metal;

// Basic Struct to match our Swift type
// This is what is passed into the Vertex Shader

struct VertexIn {
    float3 position;
    float4 color;
};

// What is returned by the Vertex Shader
// This is what is passed into the Fragment Shader

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

vertex VertexOut basic_vertex_function(const device VertexIn *vertices [[ buffer(0) ]],
                                       uint vertexID [[ vertex_id ]]) {
    VertexOut vOut;
    vOut.position = float4(vertices[vertexID].position, 1);
    vOut.color = vertices[vertexID].color;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}


