//
//  Renderer.swift
//  MetalViewSample
//
//  Created by Zorana Curkovic on 08/01/2021.
//

import MetalKit

//struct Vertex
//{
//    var position : SIMD3<Float>
//    var color: SIMD4<Float>
//}
class Renderer: NSObject {

    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var vertices: [Vertex] = [
        Vertex(position: SIMD3<Float>(0,0.5,0), color: SIMD4<Float>(1,0,0,1)),
        Vertex(position: SIMD3<Float>(-0.5,-0.5,0), color: SIMD4<Float>(0,1,0,1)),
        Vertex(position: SIMD3<Float>(0.5,-0.5,0), color: SIMD4<Float>(0,0,1,1))
    ]
    
    init(device: MTLDevice) {
        super.init()
        createCommandQueue(device: device)
        createPipelineState(device: device)
        createBuffers(device: device)
    }
    
    func createCommandQueue(device: MTLDevice)
    {
        commandQueue = device.makeCommandQueue()
    }
    
    // Pass in shader functions and update the render pipeline descriptor and state
    func createPipelineState(device: MTLDevice)
    {
        // The device will make a library for us
        let library = device.makeDefaultLibrary()
        // Our vertex function name
        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
        // Our fragment function name
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        // Create basic descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        // Attach the pixel format that is the same as the MetalView
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // Attach the shader functions
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        // Try to update the state of the renderPipeline
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    func createBuffers(device: MTLDevice) {
        // Create buffers with device. Finding the length is simple when using MemoryLayout
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
}


// MTKViewDelegate is a protocol, we are adopting it to receive callbacks when we should draw
extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        // Get the current drawable and descriptor
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
        
        // Create a buffer from the commandQueue
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        // Pass in the vertexBuffer into index 0
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        // Draw primitive at vertexStart 0
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
