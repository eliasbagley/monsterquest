//
//  MenuView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _monsterdexButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _monstersButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    
	
	[_monsterdexButton setFrame:CGRectMake(xOrigin, yOrigin, buttonWidth, buttonHeight)];
	[_monstersButton setFrame:CGRectMake(xOrigin, yOrigin+(1*buttonHeight)+(1*buttonSpacing), buttonWidth, buttonHeight)];
	
	[_monsterdexButton setTitle:@"Monsterdex" forState:UIControlStateNormal];
    [_monstersButton setTitle:@"Monsters" forState:UIControlStateNormal];
    
	
	[_monsterdexButton addTarget:self action:@selector(monsterdexPressed) forControlEvents:UIControlEventTouchUpInside];
    [_monstersButton addTarget:self action:@selector(monstersPressed) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:_monsterdexButton];
	[self addSubview:_monstersButton];
    
    
    _backgroundColor = [[UIColor alloc] initWithRed:.2 green:.2 blue:.8 alpha:0.85];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect 
{
	if([self isHidden])
        return;
    
    [self setOpaque:FALSE];
	
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextClearRect(context, [self bounds]);
	
    int a = 4; //inset in pixels
	
	CGContextSetLineWidth(context, 4.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [_backgroundColor CGColor]);
	
    CGContextMoveToPoint(context, 0+a, 0+a);
	CGContextAddLineToPoint(context, 0+a, rect.size.height-a);
    CGContextAddLineToPoint(context, rect.size.width-a, rect.size.height-a);
    CGContextAddLineToPoint(context, rect.size.width-a, 0+a);
    
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSLog(@"menu touched"); 
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Menu moved?");
}

//Button Handlers
-(void) monsterdexPressed
{
    NSLog(@"TODO: Load Monsterdex");
}
-(void) monstersPressed
{
    NSLog(@"TODO: Load Monsters");
}


@end