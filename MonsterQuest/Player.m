//
//  Player.m
//  MonsterQuest
//
//  Created by u0605593 on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

- (id)initWithName:(NSString *)name
{
	self = [super init];
	if (self == nil)
		return nil;
    
    _worldCoordinates = CGPointMake(0, 0);
    _name = name;
    _money = 0;
    _moving = 0;
    _direction = SOUTH;
    _xPos = 3;
    _xSubPos = 0.0;
    _yPos = 3;
    _ySubPos = 0.0;
    
    _monsters = [[[NSMutableArray alloc] initWithObjects:nil] retain];
    
    NSLog(@"Giving trainer 1 test monster");
    
    Monster* testMonster = [[Monster alloc] initWithName:@"Test Monster 1"];   
    [_monsters addObject:testMonster];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


@synthesize name=_name;
@synthesize monsters = _monsters;
@synthesize money=_money;
@synthesize direction=_direction;
@synthesize moving=_moving;
@synthesize xPos = _xPos;
@synthesize yPos = _yPos;
@synthesize xSubPos = _xSubPos;
@synthesize ySubPos = _ySubPos;
@synthesize worldCoordinates = _worldCoordinates;
@synthesize inGrass = _inGrass;

@end
