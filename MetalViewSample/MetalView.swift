//
//  MetalView.swift
//  MetalViewSample
//
//  Created by Zorana Curkovic on 06/01/2021.
//

import MetalKit

class MetalView: MTKView {
    
    var renderer: Renderer!
    
    
    func createRenderer(device: MTLDevice) {
        renderer = Renderer(device: device)
        delegate = renderer
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        // Make suree we are on a device that can run metal!
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Device loading error")
        }
        device = defaultDevice
        colorPixelFormat = .bgra8Unorm
        // Our clear color, can be set to any color
        clearColor = MTLClearColor (red: 0.1, green: 0.57, blue : 0.25, alpha: 1)
        
        createRenderer(device: defaultDevice)
    }

}
