//
//  Item.h
//  MonsterQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PERMCHANGE  = 0,
    TEMPCHANGE  = 1,
    MONSTERBALL = 2,
    VALUABLE    = 3
} ConsumableType;


@interface Consumable : NSObject <NSCoding>
{
	NSString* _name;
    NSString* _descriptionText;
    int _stat;
    int _value;
	int _goldValue;
    ConsumableType _consumableType;
    int _quantity;
}

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* descriptionText;
@property(nonatomic, readonly) int stat;
@property(nonatomic, readonly) int value;
@property(nonatomic, readonly) int goldValue;
@property(nonatomic, readonly) ConsumableType consumableType;
@property(nonatomic, assign) int quantity;

-(id) initConsumableByName:(NSString *)name;
- (UIImage*) getImage;
-(NSString*) getDescription;
+(NSMutableArray*) generateAllConsumables;

@end
