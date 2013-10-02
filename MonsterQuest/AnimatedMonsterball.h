//
//  AnimatedMonsterball.h
//  MonsterQuest
//
//  Created by Alexander W Doub on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#define ballThrowSpeed 1
#define ballRockSpeed 1.01

@interface AnimatedMonsterball : UIScrollView
{
    
    //capturing
    UIScrollView* _ballScrollView;
    UIImageView* _ballView;
    
    bool _ballInAir;
    bool _ballRocking;
    
    float _ballProgress;
    bool _turningRight;
}

-(void) animate;


@property (nonatomic, assign) bool ballInAir;
@property (nonatomic, assign) bool ballRocking;

@end
