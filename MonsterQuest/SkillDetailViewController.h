//
//  SkillDetailViewController.h
//  MonsterQuest
//
//  Created by u0605593 on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Skill.h"

@interface SkillDetailViewController : UIViewController
{
    Skill* _skill;
}

-(id) initWithSkill:(Skill*)skill;

@end
