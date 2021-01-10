//
//  Types.swift
//  MetalViewSample
//
//  Created by Zorana Curkovic on 10/01/2021.
//

import MetalKit

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

struct ModelConstraints {
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstraints {
    var projectionMatrix = matrix_identity_float4x4
}

protocol Constraintable {
    func scale(axis: SIMD3<Float>)
    
    func translate(direction: SIMD3<Float>)
    
    func rotate(angle: Float, axis: SIMD3<Float>)
}
