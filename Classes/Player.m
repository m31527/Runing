//
//  Player.m
//  Runing
//
//  Created by Mac on 2010/8/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Game.h"
#import "Menu.h"

@implementation Player
+ (id)scene{
	CCScene *scene=[CCScene node];
	Player *layer=[Player node];
	[scene addChild:layer];
	return scene;
}

- (id)init{
	if((self=[super init])){
		

		
		appDelegate = (RuningAppDelegate *)[[UIApplication sharedApplication] delegate];
		CCSprite *bg = [CCSprite spriteWithFile:@"player_select_bg.png"];
		bg.position =ccp(160,240);
		[self addChild:bg];
		
		/*
		//load db data
		[Menu getNewDBConnection];
		[Menu queryList];
		
		[CCMenuItemFont setFontName:@"Helvetica"];
		CCMenu *menu = [CCMenu menuWithItems:nil];
		[self addChild:menu];
		int y=380;
		for (int i=0; i<[appDelegate.itemArray count]; i++) {
			int x=60;
			Menu *menuObj = [appDelegate.itemArray objectAtIndex:i];
			NSString *itemid=[NSString stringWithFormat:@"%@",menuObj.itemId];
			NSLog(@"title : %id",itemid);
			UIImage *animalImage = [[UIImage alloc] initWithData:menuObj.playerImage];
			CCSprite *ppp=[CCSprite spriteWithCGImage:animalImage.CGImage];
			CCMenuItem *player1=[CCMenuItemSprite itemFromNormalSprite:ppp selectedSprite:ppp target:self  selector:@selector(scene1:)];
			
			if(i>0){
				
			if(i%3==0)
				y-=70;
				x=60;
			if((i-1)%3==0)
				x=160;
			if((i+1)%3==0)
				x=260;
				
			}
			
			[player1 setPosition:ccp(x, y)];
			//NSLog(@"num:%i,x:%i,y:%i",i,x,y);
			//menu=[CCMenu menuWithItems:player1,nil];
			[menu addChild:player1];
			//只要不要release object 就不會出現圖片混亂
			//[ppp release];
			//[animalImage release];
			//[menuObj release];
		}		
		[menu setPosition:ccp(0,0)];
		 
		*/
		
		CCMenuItem *player1=[CCMenuItemImage itemFromNormalImage:@"black_sheep.png" selectedImage:@"black_sheep.png" target:self selector:@selector(scene1:)];
		CCMenuItem *player2=[CCMenuItemImage itemFromNormalImage:@"cat_new.png" selectedImage:@"cat_new.png" target:self selector:@selector(scene2:)];
		CCMenuItem *player3=[CCMenuItemImage itemFromNormalImage:@"eye.png" selectedImage:@"eye.png" target:self selector:@selector(scene3:)];
		CCMenuItem *player4=[CCMenuItemImage itemFromNormalImage:@"snake.png" selectedImage:@"snake.png" target:self selector:@selector(scene4:)];
		CCMenuItem *player5=[CCMenuItemImage itemFromNormalImage:@"snail.png" selectedImage:@"snail.png" target:self selector:@selector(scene5:)];
		CCMenuItem *player6=[CCMenuItemImage itemFromNormalImage:@"banana.png" selectedImage:@"banana.png" target:self selector:@selector(scene6:)];
		CCMenuItem *player7=[CCMenuItemImage itemFromNormalImage:@"pig.png" selectedImage:@"pig.png" target:self selector:@selector(scene7:)];
		CCMenuItem *player8=[CCMenuItemImage itemFromNormalImage:@"elephant.png" selectedImage:@"elephant.png" target:self selector:@selector(scene8:)];
		CCMenuItem *player9=[CCMenuItemImage itemFromNormalImage:@"mushroom.png" selectedImage:@"mushroom.png" target:self selector:@selector(scene9:)];
		CCMenuItem *player10=[CCMenuItemImage itemFromNormalImage:@"crab.png" selectedImage:@"crab.png" target:self selector:@selector(scene10:)];
		CCMenuItem *player11=[CCMenuItemImage itemFromNormalImage:@"duck.png" selectedImage:@"duck.png" target:self selector:@selector(scene11:)];
		CCMenuItem *player12=[CCMenuItemImage itemFromNormalImage:@"key_question.png" selectedImage:@"key_question.png" target:self selector:@selector(scene_disable:)];
		//CCMenuItem *menuItem2=[CCMenuItemFont itemFromString:@"About Game" target:self selector:@selector(scene2:)];
		CCMenu *menu=[CCMenu menuWithItems:player1,player2,player3,player4,player5,player6,player7,player8,player9,player10,player11,player12,nil];
		
		//[menu alignItemsVertically];
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:3],
		 [NSNumber numberWithUnsignedInt:3],
		 [NSNumber numberWithUnsignedInt:3],
		 [NSNumber numberWithUnsignedInt:3],
		 nil
		 ];
		[menu setPosition:ccp(160,240)];
		[self addChild:menu];
		
		
		/*
		CCMenuItem *player1=[CCMenuItemImage itemFromNormalImage:@"step2_map.png" selectedImage:@"step2_map.png" target:self selector:@selector(scene_disable:)];
		CCMenu *menu=[CCMenu menuWithItems:player1,nil];
		[menu alignItemsVertically];
		[menu setPosition:ccp(203,400)];
		[self addChild:menu];

		CCMenuItem *player2=[CCMenuItemImage itemFromNormalImage:@"step3_map.png" selectedImage:@"step3_map.png" target:self selector:@selector(scene_disable:)];
		CCMenu *menu1=[CCMenu menuWithItems:player2,nil];

		[menu1 alignItemsVertically];
		[menu1 setPosition:ccp(250,300)];
		[self addChild:menu1];
		*/
		//選單標題
		//CCLabel* labeltitle = [CCLabel labelWithString:@"Player Selection" fontName:@"Marker Felt" fontSize:30];
		//[labeltitle setPosition:ccp(170,400)];
		//[self addChild: labeltitle];
	}
	return self;
}

- (void)select_scene:(id)sender data:(id)data
{
	NSLog(@"data::::::%@",[NSString stringWithFormat:@"%@",data]);
}

- (void)scene_new:(id)sender{
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene1:(id)sender{
	[self writeToPlist:@"1"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene2:(id)sender{
	[self writeToPlist:@"2"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene3:(id)sender{
	[self writeToPlist:@"3"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene4:(id)sender{
	[self writeToPlist:@"4"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene5:(id)sender{
	[self writeToPlist:@"5"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene6:(id)sender{
	[self writeToPlist:@"6"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene7:(id)sender{
	[self writeToPlist:@"7"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene8:(id)sender{
	[self writeToPlist:@"8"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene9:(id)sender{
	[self writeToPlist:@"9"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene10:(id)sender{
	[self writeToPlist:@"10"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene11:(id)sender{
	[self writeToPlist:@"11"];
	CCScene *scene_new = [[CCScene node] addChild:[Game node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
}

- (void)scene_disable:(id)sender{
}


//寫入settings.plist 檔
- (void)writeToPlist:(NSString *)lang
{
	if(lang !=nil){
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
		NSString *documentsDirectory = [paths objectAtIndex:0]; //2
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"mySettings.plist"]; //3
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath: path]) //4
		{
			NSString *bundle = [[NSBundle mainBundle] pathForResource:@"mySettings" ofType:@"plist"]; //5
			[fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
		}
		
		NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
		[data setValue:(NSString *)lang forKey:@"Player"];
		[data writeToFile: path atomically:NO];
		[data release]; 
	}
}
@end
