//
//  Layer.m
//  MonsterQuest
//
//  Created by u0605593 on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Zone.h"


@implementation Zone


-(id) initWithCoordinatesX:(int)x Y:(int)y
{
    self = [super init];
	if (self == nil)
		return nil;
    
    _zoneXpos = x;
    _zoneYpos = y;    
        
    //Background pictures
    NSString* filename = [NSString stringWithFormat:@"base-%i,%i", x, y];
    _baseLayerImage = [UIImage imageNamed:filename];    
    
    filename = [NSString stringWithFormat:@"overlay-%i,%i", x, y];
    _overlayLayerImage = [UIImage imageNamed:filename];
    
    
    
    //NPCs
    _NPCs = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSString* fileName = [NSString stringWithFormat:@"NPC-%i,%i", x, y];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    if(fileData)
    {    
        //loop through rows, add 1 NPC per row
        for(int i = 0; i< [fileDataRows count]; i++)
        {
            NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"##"];
        
            int xPos = [[lineArray objectAtIndex:0] intValue];
            int yPos = [[lineArray objectAtIndex:1] intValue];
            NSString* text = [[lineArray objectAtIndex:2] retain];
           
            NPC* ThisNPC = [[NPC alloc] initWithCoordinatesX:xPos andY:yPos andText:text];
            [_NPCs insertObject:ThisNPC atIndex:0];
        }
    }
    
    //Collision Map
    _obstacleMap = [[ObstacleMap alloc] initWithCoordinatesX:x Y:y];
    
    //Todo
    //Teleport Locations
    
    
    return self;
}

-(BOOL) isCollisionAtX:(int)x Y:(int)y
{
    return [_obstacleMap isCollisionAtX:x Y:y];
}
-(BOOL) isGrassAtX:(int)x Y:(int)y
{
    return [_obstacleMap isGrassAtX:x Y:y];
}

@synthesize baseLayerImage = _baseLayerImage;
@synthesize overlayLayerImage = _overlayLayerImage;
@synthesize NPCs = _NPCs;
@synthesize zoneXpos = _zoneXpos;
@synthesize zoneYpos = _zoneYpos;



@end