//
//  Bars.m
//  LazyQuest
//
//  Created by u0565496 on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView()
@end


@implementation PlayerView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _stepindex = 1;
    _xOffset = 0;
    _yOffset = 193;
    _animationProgress = 0.0;
    
    UIImage* image = [UIImage imageNamed:@"spritesheet_7"];
     _playerDrawView= [[[UIImageView alloc] initWithImage:image] retain];
    [_playerDrawView setFrame:CGRectMake(0, 0, SpriteSheetWidth, SpriteSheetHeight)];
    
    [self addSubview:_playerDrawView];
    self.contentSize = CGSizeMake(image.size.width, image.size.height);
    self.scrollEnabled=false;

    [self setBackgroundColor:[UIColor clearColor]];     
    return self;
}


-(void) dealloc
{
	[super dealloc];
}

//Returns true if its time to update.
-(void) animateStep
{   
    if(_player.moving)
    {
        _animationProgress+=(AnimationsPerSecond/FPS);
        if(_animationProgress>1.0)
        {
            _animationProgress=0;
            _stepindex=_stepindex++;
            
            if(_stepindex>3)
                _stepindex=0;
        }
        else;
    }
    else
        _stepindex=1;
    
    int _stepframe[4] = {0,1,2,1};
    
    if (_player.direction < 4)              //Prevents trying to draw diagonal sprite sheets. they dont exist
        _drawdirection = _player.direction;
    
    //correct stupid bug.
    if (_drawdirection==SOUTH && (_player.direction == NORTHWEST || _player.direction == NORTHEAST))
        _drawdirection = NORTH;
    else if (_drawdirection==NORTH && (_player.direction == SOUTHWEST || _player.direction == SOUTHEAST))
        _drawdirection = SOUTH;   
    else if (_drawdirection==EAST && (_player.direction == SOUTHWEST || _player.direction == NORTHWEST))
        _drawdirection = WEST;   
    else if (_drawdirection==WEST && (_player.direction == SOUTHEAST || _player.direction == NORTHEAST))
        _drawdirection = EAST;
    
    int xOffset = 32*_stepframe[_stepindex] + _xOffset;
    int yOffset = 48*_drawdirection + _yOffset;
    //xOffset = 0;
    //yOffset = 140;
    //log@"x:%i, y:%i", xOffset, yOffset);
    
    self.contentOffset=CGPointMake( xOffset*worldScale, yOffset*worldScale);
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    //[_myDelegate toggleMenu];
}

@synthesize _stepframe = stepframe;
@synthesize myDelegate = _myDelegate;
@synthesize player = _player;
@synthesize drawdirection = _drawdirection;

@end
