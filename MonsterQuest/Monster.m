//
//  Monster.m
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"


@implementation Monster
 
-(id) initMonsterByName:(NSString*)name andLevel:(int)level
{
    self = [super init];
    if (self == nil)
        return nil;
    
    //loop through skill list until you find it
    NSString* fileName = @"MonsterStatList";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"#"];
        
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"\n"];
        
        if ([[lineArray objectAtIndex:1] isEqualToString:name]) 
        {
            self = [super init];           
            [self resetModifiedStats];
            
            //Apply values to monster
            _name = [[lineArray objectAtIndex:1] retain];
            _number = [[lineArray objectAtIndex:0] intValue];
            
            _statCoefficients[MAXHP]    = [[lineArray objectAtIndex:3] intValue];
            _statCoefficients[PHYSATK]  = [[lineArray objectAtIndex:4] intValue];
            _statCoefficients[PHYSDEF]  = [[lineArray objectAtIndex:5] intValue];
            _statCoefficients[MAGICATK] = [[lineArray objectAtIndex:6] intValue];
            _statCoefficients[MAGICDEF] = [[lineArray objectAtIndex:7] intValue];
            _statCoefficients[SPEED]    = [[lineArray objectAtIndex:8] intValue];
            
            _stats[MAXHP]       = flatHp;
            _stats[LEVEL]       = 0;
            _stats[TYPE]        = [Skill getTypeForString:[lineArray objectAtIndex:2]]; 
            _stats[EXP]         = 0;
            _stats[ACCURACY]    = 90;
            _stats[CRITICAL]    = 10;
            
            
            _skills = [[NSMutableArray alloc] initWithObjects:nil];
            
            
            //get skills and level him up
            while(_stats[LEVEL] < level)
            {
                _stats[LEVEL]++;
                [self levelUp];
            }
            
            _stats[CURHP]       = _stats[MAXHP];
            
            return self;
        }
        
        
    }
    
    //nothing found, alert the internet

    _name = @"ERROR";
    NSLog(@"No monster by name %@ found. This is bad, fix it.", name);
    return self;   
}

-(id) initMonsterByNumber:(int)number andLevel:(int)level
{
    self = [super init];
    if (self == nil)
        return nil;
    
    //loop through skill list until you find it
    NSString* fileName = @"MonsterStatList";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"#"];
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"\n"];
        
        if ([[lineArray objectAtIndex:0] intValue] == number) 
        {
            self = [super init];           
            [self resetModifiedStats];
            
            //Apply values to monster
            _name = [[lineArray objectAtIndex:1] retain];
            _number = [[lineArray objectAtIndex:0] intValue];
            
            _statCoefficients[MAXHP]    = [[lineArray objectAtIndex:3] intValue];
            _statCoefficients[PHYSATK]  = [[lineArray objectAtIndex:4] intValue];
            _statCoefficients[PHYSDEF]  = [[lineArray objectAtIndex:5] intValue];
            _statCoefficients[MAGICATK] = [[lineArray objectAtIndex:6] intValue];
            _statCoefficients[MAGICDEF] = [[lineArray objectAtIndex:7] intValue];
            _statCoefficients[SPEED]    = [[lineArray objectAtIndex:8] intValue];
            
            _stats[MAXHP]       = flatHp;
            _stats[LEVEL]       = 0;
            _stats[TYPE]        = [Skill getTypeForString:[lineArray objectAtIndex:2]]; 
            _stats[EXP]         = 0;
            _stats[ACCURACY]    = 90;
            _stats[CRITICAL]    = 10;
            
            
            _skills = [[NSMutableArray alloc] initWithObjects:nil];
            
            
            //get skills and level him up
            while(_stats[LEVEL] < level)
            {
                _stats[LEVEL]++;
                [self levelUp];
            }
            
            _stats[CURHP]       = _stats[MAXHP];
            
            return self;
        }
        
        
    }
    
    //nothing found, alert the internet
    _name = @"ERROR";
    NSLog(@"No monster by number %i found. This is bad, fix it.", number);
    return self;   
}

