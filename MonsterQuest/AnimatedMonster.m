//
//  AnimatedMonster.m
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimatedMonster.h"

@implementation AnimatedMonster

- (void)dealloc
{
    [_monsterView release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    //monster
    _monsterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:_monsterView];
    
    //animation variables
    _prepareAttack = 0;
    _attack = 0;
    _dying = 0;
    _rotationRadians = 0;
    
    //ball (for capturing)

    
    return self;
}

-(void) setImage:(UIImage*)image
{
    [_monsterView setImage:image];
}

-(void) setContentMode:(UIViewContentMode)contentMode
{
    [_monsterView setContentMode:contentMode];
}

-(void) animate
{   
    int xPos = self.contentOffset.x;
    int yPos = self.contentOffset.y;
    
    //if attacking a side, back away from it so you can "charge" it.
    if(_prepareAttack)
    {
        
        if(_onLeftSide)
        {
            xPos = xPos + animateIncrements;
        
            if(xPos>attackPixelOffset)
            {
                _prepareAttack=0;
                _attack = 1;
            }
        }
        else 
        {
            xPos = xPos - animateIncrements;
            
            if(xPos<-attackPixelOffset)
            {
                _prepareAttack=0;
                _attack = 1;
            }
        }
        
        self.contentOffset = CGPointMake(xPos, 0);
    }

        
    //attack = return monster to origin really quickly
    else if (_attack)
    {
        if(xPos > 0)
        {
            xPos = xPos - returnSpeed;
            if (xPos < 0) 
            {
                xPos = 0;           
                _attack = 0;
            }
        }
        else
        {
            xPos = xPos + returnSpeed;
            if (xPos > 0) 
            {
                xPos = 0;         
                _attack = 0;
            }           
        }
        
        
        self.contentOffset = CGPointMake(xPos, 0);
    }
    
    //dying = spins around a bit
    else if (_dying)
    {
        if (_onLeftSide)
        {
            _rotationRadians -= turnIncrement;
            yPos = yPos + dyingSpeed;
            
            if(_rotationRadians < -3.14)
                _dying = 0;  
        }
        else
        {
            _rotationRadians += turnIncrement;
            yPos = yPos + dyingSpeed;
            
            if(_rotationRadians > 3.14)
                _dying = 0;
        }
        
        self.transform = CGAffineTransformMakeRotation(_rotationRadians);
        self.contentOffset = CGPointMake(0, yPos);
    }
    
    
    else if (_isShrinking)
    {
        if (!_onLeftSide)
        {

            if (_shrunkProgress < 1)
                _shrunkProgress += (1.0/FPS*1.0);    
            else if (_shrunkProgress > 1)
                _shrunkProgress += (shrinkSpeedMultiplier/FPS*1.0);  
            if(_shrunkProgress > 2.0)
                _shrunkProgress = 2.0;
        
            if(_shrunkProgress > 1.0)
            {
                self.transform = CGAffineTransformMakeScale(2.0 - _shrunkProgress, 2.0 - _shrunkProgress);
            }
        }
    }
    


    
    
}
-(void) reset
{
    _prepareAttack = 0;
    _attack = 0;
    _dying = 0;
    _rotationRadians = 0;
    _shrunkProgress = 0;
    self.contentOffset = CGPointMake(0, 0);
    self.transform = CGAffineTransformMakeRotation(_rotationRadians);
    self.transform = CGAffineTransformMakeScale(1.0 - _shrunkProgress, 1.0 - _shrunkProgress);
}

@synthesize prepareAttack = _prepareAttack;
@synthesize dying = _dying;
@synthesize onLeftSide = _onLeftSide;
@synthesize isShrinking = _isShrinking;

@end
