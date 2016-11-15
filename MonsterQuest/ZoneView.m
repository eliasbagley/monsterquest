//
//  ZoneView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoneView.h"


@implementation ZoneView

-(id) initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    if (self == nil)
    {
        NSLog(@"Failed to create ZoneView");
        return nil;
    }
    
    [self setImage:image];
    [self setBackgroundColor:[UIColor clearColor]];  
    
    NSLog(@"ZoneView creation completed");
    return self;
}

@end
