//
//  Zone.h
//  MonsterQuest
//
//  Created by u0605593 on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPC.h"
#import "ObstacleMap.h"

@interface Zone : NSObject 
{
    int _zoneXpos;  //used to keep track of this zones X and Y coordinates
    int _zoneYpos; 
    
    UIImage* _baseLayerImage;
    UIImage* _overlayLayerImage;
    NSMutableDictionary* _teleportLocations;
    
    NSMutableArray* _NPCs;
    
    ObstacleMap* _obstacleMap;
}

-(id) initWithCoordinatesX:(int)x Y:(int)y;
-(BOOL) isCollisionAtX:(int)x Y:(int)y;
-(BOOL) isGrassAtX:(int)x Y:(int)y;
-(NSString*) teleportLocationForCoordsX:(int)x andY:(int)y;

@property(nonatomic, retain) UIImage* baseLayerImage;
@property(nonatomic, retain) UIImage* overlayLayerImage;
@property(nonatomic, retain) NSMutableArray* NPCs;
@property(nonatomic, readonly) int zoneXpos;
@property(nonatomic, readonly) int zoneYpos;




@end
