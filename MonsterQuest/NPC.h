//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface NPC : NSObject 
{
    //World infomation
    int _xPos;      //xPos and yPos are aligned to grid
    float _xSubPos; //SubPos is the offset within the grid. -1.0 to 1.0
    int _yPos;
    float _ySubPos;
    int _direction; //Direction he faces
    bool _moving;   //Whether or not he is currently moving
    int _sight;
    
    //talking
    NSString* _name;
    NSString* _chatText;
    NSString* _challengeText;
    NSString* _defeatText;
    
    
    //Battle information
    NSMutableArray* _monsters; //monster array
    //-array of items
    //-sight range //if you walk within his sight he will auto challenge you
    
    int _recentlyChanged;
    
    int _npcType; 
    int _pictureID;
    
}


@property(nonatomic, retain) NSString* name;
@property(nonatomic, assign) int direction;
@property(nonatomic, assign) bool moving;
@property(nonatomic, assign) int xPos;
@property(nonatomic, assign) int yPos;
@property(nonatomic, assign) float xSubPos;
@property(nonatomic, assign) float ySubPos;
@property(nonatomic, retain) NSString* chatText;
@property(nonatomic, retain) NSString* challengeText;
@property(nonatomic, retain) NSString* defeatText;
@property(nonatomic, retain) NSMutableArray* monsters;
@property(nonatomic, assign) int npcType;
@property(nonatomic, assign) int pictureID;
@property(nonatomic, assign) int sight;
@property(nonatomic, assign) int recentlyChanged;





- (id) initFromPlayer:(Player *)player;
- (id)initWithCoordinatesX:(int)xPos andY:(int)yPos;
-(int) getGoldValue;

@end