-(id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init])
	{
        _name          = [[decoder decodeObjectForKey:@"name"] retain];
        _number        = [decoder decodeIntForKey:@"number"];
        for (int i = 0; i< 12; i++)
        {
            _stats[i]            = [decoder decodeIntForKey:[NSString stringWithFormat:@"stats%i", i]];
            _statCoefficients[i] = [decoder decodeIntForKey:[NSString stringWithFormat:@"statcoefficients%i", i]];
            _modifiedStats[i]    = [decoder decodeFloatForKey:[NSString stringWithFormat:@"modifiedstats%i", i]];
        }
        _skills        = [[decoder decodeObjectForKey:@"skills"] retain];
        _weaponSlot    = [[decoder decodeObjectForKey:@"weaponslot"] retain];
        _armorSlot     = [[decoder decodeObjectForKey:@"armorslot"] retain];
        _accessorySlot = [[decoder decodeObjectForKey:@"accessoryslot"] retain];
	}
    
	return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name         forKey:@"name"];
	[encoder encodeInt:_number          forKey:@"number"];
    for (int i = 0; i< 12; i++)
    {
        [encoder encodeInt:_stats[i] forKey:[NSString stringWithFormat:@"stats%i", i]];
        [encoder encodeInt:_statCoefficients[i] forKey:[NSString stringWithFormat:@"statcoefficients%i", i]];
        [encoder encodeFloat:_modifiedStats[i] forKey:[NSString stringWithFormat:@"modifiedstats%i", i]];
    }
    [encoder encodeObject:_skills        forKey:@"skills"];
    [encoder encodeObject:_weaponSlot    forKey:@"weaponslot"];
    [encoder encodeObject:_armorSlot     forKey:@"armorslot"];
    [encoder encodeObject:_accessorySlot forKey:@"accessoryslot"];
    
}

-(int)getStat:(int)stat
{
    return _stats[stat];
}
- (void)setStat:(int)stat withValue:(int)value;
{
    _stats[stat] = value;
}
-(int) getCoefficientForStat:(int)stat
{
    return _statCoefficients[stat];
}
-(void) giveXP:(int)xp
{
    _stats[EXP] += xp;
    
    //check if level up
    while (_stats[EXP] > [self expToLevel])
    {
        _stats[EXP] = _stats[EXP] - [self expToLevel];
        _stats[LEVEL]++;
        [self levelUp];
    }
        
}

-(void)recieveDamage:(int)damage
{    
    _stats[CURHP] = _stats[CURHP] - damage;
    
    if (_stats[CURHP] < 0)
        _stats[CURHP] = 0;
    
}

-(void) setSkillByName:(NSString *)skillname atSlot:(int)slot
{
    if(slot<1 || slot>4)
    {
        NSLog(@"Slots are from 1-4");
        return;
    }
    
    //fetch skill
    Skill* skill = [[Skill alloc] initSkillByName:skillname];
    
    
    //monster has <4 attacks, so just insert it
    if ([_skills count]<4)
    {
        [_skills addObject:skill];
    }
    //monster has 4 attacks, replace it
    else
    {
        [_skills removeObjectAtIndex:(slot-1)];
        [_skills insertObject:skill atIndex:(slot-1)];
    }
    [skill release];
}

- (UIImage*) getImage
{
    
    NSString* nameString = [NSString stringWithFormat:@"%i", _number];
    return [UIImage imageNamed:nameString];
}

- (void)dealloc
{
    [_name release];
    [_skills release];
    [_weaponSlot release];
    [_armorSlot release];
    [_accessorySlot release];
    [super dealloc];
}

//returns total XP required to get to next level. NOT remaining xp.
-(int) expToLevel
{
    return _stats[LEVEL]*100;
}


-(void) useConsumable:(Consumable*)consumable
{
    NSAssert(consumable.consumableType == 0, @"Make sure item is usuable directly to monster");
    
    _stats[consumable.stat] = _stats[consumable.stat] + consumable.value;
    if(_stats[CURHP] > _stats[MAXHP])
        _stats[CURHP] = _stats[MAXHP];
}

