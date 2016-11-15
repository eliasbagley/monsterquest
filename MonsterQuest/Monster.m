//
//  Monster.m
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"


@implementation Monster

- (id)initWithName:(NSString*)name
{
	self = [super init];
	if (self == nil)
		return nil;
    
    _level = 1;
    _experience = 1;
    _name = name;
    _type = NORM;
    
    _stat[MAXHP]    = 1;
    _stat[CURHP]    = 1;
    _stat[PHYSATK]  = 1;
    _stat[PHYSDEF]  = 1;
    _stat[MAGICATK] = 1;
    _stat[MAGICDEF] = 1;
    _stat[SPEED]    = 1;
    _stat[ACCURACY] = 1;
    
    
    _skills = [[NSMutableArray alloc] initWithObjects:nil];
    
    Skill* testSkill1 = [[Skill alloc] initWithName:@"Skill 1"];
    [_skills addObject:testSkill1];
    Skill* testSkill2 = [[Skill alloc] initWithName:@"Skill 2"];
    [_skills addObject:testSkill2];
    Skill* testSkill3 = [[Skill alloc] initWithName:@"Skill 3"];
    [_skills addObject:testSkill3];
    Skill* testSkill4 = [[Skill alloc] initWithName:@"Skill 4"];
    [_skills addObject:testSkill4];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@synthesize skills = _skills;

@end
