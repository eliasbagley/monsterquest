//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Skill.h"


@implementation Skill

-(id) initWithName:(NSString*)name
{
    _name = name;
    _maxPP = 30;
    _attackPower = 5;
    _type = NORM;
    _isPhysical = 1;
    
    
    
    return self;
}

@synthesize name = _name;
@synthesize maxPP = _maxPP;
@synthesize attackPower = _attackPower;
@synthesize type = _type;
@synthesize isPhysical = _isPhysical;

@end
