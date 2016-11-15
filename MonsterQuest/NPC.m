//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NPC.h"


@implementation NPC

- (id)initWithCoordinatesX:(int)xPos andY:(int)yPos andText:(NSString*)text
{
	self = [super init];
	if (self == nil)
		return nil;
    
    _moving = 0;
    _direction = SOUTH;
    _xPos = xPos;
    _xSubPos = 0.0;
    _yPos = yPos;
    _ySubPos = 0.0;
    _chatText = text;
    
    _monsters = [[NSMutableArray alloc] initWithObjects:nil];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@synthesize direction=_direction;
@synthesize moving=_moving;
@synthesize xPos = _xPos;
@synthesize yPos = _yPos;
@synthesize xSubPos = _xSubPos;
@synthesize ySubPos = _ySubPos;
@synthesize chatText= _chatText;
@synthesize monsters = _monsters;

@end
