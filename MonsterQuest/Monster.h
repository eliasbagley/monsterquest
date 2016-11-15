//
//  Monster.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Skill.h"

enum {
    NORM=0, //cannot name it "NORMAL" for some reason, so cut it to 4 chars
    FIRE=1,
    WATR=2,
    GRAS=3,
    ELEC=4,
    PSYC=5,
    FGHT=6
} type;

enum {
    MAXHP   =0, 
    CURHP   =1, 
    PHYSATK =2, 
    PHYSDEF =3, 
    MAGICATK=4, 
    MAGICDEF=5, 
    SPEED   =6, 
    ACCURACY=7
} stat;

@interface Monster : NSObject 
{
    NSString* _name;
    int _level;
    int _experience;
    
    int _stat[8];
    
    int _type;
    
    NSMutableArray* _skills;
}


- (id)initWithName:(NSString*)name;

@property(nonatomic, retain) NSMutableArray* skills;

@end
