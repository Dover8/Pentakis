//
//  ViewController.swift
//  Pentakis
//
//  Created by Ben MacKinnon on 12/02/2020.
//  Copyright © 2020 Dover. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {

    private var context: EAGLContext?
    
    private func setupGL() {
        context = EAGLContext(api: .openGLES3)
        
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.85, 0.85, 0.85, 10)
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }

}

extension ViewController: GLKViewControllerDelegate {
    func  glkViewControllerUpdate(_ controller: GLKViewController) {
        
    }
}
