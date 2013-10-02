//
//  Item.m
//  MonsterQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Equipment.h"

@interface Equipment()
@end

@implementation Equipment


-(id) initEquipmentByName:(NSString *)name
{  
    
    self = [super init];
    if (self == nil)
        return nil;
    //loop through skill list until you find it
    NSString* fileName = [NSString stringWithFormat:@"EquipmentList"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    int currentSlot = -1;
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
        
        
        //If its an empty line, skip it. (the IF hits this one, then all the other ones are "else" so it skips)
        if ([[lineArray objectAtIndex:0] isEqualToString:@""]) 
            currentSlot = currentSlot;  
        
        //check type
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"WEAPON"]) 
            currentSlot = WEAPON;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"ARMOR"]) 
            currentSlot = ARMOR;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"ACCESSORY"]) 
            currentSlot = ACCESSORY;
        
        
        //check if the name matches
        else if ([[lineArray objectAtIndex:0] isEqualToString:name]) 
        {
            if (lineArray.count !=9) 
            {
                NSLog(@"EquipmentList - %@ - incorrect arguments", name);
                break;
            }
            
            _name       = [name retain];
            _maxhp      = [[lineArray objectAtIndex:1] intValue];
            _physatk    = [[lineArray objectAtIndex:2] intValue];
            _physdef    = [[lineArray objectAtIndex:3] intValue];
            _magicatk   = [[lineArray objectAtIndex:4] intValue];
            _magicdef   = [[lineArray objectAtIndex:5] intValue];
            _speed      = [[lineArray objectAtIndex:6] intValue];
            _accuracy   = [[lineArray objectAtIndex:7] intValue];
            _critical   = [[lineArray objectAtIndex:8] intValue];
            _goldValue  = _physatk*2 + _physdef*2 + _magicatk*2 + _magicdef*2 + _speed + _accuracy + _maxhp + _critical*5;
            _goldValue  = pow(_goldValue*10, 1.1);
            _slot       = currentSlot;
            
            return self;
        }
    }
    
    //nothing found, alert the internet
    _name = [@"ERROR" retain];
    NSLog(@"No item by name %@ found. This is bad, fix it.", name);
    return self;  
    
}

+(NSMutableArray*) generateAllEquipment
{
    NSMutableArray* equipmentArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSString* fileName = [NSString stringWithFormat:@"EquipmentList"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
        if ([lineArray count] == 9)
        {
            Equipment* equipment = [[Equipment alloc] initEquipmentByName:[lineArray objectAtIndex:0]];
            [equipmentArray addObject:equipment];
            [equipment release];
        }
    }
    
    [equipmentArray sortUsingSelector:@selector(compare:)];
    
    return equipmentArray;
}

-(NSComparator) compare:(Equipment*)otherObject
{    
    if (self.goldValue > otherObject.goldValue)
    {
        return (NSComparator)1;
    }
    else
        return (NSComparator)-1;
}

-(id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init])
	{
        _name       = [[decoder decodeObjectForKey:@"name"] retain];
        _maxhp      = [decoder decodeIntForKey:@"maxhp"];
        _physatk    = [decoder decodeIntForKey:@"physatk"];
        _physdef    = [decoder decodeIntForKey:@"phydef"];
        _magicatk   = [decoder decodeIntForKey:@"magicatk"];
        _magicdef   = [decoder decodeIntForKey:@"magicdef"];
        _speed      = [decoder decodeIntForKey:@"speed"];
        _accuracy   = [decoder decodeIntForKey:@"accuracy"];
        _critical   = [decoder decodeIntForKey:@"critical"];
        _goldValue  = [decoder decodeIntForKey:@"goldValue"];
        _slot       = [decoder decodeIntForKey:@"slot"];
	}
    
	return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name     forKey:@"name"];
	[encoder encodeInt:_maxhp       forKey:@"maxhp"];
	[encoder encodeInt:_physatk     forKey:@"physatk"];
	[encoder encodeInt:_physdef     forKey:@"physdef"];
	[encoder encodeInt:_magicatk    forKey:@"magicatk"];
	[encoder encodeInt:_magicdef    forKey:@"magicdef"];
    [encoder encodeInt:_speed       forKey:@"speed"];
    [encoder encodeInt:_accuracy    forKey:@"accuracy"];
    [encoder encodeInt:_critical    forKey:@"critical"];
	[encoder encodeInt:_goldValue   forKey:@"goldValue"];
	[encoder encodeInt:_slot        forKey:@"slot"];    
}

-(NSString*) getDescription
{
    NSString* desc = [Equipment getStringForSlot:_slot];
    
    if (_maxhp > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Max HP", desc, _maxhp];
    if (_physatk > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Phys Atk", desc, _physatk];
    if (_physdef > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Phys Def", desc, _physdef];
    if (_magicatk > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Magic Atk", desc, _magicatk];
    if (_magicdef > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Magic Def", desc, _magicdef];
    if (_speed > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Speed", desc, _speed];
    if (_accuracy > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Accuracy", desc, _accuracy];
    if (_critical > 0) 
        desc = [NSString stringWithFormat:@"%@\n+%i Critical", desc, _critical];
    
    
    
    desc = [NSString stringWithFormat:@"%@\n%i Gold", desc, _goldValue];
    
    
    return desc;
}

+(NSString*) getStringForSlot:(int)slot
{
    switch (slot) {
        case 0:
            return @"Weapon";
        case 1:
            return @"Armor";
        case 2:
            return @"Accessory";
    }
    return @"Error";
}


@synthesize physatk = _physatk;
@synthesize goldValue = _goldValue;
@synthesize name = _name;
@synthesize physdef = _physdef;
@synthesize magicatk = _magicatk;
@synthesize magicdef = _magicdef;
@synthesize speed = _speed;
@synthesize accuracy = _accuracy;
@synthesize critical = _critical;
@synthesize maxhp = _maxhp;
@synthesize slot = _slot;

- (UIImage*) getImage
{
    return [UIImage imageNamed:_name];
}


-(void) dealloc
{
    [_name release];
    [super dealloc];
}

@end
