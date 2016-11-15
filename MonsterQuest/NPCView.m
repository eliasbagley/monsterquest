//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NPCView.h"


@implementation NPCView
-(id) initWithNPC:(NPC*)npc
{
    self = [super initWithFrame:CGRectMake(0, 0, ppb, 50*(ppb/32))];
    if (self == nil)
        return nil;
    
    _zoneXPosOffset = 0;
    _zoneYPosOffset = 0;
    
    _NPC = npc;
    _stepindex = 1;
    _xOffset = 0;
    _yOffset = 0;
    _animationProgress = 0.0;
    
    UIImage* image = [UIImage imageNamed:@"character_spritesheet"];
    _NPCDrawView= [[[UIImageView alloc] initWithImage:image] retain];
    [_NPCDrawView setFrame:CGRectMake(0, 0, SpriteSheetWidth, SpriteSheetHeight)];
    
    [self addSubview:_NPCDrawView];
    self.contentSize = CGSizeMake(image.size.width, image.size.height);
    self.scrollEnabled=false;
    
    [self setBackgroundColor:[UIColor clearColor]];   
    
    return self;
}


-(void) dealloc
{
	[super dealloc];
}

/*
-(void) drawRect:(CGRect)rect
{    

}
*/

-(void) animateStep
{   
    if(_NPC.moving)
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
    
    if (_NPC.direction < 4)              //Prevents trying to draw diagonal sprite sheets. they dont exist
        _drawdirection = _NPC.direction;
    
    //correct stupid bug.
    if (_drawdirection==SOUTH && (_NPC.direction == NORTHWEST || _NPC.direction == NORTHEAST))
        _drawdirection = NORTH;
    else if (_drawdirection==NORTH && (_NPC.direction == SOUTHWEST || _NPC.direction == SOUTHEAST))
        _drawdirection = SOUTH;   
    else if (_drawdirection==EAST && (_NPC.direction == SOUTHWEST || _NPC.direction == NORTHWEST))
        _drawdirection = WEST;   
    else if (_drawdirection==WEST && (_NPC.direction == SOUTHEAST || _NPC.direction == NORTHEAST))
        _drawdirection = EAST;
    
    
    self.contentOffset=CGPointMake(ppb*_stepframe[_stepindex] + _xOffset, 48*_drawdirection + _yOffset);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [_myDelegate interactWithNPC:_NPC];
}

@synthesize _stepframe = stepframe;
@synthesize myDelegate = _myDelegate;
@synthesize player = _player;
@synthesize drawdirection = _drawdirection;
@synthesize NPC = _NPC;
@synthesize zoneXPosOffset = _zoneXPosOffset;
@synthesize zoneYPosOffset = _zoneYPosOffset;

@end