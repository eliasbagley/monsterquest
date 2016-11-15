//
//  LowerHUD.m
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LowerHUD.h"


@implementation LowerHUD 

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
    
    int buttonW = frame.size.width*0.5;
    int buttonH = frame.size.height*0.4;
    
    //place 4 buttons in 2x2 grid with a long one below it
    _buttonLabel1 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonW, buttonH)] retain];
    _buttonLabel2 = [[[UILabel alloc] initWithFrame:CGRectMake(buttonW, 0, buttonW, buttonH)] retain];
    _buttonLabel3 = [[[UILabel alloc] initWithFrame:CGRectMake(0, buttonH, buttonW, buttonH)] retain];
    _buttonLabel4 = [[[UILabel alloc] initWithFrame:CGRectMake(buttonW, buttonH, buttonW, buttonH)] retain];
    _buttonLabel5 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2*buttonH, 2*buttonW, 0.5*buttonH)] retain];
    
    //add them all as subviews
    [self addSubview:_buttonLabel1];
    [self addSubview:_buttonLabel2];
    [self addSubview:_buttonLabel3];
    [self addSubview:_buttonLabel4];
    [self addSubview:_buttonLabel5];
    
    UIFont* _font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:22.0f];
    
    //set up button labels
    for(UILabel* label in self.subviews)
    {
        [label setText:@"test"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setShadowColor:[UIColor blackColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:_font];
        [label setShadowOffset:CGSizeMake(2, 2)];
        [label setNeedsDisplay];
        label.numberOfLines = 2;
    }
    
    [_buttonLabel5 setText:@"Cancel"];
    
    //set up dummy skills
    //_skill1 = [[Skill alloc] initWithName:@"dummy1"];
    //_skill2 = [[Skill alloc] initWithName:@"dummy2"];
    //_skill3 = [[Skill alloc] initWithName:@"dummy3"];
    //_skill4 = [[Skill alloc] initWithName:@"dummy4"];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect
{    
    //TODO replace all this ugly shit with a picture
    
	//set up colors
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextClearRect(context, [self bounds]);
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
	
    //draw controls' backdrop
    CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}


-(void) setSkill:(int)skillNumber withSkill:(Skill*)skill
{
    if (skillNumber<0 || skillNumber>4) 
        NSLog(@"Skills are from 1 to 4");
    
    else if(skillNumber==1)
    {
        _skill1 = skill;
        _buttonLabel1.text = skill.name;
    }
    
    else if(skillNumber==2)
    {
        _skill2 = skill;
        _buttonLabel2.text = skill.name;
    }
    
    else if(skillNumber==3)
    {
        _skill3 = skill;
        _buttonLabel3.text = skill.name;
    }
    
    else if(skillNumber==4)
    {
        _skill4 = skill;
        _buttonLabel4.text = skill.name;
    }   
    
}


-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{    
    return false;
}

@synthesize skill1 = _skill1;
@synthesize skill2 = _skill2;
@synthesize skill3 = _skill3;
@synthesize skill4 = _skill4;


@end