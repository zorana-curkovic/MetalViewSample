//
//  Node.swift
//  MetalViewSample
//
//  Created by Zorana Curkovic on 10/01/2021.
//

import MetalKit

class Node {
    
    var children: [Node] = []
    
    func add(child: Node)
    {
        children.append(child)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        children.forEach { $0.render(commandEncoder: commandEncoder, deltaTime: deltaTime) }
    }
}
