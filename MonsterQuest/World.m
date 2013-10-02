//
//  Item.m
//  LazyQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"

@interface World()
@end

@implementation World

-(id) initWithPlayer:(Player*) player
{

	self = [super init];
	if (self == nil)
		return nil;
	
    _player = [player retain];
    _centeredZone = player.worldCoordinates;
    
    int x = (int)_player.worldCoordinates.x;
    int y = (int)_player.worldCoordinates.y;
    _zone = [[Zone alloc] initWithCoordinatesX:x+0 Y:y+0];
    
    _nZone = [[Zone alloc] initWithCoordinatesX:x+0 Y:y+1];
    _sZone = [[Zone alloc] initWithCoordinatesX:x+0 Y:y-1];
    _wZone = [[Zone alloc] initWithCoordinatesX:x-1 Y:y+0];
    _eZone = [[Zone alloc] initWithCoordinatesX:x+1 Y:y+0];
    _nwZone = [[Zone alloc] initWithCoordinatesX:x-1 Y:y+1];
    _swZone = [[Zone alloc] initWithCoordinatesX:x-1 Y:y-1];
    _neZone = [[Zone alloc] initWithCoordinatesX:x+1 Y:y+1];
    _seZone = [[Zone alloc] initWithCoordinatesX:x+1 Y:y-1];
    
	return self;
}

-(void) dealloc
{
	// clean up after we take a sucker's money
    _delegate = nil;
    [_player release];
    [_zone release];
    [_nZone release];
    [_sZone release];
    [_wZone release];
    [_eZone release];
    [_nwZone release];
    [_swZone release];
    [_neZone release];
    [_seZone release];
    [_tempA release];
    [_tempB release];
    [_tempC release];
	[super dealloc];
}

-(void) updatePlayer
{
    [_delegate playerChanged:_player];
    
    if (_player.worldCoordinates.x != _zone.zoneXpos || _player.worldCoordinates.y != _zone.zoneYpos)
        [self loadZones];
}

//Moves player ONE TIME SLICE in that direction. Based on FPS const
-(void) stepWorldOnce
{
    if (_player.moving && !_player.isFrozen)
        [self movePlayerOneStep];
    
    [self moveNPCsOneStep];
    
    
    [_delegate playerChanged:_player];
}

