//
//  Vertex.swift
//  Pentakis
//
//  Created by Ben MacKinnon on 12/02/2020.
//  Copyright © 2020 Dover. All rights reserved.
//

import GLKit

struct Vertex {
    var x: GLfloat
    var y: GLfloat
    var z: GLfloat
}

struct  ColoredVertex
{
    var x: GLfloat
    var y: GLfloat
    var z: GLfloat
    var r: GLfloat = 1
    var g: GLfloat = 1
    var b: GLfloat = 1
    var a: GLfloat = 1
}
