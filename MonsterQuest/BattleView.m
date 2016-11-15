//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleView.h"


@implementation BattleView

- (void)dealloc
{
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    [self setBackgroundColor:[[UIColor alloc] initWithRed:.9 green:.9 blue:.9 alpha:1.0]];
    
    _upperHUD = [[[UpperHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 100)]retain];
    _lowerHUD = [[[LowerHUD alloc] initWithFrame:CGRectMake(0, 320, LowerHUDxOffset, 460-LowerHUDxOffset)]retain];
    [self addSubview:_upperHUD];
    [self addSubview:_lowerHUD];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawing battleview");
    
}
*/

//interpret actions for the lowerHUD in BattleView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchpoint = [touch locationInView:self];
    
    //height and width of lower hud used to calculate which button is hit
    int buttonW = _lowerHUD.frame.size.width*0.5; 
    int buttonH = _lowerHUD.frame.size.height*0.4;
    
    //touched an area above the lowerHUD, dont do anything
    if (touchpoint.y < LowerHUDxOffset) 
    {
        NSLog(@"touched empty space in battleview");
    }
    
    else if (touchpoint.y < (buttonH + LowerHUDxOffset))
    {
        if(touchpoint.x < buttonW)
            [self performAction:_lowerHUD.skill1];
        else if (touchpoint.x > buttonW)
            [self performAction:_lowerHUD.skill2];
    }
    else if (touchpoint.y <((2*buttonH) + LowerHUDxOffset))
    {        
        if(touchpoint.x < buttonW)
            [self performAction:_lowerHUD.skill3];
        else if (touchpoint.x > buttonW)
            [self performAction:_lowerHUD.skill4];
    }
    else
        [self resetBattleMenu];
    
    
    return;
}

//updaters lowerHUD with all the monsters skills
-(void) updateSkills
{
    if([_player.monsters count] == 0)
        NSLog(@"ERROR: Player has no monsters, cannot update skills");
    
    else
    {
        Monster* thisMonster = [_player.monsters objectAtIndex:0];
        for (int i=1; i<=[thisMonster.skills count]; i++) 
        {
            [_lowerHUD setSkill:i withSkill:[thisMonster.skills objectAtIndex:i-1]];     
        }
    }
}

-(void) resetBattleMenu
{
    Skill* menuAttack = [[Skill alloc] initWithName:@"Attack"];
    Skill* menuMonsters = [[Skill alloc] initWithName:@"Change Monster"];
    Skill* menuItem = [[Skill alloc] initWithName:@"Use Item"];
    Skill* menuRun = [[Skill alloc] initWithName:@"Run Away"];
    
    
    [_lowerHUD setSkill:1 withSkill:menuAttack];
    [_lowerHUD setSkill:2 withSkill:menuMonsters];
    [_lowerHUD setSkill:3 withSkill:menuItem];
    [_lowerHUD setSkill:4 withSkill:menuRun];
    
}

-(void) performAction:(Skill*)action
{    
    //menu actions
    if([action.name isEqualToString:@"Attack"])
        [self updateSkills];
    else if([action.name isEqualToString:@"Change Monster"])
        NSLog(@"Push Monsters view");
    else if([action.name isEqualToString:@"Use Item"])
        NSLog(@"Push Items view");
    
    //tell controller to try to run
    else if([action.name isEqualToString:@"Run Away"])
        [_delegate attemptRun];
    
    
    
    //if its a real attack, tell the controller
    
}


-(void) setPlayer:(Player*)player
{
    _player = player;
}
-(void) setNPC:(NPC*)NPC
{
    _NPC=NPC;
}

@synthesize delegate = _delegate;

@end