//
//  BattleController.m
//  MonsterQuest
//
//  Created by u0605593 on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"


@implementation BattleController

-(void) dealloc
{
    [_player release];
    [_NPC release];
    [_playerSelectedSkill release];
    [_enemySelectedSkill release];
    [_oldName release];
    [_frameLink release];
    [_peerID release];
    [_bgmPlayer release];
    [_sfxPlayer release];
    [super dealloc];
}

-(id) initWithPlayer:(Player*)player andEnemy:(NPC*)NPC andSession:(GKSession*) session andPeerID:(NSString *)peerID
{
	self = [super init];
	if (self == nil)
		return nil;
    
    _player = [player retain];
    _NPC    = [NPC retain];
    _willEndBattle = 0;
    _willShowDefeatText = 0;
    _willGivePlayerXP = 0;
    _playerWillSwitchMonster = 0;
    _playerLeveledUp=0;
    _monsterballHangTime = 0;
    _waitForPlayer = 0;
    _willCaptureMonster = 0;
    
    _playerWillAttack = 0;
    _enemyWillAttack = 0;
    
    _peerID = [peerID retain];
    
    _playerHasUsedTurn = 0;
    _enemyHasUsedTurn = 0;
    _gameState = GKPeerStateConnected;
    
    
    // seed for multiplayer
    if (session)
    {
        _gameSession = [session retain];
        [_gameSession setDelegate:self];
        [_gameSession setDataReceiveHandler:self withContext:nil];
        
        // seed both players with the same value
        if ([_peerID intValue] < [[_gameSession peerID] intValue])
        {
            srand48([_peerID intValue]);
        }
        else
        {
            srand48([[_gameSession peerID] intValue]);
        }
    }
    
    // seed for single player
    else
    {
        srand48([[NSDate date] timeIntervalSince1970]);
    }
    
    
    //reset PP
    
    for (Monster* monster in _player.monsters)
        [monster resetPP];
    for (Monster* monster in _NPC.monsters)
        [monster resetPP];
    
    //music
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/battle.mp3", [[NSBundle mainBundle] resourcePath]]];
    _bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _bgmPlayer.numberOfLoops = -1;
    
    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hit.wav", [[NSBundle mainBundle] resourcePath]]];
    _sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
	return self;
}

-(BattleView*) contentView
{
	return (BattleView*)[self view];
}

-(void) loadView
{   
	BattleView* _battleView = [[BattleView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
    [_battleView setDelegate:self];
    [_battleView resetBattleMenu];
    [self setView:_battleView];
    
    [self updateViewWithPlayer];
    [self updateViewWithNPC];
    
    Monster* daMonster = [_NPC.monsters objectAtIndex:0];
    [_player sawMonster:daMonster.number];
    [_battleView release];
    
    [_bgmPlayer play];
}

-(void) receiveLoot
{
    //check if they were gym leader
    if (_NPC.npcType > 9 && _NPC.npcType < 19) 
    {
        [_player recievesBadge:_NPC.npcType-10];
        NSString* chatText = [NSString stringWithFormat:@"You receive %@'s badge!", _NPC.name];
        [[[self contentView] chatView] setChatDialog:chatText];
        return;
    }
    
    else
    {
        int receivedGold = [_NPC getGoldValue];
        NSString* chatText = [NSString stringWithFormat:@"You receive %i gold", receivedGold ];
        [[[self contentView] chatView] setChatDialog:chatText];
        _player.gold = _player.gold+receivedGold;
        return;
    }
}
-(void) endBattle
{    
    [_bgmPlayer stop];
    //kill all his monsters so he wont fight us again
    _NPC.monsters = nil;
    
    for (Monster* m in _player.monsters)
    {
        [m resetPP];
        [m resetModifiedStats];
    }
    
    _player.isFrozen = 0;
    [_frameLink invalidate];
    if (_gameSession)
    {
        [_gameSession disconnectFromAllPeers];
        [_gameSession setDelegate:nil];
        [_gameSession setAvailable:NO];
        [_gameSession setDataReceiveHandler:nil withContext:nil];
        _gameSession = nil;
    }
    
    [self.navigationController popViewControllerAnimated:TRUE];  
}


-(void) viewDidLoad
{
    _frameLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)] retain];
    _frameLink.frameInterval = 1;
    [_frameLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    NSString* chatText;
    if (!_gameSession && [_NPC.name isEqualToString:@"WILD"])
        chatText = [NSString stringWithFormat:@"A wild %@ jumps out of the grass!" ,[[[_NPC monsters] objectAtIndex:0] name ]];
    else
        chatText = [NSString stringWithFormat:@"%@ challenges you to a fight!" ,_NPC.name];
    
    [[[self contentView] chatView] setChatDialog:chatText];
    //[[[self contentView] chatView] stepChatCompletelyOrAdvance];
}