-(void) moveNPCsOneStep
{
    for (NPC* npc in _zone.NPCs)
    {
        if (npc.npcType==0 && npc.monsters.count==0)
        {
            //picks 8 directions. 
            //0-3 = nswe + still. 
            //4-7 = nsew + moving.
            //float random = drand48();
            float random = arc4random()/(float)UINT32_MAX;
            if (random > .98 && npc.recentlyChanged < 1)
            {
                npc.recentlyChanged = 5;
                npc.direction = (arc4random()/(float)UINT32_MAX*7.9999999999);
            
                if (npc.direction > 3)
                {
                    npc.direction -= 4;
                    npc.moving = 1;
                }
                else if (npc.direction < 4)
                    npc.moving = 0;
            }
            
            npc.recentlyChanged -=1;
            
            //log@"direction=%i, moving=%i", npc.direction, npc.moving);
            
            if ([self npcWillCollide:npc])
                npc.moving = 0;
            
            if (npc.moving)
            {
            
                //continue wut doing
                int direction = npc.direction;
            
            
                if(direction == NORTH)
                {
                    if (npc.yPos > 0)
                        npc.ySubPos = npc.ySubPos-(npcMovementSpeed/FPS);
                    else
                        npc.moving = 0;
                }
                else if(direction == SOUTH)
                {
                    if (npc.yPos < ZONE_HEIGHT-1)
                        npc.ySubPos = npc.ySubPos+(npcMovementSpeed/FPS);
                    else
                        npc.moving = 0;
                }
                else if(direction == WEST)
                {
                    if (npc.xPos > 0)
                        npc.xSubPos = npc.xSubPos-(npcMovementSpeed/FPS);
                    else
                        npc.moving = 0;
                }
                else if(direction == EAST)
                {
                    if (npc.xPos < ZONE_WIDTH-1)
                        npc.xSubPos = npc.xSubPos+(npcMovementSpeed/FPS);
                    else
                        npc.moving = 0;
                }
                
            
                //major movements
                if(npc.xSubPos > 0.5) //East
                {
                    npc.xSubPos = -.4999;
                    npc.xPos = npc.xPos+1;
                }
                else if(npc.xSubPos < -0.5) //West
                {
                    npc.xSubPos = .4999;
                    npc.xPos = npc.xPos-1;
                }
                if(npc.ySubPos > 0.5) //North
                {
                    npc.ySubPos = -.4999;
                    npc.yPos = npc.yPos+1;
                }
                else if(npc.ySubPos < -0.5) //South
                {
                    npc.ySubPos = .4999;
                    npc.yPos = npc.yPos-1;
                }
            }
            
            /*
            log@"Starting zone change");
            //zones
            if(npc.yPos > ZONE_HEIGHT-1)  //South
            {
                npc.yPos = 0;
                [_sZone.NPCs addObject:npc];
                [_zone.NPCs removeObject:npc];
            }
            if(npc.yPos < 0)            //North
            {
                npc.yPos = ZONE_HEIGHT-1;
                [_nZone.NPCs addObject:npc];
                [_zone.NPCs removeObject:npc];
            }
            if(npc.xPos < 0)            //west
            {
                npc.xPos = ZONE_WIDTH-1;
                [_wZone.NPCs addObject:npc];
                [_zone.NPCs removeObject:npc];
            }
            if(_player.xPos > ZONE_WIDTH-1) //east
            {
                npc.xPos = 0;
                [_eZone.NPCs addObject:npc];
                [_zone.NPCs removeObject:npc];
            }
            log@"Done with zone change");
             */
            
        }
    }
}
-(void) movePlayerOneStep
{
    
    //double oldTime = _time;
    _time = [[NSDate date] timeIntervalSince1970];
    // double _timeSinceLast = 1000*(_time - oldTime);
    // _timeSinceLast = _timeSinceLast - 16.6666;
    //if (_timeSinceLast > 4)
    //    log@"%fms since last move", _timeSinceLast);
    
    int direction = _player.direction;
    
    if(direction == -1 || _player.isFrozen || !_player.moving)
    {   
        return;
    }
    else 
    {
        _player.direction = direction;
        _player.moving = 1;
    }

    if ([_zone isGrassAtX:_player.xPos Y:_player.yPos]) 
         [self walkingInGrass];
    
    _player.metersWalked += (MovementSpeed /(FPS * 5));
    
    //Apply minor movements
    if(direction == NORTH)
    {
        if(![self playerWillCollideAtDirection:NORTH])
           _player.ySubPos = _player.ySubPos-(MovementSpeed/FPS);
    }
    if(direction == NORTHWEST || direction == NORTHEAST)
    {
        if(![self playerWillCollideAtDirection:NORTH])
            _player.ySubPos = _player.ySubPos - (0.7071 * (MovementSpeed/FPS));
    }
    
    
    if(direction == SOUTH)
    {
        if(![self playerWillCollideAtDirection:SOUTH])
            _player.ySubPos = _player.ySubPos+(MovementSpeed/FPS);
    }
    if (direction == SOUTHWEST || direction == SOUTHEAST)
    {
        if(![self playerWillCollideAtDirection:SOUTH])
            _player.ySubPos = _player.ySubPos + (0.7071 * (MovementSpeed/FPS));
    }
    
    
    if(direction == WEST)
    {
        if(![self playerWillCollideAtDirection:WEST])
            _player.xSubPos = _player.xSubPos-(MovementSpeed/FPS);
    }
    if(direction == NORTHWEST || direction == SOUTHWEST)
    {
        if(![self playerWillCollideAtDirection:WEST])
            _player.xSubPos = _player.xSubPos - (0.7071 * (MovementSpeed/FPS));
    }
    
    
    if(direction == EAST)
    {
        if(![self playerWillCollideAtDirection:EAST])
            _player.xSubPos = _player.xSubPos+(MovementSpeed/FPS);
    }
    if (direction == NORTHEAST || direction == SOUTHEAST)
    {
        if(![self playerWillCollideAtDirection:EAST])
            _player.xSubPos = _player.xSubPos + (0.7071 * (MovementSpeed/FPS));
    }

    
    //Apply major movements from minor movements
    if(_player.xSubPos > 0.5) //East
    {
        _player.xSubPos = -.4999;
        _player.xPos = _player.xPos+1;
        [self teleportCheck];
        [self NPCAggroCheck];
    }
    else if(_player.xSubPos < -0.5) //West
    {
        _player.xSubPos = .4999;
        _player.xPos = _player.xPos-1;
        [self teleportCheck];
        [self NPCAggroCheck];
    }
    if(_player.ySubPos > 0.5) //North
    {
        _player.ySubPos = -.4999;
        _player.yPos = _player.yPos+1;
        [self teleportCheck];
        [self NPCAggroCheck];
    }
    else if(_player.ySubPos < -0.5) //South
    {
        _player.ySubPos = .4999;
        _player.yPos = _player.yPos-1;
        [self teleportCheck];
        [self NPCAggroCheck];
    }

    //Check if player walks into new zone
    if(_player.yPos > ZONE_HEIGHT-1)  //South
    {
        _player.yPos = 0;
        _player.worldCoordinates = CGPointMake(_player.worldCoordinates.x, _player.worldCoordinates.y-1);
        [self loadZones];
    }
    if(_player.yPos < 0)            //North
    {
        _player.yPos = ZONE_HEIGHT-1;
        _player.worldCoordinates = CGPointMake(_player.worldCoordinates.x, _player.worldCoordinates.y+1);
        [self loadZones];
    }
    if(_player.xPos < 0)            //west
    {
        _player.xPos = ZONE_WIDTH-1;
        _player.worldCoordinates = CGPointMake(_player.worldCoordinates.x-1, _player.worldCoordinates.y);
        [self loadZones];
    }
    if(_player.xPos > ZONE_WIDTH-1) //east
    {
        _player.xPos = 0;
        _player.worldCoordinates = CGPointMake(_player.worldCoordinates.x+1, _player.worldCoordinates.y);
        [self loadZones];
    }
}

