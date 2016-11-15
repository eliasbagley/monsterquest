//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"

@interface Skill : NSObject 
{
    NSString* _name;
    
    int _maxPP;         // pp = power points
    int _attackPower;   //base strength of attack
    int _type;          //elemental type
    bool _isPhysical;   //physical vs magical attack
}

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) int maxPP;
@property(nonatomic, readonly) int attackPower;
@property(nonatomic, readonly) int type;
@property(nonatomic, readonly) bool isPhysical;


-(id) initWithName:(NSString*)name;

@end
