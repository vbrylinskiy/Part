//
//  GLAnimationConroller.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 13.06.17.
//  Copyright © 2017 void. All rights reserved.
//

import UIKit
import GLKit

class GLAnimationConroller: NSObject {
    let fromView: UIView
    let toView: UIView
    let containerView: UIView
    let transitionDuration: Double
    var glView: OpengGLView!
    var displayLink: CADisplayLink!
    var bgShader: Shader!
    var shader: Shader!
    var bgTexture: GLKTextureInfo!
    var texture1: GLKTextureInfo!
    var texture2: GLKTextureInfo!
    fileprivate var bgPositionSlot: GLuint = 0
    fileprivate var startPositionSlot: GLuint = 0
    fileprivate var endPositionSlot: GLuint = 0
    fileprivate var bgTexCoordSlot: GLuint = 0
    fileprivate var texCoordSlot: GLuint = 0
    fileprivate var projectionSlot: GLuint = 0
    fileprivate var modelSlot: GLuint = 0
    fileprivate var bgTextureSlot: GLuint = 0
    fileprivate var texture1Slot: GLuint = 0
    fileprivate var texture2Slot: GLuint = 0
    
    var startTime: Double!
    
    var sprites: [Sprite] = []
    
    var mixValue: Float = 0.0
    var mixValueSlot: GLuint = 0
    
    var indices: [GLubyte] = [
        0, 1, 2,
        2, 0, 3
    ]
    
    var bgVertexBuffer: GLuint = 0

    
    struct Vertex {
        var Position:(Float, Float, Float)
        var TexCoord:(Float, Float)
    }
    
    let vertices = [Vertex(Position: (-1, -1, 0), TexCoord: (0.0, 1.0)),
                    Vertex(Position: (-1, 1, 0), TexCoord: (0.0, 0.0)),
                    Vertex(Position: (1, -1, 0), TexCoord: (1.0, 1.0)),
                    Vertex(Position: (1, -1, 0), TexCoord: (1.0, 1.0)),
                    Vertex(Position: (-1, 1, 0), TexCoord: (0.0, 0.0)),
                    Vertex(Position: (1, 1, 0), TexCoord: (1.0, 0.0))]
    
    init(fromView: UIView, toView: UIView, containerView: UIView, transitionDuration: Double) {
        self.fromView = fromView
        self.toView = toView
        self.containerView = containerView
        self.transitionDuration = transitionDuration
        
        super.init()
    }
    
    func imageFrom(view: UIView) -> UIImage {
        let isHidden = view.isHidden
        
        if isHidden {
            view.isHidden = false
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if isHidden {
            view.isHidden = true
        }
        return snapshotImageFromMyView!
    }
    
    func animateTransitionWithCompletion (_ completion: @escaping ((Void) -> Void)) {
        
        self.startTime = CACurrentMediaTime()

        let wasHidden = toView.isHidden
        
        
        let fromImage = self.imageFrom(view: self.fromView)
        
        fromView.isHidden = true
        
        let bgImage = self.imageFrom(view: self.containerView)
        let toImage = self.imageFrom(view: self.toView)
        
        self.glView = OpengGLView(frame: self.containerView.frame)
        self.containerView.addSubview(self.glView)
        
        EAGLContext.setCurrent(self.glView.context)
        
        self.bgShader = Shader(vertexFile: Bundle.main.path(forResource: "Vertex2", ofType: "vs")!,
                             fragmentFile: Bundle.main.path(forResource: "Fragment2", ofType: "fs")!)
        
        self.shader = Shader(vertexFile: Bundle.main.path(forResource: "Vertex", ofType: "vs")!,
                             fragmentFile: Bundle.main.path(forResource: "Fragment", ofType: "fs")!)
        self.shader.use()
        startPositionSlot = GLuint(glGetAttribLocation(self.shader.program, "StartPosition"))
        endPositionSlot = GLuint(glGetAttribLocation(self.shader.program, "EndPosition"))
        texCoordSlot = GLuint(glGetAttribLocation(self.shader.program, "TexCoordIn"))
        projectionSlot = GLuint(glGetUniformLocation(self.shader.program, "Projection"))
        modelSlot = GLuint(glGetUniformLocation(self.shader.program, "Model"))
        texture1Slot = GLuint(glGetUniformLocation(self.shader.program, "Texture1"))
        texture2Slot = GLuint(glGetUniformLocation(self.shader.program, "Texture2"))
        mixValueSlot = GLuint(glGetUniformLocation(self.shader.program, "MixValue"))
        glEnableVertexAttribArray(startPositionSlot)
        glEnableVertexAttribArray(endPositionSlot)
        glEnableVertexAttribArray(texCoordSlot)
    
        self.texture1 = try! GLKTextureLoader.texture(with: fromImage.cgImage!, options: nil)
        glActiveTexture(GLenum(GL_TEXTURE0));
        glUniform1i(GLint(texture1Slot), 0);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1.name);
        glActiveTexture(GLenum(GL_TEXTURE1));
        self.texture2 = try! GLKTextureLoader.texture(with: toImage.cgImage!, options: nil)
        glUniform1i(GLint(texture2Slot), 1);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture2.name);
        
