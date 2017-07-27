//
//  Sprite.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 26.07.17.
//  Copyright © 2017 void. All rights reserved.
//

import Foundation
import GLKit

struct Sprite {
    var startFrame: CGRect
    var endFrame: CGRect
    var textureFrame: CGRect
    var vertices: [Vertex] = []
    var vertexBuffer: GLuint = 0
    
    struct Vertex {
        var StartPosition:(Float, Float, Float)
        var EndPosition:(Float, Float, Float)
        var TexCoord:(Float, Float)
    }
    
    init(startFrame: CGRect, endFrame: CGRect, textureFrame: CGRect) {
        self.startFrame = startFrame
        self.endFrame = endFrame
        self.textureFrame = textureFrame
        glGenBuffers(1, &(self.vertexBuffer))

        self.generateVertices()
    }
    
    mutating func generateVertices() {
        var result: [Vertex] = []
        
        result.append(Vertex(StartPosition: (Float(self.startFrame.minX), Float(self.startFrame.minY), 0.0),
                             EndPosition: (Float(self.endFrame.minX), Float(self.endFrame.minY), 0.0),
                             TexCoord: (Float(self.textureFrame.minX), Float(self.textureFrame.minY))))
        
        result.append(Vertex(StartPosition: (Float(self.startFrame.minX), Float(self.startFrame.maxY), 0.0),
                             EndPosition: (Float(self.endFrame.minX), Float(self.endFrame.maxY), 0.0),
                             TexCoord: (Float(self.textureFrame.minX), Float(self.textureFrame.maxY))))
        
        result.append(Vertex(StartPosition: (Float(self.startFrame.maxX), Float(self.startFrame.maxY), 0.0),
                             EndPosition: (Float(self.endFrame.maxX), Float(self.endFrame.maxY), 0.0),
                             TexCoord: (Float(self.textureFrame.maxX), Float(self.textureFrame.maxY))))
        
        result.append(Vertex(StartPosition: (Float(self.startFrame.maxX), Float(self.startFrame.minY), 0.0),
                             EndPosition: (Float(self.endFrame.maxX), Float(self.endFrame.minY), 0.0),
                             TexCoord: (Float(self.textureFrame.maxX), Float(self.textureFrame.minY))))
        
        self.vertices = result
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Vertex>.stride * self.vertices.count, vertices, GLenum(GL_STATIC_DRAW))
    }
    
    func bind() {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
    }
    
    func unbind() {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    }

}
