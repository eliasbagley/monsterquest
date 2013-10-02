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
    _baseLayerImage = [[UIImage imageNamed:filename] retain];    
    
    filename = [NSString stringWithFormat:@"overlay-%i,%i", x, y];
    _overlayLayerImage = [[UIImage imageNamed:filename] retain];
    
        
    //NPCs
    if (_NPCs)
        [_NPCs removeAllObjects];
    else
        _NPCs = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSString* fileName = [NSString stringWithFormat:@"NPC-%i,%i", x, y];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    if(fileData)
    {    
        
        NSArray* NPCs = [fileData componentsSeparatedByString:@"\n\n"];
        
        //loop through NPCs
        for(int i = 0; i< [NPCs count]; i++)
        {
           
            NSArray* NPCrows = [[NPCs objectAtIndex:i] componentsSeparatedByString:@"\n"];
            NPC* ThisNPC;
            //loop through rows in NPC paragraph
            //NOTE: There must be 2 "new lines" between NPCs now
            for(int k = 0; k < [NPCrows count] - 0; k++)
            {
                
                NSArray* cells = [[NPCrows objectAtIndex:k] componentsSeparatedByString:@"#"];

                //make the NPC
                if (k==0) 
                {
                    if (cells.count !=8 && cells.count != 9) 
                    {
                        NSLog(@"NPC-%i,%i NPC:%i, Row:%i - npc - incorrect arguments", x,y,i,k);
                        break;
                    }
                    
                    int pictureID = [[cells objectAtIndex:0] intValue];
                    int xPos = [[cells objectAtIndex:1] intValue];
                    int yPos = [[cells objectAtIndex:2] intValue];
                    NSString* npcName = [cells objectAtIndex:3];
                    NSString* challengeText = [cells objectAtIndex:4 ];
                    NSString* defeatText = [cells objectAtIndex:5 ];
                    NSString* chatText = [cells objectAtIndex:6];
                    int vendorType = [[cells objectAtIndex:7] intValue];
                    
                    int direction = SOUTH;
                    if (cells.count == 9)
                        direction = [[cells objectAtIndex:8] intValue];
                        
                    
                    defeatText = [NSString stringWithFormat:@"%@: %@", npcName, defeatText];
                    
                    ThisNPC = [[NPC alloc] initWithCoordinatesX:xPos andY:yPos];
                    ThisNPC.name = npcName;
                    ThisNPC.challengeText = challengeText;
                    ThisNPC.defeatText = defeatText;
                    ThisNPC.chatText = chatText;
                    ThisNPC.npcType = vendorType;
                    ThisNPC.pictureID = pictureID;
                    ThisNPC.direction = direction;
                    
                    [_NPCs insertObject:ThisNPC atIndex:0];
                }
                //its a monster. add to NPCs monsters
                else
                {
                    if (cells.count !=2) 
                    {
                        NSLog(@"NPC-%i,%i NPC:%i, Row:%i - monster - incorrect arguments", x,y,i,k);
                        break;
                    }
                    NSString* name = [[cells objectAtIndex:0] retain];
                    int level = [[cells objectAtIndex:1] intValue];
                    Monster* NPCsMonster = [[Monster alloc] initMonsterByName:name andLevel:level];
                    [ThisNPC.monsters addObject:NPCsMonster];
                    [NPCsMonster release];
                }
            }
            
            [ThisNPC release];
        }
    }
    
    
    //Collision Map
    if (_obstacleMap)
        [_obstacleMap release];
    
    _obstacleMap = [[ObstacleMap alloc] initWithCoordinatesX:x Y:y];
    
    
    //Teleport locations    
    if (_teleportLocations)
        [_teleportLocations removeAllObjects];
    else
        _teleportLocations = [[NSMutableDictionary alloc] init];    
    
    fileName = [NSString stringWithFormat:@"indoors-%i,%i", x, y];
	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    if(fileData && fileData.length>1)
    {    
        NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
        
        //loop through rows, add 1 NPC per row
        for(int i = 0; i< [fileDataRows count]; i++)
        {
            NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
            
            if (lineArray.count == 0)
                break;
            
            if ([lineArray count] != 2)
                NSLog(@"Error with indoors for zone %i,%i",x,y);
            
            else
            {
                NSArray* partsArray = [[lineArray objectAtIndex:0] componentsSeparatedByString:@","];      
                if (partsArray.count !=2)
                {
                    NSLog(@"Error with indoors for zone %i,%i",x,y);
                    break;
                }
                int keyA = [[partsArray objectAtIndex:0] intValue] - 1;
                int keyB = [[partsArray objectAtIndex:1] intValue] - 1;
                NSString* adjustedKeyString = [NSString stringWithFormat:@"%i,%i", keyA, keyB];
                
                partsArray = [[lineArray objectAtIndex:1] componentsSeparatedByString:@","];
                if (partsArray.count !=4)
                {
                    NSLog(@"Error with indoors for zone %i,%i",x,y);
                    break;
                }
                int valA = [[partsArray objectAtIndex:0] intValue] - 0;
                int valB = [[partsArray objectAtIndex:1] intValue] - 0;
                int valC = [[partsArray objectAtIndex:2] intValue] - 1;
                int valD = [[partsArray objectAtIndex:3] intValue] - 1;
                NSString* adjustedValueString = [NSString stringWithFormat:@"%i,%i,%i,%i", valA, valB, valC, valD];
                [_teleportLocations setValue:adjustedValueString forKey:adjustedKeyString];
                
                NSString* adjustedKeyString2 = [NSString stringWithFormat:@"%i,%i", keyA, keyB+1];
                NSString* adjustedValueString2 = [NSString stringWithFormat:@"%i,%i,%i,%i", valA, valB, valC, valD+1];
                [_teleportLocations setValue:adjustedValueString2 forKey:adjustedKeyString2];
                
                
            }
        }
    }    
        
    
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
-(NSString*) teleportLocationForCoordsX:(int)x andY:(int)y;
{
    NSString* checkString = [NSString stringWithFormat:@"%i,%i", x, y];
    return [_teleportLocations objectForKey:checkString];
}

-(void) dealloc
{
    [_baseLayerImage release];
    [_overlayLayerImage release];
    [_teleportLocations release];
    [_NPCs release];
    [_obstacleMap release];
    [super dealloc];
    
    
}

@synthesize baseLayerImage = _baseLayerImage;
@synthesize overlayLayerImage = _overlayLayerImage;
@synthesize NPCs = _NPCs;
@synthesize zoneXpos = _zoneXpos;
@synthesize zoneYpos = _zoneYpos;



@end