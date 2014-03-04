//
//  SKSpriteNode+DebugDraw.h
//  CatNap
//
//  Created by Jasmine Wright on 2/27/14.
//  Copyright (c) 2014 Jasmine Wright. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (DebugDraw)

- (void)attachDebugRectWithSize:(CGSize)s;
- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath;


@end
