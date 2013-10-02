//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"

enum {
    NORM    = 0, //cannot name it "NORMAL" for some reason, so cut it to 4 chars
    FIRE    = 1,
    WATER   = 2,
    GRASS   = 3,
    ELECTRIC= 4,
    ROCK    = 5,
    PSYCHIC = 6,
    GHOST   = 7,
    BUFF    = 8,
    DEBUFF  = 9,
    RESTORE = 10
} type;

@interface Skill : NSObject <NSCoding>
{
    NSString* _name;
    NSString* _description;
    
    int _curPP;
    int _maxPP;         // pp = power points
    int _attackPower;   //base strength of attack
    int _type;          //elemental type
    bool _isPhysical;   //physical vs magical attack
}

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, assign) int curPP;
@property(nonatomic, assign) int maxPP;
@property(nonatomic, assign) int attackPower;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) bool isPhysical;

-(id) initDummySkill;
-(id) initSkillByName:(NSString*)name;
+(NSString*) getStringForType:(int)type;
+(NSString*) getStringForStat:(int)stat;
+(int) getTypeForString:(NSString*)string;

@end
