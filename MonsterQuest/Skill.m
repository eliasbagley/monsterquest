//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Skill.h"


@implementation Skill


-(id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init])
	{
        _name          = [[decoder decodeObjectForKey:@"name"] retain];
        _description   = [[decoder decodeObjectForKey:@"description"] retain];
        _curPP         = [decoder decodeIntForKey:@"curPP"];
        _maxPP         = [decoder decodeIntForKey:@"maxPP"];
        _attackPower   = [decoder decodeIntForKey:@"attackpower"];
        _type          = [decoder decodeIntForKey:@"type"];
        _isPhysical    = [decoder decodeBoolForKey:@"isPhysical"];
	}
    
    
	return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name          forKey:@"name"];
	[encoder encodeObject:_description   forKey:@"description"];
	[encoder encodeInt:_curPP            forKey:@"curPP"];
    [encoder encodeInt:_maxPP            forKey:@"maxPP"];
    [encoder encodeInt:_attackPower      forKey:@"attackpower"];
    [encoder encodeInt:_type             forKey:@"type"];
    [encoder encodeBool:_isPhysical      forKey:@"isPhysical"];
    
}


//NOTE: The only reason this is still here is because of the menu actions, like "atack" and "run".
-(id) initDummySkill
{
    _name = @"Dummy";
    _maxPP = 300;
    _curPP = 300;
    _attackPower = 5000000;
    _type = NORM;
    _isPhysical = 1;
    
    return self;
}

-(id) initSkillByName:(NSString *)name
{  
    self = [super init];
    if (self == nil)
        return nil;
    //loop through skill list until you find it
    NSString* fileName = [NSString stringWithFormat:@"SkillList"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    int currentType = -1;
    int physical = -1;
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
        
        
        
        //If its an empty line, skip it. (the IF hits this one, then all the other ones are "else" so it skips)
        if ([[lineArray objectAtIndex:0] isEqualToString:@""]) 
            currentType = currentType;
        
        //check type
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"NORMAL"]) 
            currentType = NORM;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"FIRE"]) 
            currentType = FIRE;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"ELECTRIC"]) 
            currentType = ELECTRIC;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"WATER"]) 
            currentType = WATER;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"GRASS"]) 
            currentType = GRASS;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"GHOST"]) 
            currentType = GHOST;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"PSYCHIC"]) 
            currentType = PSYCHIC;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"ROCK"]) 
            currentType = ROCK;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"BUFF"]) 
            currentType = BUFF;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"DEBUFF"]) 
            currentType = DEBUFF;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"RESTORE"]) 
            currentType = RESTORE;
        
        
        //check phys/magical
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"PHYSICAL"]) 
            physical = 1;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"MAGICAL"]) 
            physical = 0;
        
        //check if the name matches
        else if ([[lineArray objectAtIndex:0] isEqualToString:name]) 
        {
            _name = [name retain];
            _description = [[lineArray objectAtIndex:3] retain];
            _maxPP = [[lineArray objectAtIndex:2] intValue];
            _curPP = _maxPP;
            _attackPower = [[lineArray objectAtIndex:1] intValue];
            _isPhysical = physical;
            _type = currentType;
                    
            return self;
        }
    }
    
    //nothing found, alert the internet
    _name = @"ERROR";
    NSLog(@"No skill by name %@ found. This is bad, fix it.", name);
    return self;    
}

+(NSString*) getStringForType:(int)type
{
    switch (type) {
        case NORM:
            return @"Normal";
        case FIRE:
            return @"Fire";
        case WATER:
            return @"Water";
        case GRASS:
            return @"Grass";
        case ELECTRIC:
            return @"Electric";
        case ROCK:
            return @"Rock";
        case PSYCHIC:
            return @"Psychic";
        case GHOST:
            return @"Ghost";
        case BUFF:
            return @"Buff";
        case DEBUFF:
            return @"Debuff";
        case RESTORE:
            return @"Restore";
    }
    return @"Error";
}
+(int) getTypeForString:(NSString*)string
{
    if ([[string uppercaseString] isEqualToString:@"NORMAL"])
        return NORM;
    if ([[string uppercaseString] isEqualToString:@"FIRE"])
        return FIRE;
    if ([[string uppercaseString] isEqualToString:@"WATER"])
        return WATER;
    if ([[string uppercaseString] isEqualToString:@"GRASS"])
        return GRASS;
    if ([[string uppercaseString] isEqualToString:@"ELECTRIC"])
        return ELECTRIC;
    if ([[string uppercaseString] isEqualToString:@"ROCK"])
        return ROCK;
    if ([[string uppercaseString] isEqualToString:@"PSYCHIC"])
        return PSYCHIC;
    if ([[string uppercaseString] isEqualToString:@"GHOST"])
        return GHOST;
    if ([[string uppercaseString] isEqualToString:@"BUFF"])
        return BUFF;
    if ([[string uppercaseString] isEqualToString:@"DEBUFF"])
        return DEBUFF;
    if ([[string uppercaseString] isEqualToString:@"RESTORE"])
        return RESTORE;
    
    
    NSLog(@"No type found for string:%@", string);
    return 0;
}
+(NSString*) getStringForStat:(int)stat
{
    switch (stat) {
        case MAXHP:
            return @"Max HP";
        case CURHP:
            return @"HP";
        case PHYSATK:
            return @"Physical Attack";
        case PHYSDEF:
            return @"Physical Defense";
        case MAGICATK:
            return @"Magic Attack";
        case MAGICDEF:
            return @"Magic Defense";
        case SPEED:
            return @"Speed";
        case ACCURACY:
            return @"Accuracy";
    }
    return @"Error";
}

@synthesize name = _name;
@synthesize description = _description;
@synthesize curPP = _curPP;
@synthesize maxPP = _maxPP;
@synthesize attackPower = _attackPower;
@synthesize type = _type;
@synthesize isPhysical = _isPhysical;

-(void) dealloc
{
    [_name release];
    [_description release];
    
    [super dealloc];
}

@end
