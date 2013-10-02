//
//  Item.m
//  MonsterQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Consumable.h"

@interface Consumable()
@end

@implementation Consumable

-(id) initConsumableByName:(NSString *)name
{  
    self = [super init];
    if (self == nil)
        return nil;
    
    //loop through skill list until you find it
    NSString* fileName = [NSString stringWithFormat:@"ConsumableList"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    int currentType = -1;
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
        
        
        //If its an empty line, skip it. (the IF hits this one, then all the other ones are "else" so it skips)
        if ([[lineArray objectAtIndex:0] isEqualToString:@""]) 
            currentType = currentType;  
        
        //check type
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"PERMCHANGE"]) 
            currentType = PERMCHANGE;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"TEMPCHANGE"]) 
            currentType = TEMPCHANGE;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"MONSTERBALL"]) 
            currentType = MONSTERBALL;
        else if ([[lineArray objectAtIndex:0] isEqualToString:@"VALUABLE"]) 
            currentType = VALUABLE;
        
        //check if the name matches
        else if ([[lineArray objectAtIndex:0] isEqualToString:name]) 
        {
            _name = [name retain];
            _consumableType = currentType;
            _quantity = 1;
            
            if (currentType==PERMCHANGE) {
                _stat = [[lineArray objectAtIndex:1] intValue];
                _value = [[lineArray objectAtIndex:2] intValue];
                _goldValue = [[lineArray objectAtIndex:3] intValue];
                _descriptionText = [[lineArray objectAtIndex:4] retain];
            }
            else if (currentType==TEMPCHANGE) {
                _stat = [[lineArray objectAtIndex:1] intValue];
                _value = [[lineArray objectAtIndex:2] intValue];
                _goldValue = [[lineArray objectAtIndex:3] intValue];
                _descriptionText = [[lineArray objectAtIndex:4] retain];
            }
            else if (currentType==MONSTERBALL) {
                _stat = 0;
                _value = [[lineArray objectAtIndex:1] intValue];
                _goldValue = [[lineArray objectAtIndex:2] intValue];
                _descriptionText = [[lineArray objectAtIndex:3] retain];
            }
            else if (currentType==VALUABLE) {
                _stat = 0;
                _value = 0;
                _goldValue = [[lineArray objectAtIndex:1] intValue];
                _descriptionText = [[lineArray objectAtIndex:2] retain];
            }
            
            
            return self;
        }
        
        
    }
    
    //nothing found, alert the internet
    _name = @"ERROR";
    _descriptionText = @"Item not found";
    _quantity = 99; 
    NSLog(@"No item by name %@ found. This is bad, fix it.", name);
    return self;  
}

+(NSMutableArray*) generateAllConsumables
{
    NSMutableArray* consumableArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSString* fileName = [NSString stringWithFormat:@"ConsumableList"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray* fileDataRows = [fileData componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i<[fileDataRows count]; i++) 
    {
        NSArray* lineArray = [[fileDataRows objectAtIndex:i] componentsSeparatedByString:@"#"];
        if (![[lineArray objectAtIndex:0] isEqualToString:@"FORMAT"] && [lineArray count] > 2)
        {
            Consumable* consumable = [[Consumable alloc] initConsumableByName:[lineArray objectAtIndex:0]];
            [consumable setQuantity:20];
            if (consumable.consumableType != VALUABLE)
                [consumableArray addObject:consumable];
            [consumable release];
        }
    }
    
    [consumableArray sortUsingSelector:@selector(compare:)];

    return consumableArray;
}

-(NSComparator) compare:(Consumable*)otherObject
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
        _name                 = [[decoder decodeObjectForKey:@"name"] retain];
        _descriptionText      = [[decoder decodeObjectForKey:@"descriptiontext"] retain];
        _stat                 = [decoder decodeIntForKey:@"stat"];
        _value                = [decoder decodeIntForKey:@"value"];
        _goldValue            = [decoder decodeIntForKey:@"goldvalue"];
        _consumableType       = [decoder decodeIntForKey:@"consumabletype"];
        _quantity             = [decoder decodeIntForKey:@"quantity"];
	}
    
	return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name             forKey:@"name"];
	[encoder encodeObject:_descriptionText  forKey:@"descriptiontext"];
	[encoder encodeInt:_stat                forKey:@"stat"];
	[encoder encodeInt:_value               forKey:@"value"];
	[encoder encodeInt:_goldValue           forKey:@"goldvalue"];
	[encoder encodeInt:_consumableType      forKey:@"consumabletype"];
    [encoder encodeInt:_quantity            forKey:@"quantity"]; 
    
}

- (UIImage*) getImage
{
    return [UIImage imageNamed:_name];
}


-(void) dealloc
{
    [_name release];
    [_descriptionText release];
    [super dealloc];
}

-(NSString*) getDescription
{
    NSString* desc = [NSString stringWithFormat:@"%@\n%i Gold", _descriptionText, _goldValue];   
    
    return desc;
}

@synthesize name = _name;
@synthesize descriptionText = _descriptionText;
@synthesize stat = _stat;
@synthesize value = _value;
@synthesize goldValue = _goldValue;
@synthesize consumableType = _consumableType;
@synthesize quantity = _quantity;


@end