-(void) getSkillForCurrentLevel
{
    NSString* fileName = @"MonsterSkillList";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* monsterRows = [fileData componentsSeparatedByString:@"#"];
    
    for (int i = 0; i<[monsterRows count]; i++) 
    {
        
        NSArray* lineArray = [[monsterRows objectAtIndex:i] componentsSeparatedByString:@"\n"];
        
        //monster matches
        if ([[lineArray objectAtIndex:0] isEqualToString:_name]) 
        {
            for (NSString* line in lineArray) 
            {
                //new skill
                NSArray* separatedLine = [line componentsSeparatedByString:@"_"];
                if ([separatedLine count] == 2 && [[separatedLine objectAtIndex:0] intValue] == _stats[LEVEL])
                {
                    NSString* skillname1 = [separatedLine objectAtIndex:1];                    
                    [self setSkillByName:skillname1 atSlot:1];
                    return; //note - remove this if we want more than 1 skill per level.
                }
                //evolve
                else if ([separatedLine count] == 3 && [[separatedLine objectAtIndex:0] intValue] == _stats[LEVEL])
                {
                    NSString* evolutionName = [separatedLine objectAtIndex:2];   
                    Monster* evolution = [[Monster alloc] initMonsterByName:evolutionName andLevel:_stats[LEVEL]];
                    
                    _name = [evolutionName retain];
                    _skills = evolution.skills;
                    _number = evolution.number;
                    
                    for (int zz = 0; zz<12; zz++)
                    {
                        _stats[zz] = [evolution getStat:zz];
                        _statCoefficients[zz] = [evolution getCoefficientForStat:zz];
                    }
                    
                    return;
                }   
                    
            }
        }
    }
}

-(void) setEquipment:(Equipment*)equipment toSlot:(int)slot
{
    NSAssert(slot>0, @"derp1");
    NSAssert(slot<4, @"derp1");
        
    if (slot == 1) 
    {
        //remove old item
        if (_weaponSlot != nil) 
        {
            _stats[MAXHP] -= _weaponSlot.maxhp;
            _stats[CURHP] -= _weaponSlot.maxhp;
            _stats[PHYSATK] -= _weaponSlot.physatk;
            _stats[PHYSDEF] -= _weaponSlot.physdef;
            _stats[MAGICATK] -= _weaponSlot.magicatk;
            _stats[MAGICDEF] -= _weaponSlot.magicdef;
            _stats[SPEED] -= _weaponSlot.speed;
            _stats[ACCURACY] -= _weaponSlot.accuracy;
            _stats[CRITICAL] -= _weaponSlot.critical;
            
        }
        
        //apply new item
        _weaponSlot = [equipment retain];
        _stats[MAXHP] += _weaponSlot.maxhp;
        _stats[CURHP] += _weaponSlot.maxhp;
        _stats[PHYSATK] += _weaponSlot.physatk;
        _stats[PHYSDEF] += _weaponSlot.physdef;
        _stats[MAGICATK] += _weaponSlot.magicatk;
        _stats[MAGICDEF] += _weaponSlot.magicdef;
        _stats[SPEED] += _weaponSlot.speed;
        _stats[ACCURACY] += _weaponSlot.accuracy;
        _stats[CRITICAL] += _weaponSlot.critical;
    }
    
    if (slot == 2) 
    {
        if (_armorSlot != nil) 
        {
            _stats[MAXHP] -= _armorSlot.maxhp;
            _stats[CURHP] -= _armorSlot.maxhp;
            _stats[PHYSATK] -= _armorSlot.physatk;
            _stats[PHYSDEF] -= _armorSlot.physdef;
            _stats[MAGICATK] -= _armorSlot.magicatk;
            _stats[MAGICDEF] -= _armorSlot.magicdef;
            _stats[SPEED] -= _armorSlot.speed;
            _stats[ACCURACY] -= _armorSlot.accuracy;
            _stats[CRITICAL] -= _armorSlot.critical;
            //todo: accuracy
        }
        
        _armorSlot = [equipment retain];
        _stats[MAXHP] += _armorSlot.maxhp;
        _stats[CURHP] += _armorSlot.maxhp;
        _stats[PHYSATK] += _armorSlot.physatk;
        _stats[PHYSDEF] += _armorSlot.physdef;
        _stats[MAGICATK] += _armorSlot.magicatk;
        _stats[MAGICDEF] += _armorSlot.magicdef;
        _stats[SPEED] += _armorSlot.speed;
        _stats[ACCURACY] += _armorSlot.accuracy;
        _stats[CRITICAL] += _armorSlot.critical;
    }
    if (slot == 3) 
    {
        if (_accessorySlot != nil) 
        {
            _stats[MAXHP] -= _accessorySlot.maxhp;
            _stats[CURHP] -= _accessorySlot.maxhp;
            _stats[PHYSATK] -= _accessorySlot.physatk;
            _stats[PHYSDEF] -= _accessorySlot.physdef;
            _stats[MAGICATK] -= _accessorySlot.magicatk;
            _stats[MAGICDEF] -= _accessorySlot.magicdef;
            _stats[SPEED] -= _accessorySlot.speed;
            _stats[ACCURACY] -= _accessorySlot.accuracy;
            _stats[CRITICAL] -= _accessorySlot.critical;
        }
        
        _accessorySlot = [equipment retain];
        _stats[MAXHP] += _accessorySlot.maxhp;
        _stats[CURHP] += _accessorySlot.maxhp;
        _stats[PHYSATK] += _accessorySlot.physatk;
        _stats[PHYSDEF] += _accessorySlot.physdef;
        _stats[MAGICATK] += _accessorySlot.magicatk;
        _stats[MAGICDEF] += _accessorySlot.magicdef;
        _stats[SPEED] += _accessorySlot.speed;
        _stats[ACCURACY] += _accessorySlot.accuracy;
        _stats[CRITICAL] += _accessorySlot.critical;
    }
    
    if (_stats[CURHP] < 1)
        _stats[CURHP] = 1;
    if (_stats[CURHP] > _stats[MAXHP]) 
        _stats[CURHP] = _stats[MAXHP];    

}
-(void) levelUp;
{
    _stats[MAXHP]       += _statCoefficients[MAXHP];
    _stats[CURHP]       += _statCoefficients[MAXHP];
    _stats[PHYSATK]     += _statCoefficients[PHYSATK];
    _stats[PHYSDEF]     += _statCoefficients[PHYSDEF];
    _stats[MAGICATK]    += _statCoefficients[MAGICATK];
    _stats[MAGICDEF]    += _statCoefficients[MAGICDEF];
    _stats[SPEED]       += _statCoefficients[SPEED];
    
    [self getSkillForCurrentLevel];
}

