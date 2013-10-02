//
//  Monster.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class Skill;
#import <Foundation/Foundation.h>
#import "Skill.h"
#import "Consumable.h"
#import "Equipment.h"


#define flatHp 20

enum {
    LEVEL   =0,
    EXP     =1,
    TYPE    =2,
    MAXHP   =3, 
    CURHP   =4, 
    PHYSATK =5, 
    PHYSDEF =6, 
    MAGICATK=7, 
    MAGICDEF=8, 
    SPEED   =9, 
    ACCURACY=10,
    CRITICAL=11
} stat;

@interface Monster : NSObject <NSCoding>
{
    NSString* _name;
    int _number;
    int _stats[12];
    int _statCoefficients[12];
    float _modifiedStats[12];
    NSMutableArray* _skills;
    Equipment* _weaponSlot;
    Equipment* _armorSlot;
    Equipment* _accessorySlot;
    
}


- (id) initMonsterByName:(NSString*)name andLevel:(int)level;
- (id) initMonsterByNumber:(int)number andLevel:(int)level;
- (int) getStat:(int)stat;
- (int) getCoefficientForStat:(int)stat;
- (void) setStat:(int)stat withValue:(int)value;
- (void) recieveDamage:(int)damage;
- (void) giveXP:(int)xp;
- (void) setSkillByName:(NSString*)skillName atSlot:(int)slot;
- (UIImage*) getImage;
- (int) expToLevel;
- (void) levelUp;
- (void) useConsumable:(Consumable*)consumable;
- (void) setEquipment:(Equipment*)equipment toSlot:(int)slot;
-(void) getSkillForCurrentLevel;

-(void) resetModifiedStats;
-(bool) incrementStat:(int)stat;
-(bool) decrementStat:(int)stat;
-(float) getMofidiedStat:(int)stat;

-(void) resetPP;
-(void) incrementPP;


+ (float) getTypeMultiplierWithAttacktype:(int)at andDefenseType:(int)dt;

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) int number;
@property(nonatomic, readonly) NSMutableArray* skills;
@property(nonatomic, readonly) Equipment* weaponSlot;
@property(nonatomic, readonly) Equipment* armorSlot;
@property(nonatomic, readonly) Equipment* accessorySlot;


@end
