//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZONE_WIDTH 32
#define ZONE_HEIGHT 32

@interface ObstacleMap : NSObject 

{
    int _collisionMap[ZONE_WIDTH][ZONE_HEIGHT];
    int _grassMap[ZONE_WIDTH][ZONE_HEIGHT];
    
}

-(id) initWithCoordinatesX:(int)x Y:(int)y;
-(BOOL) isCollisionAtX:(int)x Y:(int)y;
-(BOOL) isGrassAtX:(int)x Y:(int)y;
-(void) updateToCoordinatesX:(int)x Y:(int)y;

@end
