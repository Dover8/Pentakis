//
//  ViewController.swift
//  Pentakis
//
//  Created by Ben MacKinnon on 12/02/2020.
//  Copyright © 2020 Dover. All rights reserved.
//

import GLKit

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}

class ViewController: GLKViewController {

    private var context: EAGLContext?
    private var pentikisIndiceBuffer = GLuint()
    private var pentikisPointBuffer = GLuint()
    private var vbo = GLuint()
    private var vao = GLuint()
    private var effect = GLKBaseEffect()
    private var rotation: Float = 0.0
    private var rotMartrix = GLKMatrix4Identity
    
    private func setupGL() {
        context = EAGLContext(api: .openGLES3)
        
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self
        }
        
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        let vertexSize = MemoryLayout<ColoredVertex>.stride
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        let colofOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        glGenVertexArraysOES(1, &vao)
        
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER),
                     Vertices.size(),
                     Vertices,
                     GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(vertexAttribPosition)
        glVertexAttribPointer(vertexAttribPosition, 3,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(vertexSize),
                              nil)
        
        glEnableVertexAttribArray(vertexAttribColor)
        glVertexAttribPointer(vertexAttribColor,
                              4,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(vertexSize),
                              colofOffsetPointer)
        
        glGenBuffers(1, &pentikisIndiceBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), pentikisIndiceBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     Pairs.size(),
                     Pairs,
                     GLenum(GL_STATIC_DRAW))
        
//        glGenBuffers(1, &pentikisPointBuffer)
//        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), pentikisPointBuffer)
//        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
//                     Points.size(),
//                     Points,
//                     GLenum(GL_STATIC_DRAW))
        
        // clear the buffers
        glBindVertexArray(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &pentikisIndiceBuffer)
        glDeleteBuffers(1, &pentikisPointBuffer)
        
        EAGLContext.setCurrent(nil)
        
        context = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.85, 0.85, 0.85, 10)
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        effect.prepareToDraw()
        glBindVertexArray(vao)
        glDrawElements(GLenum(GL_LINES),
                       GLsizei(Pairs.count),
                       GLenum(GL_UNSIGNED_BYTE),
                       nil)
        glBindVertexArray(0)
    }
    
    deinit {
        tearDownGL()
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

extension ViewController: GLKViewControllerDelegate {
    func  glkViewControllerUpdate(_ controller: GLKViewController) {
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 50.0)
        
        effect.transform.projectionMatrix = projectionMatrix
        
        var modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -7.5)
        
        //rotation += 90 * Float(timeSinceLastUpdate)
        //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 1, 1, 1)
        modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, rotMartrix)
        
        effect.transform.modelviewMatrix = modelViewMatrix
    }
}
