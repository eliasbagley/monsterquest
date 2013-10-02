//
//  AnimatedMonster.h
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

#define attackPixelOffset 65        //total distance moved
#define animateIncrements (300/FPS) //moves towards position
#define returnSpeed (700/FPS)       //returns to origin
#define turnIncrement (3.14/FPS)
#define dyingSpeed (400/FPS)
#define shrinkSpeedMultiplier 7

@interface AnimatedMonster : UIScrollView 
{
    UIImageView* _monsterView;
    bool _onLeftSide;
    
    bool _prepareAttack;
    bool _attack;
    bool _dying;
    bool _isShrinking;
    
    float _rotationRadians;
    float _shrunkProgress;
}

-(id) initWithFrame:(CGRect)frame;
-(void) setImage:(UIImage*)image;
-(void) animate;
-(void) reset;

@property (nonatomic, assign) bool prepareAttack;
@property (nonatomic, assign) bool onLeftSide;
@property (nonatomic, assign) bool dying;
@property (nonatomic, assign) bool isShrinking;




@end
