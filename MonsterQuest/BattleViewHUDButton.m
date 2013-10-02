//
//  BattleViewHUDButton.m
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleViewHUDButton.h"


@implementation BattleViewHUDButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _label = [[[UILabel alloc] initWithFrame:frame]retain]; 
    [_label setText:@"test"];
    [self addSubview:_label];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString*)text
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _label = [[[UILabel alloc] initWithFrame:frame]retain]; 
    [_label setText:text];
    [self addSubview:_label];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchpoint = [touch locationInView:self];
    
    
    return;
    
}

@end
