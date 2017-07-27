//
//  TextureHelper.h
//  Part
//
//  Created by Vladislav Brylinskiy on 27.06.17.
//  Copyright © 2017 void. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TextureHelper : NSObject

+(GLuint) createTextureFromView: (UIView *) view;

@end