-(void) walkingInGrass
{
    float random = arc4random()/(float)UINT32_MAX;
    
    //log@"random:%f", random);
    if (random < chanceToEncounterWildMonster)
    {
        NSLog(@"start");
        _player.moving = 0; //stop player from walking
        
        NPC* dummyNPC = [[NPC alloc] initWithCoordinatesX:0 andY:0];
        dummyNPC.name = @"WILD";
        
        //clear his monsters during testing phase
        NSMutableArray* dummyNPCMonsters = [[NSMutableArray alloc] init];
        dummyNPC.monsters = dummyNPCMonsters;        
        
        Monster* wildMonster;
        
        float randomNumber = drand48() * 7;
        int level = [[_player.monsters objectAtIndex:0] getStat:LEVEL] * .8;
        NSLog(@"making random number:%f. should be 0 - 7", randomNumber);
        
        if (randomNumber < 1)
            wildMonster = [[Monster alloc] initMonsterByName:@"Rattles" andLevel:level];
        else if (randomNumber < 2)
            wildMonster = [[Monster alloc] initMonsterByName:@"Tanooky" andLevel:level];
        else if (randomNumber < 3)
            wildMonster = [[Monster alloc] initMonsterByName:@"Teddy" andLevel:level];
        else if (randomNumber < 4)
            wildMonster = [[Monster alloc] initMonsterByName:@"Schnook" andLevel:level];
        else if (randomNumber < 5)
            wildMonster = [[Monster alloc] initMonsterByName:@"Scarab" andLevel:level];
        else if (randomNumber < 6)
            wildMonster = [[Monster alloc] initMonsterByName:@"Rocko" andLevel:level];
        else if (randomNumber < 7)
            wildMonster = [[Monster alloc] initMonsterByName:@"Salaz" andLevel:level];
        
        
        
        
        
        [dummyNPC.monsters addObject:wildMonster];
        
        
        [_delegate initiateCombatWithEnemy:dummyNPC];
        [dummyNPCMonsters release];
        [wildMonster release];
        [dummyNPC release];
    }
}



