//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UpperHUD.h"


@implementation UpperHUD

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
    
    _leftName = [[[UILabel alloc] initWithFrame:CGRectMake(healthBarXOffset, nameYOffset, 160, 30)]retain];
    _rightName = [[[UILabel alloc] initWithFrame:CGRectMake(160, nameYOffset, 160-healthBarXOffset, 30)]retain];
    
    [_leftName setText:@"Bulbamon"];
    [_rightName setText:@"Tacomon"];
    
    [_leftName setBackgroundColor:[UIColor clearColor]];
    [_rightName setBackgroundColor:[UIColor clearColor]];
    
    [_rightName setTextAlignment:UITextAlignmentRight];
    
    [_leftName setShadowColor:[UIColor blackColor]];
    [_rightName setShadowColor:[UIColor blackColor]];
    
    [_leftName setTextColor:[UIColor whiteColor]];
    [_rightName setTextColor:[UIColor whiteColor]];
    
    [_leftName setShadowOffset:CGSizeMake(2, 2)];
    [_rightName setShadowOffset:CGSizeMake(2, 2)];
    
    UIFont* _font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:22.0f];
    
    [_leftName setFont:_font];
    [_rightName setFont:_font];
    
    [self addSubview:_leftName];
    [self addSubview:_rightName];
        
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect
{    
	//set up colors
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextClearRect(context, [self bounds]);
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
	
    //draw left bar
    CGContextMoveToPoint(context, healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + healthBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + healthBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
    //draw right bar
    CGContextMoveToPoint(context, 320-healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, 320-healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - healthBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - healthBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
    /*
    
    UIFont* _font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:22.0f];
    
    //draw left name
    rect = CGRectMake(healthBarXOffset, nameYOffset, 160, 30);
    CGRect rect2 = CGRectMake(rect.origin.x+2, rect.origin.y+1, rect.size.width, rect.size.height);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    [_leftName drawInRect:rect2 withFont:_font];
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    [_leftName drawInRect:rect withFont:_font];
    
    //draw right name
    rect = CGRectMake(160+healthBarXOffset, nameYOffset, 160, 30);
    rect2 = CGRectMake(rect.origin.x+2, rect.origin.y+1, rect.size.width, rect.size.height);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    [_rightName drawInRect:rect2 withFont:_font];
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    [_rightName drawInRect:rect withFont:_font];
    */
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchpoint = [touch locationInView:self];
    
    NSLog(@"touched hud");
    
    return;
    
}



-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchpoint = [touch locationInView:self];
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}




@end