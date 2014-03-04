//
//  MyScene.m
//  CatNap
//
//  Created by Jasmine Wright on 2/27/14.
//  Copyright (c) 2014 Jasmine Wright. All rights reserved.
//

#import "MyScene.h"
#import "SKSpriteNode+DebugDraw.h"
#import "SKTAudio.h"

typedef NS_OPTIONS(uint32_t, CNPhysicsCategory)
{
    CNPhysicsCategoryCat = 1 << 0, // 0001 = 1
    CNPhysicsCategoryBlock = 1 << 1, // 0010 = 2
    CNPhysicsCategoryBed = 1 << 2, // 0100 = 4
};

@implementation MyScene
{
    SKNode *_gameNode;
    SKSpriteNode *_catNode;
    SKSpriteNode *_bedNode;
    int _currentLevel;
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self initializeScene];
    }
    return self;
}


- (void)initializeScene
{
    self.physicsBody =
    [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    SKSpriteNode* bg =
    [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    bg.position =
    CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild: bg];
    
    _gameNode = [SKNode node];
    [self addChild:_gameNode];
    _currentLevel = 1;
    [self setupLevel: _currentLevel];
}


- (void)addCatBed
{
    _bedNode =
    [SKSpriteNode spriteNodeWithImageNamed:@"cat_bed"];
    _bedNode.position = CGPointMake(270, 15);
    [self addChild:_bedNode];
    
    CGSize contactSize = CGSizeMake(40, 30);
    _bedNode.physicsBody =
    [SKPhysicsBody bodyWithRectangleOfSize:contactSize];
    _bedNode.physicsBody.dynamic = NO;
    [_bedNode attachDebugRectWithSize:contactSize];
    
    [self addCatBed];
}

- (void)addCatAtPosition:(CGPoint)pos
{
    //add the cat in the level on its starting position
    _catNode = [
                SKSpriteNode spriteNodeWithImageNamed:@"cat_sleepy"];
    _catNode.position = pos;
    [_gameNode addChild:_catNode];
    
    
    
    CGSize contactSize = CGSizeMake(_catNode.size.width-40,
                                    _catNode.size.height-10);
    _catNode.physicsBody =
    [SKPhysicsBody bodyWithRectangleOfSize: contactSize];
    [_catNode attachDebugRectWithSize: contactSize];
}

- (void)setupLevel:(int)levelNum
{
    //load the plist file
    NSString *fileName =
    [NSString stringWithFormat:@"level%i",levelNum];
    NSString *filePath =
    [[NSBundle mainBundle] pathForResource:fileName
                                    ofType:@"plist"];
    NSDictionary *level =
    [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self addCatAtPosition:
     CGPointFromString(level[@"catPosition"])];
    
    [self addBlocksFromArray:level[@"blocks"]];
    [[SKTAudio sharedInstance] playBackgroundMusic:@"bgMusic.mp3"];
}

-(void)addBlocksFromArray:(NSArray*)blocks
{
    // 1
    for (NSDictionary *block in blocks) {
        //2
        SKSpriteNode *blockSprite =
        [self addBlockWithRect:CGRectFromString(block[@"rect"])];
        [_gameNode addChild:blockSprite];
    }
}

-(SKSpriteNode*)addBlockWithRect:(CGRect)blockRect
{
    // 3
    NSString *textureName = [NSString stringWithFormat:
                             @"%.fx%.f.png",blockRect.size.width, blockRect.size.height];
    // 4
    SKSpriteNode *blockSprite =
    [SKSpriteNode spriteNodeWithImageNamed:textureName];
    blockSprite.position = blockRect.origin;
    // 5
    CGRect bodyRect = CGRectInset(blockRect, 2, 2);
    blockSprite.physicsBody =
    [SKPhysicsBody bodyWithRectangleOfSize:bodyRect.size];
    //6
    [blockSprite attachDebugRectWithSize:blockSprite.size];
    return blockSprite;
}
@end
