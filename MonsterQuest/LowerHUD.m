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
    [tlButton release];
    [trButton release];
    [blButton release];
    [brButton release];
    [cButton release];
    
    [_buttonLabel1 release];
    [_buttonLabel2 release];
    [_buttonLabel3 release];
    [_buttonLabel4 release];
    [_buttonLabel5 release];
    
    [_skill1 release];
    [_skill2 release];
    [_skill3 release];
    [_skill4 release];
    [_skill5 release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    
    //set background texture
    UIImageView* bgTextureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metalTexture"]];
    [bgTextureView setFrame:
        CGRectMake(0, 0, bgTextureView.image.size.width, bgTextureView.image.size.height)];
    
  
    
    //place 5 pictures
    tlButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIButtonNormal"]];
    trButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIButtonNormal"]];
    blButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIButtonNormal"]];
    brButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIButtonNormal"]];
    cButton  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIButtonCancel"]];
    
    int frameW = frame.size.width * 0.5;
    int frameH = frame.size.height * 0.4;
    
    [tlButton setFrame:CGRectMake(-buttonOffset, 0, frameW, frameH)];
    [trButton setFrame:CGRectMake(buttonOffset+frameW, 0, frameW, frameH)];
    [blButton setFrame:CGRectMake(-buttonOffset, frameH, frameW, frameH)];
    [brButton setFrame:CGRectMake(buttonOffset+frameW, frameH, frameW, frameH)];
    [cButton  setFrame:CGRectMake(0, frameH*2, frameW*2, frameH)];
    
    [tlButton setContentMode:UIViewContentModeLeft];
    [trButton setContentMode:UIViewContentModeRight];
    [blButton setContentMode:UIViewContentModeLeft];
    [brButton setContentMode:UIViewContentModeRight];
    [cButton  setContentMode:UIViewContentModeTop];
    
    
    //labels
    _buttonLabel1 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameW-buttonOffset, frameH)] retain];
    _buttonLabel2 = [[[UILabel alloc] initWithFrame:CGRectMake(frameW+buttonOffset, 0, frameW-buttonOffset, frameH)] retain];
    _buttonLabel3 = [[[UILabel alloc] initWithFrame:CGRectMake(0, frameH, frameW-buttonOffset, frameH)] retain];
    _buttonLabel4 = [[[UILabel alloc] initWithFrame:CGRectMake(frameW+buttonOffset, frameH, frameW-buttonOffset, frameH)] retain];
    _buttonLabel5 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2*frameH, 2*frameW, 0.5*frameH)] retain];
    
    UIFont* _font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:20.0f];
    //_font = [UIFont boldSystemFontOfSize:20];
    
    UIColor* textColor = [UIColor colorWithRed:.2 green:0.2 blue:0.6 alpha:1];
    
    [_buttonLabel1 setBackgroundColor:[UIColor clearColor]];
    [_buttonLabel1 setTextAlignment:UITextAlignmentCenter];
    [_buttonLabel1 setTextColor:textColor];
    [_buttonLabel1 setFont:_font];
    _buttonLabel1.numberOfLines = 2;
    
    [_buttonLabel2 setBackgroundColor:[UIColor clearColor]];
    [_buttonLabel2 setTextAlignment:UITextAlignmentCenter];
    [_buttonLabel2 setTextColor:textColor];
    [_buttonLabel2 setFont:_font];
    _buttonLabel2.numberOfLines = 2;
    
    [_buttonLabel3 setBackgroundColor:[UIColor clearColor]];
    [_buttonLabel3 setTextAlignment:UITextAlignmentCenter];
    [_buttonLabel3 setTextColor:textColor];
    [_buttonLabel3 setFont:_font];
    _buttonLabel3.numberOfLines = 2;
    
    [_buttonLabel4 setBackgroundColor:[UIColor clearColor]];
    [_buttonLabel4 setTextAlignment:UITextAlignmentCenter];
    [_buttonLabel4 setTextColor:textColor];
    [_buttonLabel4 setFont:_font];
    _buttonLabel4.numberOfLines = 2;
    
    [_buttonLabel5 setBackgroundColor:[UIColor clearColor]];
    [_buttonLabel5 setTextAlignment:UITextAlignmentCenter];
    [_buttonLabel5 setTextColor:textColor];
    [_buttonLabel5 setFont:_font];
    _buttonLabel5.numberOfLines = 2;
    
    //add them all as subviews
    [self addSubview:bgTextureView];
    
    [self addSubview:tlButton];
    [self addSubview:trButton];
    [self addSubview:blButton];
    [self addSubview:brButton];
    [self addSubview:cButton];
    
    [self addSubview:_buttonLabel1];
    [self addSubview:_buttonLabel2];
    [self addSubview:_buttonLabel3];
    [self addSubview:_buttonLabel4];
    [self addSubview:_buttonLabel5];
    
    [bgTextureView release];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setSkill:(int)skillNumber withSkill:(Skill*)skill
{
    if (skillNumber<0 || skillNumber>5) 
        NSLog(@"Skills are from 1 to 5");
    
    else if(skillNumber==1)
    {
        _skill1 = [skill retain];
        _buttonLabel1.text = skill.name;
    }
    
    else if(skillNumber==2)
    {
        _skill2 = [skill retain];
        _buttonLabel2.text = skill.name;
    }
    
    else if(skillNumber==3)
    {
        _skill3 = [skill retain];
        _buttonLabel3.text = skill.name;
    }
    
    else if(skillNumber==4)
    {
        _skill4 = [skill retain];
        _buttonLabel4.text = skill.name;
    } 
    
    
    if(skillNumber==5)
    {
        _skill5 = [skill retain];
        _buttonLabel5.text = skill.name;
    } 
    
    //update picture (only if its 1-4!)
    else
    {
        if (skill.curPP != skill.maxPP)
            [self setButton:skillNumber toState:BUTTON_DISABLED];
        else
            [self setButton:skillNumber toState:skill.type];
    }
}


