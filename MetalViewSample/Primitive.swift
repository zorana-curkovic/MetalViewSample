//
//  Primitive.swift
//  MetalViewSample
//
//  Created by Zorana Curkovic on 10/01/2021.
//

import MetalKit

class Primitive: Node {

    // Buffers
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    // BufferData
    var vertices: [Vertex]!
    var indices: [UInt16]!
    // States
    var renderPipelineState : MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    // Constraints
    var modelConstraints = ModelConstraints()
    
    init(withDevice device: MTLDevice) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        buildPipelineState(device: device)
        buildDepthStencil(device: device)
    }
    
    public func buildVertices()
    {
        
    }
    
    // makeBuffer(bytes:length:options:) - Allocates a new buffer of a given length and initializes its contents by copying existing data into it
    private func buildBuffers(device: MTLDevice)
    {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<Vertex>.stride * vertices.count,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: MemoryLayout<UInt16>.stride * indices.count,
                                        options: [])
    }
    
    private func buildPipelineState(device: MTLDevice) {
        let library = device.makeDefaultLibrary()
        // Retrieve the shader functions
        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        
        // Create the renderPipelineDescriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        // Create the VertexDescriptor = an object that describes how vertex data is organized and mapped to a vertex function
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        // Create the PipelineState
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func buildDepthStencil(device: MTLDevice) {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        commandEncoder.setRenderPipelineState(renderPipelineState)
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setDepthStencilState(depthStencilState)
        commandEncoder.setVertexBytes(&modelConstraints, length: MemoryLayout<ModelConstraints>.stride, index:1)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
    
}
