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
    
	return self;
}

-(void) dealloc
{
	// clean up after we take a sucker's money
	[super dealloc];
}

-(void) updatePlayer
{
    [_delegate playerChanged:_player];
}

//Moves player ONE TIME SLICE in that direction. Based on FPS const
-(void) movePlayerOneStep
{
    int direction = _player.direction;
    
    if(direction == -1)
    {   
        return;
    }
    else {
        _player.direction = direction;
        _player.moving = 1;
    }


    
    //Apply minor movements
    if(direction == NORTH || direction == NORTHWEST || direction == NORTHEAST)
    {
        if(![self playerWillCollideAtDirection:NORTH])
           _player.ySubPos = _player.ySubPos-(MovementSpeed/FPS);
    }
    if(direction == SOUTH || direction == SOUTHWEST || direction == SOUTHEAST)
    {
        if(![self playerWillCollideAtDirection:SOUTH])
            _player.ySubPos = _player.ySubPos+(MovementSpeed/FPS);
    }
    if(direction == WEST || direction == NORTHWEST || direction == SOUTHWEST)
    {
        if(![self playerWillCollideAtDirection:WEST])
            _player.xSubPos = _player.xSubPos-(MovementSpeed/FPS);
    }
    if(direction == EAST || direction == NORTHEAST || direction == SOUTHEAST)
    {
        if(![self playerWillCollideAtDirection:EAST])
            _player.xSubPos = _player.xSubPos+(MovementSpeed/FPS);
    }

    
    //Apply major movements from minor movements
    if(_player.xSubPos > 0.5) //East
    {
        _player.xSubPos = -.4999;
        _player.xPos = _player.xPos+1;
        
        if([_zone isGrassAtX:_player.xPos Y:_player.yPos])
            _player.inGrass = 1;
            
    }
    else if(_player.xSubPos < -0.5) //West
    {
        _player.xSubPos = .4999;
        _player.xPos = _player.xPos-1;
    }
    if(_player.ySubPos > 0.5) //North
    {
        _player.ySubPos = -.4999;
        _player.yPos = _player.yPos+1;
    }
    else if(_player.ySubPos < -0.5) //South
    {
        _player.ySubPos = .4999;
        _player.yPos = _player.yPos-1;
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
    
    [_delegate playerChanged:_player];
}

-(void) loadZones
{
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
    NSLog(@"zone change. player at (%i, %i)", x, y);
    
    [_delegate loadZones:_zone NorthZone:_nZone SouthZone:_sZone WestZone:_wZone EastZone:_eZone NorthWestZone:_nwZone SouthWestZone:_swZone NorthEastZone:_neZone SouthEastZone:_seZone];
}

-(BOOL) playerWillCollideAtDirection:(int)direction
{    
    //int direction = _player.direction;
    
    if(direction == NORTH || direction == NORTHWEST || direction == NORTHEAST)
    {
        //collision at this zone
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos-1] && _player.ySubPos< (.5 - collisionTolerance))
        return TRUE;

        
        //collision at neighboring zone
        if (_player.yPos==0 && [_nZone isCollisionAtX:_player.xPos Y:(MAX_COLS-1)] && _player.ySubPos < (.5 - collisionTolerance))
            return TRUE;
    }
    
    if(direction == SOUTH || direction == SOUTHWEST || direction == SOUTHEAST)
    {
        if ([_zone isCollisionAtX:_player.xPos Y:_player.yPos+1] && _player.ySubPos > (-.5 + collisionTolerance))
            return TRUE;
        
        if (_player.yPos==(MAX_COLS-1) && [_sZone isCollisionAtX:_player.xPos Y:0] && _player.ySubPos> (-.5 + collisionTolerance))
            return TRUE;
    }
    
    if(direction == WEST || direction == NORTHWEST || direction == SOUTHWEST)
    {
        if ([_zone isCollisionAtX:_player.xPos-1 Y:_player.yPos] && _player.xSubPos< (.5 - collisionTolerance))
            return TRUE;
        if (_player.xPos==0 && [_wZone isCollisionAtX:(MAX_ROWS-1) Y:_player.yPos] && _player.xSubPos< (.5 - collisionTolerance))
            return true;
    }
    
    if(direction == EAST || direction == NORTHEAST || direction == SOUTHEAST)
    {
        if ([_zone isCollisionAtX:_player.xPos+1 Y:_player.yPos] && _player.xSubPos> (-.5 + collisionTolerance))
            return TRUE;
        if (_player.xPos==(MAX_ROWS-1) && [_eZone isCollisionAtX:0 Y:_player.yPos] && _player.xSubPos> (-.5 + collisionTolerance))
            return true;
        
    }
    
    return false;
}
 
@synthesize delegate = _delegate;
@synthesize zone = _zone;
@synthesize player = _player;


@end
 
