//
//  OpengGLView.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 20.06.17.
//  Copyright © 2017 void. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit
import QuartzCore

class OpengGLView: UIView {
    
    fileprivate var eaglLayer: CAEAGLLayer!
    var context: EAGLContext!
    var colorRenderBuffer: GLuint = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        callSetups()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        callSetups()
    }
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    fileprivate func callSetups() {
        setupLayer()
        setupContext()
        setupRenderBuffer()
        setupFrameBuffer()
    }
    
    fileprivate func setupLayer() {
        eaglLayer = self.layer as! CAEAGLLayer
        eaglLayer.isOpaque = true
    }
    
    fileprivate func setupContext() {
        context = EAGLContext(api: .openGLES3)
        if context == nil {
            context = EAGLContext(api: .openGLES2)
        }
        
        EAGLContext.setCurrent(context)
    }
    
    fileprivate func setupRenderBuffer() {
        glGenRenderbuffers(1, &colorRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        context.renderbufferStorage(Int(GL_RENDERBUFFER), from: eaglLayer)
    }
    
    fileprivate func setupFrameBuffer() {
        var frameBuffer: GLuint = 0
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderBuffer)
    }
}
