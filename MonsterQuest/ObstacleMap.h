//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MAX_COLS 16
#define MAX_ROWS 16

@interface ObstacleMap : NSObject 

{
    int _collisionMap[MAX_COLS][MAX_ROWS];
    int _grassMap[MAX_COLS][MAX_ROWS];
    
}

-(id) initWithCoordinatesX:(int)x Y:(int)y;
-(BOOL) isCollisionAtX:(int)x Y:(int)y;
-(BOOL) isGrassAtX:(int)x Y:(int)y;

@end