-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{    
    return false;
}

-(void) removeCancelButtonFromView
{
    [cButton setHidden:1];
}

-(void) setButton:(int)buttonIndex toState:(int)buttonStatus
{
    UIImage* newButtonImage;
    
    if (buttonStatus == BUTTON_DISABLED)
        newButtonImage = [UIImage imageNamed:@"UIButtonDisabled"];
    else if (buttonStatus == BUTTON_NORMAL)
        newButtonImage = [UIImage imageNamed:@"UIButtonNormal"];
    else if (buttonStatus == BUTTON_FIRE)
        newButtonImage = [UIImage imageNamed:@"UIButtonFire"];
    else if (buttonStatus == BUTTON_WATER)
        newButtonImage = [UIImage imageNamed:@"UIButtonWater"];
    else if (buttonStatus == BUTTON_GRASS)
        newButtonImage = [UIImage imageNamed:@"UIButtonGrass"];
    else if (buttonStatus == BUTTON_ELECTRIC)
        newButtonImage = [UIImage imageNamed:@"UIButtonElectric"];
    else if (buttonStatus == BUTTON_ROCK)
        newButtonImage = [UIImage imageNamed:@"UIButtonRock"];
    else if (buttonStatus == BUTTON_PSYCHIC)
        newButtonImage = [UIImage imageNamed:@"UIButtonPsychic"];
    else if (buttonStatus == BUTTON_GHOST)
        newButtonImage = [UIImage imageNamed:@"UIButtonGhost"];
    else
    {
        NSLog(@"No button status by that status! Forcing type normal.");
        newButtonImage = [UIImage imageNamed:@"UIButtonNormal"];
    }
    
    if (buttonIndex == 1)
        tlButton.image = newButtonImage;
    else if (buttonIndex == 2)
        trButton.image = newButtonImage;
    else if (buttonIndex == 3)
        blButton.image = newButtonImage;
    else if (buttonIndex == 4)
        brButton.image = newButtonImage;
    else
        NSLog(@"Set buttons 1-4, not %i", buttonIndex);    
}

-(void) setAllButtonsToHidden:(_Bool)hidden
{
    [tlButton setHidden:hidden];
    [trButton setHidden:hidden];
    [blButton setHidden:hidden];
    [brButton setHidden:hidden];
    [cButton  setHidden:hidden];
    
    [_buttonLabel1 setHidden:hidden];
    [_buttonLabel2 setHidden:hidden];
    [_buttonLabel3 setHidden:hidden];
    [_buttonLabel4 setHidden:hidden];
    [_buttonLabel5 setHidden:hidden];
}

-(bool) buttonsAreHidden
{
    return [tlButton isHidden];
}


@synthesize skill1 = _skill1;
@synthesize skill2 = _skill2;
@synthesize skill3 = _skill3;
@synthesize skill4 = _skill4;
@synthesize skill5 = _skill5;


@end