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
    [_player release];
    [_NPC release];
    [_upperHUD release];
    [_lowerHUD release];
    [_chatView release];
    [_leftMonster release];
    [_rightMonster release];
    [_monsterballview release];
    _delegate = nil;
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    [self setBackgroundColor:[[[UIColor alloc] initWithRed:.9 green:.9 blue:.9 alpha:1.0] autorelease]];
    
    _upperHUD = [[UpperHUD alloc] initWithFrame:CGRectMake(0, 0, 320, UpperHUDySize)];
    _lowerHUD = [[LowerHUD alloc] initWithFrame:
                    CGRectMake(0, LowerHUDyOffset, 320, 460-LowerHUDyOffset)];
    _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    _leftMonster = [[AnimatedMonster alloc] initWithFrame:
                    CGRectMake(0, UpperHUDySize, 160, 460-UpperHUDySize-(460-LowerHUDyOffset))];
    _rightMonster = [[AnimatedMonster alloc] initWithFrame:
                    CGRectMake(160, UpperHUDySize, 160, 460-UpperHUDySize-(460-LowerHUDyOffset))];
    _monsterballview = [[AnimatedMonsterball alloc] initWithFrame:
                        CGRectMake(0, UpperHUDySize, 320, 460-UpperHUDySize-(460-LowerHUDyOffset))];
    
    
    UIImage* image = [UIImage imageNamed:@"background_01"];
    UIImageView* background = [[UIImageView alloc] initWithFrame:
                               CGRectMake(0, UpperHUDySize, 320, 460-UpperHUDySize-(460-LowerHUDyOffset))];
    [background setImage:image];
    [background setFrame:CGRectMake(0, 0, 320, 460-(460-LowerHUDyOffset))];
    _leftMonster.onLeftSide = 1;
    _rightMonster.onLeftSide = 0;
    
    [_leftMonster setContentMode:UIViewContentModeCenter];
    [_rightMonster setContentMode:UIViewContentModeCenter];
    
    [self addSubview:background];
    [self addSubview:_leftMonster];
    [self addSubview:_rightMonster];
    [self addSubview:_monsterballview];
    [self addSubview:_upperHUD];
    [self addSubview:_lowerHUD];
    [self addSubview:_chatView];
    
    
    [background release];

    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//interpret actions for the lowerHUD in BattleView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchpoint = [touch locationInView:self];
    
    //height and width of lower hud used to calculate which button is hit
    int buttonW = _lowerHUD.frame.size.width*0.5; 
    int buttonH = _lowerHUD.frame.size.height*0.4;
    
    //touched an area above the lowerHUD, dont do anything
    if (touchpoint.y < LowerHUDyOffset) 
    {
        
    }
    
    else if (touchpoint.y < (buttonH + LowerHUDyOffset))
    {
        if(touchpoint.x < buttonW)
            [self performAction:_lowerHUD.skill1];
        else if (touchpoint.x > buttonW)
            [self performAction:_lowerHUD.skill2];
    }
    else if (touchpoint.y <((2*buttonH) + LowerHUDyOffset))
    {        
        if(touchpoint.x < buttonW)
            [self performAction:_lowerHUD.skill3];
        else if (touchpoint.x > buttonW)
            [self performAction:_lowerHUD.skill4];
    }
    else
        [self performAction:_lowerHUD.skill5];
    
    
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
        for (int i=1; i<=4; i++) 
        {
            
            if(i<=[thisMonster.skills count])
                [_lowerHUD setSkill:i withSkill:[thisMonster.skills objectAtIndex:i-1]];  
            else
            {
                Skill* skillNone = [[Skill alloc] initDummySkill];
                [skillNone setName:@"None"];
                [skillNone setType:BUTTON_DISABLED];
                [_lowerHUD setSkill:i withSkill:skillNone];  
                [skillNone release];
            }
                
        }
    }
    
    Skill* menuCancel = [[Skill alloc] initDummySkill];
    [menuCancel setName:@"Cancel"];
    
    [_lowerHUD setSkill:5 withSkill:menuCancel];
    [menuCancel release];
}