-(BOOL) playerWillCollideAtDirection:(int)direction
{    
    //int direction = _player.direction;
    
    if(direction == NORTH || direction == NORTHWEST || direction == NORTHEAST)
    {
        //north
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos-1] && _player.ySubPos< (.5 - collisionTolerance))
            return TRUE;
        
        //west
        if ([_zone isCollisionAtX:_player.xPos-1 Y:_player.yPos] && _player.xSubPos< (.5 - sideTolerance))
            return TRUE;
        //east
        if ([_zone isCollisionAtX:_player.xPos+1 Y:_player.yPos] && _player.xSubPos> (-.5 + sideTolerance))
            return TRUE;
        
        
        //collision at neighboring zone
        if (_player.yPos==0 && [_nZone isCollisionAtX:_player.xPos Y:(ZONE_HEIGHT-1)] && _player.ySubPos < (.5 - collisionTolerance))
            return TRUE;
    }
    
    if(direction == SOUTH || direction == SOUTHWEST || direction == SOUTHEAST)
    {
        //south
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos+1] && _player.ySubPos > (-.5 + collisionTolerance))
            return TRUE;
        
        //west
        if ([_zone isCollisionAtX:_player.xPos-1 Y:_player.yPos] && _player.xSubPos< (.5 - sideTolerance))
            return TRUE;
        //east
        if ([_zone isCollisionAtX:_player.xPos+1 Y:_player.yPos] && _player.xSubPos> (-.5 + sideTolerance))
            return TRUE;
        
        
        if (_player.yPos==(ZONE_HEIGHT-1) && [_sZone isCollisionAtX:_player.xPos Y:0] && _player.ySubPos> (-.5 + collisionTolerance))
            return TRUE;
    }
    
    if(direction == WEST || direction == NORTHWEST || direction == SOUTHWEST)
    {
        //west
        if ([_zone isCollisionAtX:_player.xPos-1 Y:_player.yPos] && _player.xSubPos< (.5 - collisionTolerance))
            return TRUE;
        
        //north
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos-1] && _player.ySubPos< (.5 - sideTolerance))
            return TRUE;
        //south
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos+1] && _player.ySubPos > (-.5 + sideTolerance))
            return TRUE;
        
        
        if (_player.xPos==0 && [_wZone isCollisionAtX:(ZONE_WIDTH-1) Y:_player.yPos] && _player.xSubPos< (.5 - collisionTolerance))
            return true;
    }
    
    if(direction == EAST || direction == NORTHEAST || direction == SOUTHEAST)
    {
        //east
        if ([_zone isCollisionAtX:_player.xPos+1 Y:_player.yPos] && _player.xSubPos> (-.5 + collisionTolerance))
            return TRUE;
        
        //north
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos-1] && _player.ySubPos< (.5 - sideTolerance))
            return TRUE;
        //south
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos+1] && _player.ySubPos > (-.5 + sideTolerance))
            return TRUE;
        
        if (_player.xPos==(ZONE_WIDTH-1) && [_eZone isCollisionAtX:0 Y:_player.yPos] && _player.xSubPos> (-.5 + collisionTolerance))
            return true;
        
    }
    
    return false;
}


-(BOOL) npcWillCollide:(NPC*)npc
{    
    int direction = npc.direction;
    int xPos = npc.xPos;
    int yPos = npc.yPos;
    float xSubPos = npc.xSubPos;
    float ySubPos = npc.ySubPos;
    
    if(direction == NORTH || direction == NORTHWEST || direction == NORTHEAST)
    {
        //collision at this zone
        if ([_zone isCollisionAtX:xPos Y:yPos-1] && ySubPos< (.5 - collisionTolerance))
            return TRUE;
        
        //collision at neighboring zone
        if (yPos==0 && [_nZone isCollisionAtX:xPos Y:(ZONE_HEIGHT-1)] && ySubPos < (.5 - collisionTolerance))
            return TRUE;
    }
    
    if(direction == SOUTH || direction == SOUTHWEST || direction == SOUTHEAST)
    {
        if ([_zone isCollisionAtX:xPos Y:yPos+1] && ySubPos > (-.5 + collisionTolerance))
            return TRUE;
        
        if (yPos==(ZONE_HEIGHT-1) && [_sZone isCollisionAtX:xPos Y:0] && ySubPos> (-.5 + collisionTolerance))
            return TRUE;
    }
    
    if(direction == WEST || direction == NORTHWEST || direction == SOUTHWEST)
    {
        if ([_zone isCollisionAtX:xPos-1 Y:yPos] && xSubPos< (.5 - collisionTolerance))
            return TRUE;
        if (xPos==0 && [_wZone isCollisionAtX:(ZONE_WIDTH-1) Y:yPos] && xSubPos< (.5 - collisionTolerance))
            return true;
    }
    
    if(direction == EAST || direction == NORTHEAST || direction == SOUTHEAST)
    {
        if ([_zone isCollisionAtX:xPos+1 Y:yPos] && xSubPos> (-.5 + collisionTolerance))
            return TRUE;
        if (xPos==(ZONE_WIDTH-1) && [_eZone isCollisionAtX:0 Y:yPos] && xSubPos> (-.5 + collisionTolerance))
            return true;
        
    }
    
    return false;
}