+(float)getTypeMultiplierWithAttacktype:(int)at andDefenseType:(int)dt
{    
    if (at==WATER)
    {
        if (dt==FIRE)
            return 2.0;
        
        if (dt==ROCK)
            return 2.0;
    }
    
    if (at==NORM)
    {
        if (dt==ROCK)
            return 0.5;
    }
    
    if (at==GRASS) 
    {
        if (dt==ROCK)
            return 2.0;
    }
    
    if (at==FIRE) 
    {
        if (dt==GRASS)
            return 2.0;
    }
    
    return 1.00;
}

-(float) getMofidiedStat:(int)stat
{
    return _modifiedStats[stat];
}
-(void) resetModifiedStats
{
    for (int i = 0; i < 12; i++)
        _modifiedStats[i] = 1;
}
-(bool) incrementStat:(int)stat
{
    
    if (stat == PHYSATK || stat == PHYSDEF || stat == MAGICATK || stat == MAGICDEF || stat == SPEED)
    {
    
        if (_modifiedStats[stat] > 1.83) 
            return false;
        
        _modifiedStats[stat] = sqrt((2*_modifiedStats[stat]));
    
        return true;
    }
    else if (stat == ACCURACY || stat == CRITICAL)
    {
        if (_modifiedStats[stat] > 10)
            return false;
        
        _modifiedStats[stat] += 2;
        return true;
    }
    else
    {
        NSLog(@"undefined stat changed");
        return false;
    }
    
}
-(bool) decrementStat:(int)stat
{    
    if (stat == PHYSATK || stat == PHYSDEF || stat == MAGICATK || stat == MAGICDEF || stat == SPEED)
    {
        
        if (_modifiedStats[stat] < 0.546) 
            return false;
        
        _modifiedStats[stat] = sqrt((_modifiedStats[stat]/2));
        
        return true;
    }
    else if (stat == ACCURACY || stat == CRITICAL)
    {
        if (_modifiedStats[stat] < -10)
            return false;
        
        _modifiedStats[stat] -= 2;
        return true;
    }
    else
    {
        NSLog(@"undefined stat changed");
        return false;
    }
}
-(void) resetPP
{
    for (Skill* skill in _skills)
        skill.curPP = skill.maxPP;
}
-(void) incrementPP
{
    for (Skill* skill in _skills)
    {
        skill.curPP = skill.curPP + 1;
        
        if (skill.curPP >= skill.maxPP)
            skill.curPP = skill.maxPP;
    }
}


@synthesize name = _name;
@synthesize number = _number;
@synthesize skills = _skills;
@synthesize weaponSlot = _weaponSlot;
@synthesize armorSlot = _armorSlot;
@synthesize accessorySlot = _accessorySlot;

@end