-(void) gameLoop
{        
    //take care of animation. 
    [self.contentView animate];
    
    //u gro older
    _player.secondsPlayed += (1/FPS);
    
    //---------- enemy in monsterball
    if(_enemyMonsterWillSufferMonsterball)
    {
        _monsterballHangTime += (1.0/FPS*1.0);
        
        if (_monsterballHangTime > maxMonsterballHangTime) 
        {
            _willCaptureMonster = 1;
            _enemyMonsterWillSufferMonsterball = 0;
            [[self contentView] stopRightCaptureAnimation];
        }
        return;
    }
    
    //wait for health bars
    if([self.contentView.upperHud animate])
    {
        [[self contentView] setLowerHUDHidden:1];
        [self.contentView.upperHud setNeedsDisplay];
        return;
    }

    //hide buttons early 
    if(_playerSelectedSkill)
        [[self contentView] setLowerHUDHidden:1];
    
    //if drawing chat or waiting on player dont do anything else
    if ([self.contentView.chatView isInUse] || _waitForPlayer) 
        return;
    
    //receiving xp
    if (_willReceiveXP) 
    {
        _willReceiveXP = 0;
        
        _oldName = [[[_player.monsters objectAtIndex:0] name] retain]; 
        int playerCurrentLevel = [[_player.monsters objectAtIndex:0] getStat:LEVEL];
        int xpToGive = [[_NPC.monsters objectAtIndex:0] getStat:LEVEL] * 100;
        [[_player.monsters objectAtIndex:0] giveXP:xpToGive];
        if ([[_player.monsters objectAtIndex:0] getStat:LEVEL] > playerCurrentLevel)
            _playerLeveledUp=1;
        if (![_oldName isEqualToString:[[_player.monsters objectAtIndex:0] name]]) 
            _playerEvolved = 1;
        
        NSString* chatText = [NSString stringWithFormat:@"%@ receives %i XP!", 
                              [[_player.monsters objectAtIndex:0] name], xpToGive];        
        [[[self contentView] chatView] setChatDialog:chatText];
        [self updateViewWithPlayer];
        _NPCWillSwitchMonster = 1;
        return;
    }
    
    //leveled up
    if (_playerLeveledUp)
    {
        NSString* chatText = [NSString stringWithFormat:@"%@ grows to level %i!", 
                              _oldName,[[_player.monsters objectAtIndex:0] getStat:LEVEL]];        
        [[[self contentView] chatView] setChatDialog:chatText];
        _playerLeveledUp = 0;
        return;
    }
    if (_playerEvolved)
    {
        NSString* chatText = [NSString stringWithFormat:@"%@ evolves to %@!", 
                              _oldName,[[_player.monsters objectAtIndex:0] name]];        
        [[[self contentView] chatView] setChatDialog:chatText];
        _playerEvolved=0;
        [[self contentView] resetBattleMenu];
        return;
    }
    if (_willReceiveLoot)
    {
        _willReceiveLoot = 0;
        [self receiveLoot];
        _willEndBattle = 1;
        return;
    }
    
    //--------ending battle
    if (_willShowDefeatText) 
    {
        [[[self contentView] chatView] setChatDialog:_NPC.defeatText];
        _willShowDefeatText = 0;
        _willReceiveLoot = 1;
        return;
    }
    if(_willCaptureMonster)
    {
        Monster* capturedMonster = [_NPC.monsters objectAtIndex:0];
        
        [_player capturedMonster:capturedMonster];
        NSString* chatText = [NSString stringWithFormat:@"You captured %@!", capturedMonster.name];        
        [[[self contentView] chatView] setChatDialog:chatText];
        _willEndBattle = 1;
        _willCaptureMonster = 0;
        return;
    }
    
    if(_willEndBattle)
    {        
        [self endBattle];
        return;
    }
    
    
    //---------- switching/swapping monsters
    if (_playerWillSwitchToChosenMonster) 
    {
        _playerWillSwitchToChosenMonster = 0;
        [_player.monsters exchangeObjectAtIndex:0 withObjectAtIndex:_playerWillSwitchToChosenMonsterIndex];
        [[_player.monsters objectAtIndex:0] resetModifiedStats];
        [self updateViewWithPlayer];
        [self updateViewWithNPC];
        return;
    }
    if (_NPCWillSwitchMonster && !_gameSession) 
    {
        _NPCWillSwitchMonster = 0;
        [self npcChooseNextMonster];
        [self updateViewWithPlayer];
        [self updateViewWithNPC];
        return;
    }
    else if (_NPCWillSwitchMonster && _gameSession)
    {
        bool isOutOfMonsters = 1;
        for (Monster* monster in _NPC.monsters)
            if ([monster getStat:CURHP] > 0)
                isOutOfMonsters = 0;
        
        if (isOutOfMonsters) 
        {
            NSString* chatText = [_NPC.name stringByAppendingString:@" is out of monsters to fight with! You win!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            _willEndBattle = 1;
            return;
        }
    }
    if (_playerWillSwitchMonster)
    {
        _playerWillSwitchMonster = 0;
        [self showChangeMonsterScreen:1];
        [self updateViewWithPlayer];
        [self updateViewWithNPC];
        return;
    }
    
    //check if dead
    if([[_NPC.monsters objectAtIndex:0] getStat:CURHP]==0 && !_NPCWillSwitchMonster)
    {
        NSString* chatText = [NSString stringWithFormat:@"%@ collapses!", [[_NPC.monsters objectAtIndex:0] name]];
        [[[self contentView] chatView] setChatDialog:chatText];
        [[self contentView] startRightDyingAnimation];
        
        _willReceiveXP = 1;        
        return;
    }
    if ([[_player.monsters objectAtIndex:0] getStat:CURHP]==0) 
    {
        if ([self checkIfGameOver])
            return;
        
        NSString* chatText = [NSString stringWithFormat:@"%@ collapses! Who will you send out next?", [[_player.monsters objectAtIndex:0] name]];        
        [[[self contentView] chatView] setChatDialog:chatText];
        [[self contentView] startLeftDyingAnimation];
        _playerWillSwitchMonster = 1;
        return;
    }
    
    
    //commence fight
    if (_playerSelectedSkill != nil && _enemySelectedSkill != nil && !_playerWillAttack && !_enemyWillAttack && !_NPCWillSwitchMonster) 
    {
        //start player attack
        if(!_playerHasUsedTurn && ([self playerIsFaster] || _enemyHasUsedTurn))
        {
            
            [_playerSelectedSkill setCurPP:0];
            _playerWillAttack = 1;
            _playerHasUsedTurn = 1;
            NSString* chatText = [NSString stringWithFormat:@"%@ uses %@!", 
                                  [[_player.monsters objectAtIndex:0] name], _playerSelectedSkill.name];        
            [[[self contentView] chatView] setChatDialog:chatText];
            return;
        }   
        
        //start enemy attack
        else if(!_enemyHasUsedTurn)
        {
            NSString* chatText = [NSString stringWithFormat:@"%@ uses %@!", 
                                  [[_NPC.monsters objectAtIndex:0] name], _enemySelectedSkill.name];        
            [[[self contentView] chatView] setChatDialog:chatText];
            [_enemySelectedSkill setCurPP:0];
            _enemyWillAttack = 1;
            _enemyHasUsedTurn = 1;
            return;
        }
    }
    
    if(_playerWillAttack)
    {
        Monster* npcMonster = [_NPC.monsters objectAtIndex:0];
        Monster* playerMonster = [_player.monsters objectAtIndex:0];
        
        [self monsterUseSkillOnMonster:playerMonster usesSkill:_playerSelectedSkill onTarget:npcMonster]; 
        if (_playerSelectedSkill.isPhysical)
            [[self contentView] startLeftAttackAnimation];
        _playerWillAttack = 0;
        return;
    }
    
    if (_enemyWillAttack)
    {
        Monster* npcMonster = [_NPC.monsters objectAtIndex:0];
        Monster* playerMonster = [_player.monsters objectAtIndex:0];
        Skill* enemySkill = _enemySelectedSkill;
        
        [self monsterUseSkillOnMonster:npcMonster usesSkill:enemySkill onTarget:playerMonster];
        if (_enemySelectedSkill.isPhysical)
            [[self contentView] startRightAttackAnimation];
        _enemyWillAttack = 0;
        return;
    }
    
    //both people used turns
    if (!_playerWillAttack && !_enemyWillAttack && 
        _playerHasUsedTurn && _enemyHasUsedTurn) 
    {
        if (_gameSession) 
        {
            Skill* readySkill = [[Skill alloc] initDummySkill];
            [readySkill setName:@"READY"];
            NSData* sendData = [NSKeyedArchiver archivedDataWithRootObject:readySkill];
            [_gameSession sendDataToAllPeers:sendData withDataMode:GKSendDataReliable error:nil];
            [readySkill release];
        }
        if (!_gameSession)
            _enemyIsDone = 1;
        
        if (_enemyIsDone)
            [self resetTurns];
        
        else if (_gameState == 1)
        {
            NSString* chatText = [_NPC.name stringByAppendingString:@" ran way! You win!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            _willEndBattle = 1;
        }
        return;
    }
    
    //for single player use only
    if (_enemySelectedSkill == nil && !_gameSession) 
        _enemySelectedSkill = [[self chooseEnemySkill] retain];
    
    
    //hiding/unhiding lower hud
    [[self contentView] setLowerHUDHidden:(_playerSelectedSkill != nil)];
    
}

-(void) npcChooseNextMonster
{
    [self resetTurns];
    
    //swap with one that has HP
    for (int i =0; i<[_NPC.monsters count]; i++) 
    {
        if ([[_NPC.monsters objectAtIndex:i] getStat:CURHP] > 0) 
        {
            [_NPC.monsters exchangeObjectAtIndex:0 withObjectAtIndex:i];
            Monster* daMonster = [_NPC.monsters objectAtIndex:0];
            
            NSString* chatText = [NSString stringWithFormat:@"%@ sends out %@!", _NPC.name, daMonster.name];
            [[[self contentView] chatView] setChatDialog:chatText];
            [_player sawMonster:daMonster.number];
            [[self contentView] resetRightAnimation];
            [self updateViewWithPlayer];
            [self updateViewWithNPC];
            
            return;
        }
    }
    //no healthy monsters left, player wins
    if (![_NPC.name isEqualToString:@"WILD"]) {
        NSString* chatText = [_NPC.name stringByAppendingString:@" is out of monsters to fight with! You win!"];
        [[[self contentView] chatView] setChatDialog:chatText];
    }       
    
    _willShowDefeatText = 1;
    
}
-(BOOL) checkIfGameOver
{    
    //swap with one that has HP
    for (int i =0; i<[_player.monsters count]; i++) 
    {
        if ([[_player.monsters objectAtIndex:i] getStat:CURHP] > 0) 
            return false;
    }
    //no healthy monsters left, player wins
    NSString* chatText = @"You are out of monsters to fight with! You black out!";
    [[[self contentView] chatView] setChatDialog:chatText];
    _willEndBattle = 1;
    
    [_player setWorldCoordinates:CGPointMake(playerStartZoneX, playerStartZoneY)];
    [_player setXPos:playerStartPosX];
    [_player setYPos:playerStartPosY];
    [[_player.monsters objectAtIndex:0] setStat:CURHP withValue:1];
    
    return true;
}

-(void) updateViewWithPlayer
{
    [[self contentView] setPlayer:_player];
}
-(void) updateViewWithNPC
{
    [[self contentView] setNPC:_NPC];
}


//for now just picks a skill at random
-(Skill*) chooseEnemySkill
{
    Monster* thisMonster = [_NPC.monsters objectAtIndex:0];
    int skillNumber = arc4random()%[thisMonster.skills count];
    
    if([thisMonster.skills count]==0)
        NSLog(@"For some reason this monster has 0 skills. Fix it.");
    
    return [thisMonster.skills objectAtIndex:skillNumber];
}


-(void) monsterUseSkillOnMonster:(Monster*)attacker usesSkill:(Skill *)skill onTarget:(Monster*) target
{
    //attack
    if (skill.type != BUFF && skill.type != DEBUFF && skill.type != RESTORE) 
    {
        
        //miss
        float randomNumber = drand48() * 100;
        NSLog(@"rand: %f", randomNumber);
        if (randomNumber > ([attacker getStat:ACCURACY] + [attacker getMofidiedStat:ACCURACY]))
        {
            NSString* chatText = [NSString stringWithFormat:@"It missed!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            return;
        }
        
        //hit
        float baseStatsDamageMultiplier = -1000;        
        if(skill.isPhysical)
            baseStatsDamageMultiplier = ([attacker getStat:PHYSATK]*1.0) / ([target getStat:PHYSDEF]*1.0);
        else
            baseStatsDamageMultiplier = ([attacker getStat:MAGICATK]*1.0) / ([target getStat:MAGICDEF]*1.0);
        float typeDamageMultiplier = [Monster getTypeMultiplierWithAttacktype:skill.type andDefenseType:[target getStat:TYPE]];
        
        float modifiedStatsDamageMultiplier = 1.0;
        if (skill.isPhysical) 
            modifiedStatsDamageMultiplier = [attacker getMofidiedStat:PHYSATK] / [target getMofidiedStat:PHYSDEF];
        else
            modifiedStatsDamageMultiplier = [attacker getMofidiedStat:MAGICATK] / [target getMofidiedStat:MAGICDEF];       
        
        //test
        baseStatsDamageMultiplier = sqrt(baseStatsDamageMultiplier);
        NSLog(@"my attack:%f, his def:%f", [attacker getMofidiedStat:PHYSATK]*1.0, [target getMofidiedStat:PHYSDEF]*1.0);
        NSLog(@"type:%f, modified:%f, base:%f", typeDamageMultiplier, modifiedStatsDamageMultiplier, baseStatsDamageMultiplier);
        
        NSString* chatText;
        int damageDone =    flatDamageMultiplier * typeDamageMultiplier * modifiedStatsDamageMultiplier * 
        (skill.attackPower * baseStatsDamageMultiplier * 
         ((5.0*[attacker getStat:LEVEL]+20.0)/100.0) + 2.0);
        
        //lower the damage by a random percent
        damageDone -= (damageDone * damageVariation * (randomNumber/100));
        
        //critical
        if (randomNumber < ([attacker getStat:CRITICAL] + [attacker getMofidiedStat:CRITICAL]))
        {
            damageDone *= 2;
            chatText = [NSString stringWithFormat:@"It critically hits for %i %@ type damage!", 
                        damageDone, [[Skill getStringForType:skill.type] lowercaseString]];
            NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/crit1.wav", [[NSBundle mainBundle] resourcePath]]];
            _sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [_sfxPlayer play];
        }
        //normal
        else
        {
            chatText = [NSString stringWithFormat:@"It hits for %i %@ type damage!", 
                        damageDone, [[Skill getStringForType:skill.type] lowercaseString]];
            NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hit1.wav", [[NSBundle mainBundle] resourcePath]]];
            _sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [_sfxPlayer play];
        }
        
        if (typeDamageMultiplier < 1.0)
            chatText = [chatText stringByAppendingFormat:@" It's not very effective..."];
        else if (typeDamageMultiplier > 1.0)
            chatText = [chatText stringByAppendingFormat:@" It's super effective!"];
        
        [target recieveDamage:damageDone];
        [[[self contentView] chatView] setChatDialog:chatText];
        
    }
    //buff
    if (skill.type==BUFF)
    {
        //miss
        float randomNumber = drand48() * 100;
        if (randomNumber > [attacker getStat:ACCURACY])
        {
            NSString* chatText = [NSString stringWithFormat:@"It fails!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            return;
        }
        NSString* chatText;
        if ([attacker incrementStat:skill.attackPower])
            chatText = [NSString stringWithFormat:@"%@'s %@ raises!", 
                        attacker.name, [Skill getStringForStat:skill.attackPower]];
        else
            chatText = [NSString stringWithFormat:@"%@'s %@ can't go any higher!", 
                        attacker.name, [Skill getStringForStat:skill.attackPower]];    
        
        [[[self contentView] chatView] setChatDialog:chatText];
    }
    
    //debuff
    if (skill.type==DEBUFF)
    {
        //miss
        float randomNumber = drand48() * 100;
        if (randomNumber > [attacker getStat:ACCURACY])
        {
            NSString* chatText = [NSString stringWithFormat:@"It fails!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            return;
        }
        NSString* chatText;
        if ([target decrementStat:skill.attackPower])
            chatText = [NSString stringWithFormat:@"%@'s %@ lowers!", 
                        target.name, [Skill getStringForStat:skill.attackPower]];
        else
            chatText = [NSString stringWithFormat:@"%@'s %@ can't go any lower!", 
                        target.name, [Skill getStringForStat:skill.attackPower]];    
        
        [[[self contentView] chatView] setChatDialog:chatText];
    }
    
    //RESTORE
    if (skill.type==RESTORE)
    {
        //miss
        float randomNumber = drand48() * 100;
        if (randomNumber > [attacker getStat:ACCURACY])
        {
            NSString* chatText = [NSString stringWithFormat:@"It fails!"];
            [[[self contentView] chatView] setChatDialog:chatText];
            return;
        }
        NSString* chatText;
        int HPtoRestore = [attacker getStat:MAXHP] / 2;
        [attacker setStat:CURHP withValue:HPtoRestore + [attacker getStat:CURHP]];
        if ([attacker getStat:CURHP] > [attacker getStat:MAXHP])
            [attacker setStat:CURHP withValue:[attacker getStat:MAXHP]];
        
        chatText = [NSString stringWithFormat:@"%@'s restores %i HP!", 
                    attacker.name, HPtoRestore]; 
        [[[self contentView] chatView] setChatDialog:chatText];
    }
    
    
    //update views
    [self updateViewWithPlayer];
    [self updateViewWithNPC];
}

//delegate methods
-(void) playerChoosesSkill:(Skill*)skill
{
    if (skill.curPP != skill.maxPP) 
    {
        NSString* chatText = [NSString stringWithFormat:@"That attack is on cooldown for %i more turns!", 
                              (skill.maxPP - skill.curPP)]; 
        [[[self contentView] chatView] setChatDialog:chatText];
        return;
    }
    
    
    _waitForPlayer = 0;
    _playerSelectedSkill = [skill retain];
    
    if (_gameSession)
    {
        NSData* skillData = [NSKeyedArchiver archivedDataWithRootObject:_playerSelectedSkill];
        [_gameSession sendDataToAllPeers:skillData withDataMode:GKSendDataReliable error:nil];
        NSLog(@"sending my skill named %@ to opponent", [_playerSelectedSkill name]);
    }
    
    return;
}

-(void) attemptRun
{
    _waitForPlayer = 0;
    
    //REMOVE THIS ASAP vvvv
    //_willEndBattle = 1;
    //^^^^^^^^^^
    
    if ([_NPC.name isEqualToString:@"WILD"] && !_gameSession)
    {
        if (drand48() < successfulRunChance)
        {
            _willEndBattle = 1;
            NSString* chatText = [NSString stringWithFormat:@"Successfully ran away!"];
            [[[self contentView] chatView] setChatDialog:chatText];
        }
        else
        {
            _playerHasUsedTurn = 1;
            _playerSelectedSkill = [[Skill alloc] initDummySkill];
            _willEndBattle = 0;
            NSString* chatText = [NSString stringWithFormat:@"Could not run away!"];
            [[[self contentView] chatView] setChatDialog:chatText];
        }
    }
    else if (_gameSession)
    {
        NSLog(@"running from multiplayer");
        _willEndBattle = 1;
        
        // NSString* chatText = [NSString stringWithFormat:@"Disconnected!"];
        // [[[self contentView] chatView] setChatDialog:chatText];
        // [_gameSession disconnectFromAllPeers];
        // [_gameSession setAvailable:NO];
        // [_gameSession setDelegate:nil];
        // [_gameSession setDataReceiveHandler:nil withContext:nil];
        // [_gameSession release];
        // _gameSession = nil;
        
    }
    else
    {
        NSString* chatText = [NSString stringWithFormat:@"You can't run away from a trainer!"];
        [[[self contentView] chatView] setChatDialog:chatText];
    }
    
}

-(void) showChangeMonsterScreen:(bool)isCancellable
{
    _waitForPlayer = 1;
    MonsterTableViewController* mtvc = [[MonsterTableViewController alloc] initWithMonsters:_player.monsters];
    [mtvc setBattleDelegate:self];
    [mtvc hideBackButton:isCancellable];
    [self.navigationController pushViewController:mtvc animated:YES];
    [mtvc release];
}

-(void) changeToMonster:(Monster *)monster
{    
    _playerWillSwitchToChosenMonsterIndex = -1;
    _playerWillSwitchToChosenMonsterIndex = [_player.monsters indexOfObject:monster];
    
    if(_playerWillSwitchToChosenMonsterIndex==0)
        return;
    
    if (_gameSession) 
    {
        Skill* readySkill = [[Skill alloc] initDummySkill];
        [readySkill setName:[NSString stringWithFormat:@"CHANGE MONSTER:%i", _playerWillSwitchToChosenMonsterIndex]];
        NSData* sendData = [NSKeyedArchiver archivedDataWithRootObject:readySkill];
        [_gameSession sendDataToAllPeers:sendData withDataMode:GKSendDataReliable error:nil];
        [readySkill release];
    }
    
    
    NSAssert(_playerWillSwitchToChosenMonsterIndex > 0, @"No monster there!!");
    _playerWillSwitchToChosenMonster = 1;
    NSString* chatText = [NSString stringWithFormat:@"You send out %@!", monster.name];
    [[[self contentView] chatView] setChatDialog:chatText];
    
    [[self contentView] resetLeftAnimation];
    [[self contentView] resetBattleMenu];
    _waitForPlayer = 0;
    _playerHasUsedTurn = 1;
    _playerSelectedSkill = [[Skill alloc] initDummySkill];
    [self updateViewWithPlayer];
    [self updateViewWithNPC];
}

-(void) showInventoryScreen
{
    _waitForPlayer = 1;
    InventoryTableViewController* itvc = [[InventoryTableViewController alloc] 
                                          initWithPlayer:_player];
    [itvc setBattleDelegate:self];
    [itvc setTab:1];
    [self.navigationController pushViewController:itvc animated:YES];
    [itvc release];
}

-(void) useConsumable:(Consumable *)consumable onMonster:(Monster *)monster
{
    if (_gameSession) 
    {
        Skill* readySkill = [[Skill alloc] initDummySkill];
        [readySkill setName:[NSString stringWithFormat:@"USE ITEM:%@:%i", consumable.name, [_player.monsters indexOfObject:monster]]];
        NSData* sendData = [NSKeyedArchiver archivedDataWithRootObject:readySkill];
        [_gameSession sendDataToAllPeers:sendData withDataMode:GKSendDataReliable error:nil];
        [readySkill release];
    }
    
    
    
    NSString* chatText = [NSString stringWithFormat:@"You use %@ on %@.", consumable.name, monster.name];
    
    [monster useConsumable:consumable];    
    [_player removeConsumableFromInventory:consumable];
    _waitForPlayer = 0;
    _playerHasUsedTurn = 1;
    _playerSelectedSkill = [[Skill alloc] initDummySkill];
    [[[self contentView] chatView] setChatDialog:chatText];
    [self updateViewWithPlayer];
    [self updateViewWithNPC];
}

-(void) useMonsterball:(Consumable*)monsterball
{
    _waitForPlayer = 0;
    if (![_NPC.name isEqualToString:@"WILD"] || _gameSession) 
    {
        NSString* chatText = [NSString stringWithFormat:@"You can't catch another trainer's monster!"];
        [[[self contentView] chatView] setChatDialog:chatText];
        return;
    }
    
    Monster* enemyMonster = [_NPC.monsters objectAtIndex:0];
    _enemyMonsterWillSufferMonsterball = 1;
    NSString* chatText = [NSString stringWithFormat:@"You throw a %@ at %@.", monsterball.name, enemyMonster.name];
    [_player removeConsumableFromInventory:monsterball];
    [[[self contentView] chatView] setChatDialog:chatText];
    [[self contentView] startRightCaptureAnimation];
}

-(Player*) getPlayer
{
    return _player;
}

-(bool) playerIsFaster
{
    //TODO
    //check attacks and the person with a "fast attack" always attacks first.
    
    Monster *playerMonster = [_player.monsters objectAtIndex:0];
    Monster *enemyMonster = [_NPC.monsters objectAtIndex:0];
    
    if (([playerMonster getStat:SPEED] * [playerMonster getMofidiedStat:SPEED]) != ([enemyMonster getStat:SPEED] * [enemyMonster getMofidiedStat:SPEED]))
        return (([playerMonster getStat:SPEED] * [playerMonster getMofidiedStat:SPEED]) > ([enemyMonster getStat:SPEED] * [enemyMonster getMofidiedStat:SPEED]));
    
    //speed is the same, have to do some magic
    if (!_gameSession){
        double playerPoints = 1000.0*(_player.xSubPos * _player.ySubPos);
        double enemyPoints = 1000.0*(_NPC.xSubPos     * _NPC.ySubPos);
        return playerPoints > enemyPoints;
    }
    else
        return [_peerID intValue] < [[_gameSession peerID] intValue];
    
}

-(void) resetTurns
{
    _playerHasUsedTurn = 0;
    _enemyHasUsedTurn = 0;
    _enemyIsDone = 0;
    _playerSelectedSkill = nil;
    _enemySelectedSkill = nil;
    
    for (Monster* monster in _player.monsters)
        [monster incrementPP];
    
    for (Monster* monster in _NPC.monsters)
        [monster incrementPP];
    
    [[self contentView] updateSkills];
    
    if (_gameState == GKPeerStateDisconnected)
    {
        /*
         [_gameSession disconnectFromAllPeers];
         [_gameSession setAvailable:NO];
         [_gameSession setDelegate:nil];
         [_gameSession setDataReceiveHandler:nil withContext:nil];
         [_gameSession release];
         _gameSession = nil;
         */
        NSString* chatText = @"Player disconnected";
        [[[self contentView] chatView] setChatDialog:chatText];
        
        for (Monster* m in [_NPC monsters])
        {
            [m setStat:CURHP withValue:0];
        }
        
    }
}

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{    
    Skill* receivedSkill = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString* actionName = [[receivedSkill.name componentsSeparatedByString:@":"] objectAtIndex:0];
    
    _enemyIsDone = 0;
    
    if ([receivedSkill.name isEqualToString:@"READY"])
    {
        _enemyIsDone = 1;
    }
    
    else if ([actionName isEqualToString:@"USE ITEM"])
    {
        NSString* itemName = [[receivedSkill.name componentsSeparatedByString:@":"] objectAtIndex:1];
        int monsterIndex = [[[receivedSkill.name componentsSeparatedByString:@":"] objectAtIndex:2] intValue];
        
        //do it here
        Consumable* item = [[Consumable alloc] initConsumableByName:itemName];
        Monster* monster = [_NPC.monsters objectAtIndex:monsterIndex];
        [[_NPC.monsters objectAtIndex:0] useConsumable:item];
        NSString* chatText = [NSString stringWithFormat:@"%@ uses %@ on %@.", _NPC.name, item.name, monster.name];
        [[[self contentView] chatView] setChatDialog:chatText];
        
        _enemyHasUsedTurn = 1;
        _enemySelectedSkill = [[Skill alloc] initDummySkill];
        [item release];
    }
    
    else if ([actionName isEqualToString:@"CHANGE MONSTER"])
    {
        int monsterNumber = [[[receivedSkill.name componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
        
        //do it here
        [_NPC.monsters exchangeObjectAtIndex:0 withObjectAtIndex:monsterNumber];
        NSString* chatText = [NSString stringWithFormat:@"%@ sends out %@.", _NPC.name, [[_NPC.monsters objectAtIndex:0] name]];
        [[[self contentView] chatView] setChatDialog:chatText];
        
        _enemyHasUsedTurn = 1;
        _enemySelectedSkill = [[Skill alloc] initDummySkill];
    }
    else
        _enemySelectedSkill = [receivedSkill retain];
    
    
    [self updateViewWithPlayer];
    [self updateViewWithNPC];
}

-(void) disconnect:(id)sender
{
    /*
     [_gameSession disconnectFromAllPeers];
     [_gameSession setAvailable:NO];
     [_gameSession setDelegate:nil];
     [_gameSession setDataReceiveHandler:nil withContext:nil];
     [_gameSession release];
     _gameSession = nil;
     */
    NSString* chatText = @"Player disconnected...";
    [[[self contentView] chatView] setChatDialog:chatText];
    _willEndBattle = 1;
}

-(void) session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    _gameState = state;
    NSLog(@"getting run %i", state);
    if (state == 1)
    {
        NSLog(@"getting run");
        _enemySelectedSkill = [[Skill alloc] initDummySkill];
        _enemyHasUsedTurn = 1;
    }
}




@end