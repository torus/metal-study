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
    half x = in.texCoord.xy[0];
    half y = in.texCoord.xy[1];

    // Bezier
    float2 p = uniforms.bezierParams.points[0];
    float2 q = uniforms.bezierParams.points[1];
    float2 r = uniforms.bezierParams.points[2];
    float2 s = uniforms.bezierParams.points[3];
    
    float l2 = - p.y + 3 * q.y - 3 * r.y + s.y;
    float l1 = 2 * p.y - 4 * q.y + 2 * r.y;
    float l0 = - p.y + q.y;

    float m2 = - (- p.x + 3 * q.x - 3 * r.x + s.x);
    float m1 = - (2 * p.x - 4 * q.x + 2 * r.x);
    float m0 = - (- p.x + q.x);

    float u02 = - p.x - 2 * q.x + r.x;
    float u01 = - 2 * p.x + 2 * q.x;
    float u00 = p.x;
    
    float lu0_4 = l2 * u02;
    float lu0_3 = l1 * u02 + l2 * u01;
    float lu0_2 = l2 * u00 + l1 * u01 + l0 * u02;
    float lu0_1 = l0 * u01 + l1 * u00;
    float lu0_0 = l0 * u00;

    float u12 = - p.y - 2 * q.y + r.y;
    float u11 = - 2 * p.y + 2 * q.y;
    float u10 = p.y;
    
    float mu1_4 = m2 * u12;
    float mu1_3 = m1 * u12 + m2 * u11;
    float mu1_2 = m2 * u10 + m1 * u11 + m0 * u12;
    float mu1_1 = m0 * u11 + m1 * u10;
    float mu1_0 = m0 * u10;

    float a = - (lu0_4 + mu1_4);
    float b = (- (lu0_3 + mu1_3)) / a;
    float c = (l2 * x + m2 * y - (lu0_2 + mu1_2)) / a;
    float d = (l1 * x + m1 * y - (lu0_1 + mu1_1)) / a;
    float e = (l0 * x + m0 * y - (lu0_0 + mu1_0)) / a;
    
    float bb = b * b;
    float bbb = bb * b;
    float bbbb = bb * bb;
    float cc = c * c;
    float ccc = cc * c;
    float cccc = cc * cc;
    float dd = d * d;
    float ddd = dd * d;
    float dddd = dd * dd;
    float ee = e * e;
    float eee = ee * e;
    
    float D = - 108 * dd + 108 * b * c * d - 27 * bbb * d - 32 * ccc + 9 * bb * cc;
    float P = - 768 * e + 192 * b * d + 128 * cc - 144 * bb * c + 27 * bbbb;
    float Q = (384 * ee - 192 * b * d * e - 128 * cc * e + 144 * bb * c * e - 27 * bbbb * e
               + 72 * c * dd - 3 * bb * dd - 40 * b * cc * d + 9 * bbb * c * d + 8 * cccc
               - 2 * bb * ccc);
    float R = (- 256 * eee + 192 * b * d * ee + 128 * cc * ee - 144 * bb * c * ee
               + 27 * bbbb * ee - 144 * c * dd * e + 6 * bb * dd * e + 80 * b * cc * d * e
               - 18 * bbb * c * d * e -16 * cccc * e + 4 * bb * ccc * e + 27 * dddd - 18 * b * c * ddd
               + 4 * bbb * ddd + 4 * ccc * dd - bb * cc * dd);

    half red = 1;
    half green = R >= 0 ? 1 : 0;
    half blue = (D >= 0 && (P >= 0 || Q <= 0)) ? 1 : 0 + x / 2;
    half4 colorSample   = {red, green, blue, 1};
    
    return float4(colorSample);
}










