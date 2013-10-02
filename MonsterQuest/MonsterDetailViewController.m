//
//  MonsterDetailViewController.m
//  MonsterQuest
//
//  Created by u0605593 on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonsterDetailViewController.h"

@implementation MonsterDetailViewController

-(void) dealloc
{
    [_monster release];
    [itemView1Item release];
    [itemView2Item release];
    [itemView3Item release];
    [detailLabel release];
    _worldDelegate = nil;
    _battleDelegate = nil;
    [super dealloc];
}

-(id) initWithMonster:(Monster*) monster
{    
    self = [super init];
	if (self == nil)
		return nil;
    
    _monster = [monster retain];
    return self;
}

-(void) viewDidLoad
{
    //background Image
    UIImage* backgroundImage = [UIImage imageNamed:@"gradientBackground"];
    UIImageView* backgroundImageView = [[UIImageView alloc] 
                                        initWithFrame:CGRectMake(0, 0, 320, 460)];
    [backgroundImageView setImage:backgroundImage];
    [[self view] addSubview:backgroundImageView];
    [backgroundImageView release];
    
    //Monster image
    UIImage* monsterImage = [_monster getImage];
    UIImageView* monsterImageView = [[UIImageView alloc] initWithImage:monsterImage];
    [monsterImageView setFrame:CGRectMake(0, 55, 160, 200)];
    [monsterImageView setContentMode:UIViewContentModeCenter];
    [[self view] addSubview:monsterImageView];
    [monsterImageView release];
    
    //title label
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    [titleLabel setText:_monster.name];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    UIFont* font1 = [UIFont boldSystemFontOfSize:32];
    [titleLabel setFont:font1];
    [titleLabel setShadowOffset:CGSizeMake(2, 2)];
    [[self view] addSubview:titleLabel];
    [titleLabel release];
    
    //detail labels
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 55, 160, 200)];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setTextAlignment:UITextAlignmentLeft];
    [detailLabel setShadowColor:[UIColor blackColor]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    UIFont* font2 = [UIFont systemFontOfSize:15];
    [detailLabel setFont:font2];
    [detailLabel setShadowOffset:CGSizeMake(2, 2)];
    detailLabel.numberOfLines = 10;
    [self updateStats];
    [[self view] addSubview:detailLabel];
    
    //build a lowerhud to display skills
    LowerHUD* lowerHUD = [[LowerHUD alloc] initWithFrame:
                 CGRectMake(0, LowerHUDyOffset, 320, 460-LowerHUDyOffset)];
    [lowerHUD removeCancelButtonFromView];
    [lowerHUD setFrame:
        CGRectMake(0, LowerHUDyOffset+26, 320, 460-LowerHUDyOffset)];
    
    for (int i=1; i<=4; i++) 
    {
        if(i<=[_monster.skills count])
            [lowerHUD setSkill:i withSkill:[_monster.skills objectAtIndex:i-1]]; 
        else
        {
            Skill* skillNone = [[Skill alloc] initDummySkill];
            [skillNone setName:@"None"];
            [skillNone setType:BUTTON_DISABLED];
            [lowerHUD setSkill:i withSkill:skillNone];
            [skillNone release];
        }
    }
    [[self view] addSubview:lowerHUD];
    [lowerHUD release];
    
    //buttons
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(10, 3, 70, 30)];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
    
    if (_battleDelegate && [_monster getStat:CURHP]>0)
    {
        UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [selectButton setTitle:@"Send out" forState:UIControlStateNormal];
        [selectButton setFrame:CGRectMake(240, 3, 70, 30)];
        [selectButton addTarget:self action:@selector(switchToButtonPressed) 
           forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:selectButton];
    }
    
    //Hidden buttons to perform UI actions    
    UIButton* skillButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //skillButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skillButton1 setFrame:CGRectMake(0, 351, 155, 47)];
    [skillButton1 addTarget:self action:@selector(skillButton1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:skillButton1];
    
    UIButton* skillButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [skillButton2 setFrame:CGRectMake(165, 351, 155, 47)];
    [skillButton2 addTarget:self action:@selector(skillButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:skillButton2];
    
    UIButton* skillButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [skillButton3 setFrame:CGRectMake(0, 407, 155, 47)];
    [skillButton3 addTarget:self action:@selector(skillButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:skillButton3];
    
    UIButton* skillButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [skillButton4 setFrame:CGRectMake(165, 407, 155, 47)];
    [skillButton4 addTarget:self action:@selector(skillButton4Pressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:skillButton4];
        
    UIButton* itemButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton1 setFrame:CGRectMake(44, 270, 48, 48)];
    [itemButton1 addTarget:self action:@selector(itemButton1Pressed) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* itemView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ItemBackdrop2"]];
    itemView1Item = [[UIImageView alloc] init];
    if (_monster.weaponSlot != nil)
        itemView1Item.image = [_monster.weaponSlot getImage];
    [itemView1Item setFrame:CGRectMake(12, 12, 24, 24)];
    [itemView1 addSubview:itemView1Item];
    [itemButton1 addSubview:itemView1];
    [[self view] addSubview:itemButton1];
    //[itemView1 release];
    
    UIButton* itemButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton2 setFrame:CGRectMake(136, 270, 48, 48)];
    [itemButton2 addTarget:self action:@selector(itemButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* itemView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ItemBackdrop1"]];
    itemView2Item = [[UIImageView alloc] init];
    if (_monster.armorSlot != nil)
        itemView2Item.image = [_monster.armorSlot getImage];
    [itemView2Item setFrame:CGRectMake(12, 12, 24, 24)];
    [itemView2 addSubview:itemView2Item];
    [itemButton2 addSubview:itemView2];
    [[self view] addSubview:itemButton2];
    //[itemView2 release];
    
    UIButton* itemButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton3 setFrame:CGRectMake(228, 270, 48, 48)];
    [itemButton3 addTarget:self action:@selector(itemButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* itemView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ItemBackdrop3"]];
    itemView3Item = [[UIImageView alloc] init];
    if (_monster.accessorySlot != nil)
        itemView3Item.image = [_monster.accessorySlot getImage];
    [itemView3Item setFrame:CGRectMake(12, 12, 24, 24)];
    [itemView3 addSubview:itemView3Item];
    [itemButton3 addSubview:itemView3];
    [[self view] addSubview:itemButton3];
    //[itemView3 release];
    
    
    
    
     
}
-(void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void) switchToButtonPressed
{
    int depth = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:

     [self.navigationController.viewControllers objectAtIndex:depth-3] animated:TRUE];
    [_battleDelegate changeToMonster:_monster];
}
-(void)skillButton1Pressed
{
    if ([_monster.skills count] < 1)
        return;
    
    Skill* skill = [_monster.skills objectAtIndex:0];
    SkillDetailViewController* sdvc = [[SkillDetailViewController alloc] initWithSkill:skill];
    [self.navigationController pushViewController:sdvc animated:YES];
    [sdvc release];
}
-(void)skillButton2Pressed
{
    if ([_monster.skills count] < 2)
        return;
    
    Skill* skill = [_monster.skills objectAtIndex:1];
    SkillDetailViewController* sdvc = [[SkillDetailViewController alloc] initWithSkill:skill];
    [self.navigationController pushViewController:sdvc animated:YES];
    [sdvc release];
}
-(void)skillButton3Pressed
{
    if ([_monster.skills count] < 3)
        return;
    
    Skill* skill = [_monster.skills objectAtIndex:2];
    SkillDetailViewController* sdvc = [[SkillDetailViewController alloc] initWithSkill:skill];
    [self.navigationController pushViewController:sdvc animated:YES];
    [sdvc release];
}
-(void)skillButton4Pressed
{
    if ([_monster.skills count] < 4)
        return;
    
    Skill* skill = [_monster.skills objectAtIndex:3];
    SkillDetailViewController* sdvc = [[SkillDetailViewController alloc] initWithSkill:skill];
    [self.navigationController pushViewController:sdvc animated:YES];
    [sdvc release];
}
-(void) itemButton1Pressed
{
    if (!_worldDelegate)
        return;
    
    
    Player* player;
    if (_worldDelegate)
        player = [_worldDelegate getPlayer];
    else
        NSAssert(FALSE, @"need player to push ITVC");
    
    InventoryTableViewController* itvc = [[InventoryTableViewController alloc] initWithPlayer:player];
    [itvc setEquipmentDelegate:self];
    [itvc setEquipmentDelegateSlot:1];
    [itvc setTab:2];
    [self.navigationController pushViewController:itvc animated:YES];
    [itvc release];
}
-(void) itemButton2Pressed
{
    if (!_worldDelegate)
        return;
    
    
    Player* player;
    if (_worldDelegate)
        player = [_worldDelegate getPlayer];
    else
        NSAssert(FALSE, @"need player to push ITVC");
    
    
    InventoryTableViewController* itvc = [[InventoryTableViewController alloc] initWithPlayer:player];
    [itvc setEquipmentDelegate:self];
    [itvc setEquipmentDelegateSlot:2];
    [itvc setTab:2];
    [self.navigationController pushViewController:itvc animated:YES];
    [itvc release];
}
-(void) itemButton3Pressed
{
    if (!_worldDelegate)
        return;
    
    
    Player* player;
    if (_worldDelegate)
        player = [_worldDelegate getPlayer];
    else
        NSAssert(FALSE, @"need player to push ITVC");
    
    InventoryTableViewController* itvc = [[InventoryTableViewController alloc] initWithPlayer:player];
    [itvc setEquipmentDelegate:self];
    [itvc setEquipmentDelegateSlot:3];
    [itvc setTab:2];
    [self.navigationController pushViewController:itvc animated:YES];
    [itvc release];
}

//Delegate methods
-(void) equipEquipmentAtSlot1:(Equipment *)equipment
{
    //if item is there, put it back in player inventory
    if (_monster.weaponSlot != nil)
        [[_worldDelegate getPlayer].equipment addObject:_monster.weaponSlot];
    
    //put it on the monster
    [_monster setEquipment:equipment toSlot:1];
    [itemView1Item setImage:[equipment getImage]];
    [self updateStats];
}
-(void) equipEquipmentAtSlot2:(Equipment *)equipment
{
    if (_monster.armorSlot != nil)
        [[_worldDelegate getPlayer].equipment addObject:_monster.armorSlot];
    
    [_monster setEquipment:equipment toSlot:2];
    [itemView2Item setImage:[equipment getImage]];
    [self updateStats];
    
}
-(void) equipEquipmentAtSlot3:(Equipment *)equipment
{
    if (_monster.accessorySlot != nil)
        [[_worldDelegate getPlayer].equipment addObject:_monster.accessorySlot];
    
    [_monster setEquipment:equipment toSlot:3];
    [itemView3Item setImage:[equipment getImage]];
    [self updateStats];
}
-(void) updateStats
{
    [detailLabel setText:[NSString stringWithFormat:@"Level: %i\nType: %@\nHP: %i/%i\nPhys Atk: %i\nPhys Def: %i\nMagic Atk: %i\nMagic Def: %i\nSpeed: %i\nAccuracy: %i%%\nCritical: %i%%", 
                            [_monster getStat:LEVEL],
                            [Skill getStringForType:[_monster getStat:TYPE]], 
                            [_monster getStat:CURHP], 
                            [_monster getStat:MAXHP], 
                            [_monster getStat:PHYSATK], 
                            [_monster getStat:PHYSDEF], 
                            [_monster getStat:MAGICATK], 
                            [_monster getStat:MAGICDEF], 
                            [_monster getStat:SPEED],
                            [_monster getStat:ACCURACY],
                            [_monster getStat:CRITICAL]]];
    
}


@synthesize battleDelegate = _battleDelegate;
@synthesize worldDelegate = _worldDelegate;

@end
