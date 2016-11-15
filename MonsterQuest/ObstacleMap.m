//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ObstacleMap.h"

@implementation ObstacleMap

-(id) initWithCoordinatesX:(int)x Y:(int)y
{
    self = [super init];
	if (self == nil)
		return nil;
    
    
    NSString* fileName = [NSString stringWithFormat:@"obstacles-%i,%i", x, y];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataElements = [fileData componentsSeparatedByString:@" "];
    
    int i =0;
    
    if(fileData)
    {    
        for(int x = 0; x< MAX_ROWS; x++)
        { 
            for(int y = 0; y< MAX_COLS; y++)
            { 
                _collisionMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                //NSLog(@"Adding %i at (%i, %i)", _collisionMap[x][y], x, y);
                i++;
            }
        }
    }
    
    fileName = [NSString stringWithFormat:@"grass-%i,%i", x, y];
	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    fileDataElements = [fileData componentsSeparatedByString:@" "];
    
    i =0;
    
    if(fileData)
    {    
        for(int x = 0; x< MAX_ROWS; x++)
        { 
            for(int y = 0; y< MAX_COLS; y++)
            { 
                _grassMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                //NSLog(@"Adding %i at (%i, %i)", _collisionMap[x][y], x, y);
                i++;
            }
        }
    }
    
    
    return self;
}

-(BOOL) isCollisionAtX:(int)x Y:(int)y
{   
    if (x < 0 || x > MAX_ROWS-1) 
        return FALSE;
    
    if (y < 0 || y > MAX_COLS-1) 
        return FALSE;
    
    
    return (_collisionMap[x][y]==1);
}
-(BOOL) isGrassAtX:(int)x Y:(int)y
{
    if (x < 0 || x > MAX_ROWS-1) 
        return FALSE;
    
    if (y < 0 || y > MAX_COLS-1) 
        return FALSE;
    
    return (_grassMap[x][y]==1);
}

@end
