//
//  tacotaco.m
//  MonsterQuest
//
//  Created by Alexander W Doub on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwapTableViewController.h"

@implementation SwapTableViewController


-(id) initWithLeftSide:(NSMutableArray *)leftInventory andRightSide:(NSMutableArray *)rightInventory
{
    self = [super init];
	if (self == nil)
		return nil;
    
	_headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)] autorelease];
    _headerLabel.text = @"Buy";
	_headerLabel.textColor = [UIColor whiteColor];
	_headerLabel.shadowColor = [UIColor blackColor];
	_headerLabel.shadowOffset = CGSizeMake(0, 1);
	_headerLabel.font = [UIFont boldSystemFontOfSize:26];
	_headerLabel.backgroundColor = [UIColor clearColor];
    [_headerLabel setTextAlignment:UITextAlignmentCenter];
    
    _categoryLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 22, 300, 40)] autorelease];	
    _categoryLabel.textColor = [UIColor whiteColor];
	_categoryLabel.shadowColor = [UIColor blackColor];
	_categoryLabel.shadowOffset = CGSizeMake(0, 1);
	_categoryLabel.font = [UIFont boldSystemFontOfSize:16];
	_categoryLabel.backgroundColor = [UIColor clearColor];
    [_categoryLabel setTextAlignment:UITextAlignmentCenter];
    
    _goldLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 40)] autorelease];
	_goldLabel.textColor = [UIColor whiteColor];
	_goldLabel.shadowColor = [UIColor blackColor];
	_goldLabel.shadowOffset = CGSizeMake(0, 1);
	_goldLabel.font = [UIFont boldSystemFontOfSize:16];
	_goldLabel.backgroundColor = [UIColor clearColor];
    [_goldLabel setTextAlignment:UITextAlignmentCenter];
    
    _leftInventoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_leftInventoryButton setFrame:CGRectMake(buttonOffsetFromSide, 40, buysellButtonWidth, 30)];
	[_leftInventoryButton setTitle:@"Sell Items" forState:UIControlStateNormal];
	[_leftInventoryButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _rightInventoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_rightInventoryButton setFrame:CGRectMake(320-buysellButtonWidth-buttonOffsetFromSide, 40, buysellButtonWidth, 30)];
	[_rightInventoryButton setTitle:@"Buy Items" forState:UIControlStateNormal];
	[_rightInventoryButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    _leftInventory = [leftInventory retain];
    _rightInventory = [rightInventory retain];
    _tab = 1;
    _leftInventoryButton.hidden  = 0;
    _rightInventoryButton.hidden = 1;
    
    return self;
}


