//
//  Player.h
//  MonsterQuest
//
//  Created by u0605593 on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Monster.h"

enum {
    SOUTH=0, 
    WEST=1, 
    EAST=2, 
    NORTH=3, 
    NORTHEAST=4, 
    SOUTHEAST=5, 
    SOUTHWEST=6, 
    NORTHWEST=7
} directions;



@interface Player : NSObject 
{
    
	NSString* _name;
	int _money;
    
    CGPoint _worldCoordinates;
    
    int _xPos;      //xPos and yPos are aligned to grid
    float _xSubPos; //SubPos is the offset within the grid. -1.0 to 1.0
    int _yPos;
    float _ySubPos;
    int _direction; //Direction he faces
    bool _moving;   //Whether or not he is currently moving
    
    NSMutableArray* _monsters; 
    
    
    int _inGrass;
}

- (id)initWithName:(NSString *)name;

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSMutableArray* monsters;
@property(nonatomic, assign) int money;
@property(nonatomic, assign) int direction;
@property(nonatomic, assign) bool moving;
@property(nonatomic, assign) int xPos;
@property(nonatomic, assign) int yPos;
@property(nonatomic, assign) float xSubPos;
@property(nonatomic, assign) float ySubPos;
@property(nonatomic, assign) CGPoint worldCoordinates;
@property(nonatomic, assign) int inGrass;




@end
