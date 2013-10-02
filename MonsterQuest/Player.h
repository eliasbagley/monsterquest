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
#import "Equipment.h"
#import "Consumable.h"


#define maxMonsterCount 23 //amount of monsters in the game
#define maxHoldableMonsters 4

#define playerStartZoneX 104500
#define playerStartZoneY 104500
#define playerStartPosX 14 //14
#define playerStartPosY 11 //11



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



@interface Player : NSObject <NSCoding>
{
    
    NSString* _name;
    int _gold;
    bool _isFrozen;
    CGPoint _worldCoordinates;
    
    int _xPos;      //xPos and yPos are aligned to grid
    float _xSubPos; //SubPos is the offset within the grid. -0.5 to 0.5
    int _yPos;
    float _ySubPos;
    int _direction; //Direction he faces
    bool _moving;   //Whether or not he is currently moving
    
    bool _seenMonsters[maxMonsterCount];
    bool _ownedBadges[8];
    
    NSMutableArray* _monsters; 
    NSMutableArray* _storedMonsters;
    NSMutableArray* _consumables;
    NSMutableArray* _equipment;
    
    int _inGrass;
    
    //stats
    double _secondsPlayed;
    double _metersWalked;
}

- (id)initWithName:(NSString *)name;
- (void) addConsumableToInventory:(Consumable*) consumable;
- (void) removeConsumableFromInventory:(Consumable*) consumable;
- (void) capturedMonster:(Monster*) monster;
- (bool) hasSeenMonster:(int)number;
- (void) sawMonster:(int)number;
- (void) recievesBadge:(int)number;
- (bool) hasBadge:(int)number;
- (NSString*) getTimePlayed;

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSMutableArray* monsters;
@property(nonatomic, retain) NSMutableArray* storedMonsters;
@property(nonatomic, retain) NSMutableArray* consumables;
@property(nonatomic, retain) NSMutableArray* equipment;
@property(nonatomic, assign) int gold;
@property(nonatomic, assign) int direction;
@property(nonatomic, assign) bool moving;
@property(nonatomic, assign) int xPos;
@property(nonatomic, assign) int yPos;
@property(nonatomic, assign) float xSubPos;
@property(nonatomic, assign) float ySubPos;
@property(nonatomic, assign) CGPoint worldCoordinates;
@property(nonatomic, assign) bool isFrozen;
@property(nonatomic, assign) double secondsPlayed;
@property(nonatomic, assign) double metersWalked;




@end
