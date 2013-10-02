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
    
    _worldCoordinates = CGPointMake(playerStartZoneX, playerStartZoneY);
    //_worldCoordinates = CGPointMake(18, 2);
    _name = [name retain];
    _gold = 52;
    _moving = 0;
    _direction = SOUTH;
    _xPos = playerStartPosX;
    _xSubPos = 0.0;
    _yPos = playerStartPosY;
    //_yPos = 28;
    _ySubPos = 0.0;
    _metersWalked = 0.0;
    
    _monsters = [[NSMutableArray alloc] initWithObjects:nil];
    _storedMonsters = [[NSMutableArray alloc] initWithObjects:nil];
    _consumables = [[NSMutableArray alloc] initWithObjects:nil];
    _equipment = [[NSMutableArray alloc] initWithObjects:nil];  
    
    for (int i = 0; i<maxMonsterCount; i++)
        _seenMonsters[i] = 0;
    
    //_ownedBadges[i] = 1;
    Monster* thisMonster = [[Monster alloc] initMonsterByNumber:14 andLevel:5];
    [self capturedMonster:thisMonster];
    [thisMonster release];
    
    Consumable* potion = [[Consumable alloc] initConsumableByName:@"Strong Potion"];
    [potion setQuantity:5];
    [_consumables addObject:potion];
    [potion release];
    
    Consumable* monsterBall = [[Consumable alloc] initConsumableByName:@"Monsterball"];
    [_consumables addObject:monsterBall];
    [monsterBall release];
    
    Equipment* item = [[Equipment alloc] initEquipmentByName:@"Linen Cloak"];
    [_equipment addObject:item];
    [item release];
    
    return self;
}

-(id) initWithCoder:(NSCoder*)decoder
{
    
    if (self = [super init])
    {
        
        [self setName:[decoder decodeObjectForKey:@"name"]];
        
        _gold               = [decoder decodeIntForKey:@"gold"];
        _worldCoordinates   = [decoder decodeCGPointForKey:@"worldCoordinates"];
        _xPos               = [decoder decodeIntForKey:@"xPos"];
        _yPos               = [decoder decodeIntForKey:@"yPos"];
        _secondsPlayed      = [decoder decodeDoubleForKey:@"secondsPlayed"];
        _metersWalked       = [decoder decodeDoubleForKey:@"metersWalked"];
        _ySubPos            = [decoder decodeFloatForKey:@"ySubPos"];
        _xSubPos            = [decoder decodeFloatForKey:@"xSubPos"];
        _direction          = [decoder decodeIntForKey:@"direction"];
        _moving             = [decoder decodeBoolForKey:@"moving"];
        
        for (int i = 0; i < maxMonsterCount; i++)
        {
            _seenMonsters[i] = [decoder decodeBoolForKey:[NSString stringWithFormat:@"seenMonster%i", i]];
        }
        
        
        [self setMonsters:[decoder decodeObjectForKey:@"monsters"]];
        [self setStoredMonsters:[decoder decodeObjectForKey:@"storedMonsters"]];
        [self setConsumables:[decoder decodeObjectForKey:@"consumables"]];
        [self setEquipment:[decoder decodeObjectForKey:@"equipment"]];
        
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name                 forKey:@"name"];
    [encoder encodeInt:_gold                    forKey:@"gold"];
    [encoder encodeCGPoint:_worldCoordinates    forKey:@"worldCoordinates"];
    [encoder encodeInt:_xPos                    forKey:@"xPos"];
    [encoder encodeInt:_yPos                    forKey:@"yPos"];
    [encoder encodeFloat:_xSubPos               forKey:@"xSubPos"];
    [encoder encodeFloat:_ySubPos               forKey:@"ySubPos"];
    [encoder encodeInt:_direction               forKey:@"direction"];
    [encoder encodeBool:_moving                 forKey:@"moving"];
    [encoder encodeDouble:_metersWalked         forKey:@"metersWalked"];
    [encoder encodeDouble:_secondsPlayed        forKey:@"secondsPlayed"];
    
    for (int i = 0; i < maxMonsterCount; i++)
    {
        [encoder encodeBool:_seenMonsters[i] forKey:[NSString stringWithFormat:@"seenMonster%i", i]];
    }
    
    [encoder encodeObject:_monsters             forKey:@"monsters"];
    [encoder encodeObject:_storedMonsters       forKey:@"storedMonsters"];
    [encoder encodeObject:_consumables          forKey:@"consumables"];
    [encoder encodeObject:_equipment            forKey:@"equipment"];
    
}

- (void)dealloc
{
    [_name release];
    [_monsters release];
    [_storedMonsters release];
    [_consumables release];
    [_equipment release];
    [super dealloc];
}

-(void) addConsumableToInventory:(Consumable*) consumable
{
    //check if its there
    for (Consumable* existingConsumable in _consumables)
    {
        if([existingConsumable.name isEqualToString:consumable.name])
        {
            [existingConsumable setQuantity:(existingConsumable.quantity + 1)];
            return;
        }
    }
    //not there so add it
    [_consumables addObject:consumable];
}

-(void) removeConsumableFromInventory:(Consumable*) consumable
{
    //check if its there
    for (Consumable* existingConsumable in _consumables)
    {
        if([existingConsumable.name isEqualToString:consumable.name])
        {
            if(existingConsumable.quantity >1)
                [existingConsumable setQuantity:(existingConsumable.quantity - 1)];
            else
                [_consumables removeObject:existingConsumable];
            return;
        }
    }
    NSAssert(FALSE, @"shits broken");
}

-(void) capturedMonster:(Monster*)monster
{
    _seenMonsters[monster.number-1] = 1;
    
    if (_monsters.count < maxHoldableMonsters) 
        [_monsters addObject:monster];
    else
        [_storedMonsters addObject:monster];
}
-(bool) hasSeenMonster:(int)number
{
    return _seenMonsters[number-1];
}
-(void) sawMonster:(int)number
{
    _seenMonsters[number-1] = 1;
}
-(void) recievesBadge:(int)number
{
    _ownedBadges[number-1] = 1;
}
-(bool) hasBadge:(int)number
{
    return _ownedBadges[number-1];
}
-(NSString*) getTimePlayed
{
    NSString* hoursString = [NSString stringWithFormat:@"%i", (int)_secondsPlayed/3600];
    NSString* minutesString;
    NSString* secondsString;
    
    
    int minutes = (int)(_secondsPlayed/60)%60;
    if (minutes < 9)
        minutesString = [NSString stringWithFormat:@"0%i", minutes];
    else
        minutesString = [NSString stringWithFormat:@"%i", minutes];
    
    
    int seconds = (int)(_secondsPlayed)%60;
    if (seconds < 9)
        secondsString = [NSString stringWithFormat:@"0%i", seconds];
    else
        secondsString = [NSString stringWithFormat:@"%i", seconds];
    
    
    NSString* description = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
    
    return description;
}

@synthesize name=_name;
@synthesize monsters = _monsters;
@synthesize storedMonsters = _storedMonsters;
@synthesize consumables = _consumables;
@synthesize equipment = _equipment;
@synthesize gold=_gold;
@synthesize direction=_direction;
@synthesize moving=_moving;
@synthesize xPos = _xPos;
@synthesize yPos = _yPos;
@synthesize xSubPos = _xSubPos;
@synthesize ySubPos = _ySubPos;
@synthesize worldCoordinates = _worldCoordinates;
@synthesize isFrozen = _isFrozen;
@synthesize secondsPlayed = _secondsPlayed;
@synthesize metersWalked = _metersWalked;


@end