- (void)viewDidLoad
{
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = 50;
	self.tableView.backgroundColor = [UIColor clearColor];
    
	UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 75)] autorelease];
    [containerView addSubview:_categoryLabel];
    [containerView addSubview:_goldLabel];
	[containerView addSubview:_headerLabel];
	self.tableView.tableHeaderView = containerView;
    
    if (!_monsterTradingMode)
        _goldLabel.text = [NSString stringWithFormat:@"Gold: %i", [_worldDelegate getPlayer].gold];    
    
    UIButton* _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_backButton setFrame:CGRectMake(buttonOffsetFromSide, 3, 70, 30)];
	[_backButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:_backButton];
    [[self view] addSubview:_leftInventoryButton];
    [[self view] addSubview:_rightInventoryButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{        
    if (_tab==0)
        return [_leftInventory count];
    if (_tab==1)
        return [_rightInventory count];
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *quantityLabel;
	UILabel *nameLabel;
	UILabel *infoLabel;
    NSInteger row = [indexPath row];
    
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        
        //
        //Default cell setup
        //
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        
        //name label set up
		nameLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(consumableNameLabelXOffset,consumableNameLabelYOffset,infoLabelWidth,20)]autorelease];
        [nameLabel  setContentMode:UIViewContentModeTop];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		//nameLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
        
		//info label set up
		infoLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(consumableInfoLabelXOffset,consumableInfoLabelYOffset,infoLabelWidth,30)]autorelease];
        infoLabel.contentMode = UIViewContentModeTop;
        
        infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		//infoLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.numberOfLines = 99;
        infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:infoLabel];
        
		//picture        
		cell.backgroundView = [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        
        
        //
        // Personalize it
        //
        
        // If its a consumable
        if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Consumable class]) || 
            (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Consumable class])) 
        {
            Consumable* consumable;
            if (_tab==0)
                consumable = [_leftInventory objectAtIndex:row];
            else
                consumable = [_rightInventory objectAtIndex:row];
            
            quantityLabel =[[[UILabel alloc]initWithFrame:
                             CGRectMake(40,0,50,50)]autorelease];
            [quantityLabel setTextAlignment:UITextAlignmentLeft];
            quantityLabel.backgroundColor = [UIColor clearColor];
            quantityLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
            //quantityLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
            quantityLabel.font = [UIFont boldSystemFontOfSize:16];
            quantityLabel.text = [NSString stringWithFormat:@"x%i",consumable.quantity];
            [cell.contentView addSubview:quantityLabel];
            
            nameLabel.text = consumable.name;
            infoLabel.text = [consumable getDescription];
            cell.imageView.image = [consumable getImage];
            
            if ([_worldDelegate getPlayer].gold < consumable.goldValue && _tab == 1)
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"itemMiddleRowRed.png"];
            else
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"middleRow.png"];
            
        }
        
        // If it is equipment
        if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Equipment class]) || 
            (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Equipment class])) 
        {        
            Equipment* equipment;
            if (_tab==0)
                equipment = [_leftInventory objectAtIndex:row];
            else
                equipment = [_rightInventory objectAtIndex:row];
            
            nameLabel.text = equipment.name;
            //infoLabel.text = [Equipment getStringForSlot:equipment.slot];
            cell.imageView.image = [equipment getImage];
            infoLabel.text = [equipment getDescription];   
            
            
            if ([_worldDelegate getPlayer].gold < equipment.goldValue && _tab == 1)
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"itemMiddleRowRed.png"];
            else
                
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"middleRow.png"];
        }     
        
        //resize all infolabels
        CGSize stringSize = [infoLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
                                       constrainedToSize:CGSizeMake(infoLabelWidth, 9999) 
                                           lineBreakMode:infoLabel.lineBreakMode];
        
        infoLabel.frame = CGRectMake(consumableInfoLabelXOffset,consumableInfoLabelYOffset,
                                     infoLabelWidth,stringSize.height+5);
        
        //If its a monster
        if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Monster class]) || 
            (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Monster class])) 
        {
            Monster* daMonster = nil;
            if (_tab==0)
                daMonster = [_leftInventory objectAtIndex:row];
            else
                daMonster = [_rightInventory objectAtIndex:row];
            
            nameLabel.frame = CGRectMake(monsterNameLabelXOffset,monsterNameLabelYOffset,200,50);
            nameLabel.text = daMonster.name;
            nameLabel.font = [UIFont systemFontOfSize:24];
            [nameLabel setTextAlignment:UITextAlignmentLeft];
            
            [infoLabel setTextAlignment:UITextAlignmentLeft];
            infoLabel.numberOfLines = 99;
            infoLabel.text = [NSString stringWithFormat:@"Type: %@\nLevel: %i\nHP: %i/%i", [Skill getStringForType:[daMonster getStat:TYPE]], [daMonster getStat:LEVEL],[daMonster getStat:CURHP], [daMonster getStat:MAXHP]];
            stringSize = [infoLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
                                    constrainedToSize:CGSizeMake(infoLabelWidth, 9999) 
                                        lineBreakMode:infoLabel.lineBreakMode];
            infoLabel.frame = CGRectMake(monsterInfoLabelXOffset ,monsterInfoLabelYOffset, infoLabelWidth,stringSize.height+5);
            
            cell.imageView.image = [daMonster getImage];
            
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"middleRow.png"];
        }

        //offset quantity label too
        if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Consumable class]) || 
            (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Consumable class])) 
            quantityLabel.frame = CGRectMake(40, 0, 50,stringSize.height+5+cellBufferRoom);
        
	}
    
        
    
    //background picture
    //((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"middleRow.png"];
	//((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"middleRowSelected.png"];
	
	return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //buy
    if (_tab==1) 
    {
        if ([[_rightInventory objectAtIndex:0]class] == [Consumable class]) 
        {
            Consumable* item = [[_rightInventory objectAtIndex:indexPath.row] retain];
            if ([_worldDelegate chargePlayerGold:item.goldValue])            
            {
                if (item.quantity==1)
                    [_rightInventory removeObjectAtIndex:indexPath.row];
                else
                    [[_rightInventory objectAtIndex:indexPath.row] setQuantity:item.quantity-1];
                
                //must make fresh item to not confuse quantities
                Consumable* newItem = [[Consumable alloc] initConsumableByName:item.name];
                [[_worldDelegate getPlayer] addConsumableToInventory:newItem];
                [newItem release];
               
            }
            else
            {
                NSLog(@"not enough gold");
            }
            [item release];
                
        }
        else if ([[_rightInventory objectAtIndex:0]class] == [Equipment class])         
        {
            Equipment* item = [[_rightInventory objectAtIndex:indexPath.row] retain];
            
            if ([_worldDelegate chargePlayerGold:item.goldValue])            
            {
                [_rightInventory removeObjectAtIndex:indexPath.row];
                [_leftInventory addObject:item];
            }
            else
            {
                NSLog(@"not enough gold");
            }
            [item release];
        }
        else if ([[_rightInventory objectAtIndex:0]class] == [Monster class]) 
        {
            Monster* daMonster = [[_rightInventory objectAtIndex:indexPath.row] retain];
            
            if (_leftInventory.count < maxHoldableMonsters) 
            {
                [_rightInventory removeObjectAtIndex:indexPath.row];
                [_leftInventory addObject:daMonster];
            }
            [daMonster release];
        }
    }
    //sell
    else if (_tab==0)
    {
        if ([[_leftInventory objectAtIndex:0]class] == [Consumable class]) 
        {
            Consumable* item = [[_leftInventory objectAtIndex:indexPath.row] retain];
            
            //remove it from player
            if (item.quantity==1)
                [_leftInventory removeObjectAtIndex:indexPath.row];
            else
                [[_leftInventory objectAtIndex:indexPath.row] setQuantity:item.quantity-1];
            
            [_worldDelegate chargePlayerGold:-item.goldValue];
            
                    
            
            //give to NPC. (check to see if he already has it.
            bool added = false;
            for (Consumable* existingConsumable in _rightInventory)
            {
                if([existingConsumable.name isEqualToString:item.name])
                {
                    added = true;
                    [existingConsumable setQuantity:(existingConsumable.quantity + 1)];
                }
                
            }
            if (!added)
            {
                Consumable* newItem = [[Consumable alloc] initConsumableByName:item.name];
                [_rightInventory addObject:newItem];
                [newItem release];
            }
            [item release];
            
            
        }
        else if ([[_leftInventory objectAtIndex:0]class] == [Equipment class])         
        {
            Equipment* item = [[_leftInventory objectAtIndex:indexPath.row] retain];
            
            [_worldDelegate chargePlayerGold:-item.goldValue];
            [_rightInventory addObject:item];
            [_leftInventory removeObjectAtIndex:indexPath.row];
            [item release];
        }
        else if ([[_leftInventory objectAtIndex:0]class] == [Monster class])  
        {
            if(_leftInventory.count > 1)
            {
                Monster* daMonster = [[_leftInventory objectAtIndex:indexPath.row] retain];
                [_leftInventory removeObjectAtIndex:indexPath.row];
                [_rightInventory addObject:daMonster];
                [daMonster release];
            }
        }
    }
        
    if (_monsterTradingMode)
        _goldLabel.text = [NSString stringWithFormat:@"Can hold %i more.", maxHoldableMonsters - [_leftInventory count]];
    else
        _goldLabel.text = [NSString stringWithFormat:@"Gold: %i", [_worldDelegate getPlayer].gold];
    [self.tableView reloadData];  

}

