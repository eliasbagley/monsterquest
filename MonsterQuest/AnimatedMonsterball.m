//
//  AnimatedMonsterball.m
//  MonsterQuest
//
//  Created by Alexander W Doub on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimatedMonsterball.h"

@implementation AnimatedMonsterball

- (void)dealloc
{
    [_ballScrollView release];
    [_ballView release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    
    
    _ballInAir = 0;
    _ballRocking = 0;
    _ballProgress = 0;
    _turningRight = 1;

    _ballScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-50, 0, 320+50, 300)];
    [_ballScrollView setContentSize:CGSizeMake(400, 400)];
    _ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Monsterball"]];
    [_ballScrollView addSubview:_ballView];
    [self addSubview:_ballScrollView];
    
    [_ballScrollView setScrollEnabled:0];
    [self setScrollEnabled:0];
    
    return self;
}

-(void) animate
{
    if(_ballInAir)
    {
        _ballProgress+= (1.0/FPS)*ballThrowSpeed;   
        
        if (_ballProgress>1) 
        {
            _ballProgress=1;
            _ballInAir = 0;
            _ballRocking = 1;
        }
        
        int xOffset = -280*sin(_ballProgress * 1 * (3.14159/2.0));
        int yOffset = -100 + 80*sin(_ballProgress * 2 * (3.14159/2.0));
        
        [_ballScrollView setContentOffset:CGPointMake(xOffset, yOffset)];
    }
    
    else if(_ballRocking)
    {
        if (_turningRight)
            _ballProgress+= (1.0/FPS)*ballRockSpeed;  
        else
            _ballProgress-= (1.0/FPS)*ballRockSpeed; 
        
        if (_ballProgress > 1.0)
            _turningRight = 0;
        if (_ballProgress < -1.0)
            _turningRight = 1;
        
        //apply transformation
        _ballView.transform = CGAffineTransformMakeRotation(sin(_ballProgress * (3.14159/2.0)));
    }

}
@synthesize ballInAir = _ballInAir;
@synthesize ballRocking = _ballRocking;

@end
