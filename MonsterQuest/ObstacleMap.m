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
    //log@"building obstacles for zone (%i,%i)", x, y);
    
    self = [super init];
	if (self == nil)
		return nil;
        
    //x = 0;
    //y = 0;
    
    NSString* fileName = [NSString stringWithFormat:@"obstacles-%i,%i", x, y];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    int i = 0;
    

    
    if(fileData)
    {    
        NSArray* fileDataElements = [fileData componentsSeparatedByString:@" "];
        
        if (fileDataElements.count < 260 && fileDataElements.count > 250)
        {
            
        }
        
        else if ([fileDataElements count] < 1024) 
        {
            NSLog(@"corrupt obstacle elements for zone(%i,%i). has %i obstacles", x, y, [fileDataElements count]);
        }
        
        else
        {
            for(int x = 0; x< ZONE_WIDTH; x++)
            { 
                for(int y = 0; y< ZONE_HEIGHT; y++)
                { 
                    _collisionMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                    i++;
                }
            }
        }
    }
        
    fileName = [NSString stringWithFormat:@"grass-%i,%i", x, y];
	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    i = 0;
    
    if(fileData)
    {    
        
        NSArray* fileDataElements = [fileData componentsSeparatedByString:@" "];
        
        if (fileDataElements.count < 260 && fileDataElements.count > 250)
        {
            
        }
        
        else if ([fileDataElements count] < 1024) 
        {
            NSLog(@"corrupt grass elements for zone(%i,%i). has %i obstacles", x, y, [fileDataElements count]);
        }
        
        else
        {
            for(int x = 0; x< ZONE_WIDTH; x++)
            { 
                for(int y = 0; y< ZONE_HEIGHT; y++)
                { 
                    _grassMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                    i++;
                }
            }
        }
    }
    
    
    return self;
}

-(void) updateToCoordinatesX:(int)x Y:(int)y
{
    
    NSString* fileName = [NSString stringWithFormat:@"obstacles-%i,%i", x, y];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    int i = 0;
    
    if(fileData)
    {    
        NSArray* fileDataElements = [fileData componentsSeparatedByString:@" "];
        
        if ([fileDataElements count] < 1024) 
        {
            NSLog(@"corrupt obstacle elements for zone(%i,%i)", x, y);
        }
        
        else
        {
            for(int x = 0; x< ZONE_WIDTH; x++)
            { 
                for(int y = 0; y< ZONE_HEIGHT; y++)
                { 
                    _collisionMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                    i++;
                }
            }
        }
    }
    
    fileName = [NSString stringWithFormat:@"grass-%i,%i", x, y];
	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    i = 0;
    
    if(fileData)
    {    
        
        NSArray* fileDataElements = [fileData componentsSeparatedByString:@" "];
        
        if ([fileDataElements count] < 1024) 
        {
            NSLog(@"corrupt grass elements for zone(%i,%i)", x, y);
        }
        
        else
        {
            for(int x = 0; x< ZONE_WIDTH; x++)
            { 
                for(int y = 0; y< ZONE_HEIGHT; y++)
                { 
                    _grassMap[x][y] = [[fileDataElements objectAtIndex:i] intValue];
                    i++;
                }
            }
        }
    }
}

-(BOOL) isCollisionAtX:(int)x Y:(int)y
{   
    if (x < 0 || x > ZONE_WIDTH-1) 
        return FALSE;
    
    if (y < 0 || y > ZONE_HEIGHT-1) 
        return FALSE;
    
    
    return (_collisionMap[x][y]==1);
}
-(BOOL) isGrassAtX:(int)x Y:(int)y
{   
    if (x < 0 || x > ZONE_WIDTH-1) 
        return FALSE;
    
    if (y < 0 || y > ZONE_HEIGHT-1) 
        return FALSE;
    
    return (_grassMap[x][y]==1);
}

-(void) dealloc
{
    
    [super dealloc];
}

@end
