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
    [_leftName release];
    [_leftInfo release];
    [_rightName release];
    [_rightInfo release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _leftName = [[[UILabel alloc] initWithFrame:CGRectMake(healthBarXOffset, nameYOffset, 160, 30)]retain];
    _leftInfo = [[[UILabel alloc] initWithFrame:CGRectMake(infoXOffset, infoYOffset, 160, 60)]retain];
    _rightName = [[[UILabel alloc] initWithFrame:CGRectMake(160, nameYOffset, 160-healthBarXOffset, 30)]retain];
    _rightInfo = [[[UILabel alloc] initWithFrame:CGRectMake(160, infoYOffset, 160-infoXOffset, 60)]retain];
    
    UIFont* namefont = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:24.0f];
    UIFont* infofont = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:17.0f];
    
    [_rightName setTextAlignment:UITextAlignmentRight];
    [_rightInfo setTextAlignment:UITextAlignmentRight];
    
    [_leftName setText:@"LEFT SIDE"];
    [_leftInfo setText:@"LEFT INFO"];
    [_rightName setText:@"RIGHT SIDE"];
    [_rightInfo setText:@"RIGHT INFO"];
    
    [_leftName setFont:namefont];
    [_leftInfo setFont:infofont];
    [_rightName setFont:namefont];
    [_rightInfo setFont:infofont];
    
    [self addSubview:_leftName];
    [self addSubview:_leftInfo];
    [self addSubview:_rightName];
    [self addSubview:_rightInfo];
    
    for (UILabel* label in self.subviews)
    {
        [label setBackgroundColor:[UIColor clearColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setShadowOffset:CGSizeMake(2, 2)];
        label.numberOfLines = 2;
        label.lineBreakMode = UILineBreakModeWordWrap;
    }
    
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
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
	
    //draw left black outline
    CGContextMoveToPoint(context, healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + healthBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + healthBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);    
    
    //draw right black outline
    CGContextMoveToPoint(context, 320-healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, 320-healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - healthBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - healthBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
    
    int leftHPPercentBarWidth = _leftHPPercentDisplayed * healthBarWidth;
    int rightHPPercentBarWidth = _rightHPPercentDisplayed * healthBarWidth;
    
    //fill in left coloring
	CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    if (_leftHPPercentDisplayed <.5)
        CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]); 
    if (_leftHPPercentDisplayed <.25)
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    
    CGContextMoveToPoint(context, healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + leftHPPercentBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, healthBarXOffset + leftHPPercentBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
    //fill in right coloring
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    if (_rightHPPercentDisplayed <.5)
        CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]); 
    if (_rightHPPercentDisplayed <.25)
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    
    CGContextMoveToPoint(context, 320-healthBarXOffset, healthBarYOffset);
	CGContextAddLineToPoint(context, 320-healthBarXOffset, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - rightHPPercentBarWidth, healthBarYOffset + healthBarHeight);
    CGContextAddLineToPoint(context, 320-healthBarXOffset - rightHPPercentBarWidth, healthBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    

    
    ///Now draw XP bar
    //set up colors
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
	
    //draw left black outline
    CGContextMoveToPoint(context, expBarXOffset, expBarYOffset);
	CGContextAddLineToPoint(context, expBarXOffset, expBarYOffset + expBarHeight);
    CGContextAddLineToPoint(context, expBarXOffset + expBarWidth, expBarYOffset + expBarHeight);
    CGContextAddLineToPoint(context, expBarXOffset + expBarWidth, expBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);        
    
    int leftexpPercentBarWidth = _leftXPPercentDisplayed * expBarWidth;
    
    //fill in left coloring
	CGContextSetFillColorWithColor(context, [[UIColor purpleColor] CGColor]);
    
    CGContextMoveToPoint(context, expBarXOffset, expBarYOffset);
	CGContextAddLineToPoint(context, expBarXOffset, expBarYOffset + expBarHeight);
    CGContextAddLineToPoint(context, expBarXOffset + leftexpPercentBarWidth, expBarYOffset + expBarHeight);
    CGContextAddLineToPoint(context, expBarXOffset + leftexpPercentBarWidth, expBarYOffset);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchpoint = [touch locationInView:self];
        
    return;
    
}