-(void) resetBattleMenu
{
    Skill* menuAttack   = [[Skill alloc] initDummySkill];
                         [menuAttack setName:@"Attack"];
    Skill* menuMonsters = [[Skill alloc] initDummySkill];
                        [menuMonsters setName:@"Change Monster"];
    Skill* menuItem     = [[Skill alloc] initDummySkill];
                        [menuItem setName:@"Use Item"];
    Skill* menuRun      = [[Skill alloc] initDummySkill];
                        [menuRun setName:@"Run Away"];
    Skill* menuBlank    = [[Skill alloc] initDummySkill];
                        [menuBlank setName:@""];
    
    
    
    [_lowerHUD setSkill:1 withSkill:menuAttack];
    [_lowerHUD setSkill:2 withSkill:menuMonsters];
    [_lowerHUD setSkill:3 withSkill:menuItem];
    [_lowerHUD setSkill:4 withSkill:menuRun];
    [_lowerHUD setSkill:5 withSkill:menuBlank];   
    
    [menuAttack release];
    [menuMonsters release];
    [menuItem release];
    [menuRun release];
    [menuBlank release];
}

-(void) performAction:(Skill*)action
{    
    if ([_lowerHUD buttonsAreHidden])
        return;
    
    //menu actions
    if([action.name isEqualToString:@"Attack"])
        [self updateSkills];
    else if([action.name isEqualToString:@"Change Monster"])
        [_delegate showChangeMonsterScreen:0];
    else if([action.name isEqualToString:@"Use Item"])
        [_delegate showInventoryScreen];
    else if([action.name isEqualToString:@"Cancel"])
        [self resetBattleMenu];
    else if([action.name isEqualToString:@""])
        NSLog(@"Do Nothing");
    
    
    //tell controller to try to run
    else if([action.name isEqualToString:@"Run Away"])
        [_delegate attemptRun];
    
    //if its "nothing" then don't do anything
    else if([action.name isEqualToString:@"None"])
        return;
    
    //it must be some kind of attack. do it to the enemy
    else
        [_delegate playerChoosesSkill:action];
}


-(void) setPlayer:(Player*)player
{
    _player = [player retain];
    Monster* monster = [player.monsters objectAtIndex:0];
    [_leftMonster setImage:[monster getImage]];
    
    [_upperHUD setPlayerMonster:monster];
    [_upperHUD setNeedsDisplay];
}

-(void) setNPC:(NPC*)NPC
{
    _NPC = [NPC retain];
    if (NPC.monsters == nil) 
        return;
    
    Monster* monster = [NPC.monsters objectAtIndex:0];
    [_rightMonster setImage:[monster getImage]];
    
    [_upperHUD setOpponentMonster:monster];
    [_upperHUD setNeedsDisplay];
}

-(void) animate
{
    [_leftMonster animate];
    [_rightMonster animate];
    [_monsterballview animate];
    
    if([_chatView stepChatOnce])
        [_chatView setNeedsDisplay];
}

-(void) startRightAttackAnimation
{
    _rightMonster.prepareAttack = 1;
}
-(void) startLeftAttackAnimation
{
    _leftMonster.prepareAttack = 1;
}
-(void) startLeftDyingAnimation
{
    _leftMonster.dying = 1;
}
-(void) startRightDyingAnimation
{
    _rightMonster.dying = 1;
}
-(void) resetLeftAnimation
{
    [_leftMonster reset];
}
-(void) resetRightAnimation
{
    [_rightMonster reset];
}
-(void) startRightCaptureAnimation
{
    _rightMonster.isShrinking = 1;
    _monsterballview.ballInAir = 1;
}
-(void) stopRightCaptureAnimation
{
    _monsterballview.ballInAir = 0;
    _monsterballview.ballRocking = 0;
}

-(void) setLowerHUDHidden:(BOOL)hidden
{
    [_lowerHUD setAllButtonsToHidden:hidden];
}

 
@synthesize delegate = _delegate;
@synthesize chatView = _chatView;
@synthesize upperHud = _upperHUD;

@end