        var projection = GLKMatrix4MakeOrtho(0, Float(self.glView.frame.width), Float(self.glView.frame.height), 0.0, -1, 1)
        var model = GLKMatrix4Identity
        model = GLKMatrix4RotateX(model, 0.15)
//        var model = GLKMatrix4MakeOrtho(0, Float(self.glView.frame.width), Float(self.glView.frame.height), 0.0, -1, 1)
        
        let f = GLboolean(GL_FALSE)
        // Swift 3:
        withUnsafePointer(to: &projection.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: MemoryLayout.size(ofValue: projection.m)) {
                glUniformMatrix4fv(GLint(projectionSlot), 1, f, $0)
            }
        }
        
        self.generateSprites()
        
        var indexBuffer: GLuint = 0
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLubyte>.stride * self.indices.count, self.indices, GLenum(GL_STATIC_DRAW))
        
        self.bgShader.use()
        bgPositionSlot = GLuint(glGetAttribLocation(self.bgShader.program, "Position"))
        bgTexCoordSlot = GLuint(glGetAttribLocation(self.bgShader.program, "TexCoordIn"))
        bgTextureSlot = GLuint(glGetUniformLocation(self.bgShader.program, "Texture"))
        
        glActiveTexture(GLenum(GL_TEXTURE2));
        self.bgTexture = try! GLKTextureLoader.texture(with: bgImage.cgImage!, options: nil)
        glUniform1i(GLint(bgTextureSlot), 2);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.bgTexture.name);
        
        glGenBuffers(1, &self.bgVertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bgVertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Vertex>.stride * self.vertices.count, vertices, GLenum(GL_STATIC_DRAW))
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(render))
        self.displayLink.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.transitionDuration, execute: {
            self.displayLink.invalidate()
            self.glView.removeFromSuperview()
            completion()
        })
    }
    
    func generateSprites() {
        let n = 10
        var curX = self.fromView.frame.origin.x
        var curY = self.fromView.frame.origin.y
        let deltaX = self.fromView.frame.size.width / CGFloat(n)
        let deltaY = self.fromView.frame.size.height / CGFloat(n)
        let delatXRes = self.toView.frame.size.width / CGFloat(n)
        let delatYRes = self.toView.frame.size.height / CGFloat(n)
        let texWidth = 1.0/CGFloat(n)
        let texHeight = 1.0/CGFloat(n)
        
        for i in (0  ..< n).reversed() {
            for j in (0 ..< n).reversed() {
                curX = self.fromView.frame.origin.x + CGFloat(i) * deltaX
                curY = self.fromView.frame.origin.y + CGFloat(j) * deltaY
                
                let curResX = self.toView.frame.origin.x + CGFloat(i) * delatXRes
                let curResY = self.toView.frame.origin.y + CGFloat(j) * delatYRes
                
                self.sprites.append(Sprite(startFrame: CGRect(x: curX, y: curY, width: deltaX, height: deltaY),
                                           endFrame: CGRect(x: curResX, y: curResY, width: delatXRes, height: delatYRes),
                                           textureFrame: CGRect(x: CGFloat(i) * texWidth, y: CGFloat(j) * texWidth, width: texWidth, height: texHeight)))
            }
        }
    }
    
    func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: i)
    }
    
    func render() {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        glViewport(0, 0, GLsizei(self.glView.frame.size.width), GLsizei(self.glView.frame.size.height))
        
        glUniform1f(GLint(mixValueSlot), min(Float((CACurrentMediaTime() - startTime) / self.transitionDuration), 1.0));

        self.bgShader.use()
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bgVertexBuffer)
        
        glVertexAttribPointer(bgPositionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 20, BUFFER_OFFSET(0))
        glVertexAttribPointer(bgTexCoordSlot, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 20, BUFFER_OFFSET(12))
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(self.indices.count))
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        
        self.shader.use()
        
        for sprite in self.sprites {
            sprite.bind()
            glVertexAttribPointer(startPositionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, BUFFER_OFFSET(0))
            glVertexAttribPointer(endPositionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, BUFFER_OFFSET(12))
            glVertexAttribPointer(texCoordSlot, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, BUFFER_OFFSET(24))
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
            sprite.unbind()
        }
        
        self.glView.context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
}
