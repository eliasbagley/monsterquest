//
//  WorldView.m
//  MonsterQuest
//
//  Created by u0605593 on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIMovementButtonView.h"


@implementation UIMovementButtonView

- (void)dealloc
{
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _buttonPicture = [UIImage imageNamed:@"arrow"];
    
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)drawRect:(CGRect)rect
{
    [_buttonPicture drawInRect:CGRectMake(0, 0, _buttonPicture.size.width, _buttonPicture.size.width)];
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSLog(@"Arrow TOUCHED");
}


@end