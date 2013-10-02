//
//  Item.h
//  LazyQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	WEAPON,
    ARMOR,
    ACCESSORY
} Slot;


@interface Equipment : NSObject <NSCoding>
{
	NSString* _name;
    int _maxhp;
    int _physatk;
    int _physdef;
    int _magicatk;
    int _magicdef;
    int _speed;
    int _accuracy;
    int _critical;
	int _goldValue;
    Slot _slot;
}

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) int maxhp;
@property(nonatomic, readonly) int physatk;
@property(nonatomic, readonly) int physdef;
@property(nonatomic, readonly) int magicatk;
@property(nonatomic, readonly) int magicdef;
@property(nonatomic, readonly) int speed;
@property(nonatomic, readonly) int accuracy;
@property(nonatomic, readonly) int critical;
@property(nonatomic, readonly) int goldValue;
@property(nonatomic, readonly) Slot slot;


+(NSMutableArray*) generateAllEquipment;
-(UIImage*) getImage;
-(NSString*) getDescription;
-(id) initEquipmentByName:(NSString *)name;
+(NSString*) getStringForSlot:(int)slot;

@end
