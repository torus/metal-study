//
//  Shaders.metal
//  metal-game-study
//
//  Created by Toru Hisai on 2017/12/23.
//  Copyright © 2017年 Toru Hisai. All rights reserved.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "ShaderTypes.h"

using namespace metal;

typedef struct
{
    float3 position [[attribute(VertexAttributePosition)]];
    float2 texCoord [[attribute(VertexAttributeTexcoord)]];
} Vertex;

typedef struct
{
    float4 position [[position]];
    float2 texCoord;
} ColorInOut;

vertex ColorInOut vertexShader(Vertex in [[stage_in]],
                               constant Uniforms & uniforms [[ buffer(BufferIndexUniforms) ]])
{
    ColorInOut out;

    float4 position = float4(in.position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.texCoord = in.texCoord;

    return out;
}

fragment float4 fragmentShader(ColorInOut in [[stage_in]],
                               constant Uniforms & uniforms [[ buffer(BufferIndexUniforms) ]],
                               texture2d<half> colorMap     [[ texture(TextureIndexColor) ]])
{
    constexpr sampler colorSampler(mip_filter::linear,
                                   mag_filter::linear,
                                   min_filter::linear);

//    half4 colorSample   = colorMap.sample(colorSampler, in.texCoord.xy);
    half g = in.texCoord.xy[0];
    half r = in.texCoord.xy[1];
    half x = (r - uniforms.ovalParams.x) / uniforms.ovalParams.width;
    half y = (g - uniforms.ovalParams.y) / uniforms.ovalParams.height;
    half b = x * x + y * y < 1 ? 1 : 0;
    half4 colorSample   = {r, g, b, 1};

    return float4(colorSample);
}
