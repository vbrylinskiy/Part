//
//  TextureHelper.m
//  Part
//
//  Created by Vladislav Brylinskiy on 27.06.17.
//  Copyright © 2017 void. All rights reserved.
//

#import "TextureHelper.h"


@implementation TextureHelper

+(GLuint) createTextureFromView: (UIView *) view{
    
    size_t width = CGRectGetWidth(view.layer.bounds) * [UIScreen mainScreen].scale;
    size_t height = CGRectGetHeight(view.layer.bounds) * [UIScreen mainScreen].scale;
    
    GLubyte * texturePixelBuffer = (GLubyte *) calloc(width * height * 4,
                                                      sizeof(GLubyte));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texturePixelBuffer,
                                                 width, height, 8, width*4, colorSpace,
                                                 kCGImageAlphaPremultipliedLast |
                                                 kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    [view.layer renderInContext:context];
    
    CGContextRelease(context);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, texturePixelBuffer);
    
    free(texturePixelBuffer);
    return texName;

}


@end