-(void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void) leftButtonPressed
{
    _tab=0;
    _leftInventoryButton.hidden  = 1;
    _rightInventoryButton.hidden = 0;
    
    
    [self.tableView reloadData];
    
    if (_monsterTradingMode)
        _headerLabel.text = @"Deposit";
    else
        _headerLabel.text = @"Sell";
}
-(void) rightButtonPressed
{
    _tab=1;
    _leftInventoryButton.hidden  = 0;
    _rightInventoryButton.hidden = 1;
    [self.tableView reloadData];
    
    if (_monsterTradingMode)
        _headerLabel.text = @"Withdraw";
    else
        _headerLabel.text = @"Buy";
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //its monsters
    if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Monster class]) || 
        (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Monster class])) 
    {
        return 100;
    }
    
    //it is consumable. 
    if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Consumable class]) || 
        (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Consumable class])) 
    {
        
        Consumable* thatConsumable = nil;
        if (_tab==0) 
            thatConsumable = [[_leftInventory objectAtIndex:indexPath.row] retain];
        else if (_tab==1)
            thatConsumable = [[_rightInventory objectAtIndex:indexPath.row] retain];
        [thatConsumable release];
        CGSize stringSize = [[thatConsumable getDescription] sizeWithFont:[UIFont systemFontOfSize:12] 
                                 constrainedToSize:CGSizeMake(infoLabelWidth, 9999)];
        return stringSize.height + cellBufferRoom;
    }
    
    //is equipment
    else if ((_rightInventory.count > 0 && [[_rightInventory objectAtIndex:0] class] == [Equipment class]) || 
             (_leftInventory.count > 0 && [[_leftInventory objectAtIndex:0] class] == [Equipment class])) 
    {
        Equipment* thatEquipment = nil;
        if (_tab==0) 
            thatEquipment = [[_leftInventory objectAtIndex:indexPath.row] retain];
        else if (_tab==1)
            thatEquipment = [[_rightInventory objectAtIndex:indexPath.row] retain];
        [thatEquipment release];
        CGSize stringSize = [[thatEquipment getDescription] sizeWithFont:[UIFont systemFontOfSize:12] 
                             constrainedToSize:CGSizeMake(infoLabelWidth, 9999)];
        return stringSize.height + cellBufferRoom;
    }
    else
        return 999;
        
}

-(void) setCategory:(NSString *)string
{
    _categoryLabel.text = string;
}

-(void) setToMonsterTradingMode
{
    _headerLabel.text = @"Withdraw";
    _categoryLabel.text = @"";
    _goldLabel.text = [NSString stringWithFormat:@"Can hold %i more.", maxHoldableMonsters - [_leftInventory count]];
    [_leftInventoryButton setTitle:@"Held" forState:UIControlStateNormal];
    [_rightInventoryButton setTitle:@"Storage" forState:UIControlStateNormal];
    _monsterTradingMode = 1;
    
}

@synthesize worldDelegate = _worldDelegate;
@synthesize tab = _tab;


@end
