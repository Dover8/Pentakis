//
//  ViewController.swift
//  Pentakis
//
//  Created by Ben MacKinnon on 12/02/2020.
//  Copyright © 2020 Dover. All rights reserved.
//

import GLKit
import MetalKit

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}

class ViewController: UIViewController {

    // view and metal
    @IBOutlet weak var metalView: MTKView!
    private var metalDevice: MTLDevice!
    private var metalCommandQueue: MTLCommandQueue!
    
    // buffers
    private var vertexBuffer: MTLBuffer!
    private var pairIndicesBuffer: MTLBuffer!
    private var pointIndicesBuffer: MTLBuffer!
    
    // pipeline
    private var pipelineState: MTLRenderPipelineState!

    // view matrix
    private var sceneMatrices = SceneMatrices()
    private var uniformBuffer: MTLBuffer!
    private var rotation: Float = 0.0
    private var rotMartrix = GLKMatrix4Identity
    
    private func setupMetal() {
        
        metalDevice = MTLCreateSystemDefaultDevice()
        metalCommandQueue = metalDevice.makeCommandQueue()
        metalView.device = metalDevice
        metalView.delegate = self
        
        // set up the buffers
        
        let vertexBufferSize = Vertices.size()
        vertexBuffer = metalDevice.makeBuffer(bytes: &Vertices, length: vertexBufferSize, options: .storageModeShared)
        
        let pairIndicesBufferSize = Pairs.size()
        pairIndicesBuffer = metalDevice.makeBuffer(bytes: &Pairs, length: pairIndicesBufferSize, options: .storageModeShared)
        
        let pointIndicesBufferSize = Points.size()
        pointIndicesBuffer = metalDevice.makeBuffer(bytes: &Points, length: pointIndicesBufferSize, options: .storageModeShared)
        
        // set up the shaders
        let defaultLibrary = metalDevice.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        //set up the pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexProgram
        pipelineDescriptor.fragmentFunction = fragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // set up projection matrix (will be recalcuted in drawableSizeWillchange)
        let aspect = fabsf(Float(metalView.drawableSize.width) / Float(metalView.drawableSize.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 50)
        sceneMatrices.projectionMatrix = projectionMatrix
        
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches.first)!
        let location: CGPoint = touch.location(in: self.view)
        
        let lastLocation: CGPoint = touch.previousLocation(in: self.view)
        let diff = CGPoint(x: lastLocation.x - location.x, y: lastLocation.y - location.y)
        
        let rotX = -1 * GLKMathDegreesToRadians(Float(diff.y/2))
        let rotY = -1 * GLKMathDegreesToRadians(Float(diff.x/2))
        
        let isInvertable = UnsafeMutablePointer<Bool>.init(bitPattern: 0)
        
        let xAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(rotMartrix, isInvertable), GLKVector3(v: (1, 0, 0)))
        rotMartrix = GLKMatrix4Rotate(rotMartrix, rotX, xAxis.x, xAxis.y, xAxis.z)
        
        let yAxis =
            GLKMatrix4MultiplyVector3(GLKMatrix4Invert(rotMartrix, isInvertable), GLKVector3(v: (0, 1, 0)))
            rotMartrix = GLKMatrix4Rotate(rotMartrix, rotY, yAxis.x, yAxis.y, yAxis.z)
    }

}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect = fabsf(Float(size.width) / Float(size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 50)
        sceneMatrices.projectionMatrix = projectionMatrix
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        
        guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else {
            return
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        // Frame drawing goes here
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -7.5)
        modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, rotMartrix)
        
        sceneMatrices.modelViewMatrix = modelViewMatrix
        
        let uniformBufferSize = MemoryLayout.size(ofValue: sceneMatrices)
        uniformBuffer = metalDevice.makeBuffer(bytes: &sceneMatrices,
                                               length: uniformBufferSize,
                                               options: .storageModeShared)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.drawIndexedPrimitives(type: .line,
                                            indexCount: Pairs.count,
                                            indexType: .uint32,
                                            indexBuffer: pairIndicesBuffer,
                                            indexBufferOffset: 0)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
