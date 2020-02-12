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
}
//#define kBytesPerVertex (sizeof(vertexStruct))

let kNumVerticesCube = 24
let kNumVerticesPentakis = 180

let gC0: GLfloat = 0.927050983124842272306880251548;
let gC1: GLfloat = 1.33058699733550141141687582919;
let gC2: GLfloat = 2.15293498667750705708437914596;
let gC3: GLfloat = 2.427050983124842272306880251548;

var Vertices = [
    
    ColoredVertex(x: 0.0, y: gC0, z: gC3), //V0
    ColoredVertex(x: 0.0, y: gC0, z:-gC3), //V1
    ColoredVertex(x: 0.0, y:-gC0, z: gC3), //V2
    ColoredVertex(x: 0.0, y:-gC0, z:-gC3), //V3
    
    ColoredVertex(x: gC3, y: 0.0, z: gC0), //V4
    ColoredVertex(x: gC3, y: 0.0, z:-gC0), //V5
    ColoredVertex(x:-gC3, y: 0.0, z: gC0), //V6
    ColoredVertex(x:-gC3, y: 0.0, z:-gC0), //V7
    
    ColoredVertex(x: gC0, y: gC3, z: 0.0), //V8
    ColoredVertex(x: gC0, y:-gC3, z: 0.0), //V9
    ColoredVertex(x:-gC0, y: gC3, z: 0.0), //V10
    ColoredVertex(x:-gC0, y:-gC3, z: 0.0), //V11
    
    ColoredVertex(x: gC1, y: 0.0, z: gC2), //V12
    ColoredVertex(x: gC1, y: 0.0, z:-gC2), //V13
    ColoredVertex(x:-gC1, y: 0.0, z: gC2), //V14
    ColoredVertex(x:-gC1, y: 0.0, z:-gC2), //V15
    
    ColoredVertex(x: gC2, y: gC1, z: 0.0), //V16
    ColoredVertex(x: gC2, y:-gC1, z: 0.0, r:(189/255), g:(167/255), b:(7/255), a:1.0), //V17
    ColoredVertex(x:-gC2, y: gC1, z: 0.0), //V18
    ColoredVertex(x:-gC2, y:-gC1, z: 0.0), //V19
    
    ColoredVertex(x: 0.0, y: gC2, z: gC1, r: 0.0, g:(144/255), b:(158/255), a:1.0), //V20
    ColoredVertex(x: 0.0, y: gC2, z:-gC1, r:(181/255), g: 0, b:(102/255), a:1.0), //V21
    ColoredVertex(x: 0.0, y:-gC2, z: gC1), //V22
    ColoredVertex(x: 0.0, y:-gC2, z:-gC1, r: 0.0, g:(76/255), b:(125/255), a:1.0), //V23
    
    ColoredVertex(x: 1.5, y: 1.5, z: 1.5), //V24
    ColoredVertex(x: 1.5, y: 1.5, z:-1.5), //V25
    ColoredVertex(x: 1.5, y:-1.5, z: 1.5), //V26
    ColoredVertex(x: 1.5, y:-1.5, z:-1.5), //V27
    
    ColoredVertex(x:-1.5, y: 1.5, z: 1.5), //V28
    ColoredVertex(x:-1.5, y: 1.5, z:-1.5), //V29
    ColoredVertex(x:-1.5, y:-1.5, z: 1.5), //V30
    ColoredVertex(x:-1.5, y:-1.5, z:-1.5)  //V31
]

const GLubyte Pairs[] = {
    12,  0,
    0, 2,
    12,  2,
    2, 26,
    12, 26,
    26, 4,
    12,  4,
    4, 24,
    12, 24,
    24, 0,
    
    
    13,  1,
    1, 25,
    13, 25,
    25, 5,
    13,  5,
    5, 27,
    13, 27,
    27, 3,
    13,  3,
    3, 1,
    
    14,  0,
    0, 28,
    14, 28,
    28, 6,
    14,  6,
    6, 30,
    14, 30,
    30, 2,
    14,  2,
    2, 0,
    
    15,  1,
    1, 3,
    15,  3,
    3, 31,
    15, 31,
    31, 7,
    15,  7,
    7, 29,
    15, 29,
    29, 1,
    
    16,  8,
    8, 24,
    16, 24,
    24, 4,
    16,  4,
    4, 5,
    16,  5,
    5, 25,
    16, 25,
    25, 8,
    
    17,  9,
    9, 27,
    17, 27,
    27, 5,
    17,  5,
    5, 4,
    17,  4,
    4, 26,
    17, 26,
    26, 9,
    
    18, 10,
    10, 29,
    18, 29,
    29, 7,
    18,  7,
    7, 6,
    18,  6,
    6, 28,
    18, 28,
    28, 10,
    
    19, 11,
    11, 30,
    19, 30,
    30, 6,
    19,  6,
    6, 7,
    19,  7,
    7, 31,
    19, 31,
    31, 11,
    
    20,  0,
    0, 24,
    20, 24,
    24, 8,
    20,  8,
    8, 10,
    20, 10,
    10, 28,
    20, 28,
    28, 0,
    
    21,  1,
    1, 29,
    21, 29,
    29, 10,
    21, 10,
    10, 8,
    21,  8,
    8, 25,
    21, 25,
    25, 1,
    
    22,  2,
    2, 30,
    22, 30,
    30, 11,
    22, 11,
    11, 9,
    22,  9,
    9, 26,
    22, 26,
    26, 2,
    
    23,  3,
    3, 27,
    23, 27,
    27, 9,
    23,  9,
    9, 11,
    23, 11,
    11, 31,
    23, 31,
    31, 3
};

GLubyte Points[] = {
    17, 20,
    23, 21
};

const GLubyte Indices[] = {

    12,  0,  2,
    12,  2, 26,
    12, 26,  4,
    12,  4, 24,
     12, 24,  0,


  13,  1, 25,
     13, 25,  5,
     13,  5, 27,
     13, 27,  3,
     13,  3,  1,
  
    14,  0, 28,
     14, 28,  6,
     14,  6, 30,
     14, 30,  2,
     14,  2,  0,
    
    15,  1,  3,
     15,  3, 31,
     15, 31,  7,
     15,  7, 29,
     15, 29,  1,
    
    16,  8, 24,
     16, 24,  4,
     16,  4,  5,
     16,  5, 25,
     16, 25,  8,
    
17,  9, 27,
     17, 27,  5,
     17,  5,  4,
     17,  4, 26,
     17, 26,  9,
    
    18, 10, 29,
     18, 29,  7,
     18,  7,  6,
     18,  6, 28,
     18, 28, 10,
    
    19, 11, 30,
     19, 30,  6,
     19,  6,  7,
     19,  7, 31,
     19, 31, 11,
    
    20,  0, 24,
     20, 24,  8,
     20,  8, 10,
     20, 10, 28,
     20, 28,  0,
    
    21,  1, 29,
     21, 29, 10,
     21, 10,  8,
     21,  8, 25,
     21, 25,  1,
    
    22,  2, 30,
     22, 30, 11,
     22, 11,  9,
     22,  9, 26,
     22, 26,  2,
    
    23,  3, 27,
     23, 27,  9,
     23,  9, 11,
     23, 11, 31,
     23, 31,  3
   
};
