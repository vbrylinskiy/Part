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
    var frame: CGRect
    var textureFrame: CGRect
    var vertices: [Vertex] = []
    var vertexBuffer: GLuint = 0
    
    struct Vertex {
        var Position:(Float, Float, Float)
        var TexCoord:(Float, Float)
    }
    
    init(frame: CGRect, textureFrame: CGRect) {
        self.frame = frame
        self.textureFrame = textureFrame
        glGenBuffers(1, &(self.vertexBuffer))

        self.generateVertices()
    }
    
    mutating func generateVertices() {
        var result: [Vertex] = []
        
        result.append(Vertex(Position: (Float(self.frame.minX), Float(self.frame.minY), 0.0), TexCoord: (Float(self.textureFrame.minX), Float(self.textureFrame.minY))))
        result.append(Vertex(Position: (Float(self.frame.minX), Float(self.frame.maxY), 0.0), TexCoord: (Float(self.textureFrame.minX), Float(self.textureFrame.maxY))))
        result.append(Vertex(Position: (Float(self.frame.maxX), Float(self.frame.maxY), 0.0), TexCoord: (Float(self.textureFrame.maxX), Float(self.textureFrame.maxY))))
        result.append(Vertex(Position: (Float(self.frame.maxX), Float(self.frame.minY), 0.0), TexCoord: (Float(self.textureFrame.maxX), Float(self.textureFrame.minY))))
        
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