-(void) setPlayerMonster:(Monster*)monster
{
    _leftName.text = monster.name;
    _leftInfo.text = [NSString stringWithFormat:@"Level %i \n%@", 
                      [monster getStat:LEVEL], [Skill getStringForType:[monster getStat:TYPE]]];
    int maxHP = [monster getStat:MAXHP];
    int currentHP = [monster getStat:CURHP];
    _leftHPPercent = currentHP*1.0/maxHP*1.0;
    int curXP = [monster getStat:EXP];
    int XPtoLevel = [monster expToLevel];
    _leftXPPercent = curXP*1.0 / XPtoLevel*1.0;
}

-(void) setOpponentMonster:(Monster*)monster
{
    _rightName.text = monster.name;
    _rightInfo.text = [NSString stringWithFormat:@"Level %i \n%@", 
                       [monster getStat:LEVEL], [Skill getStringForType:[monster getStat:TYPE]]];
    int maxHP = [monster getStat:MAXHP];
    int currentHP = [monster getStat:CURHP];
    _rightHPPercent = currentHP*1.0/maxHP*1.0;
}

-(bool) animate
{
    
    if (_leftHPPercent == _leftHPPercentDisplayed && 
        _rightHPPercent == _rightHPPercentDisplayed && 
        _leftXPPercent == _leftXPPercentDisplayed) 
    {
        return false;
    }
    
    
    if (_leftHPPercentDisplayed != _leftHPPercent) 
    {
        
        //displaying more Hp than has, drop it.
        if(_leftHPPercentDisplayed > _leftHPPercent)
        {
            _leftHPPercentDisplayed -= (BarChangeRate/FPS);
        }
        //raise it
        else
        {
            _leftHPPercentDisplayed += (BarChangeRate/FPS);
        }
        
        //to make it eventually end
        if ([UpperHUD absoluteValueDifference:_leftHPPercentDisplayed andB:_leftHPPercent] < (1.5*BarChangeRate/FPS)) 
        {            
            _leftHPPercentDisplayed = _leftHPPercent;
        }
        
    }
    if (_rightHPPercentDisplayed != _rightHPPercent) 
    {
        
        //displaying more Hp than has, drop it.
        if(_rightHPPercentDisplayed > _rightHPPercent)
        {
            _rightHPPercentDisplayed -= (BarChangeRate/FPS);
        }
        //raise it
        else
        {
            _rightHPPercentDisplayed += (BarChangeRate/FPS);
        }
        
        //to make it eventually end
        if ([UpperHUD absoluteValueDifference:_rightHPPercentDisplayed andB:_rightHPPercent] < (1.5*BarChangeRate/FPS)) 
        {
            _rightHPPercentDisplayed = _rightHPPercent;
        }
        
    }
    
    if (_leftXPPercentDisplayed != _leftXPPercent) 
    {
        
        //displaying more Hp than has, drop it.
        if(_leftXPPercentDisplayed > _leftXPPercent)
        {
            _leftXPPercentDisplayed = 0;
        }
        //raise it
        else
        {
            _leftXPPercentDisplayed += (BarChangeRate/FPS);
        }
        
        //to make it eventually end
        if ([UpperHUD absoluteValueDifference:_leftXPPercentDisplayed andB:_leftXPPercent] < (1.5*BarChangeRate/FPS)) 
        {
            _leftXPPercentDisplayed = _leftXPPercent;
        }
        
    }
    
    
    return true;
}

+(float) absoluteValueDifference:(float)a andB:(float)b
{
    if (a > b)
        return a - b;
    else
        return b - a;
}


@end