-(void) teleportCheck
{
    NSString* returnString = [_zone teleportLocationForCoordsX:_player.yPos andY:_player.xPos];
    //logreturnString);
    if (returnString == nil)
        return;
    
    NSArray* returnedParts = [returnString componentsSeparatedByString:@","];
    int zoneX = [[returnedParts objectAtIndex:0] intValue];
    int zoneY = [[returnedParts objectAtIndex:1] intValue];
    int posX = [[returnedParts objectAtIndex:3] intValue];
    int posY = [[returnedParts objectAtIndex:2] intValue];
    
    _player.xPos = posX;
    _player.yPos = posY;
    
    if (_player.direction == NORTH || _player.direction == NORTHWEST || _player.direction == NORTHEAST) 
        _player.yPos -= 1;
    else
        _player.yPos += 1;
    
    _player.worldCoordinates = CGPointMake(zoneX, zoneY);
    NSLog(@"zonex: %i zoney: %i", zoneX, zoneY);
    [self loadZones];    
}

//zone loading 
-(void) loadEastZones
{
    
    int x   = (int)_player.worldCoordinates.x;
    int y   = (int)_player.worldCoordinates.y;
    
    _neZone = [_tempA initWithCoordinatesX:x+1 Y:y+1];
    _eZone  = [_tempB initWithCoordinatesX:x+1 Y:y+0];
    _seZone = [_tempC initWithCoordinatesX:x+1 Y:y-1];
    
    [_delegate loadZones:nil NorthZone:nil SouthZone:nil WestZone:nil EastZone:_eZone NorthWestZone:nil SouthWestZone:nil NorthEastZone:_neZone SouthEastZone:_seZone];
    
    _zoneLock = 0;
}

-(void) loadWestZones
{
    int x   = (int)_player.worldCoordinates.x;
    int y   = (int)_player.worldCoordinates.y;
    
    _nwZone = [_tempA initWithCoordinatesX:x-1 Y:y+1];
    _wZone  = [_tempB initWithCoordinatesX:x-1 Y:y+0];
    _swZone = [_tempC initWithCoordinatesX:x-1 Y:y-1];
    
    [_delegate loadZones:nil NorthZone:nil SouthZone:nil WestZone:_wZone EastZone:nil NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:nil SouthEastZone:nil];
    
    _zoneLock = 0;
}

-(void) loadNorthZones
{
    int x   = (int)_player.worldCoordinates.x;
    int y   = (int)_player.worldCoordinates.y;
    
    _nwZone = [_tempA initWithCoordinatesX:x-1 Y:y+1];
    _nZone  = [_tempB initWithCoordinatesX:x Y:y+1];
    _neZone = [_tempC initWithCoordinatesX:x+1 Y:y+1];
    
    [_delegate loadZones:nil NorthZone:_nZone SouthZone:nil WestZone:nil EastZone:nil NorthWestZone:_nwZone SouthWestZone:nil NorthEastZone:_neZone SouthEastZone:nil];
    
    _zoneLock = 0;
}

-(void) loadSouthZones
{
    int x   = (int)_player.worldCoordinates.x;
    int y   = (int)_player.worldCoordinates.y;
    
    _swZone = [_tempA initWithCoordinatesX:x-1 Y:y-1];
    _sZone  = [_tempB initWithCoordinatesX:x Y:y-1];
    _seZone = [_tempC initWithCoordinatesX:x+1 Y:y-1];
    
    [_delegate loadZones:nil NorthZone:nil SouthZone:_sZone WestZone:nil EastZone:nil NorthWestZone:nil SouthWestZone:_swZone NorthEastZone:nil SouthEastZone:_seZone];
    
    _zoneLock = 0;
}

