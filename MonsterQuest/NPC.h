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
    NSString* _chatText;
    
    
    //Battle information
    NSMutableArray* _monsters;      //monster array
    //-array of items
    //-challenge text
    //-defeat text
    //-sight range //if you walk within his sight he will auto challenge you
    
}

@property(nonatomic, assign) int direction;
@property(nonatomic, assign) bool moving;
@property(nonatomic, assign) int xPos;
@property(nonatomic, assign) int yPos;
@property(nonatomic, assign) float xSubPos;
@property(nonatomic, assign) float ySubPos;
@property(nonatomic, retain) NSString* chatText;
@property(nonatomic, retain) NSMutableArray* monsters;



- (id)initWithCoordinatesX:(int)xPos andY:(int)yPos andText:(NSString*)text;

@end
