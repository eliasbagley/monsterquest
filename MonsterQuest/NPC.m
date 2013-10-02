//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NPC.h"


@implementation NPC

- (id)initWithCoordinatesX:(int)xPos andY:(int)yPos
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _name = @"";
    _moving = 0;
    _direction = SOUTH;
    _xPos = xPos;
    _xSubPos = 0.0;
    _yPos = yPos;
    _ySubPos = 0.0;
    _chatText = @"";
    _challengeText = @"";
    _npcType = 0;
    _sight = 10;
    
    _monsters = [[NSMutableArray alloc] initWithObjects:nil];
    
    return self;
}

- (id) initFromPlayer:(Player*) player
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _name = [player.name retain];
    _moving = player.moving;
    _direction = player.direction;
    _xPos = player.xPos;
    _xSubPos = player.xSubPos;
    _yPos = player.yPos;
    _ySubPos = player.ySubPos;
    _chatText = @"";
    _challengeText = @"";
    _npcType = 0;
    _sight = 0;
    _recentlyChanged = 0;
    
    _monsters = [player.monsters retain];
    
    return self;
}

- (void)dealloc
{
    [_name release];
    [_chatText release];
    [_challengeText release];
    [_defeatText release];
    [_monsters release];
    [super dealloc];
}

-(int) getGoldValue
{
    int gval = 0;
    for (Monster* m in _monsters)
        gval+= [m getStat:LEVEL];
    
    return 10*gval;
}

@synthesize name = _name;
@synthesize direction=_direction;
@synthesize moving=_moving;
@synthesize xPos = _xPos;
@synthesize yPos = _yPos;
@synthesize xSubPos = _xSubPos;
@synthesize ySubPos = _ySubPos;
@synthesize chatText= _chatText;
@synthesize challengeText= _challengeText;
@synthesize defeatText= _defeatText;
@synthesize monsters = _monsters;
@synthesize npcType = _npcType;
@synthesize pictureID = _pictureID;
@synthesize sight = _sight;
@synthesize recentlyChanged = _recentlyChanged;

@end