-(void) loadZones
{
    double startTime1 = [[NSDate date] timeIntervalSince1970];
    double endTime1;
    
    int x   = (int)_player.worldCoordinates.x;
    int y   = (int)_player.worldCoordinates.y;
    
    while (_zoneLock)
    {
        sleep(1); //sleep while w
        // u wot m8
    }
    
    //go east
    if (x==(_centeredZone.x+1) && y==(_centeredZone.y) && !_zoneLock)
    {
        _zoneLock = 1;
        
        _tempA = _nwZone;
        _tempB = _wZone;
        _tempC = _swZone;
        
        _nwZone = _nZone;
        _wZone = _zone;
        _swZone = _sZone;
        
        _nZone = _neZone;
        _zone = _eZone;
        _sZone = _seZone;
        
        _neZone = nil;
        _eZone = nil;
        _seZone = nil;
        
                
        [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone]; 
        
        [NSThread detachNewThreadSelector: @selector(loadEastZones) toTarget:self withObject:NULL];
    }
    //go west
    else if (x==(_centeredZone.x-1) && y==(_centeredZone.y) && !_zoneLock)
    {
        _zoneLock = 1;
        
        _tempA = _neZone;
        _tempB = _eZone;
        _tempC = _seZone;
        
        _neZone = _nZone;
        _eZone = _zone;
        _seZone = _sZone;
        
        _nZone = _nwZone;
        _zone = _wZone;
        _sZone = _swZone;
        
        _nwZone = nil;
        _wZone = nil;
        _swZone = nil;
        

        [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone]; 
        
        [NSThread detachNewThreadSelector: @selector(loadWestZones) toTarget:self withObject:NULL];
    }
    //go north
    else if (y==(_centeredZone.y+1) && x==(_centeredZone.x) &&!_zoneLock)
    {
        _zoneLock = 1;
        
        _tempA = _swZone;
        _tempB = _sZone;
        _tempC = _seZone;
        
        _swZone = _wZone;
        _sZone = _zone;
        _seZone = _eZone;
        
        _wZone = _nwZone;
        _zone = _nZone;
        _eZone = _neZone;
        
        _nwZone = nil;
        _nZone = nil;
        _neZone = nil;
        
        
        [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone]; 
        
        [NSThread detachNewThreadSelector: @selector(loadNorthZones) toTarget:self withObject:NULL];
    }
    //go south
    else if (y==(_centeredZone.y-1) && x==(_centeredZone.x) &&!_zoneLock)
    {
        _zoneLock = 1;
        
        _tempA = _nwZone;
        _tempB = _nZone;
        _tempC = _neZone;
        
        _nwZone = _wZone;
        _nZone = _zone;
        _neZone = _eZone;
        
        _wZone = _swZone;
        _zone = _sZone;
        _eZone = _seZone;
        
        _swZone = nil;
        _sZone  = nil;
        _seZone = nil;
        
        
        [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone]; 
        
        [NSThread detachNewThreadSelector: @selector(loadSouthZones) toTarget:self withObject:NULL];
    }
    
    else
    {
        _zone = [_zone initWithCoordinatesX:x+0 Y:y+0];
        
        _nZone = [_nZone initWithCoordinatesX:x+0 Y:y+1];
        _sZone = [_sZone initWithCoordinatesX:x+0 Y:y-1];
        _wZone = [_wZone initWithCoordinatesX:x-1 Y:y+0];
        _eZone = [_eZone initWithCoordinatesX:x+1 Y:y+0];
        
        _nwZone = [_nwZone initWithCoordinatesX:x-1 Y:y+1];
        _swZone = [_swZone initWithCoordinatesX:x-1 Y:y-1];
        _neZone = [_neZone initWithCoordinatesX:x+1 Y:y+1];
        _seZone = [_seZone initWithCoordinatesX:x+1 Y:y-1];
        
        [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone]; 
    }
    endTime1 = [[NSDate date] timeIntervalSince1970];
    
    _centeredZone = _player.worldCoordinates;
    NSLog(@"zone change to (%i,%i) took %fms.", x, y, 1000*(endTime1 - startTime1));
}

-(void) NPCAggroCheck
{
    for (NPC* npc in _zone.NPCs)
    {
        if ([npc.monsters count] > 0 && npc.sight > 0)
        {
            int playerX = _player.xPos;
            int playerY = _player.yPos;
            int npcX    = npc.xPos;
            int npcY    = npc.yPos;
            
            bool xMatch     = playerX == npcX;
            bool isLeftOfNPC= playerX < npcX;
            bool yMatch     = playerY == npcY;
            bool isAboveNPC = playerY < npcY;
        
            if (npc.direction == NORTH && xMatch && !yMatch && isAboveNPC && (npcY - playerY) < npc.sight) 
                [_delegate seenByHostileNPC:npc];
            
            if (npc.direction == SOUTH && xMatch && !yMatch && !isAboveNPC && (playerY - npcY) < npc.sight) 
                [_delegate seenByHostileNPC:npc];
            
            if (npc.direction == WEST && yMatch && !xMatch && isLeftOfNPC && (npcX - playerX) < npc.sight) 
                [_delegate seenByHostileNPC:npc];
            
            if (npc.direction == EAST && yMatch && !xMatch && !isLeftOfNPC && (playerX - npcX) < npc.sight) 
                [_delegate seenByHostileNPC:npc];
        }
    }
}

 
@synthesize delegate = _delegate;
@synthesize zone = _zone;
@synthesize player = _player;


@end
 
