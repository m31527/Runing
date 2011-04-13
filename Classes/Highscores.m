#import "Highscores.h"
#import "Main.h"
#import "Game.h"
#import "Menu.h"

@interface Highscores (Private)
- (void)loadCurrentPlayer;
- (void)loadHighscores;
- (void)updateHighscores;
- (void)saveCurrentPlayer;
- (void)saveHighscores;
- (void)button1Callback:(id)sender;
- (void)button2Callback:(id)sender;

@end


@implementation Highscores
ccColor3B textcolor;
- (id)initWithScore:(int)lastScore {
//	NSLog(@"Highscores::init");
	
	if(![super init]) return nil;
	


//	NSLog(@"lastScore = %d",lastScore);
	
	currentScore = lastScore;

//	NSLog(@"currentScore = %d",currentScore);
	
	[self loadCurrentPlayer];
	[self loadHighscores];
	[self updateHighscores];
	if(currentScorePosition >= 0) {
		[self saveHighscores];
	}
	
	CCSpriteSheet *spriteManager = (CCSpriteSheet*)[self getChildByTag:kSpriteManager];
	CCSprite *title = [CCSprite spriteWithSpriteSheet:spriteManager rect:CGRectMake(608,192,225,57)];
	[spriteManager addChild:title z:5];
	title.position = ccp(160,420);

	float start_y = 360.0f;
	float step = 27.0f;
	int count = 0;

	/*
	NSString *playerStr=[self readPlist:@"Player"];

	if ([playerStr isEqualToString:"3"]) {
		textcolor = ccc3(0, 0, 0);
	}else{
		textcolor = ccc3(255, 255, 255);
	}
	*/
	textcolor = ccc3(190, 190, 190);
	for(NSMutableArray *highscore in highscores) {
		NSString *player = [highscore objectAtIndex:0];
		int score = [[highscore objectAtIndex:1] intValue];
		
		CCLabel *label1 = [CCLabel labelWithString:[NSString stringWithFormat:@"%d",(count+1)] dimensions:CGSizeMake(30,40) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:14];
		[self addChild:label1 z:5];
		[label1 setColor:textcolor];
		[label1 setOpacity:200];
		label1.position = ccp(15,start_y-count*step-2.0f);
		
		CCLabel *label2 = [CCLabel labelWithString:player dimensions:CGSizeMake(240,40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:16];
		[self addChild:label2 z:5];
		[label2 setColor:textcolor];
		label2.position = ccp(160,start_y-count*step);

		CCLabel *label3 = [CCLabel labelWithString:[NSString stringWithFormat:@"%d",score] dimensions:CGSizeMake(290,40) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:16];
		[self addChild:label3 z:5];
		[label3 setOpacity:200];
		[label3 setColor:textcolor];
		label3.position = ccp(160,start_y-count*step);
		
		count++;
		if(count == 10) break;
	}

	CCMenuItem *button1 = [CCMenuItemImage itemFromNormalImage:@"again_button.png" selectedImage:@"again_button.png" target:self selector:@selector(button1Callback:)];
	CCMenuItem *button2 = [CCMenuItemImage itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button.png" target:self selector:@selector(button2Callback:)];
	CCMenuItem *button3 = [CCMenuItemImage itemFromNormalImage:@"changePlayerButton.png" selectedImage:@"changePlayerButton.png" target:self selector:@selector(button3Callback:)];
	CCMenu *menu = [CCMenu menuWithItems: button1, button2,button3, nil];
	[menu alignItemsInColumns:
	 [NSNumber numberWithUnsignedInt:2],
	 [NSNumber numberWithUnsignedInt:1],
	 nil
	 ];
	
	//[menu alignItemsVertically];
	menu.position = ccp(160,58);
	
	[self addChild:menu];
	
	return self;
}
//讀取setting.plist 設定檔
- (NSString *)readPlist:(NSString *)field

{
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
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];	
	NSString *value; 
	value = [plistDict objectForKey:(NSString *)field];
	return value;
}

- (void)dealloc {
//	NSLog(@"Highscores::dealloc");
	[highscores release];
	[super dealloc];
}

- (void)loadCurrentPlayer {
//	NSLog(@"loadCurrentPlayer");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	currentPlayer = nil;
	currentPlayer = [defaults objectForKey:@"player"];
	if(!currentPlayer) {
		currentPlayer = @"anonymous";
	}

//	NSLog(@"currentPlayer = %@",currentPlayer);
}

- (void)loadHighscores {
//	NSLog(@"loadHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	highscores = nil;
	highscores = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:@"highscores"]];
#ifdef RESET_DEFAULTS	
	[highscores removeAllObjects];
#endif
	if([highscores count] == 0) {
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:1000000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:750000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:500000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:250000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:100000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:50000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:20000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:10000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:5000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:1000],nil]];
	}
#ifdef RESET_DEFAULTS	
	[self saveHighscores];
#endif
}

- (void)updateHighscores {
//	NSLog(@"updateHighscores");
	
	currentScorePosition = -1;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		int score = [[highscore objectAtIndex:1] intValue];
		
		if(currentScore >= score) {
			currentScorePosition = count;
			break;
		}
		count++;
	}
	
	if(currentScorePosition >= 0) {
		[highscores insertObject:[NSArray arrayWithObjects:currentPlayer,[NSNumber numberWithInt:currentScore],nil] atIndex:currentScorePosition];
		[highscores removeLastObject];
	}
}

- (void)saveCurrentPlayer {
//	NSLog(@"saveCurrentPlayer");
//	NSLog(@"currentPlayer = %@",currentPlayer);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:currentPlayer forKey:@"player"];
}

- (void)saveHighscores {
//	NSLog(@"saveHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:highscores forKey:@"highscores"];
}

- (void)button1Callback:(id)sender {
//	NSLog(@"button1Callback");

	CCScene *scene = [[CCScene node] addChild:[Game node] z:0];
	CCTransitionScene *ts = [CCFadeTransition transitionWithDuration:0.5f scene:scene  withColor:ccc3(255,0,0)];
	[[CCDirector sharedDirector] replaceScene:ts];
}

- (void)button2Callback:(id)sender {
	//	NSLog(@"button1Callback");
	
	CCScene *scene = [[CCScene node] addChild:[Menu node] z:0];
	CCTransitionScene *ts = [CCFadeTransition transitionWithDuration:0.5f scene:scene  withColor:ccc3(255,0,0)];
	[[CCDirector sharedDirector] replaceScene:ts];
}

- (void)button3Callback:(id)sender {
//	NSLog(@"button2Callback");
	
	changePlayerAlert = [UIAlertView new];
	changePlayerAlert.title = @"Change Player";
	changePlayerAlert.message = @"\n";
	changePlayerAlert.delegate = self;
	[changePlayerAlert addButtonWithTitle:@"Save"];
	[changePlayerAlert addButtonWithTitle:@"Cancel"];
	[changePlayerAlert show];

	CGRect frame = changePlayerAlert.frame;
	frame.origin.y -= 100.0f;
	changePlayerAlert.frame = frame;
	
	changePlayerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
	changePlayerTextField.borderStyle = UITextBorderStyleRoundedRect;
	[changePlayerAlert addSubview:changePlayerTextField];
//	changePlayerTextField.placeholder = @"Enter your name";
//	changePlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	changePlayerTextField.keyboardType = UIKeyboardTypeDefault;
	changePlayerTextField.returnKeyType = UIReturnKeyDone;
	changePlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	changePlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	changePlayerTextField.delegate = self;
	[changePlayerTextField becomeFirstResponder];
}

- (void)draw {
//	NSLog(@"draw");

	if(currentScorePosition < 0) return;
	
	glColor4ub(0,0,0,50);

	float w = 320.0f;
	float h = 27.0f;
	float x = (320.0f - w)/2;
	float y = 359.0f - currentScorePosition * h;

	GLfloat vertices[4][2];	
	GLubyte indices[4] = { 0, 1, 3, 2 };
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	vertices[0][0] = x;		vertices[0][1] = y;
	vertices[1][0] = x+w;	vertices[1][1] = y;
	vertices[2][0] = x+w;	vertices[2][1] = y+h;
	vertices[3][0] = x;		vertices[3][1] = y+h;
	
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, indices);
	
	glDisableClientState(GL_VERTEX_ARRAY);	
}

- (void)changePlayerDone {
	currentPlayer = [changePlayerTextField.text retain];
	[self saveCurrentPlayer];
	if(currentScorePosition >= 0) {
		[highscores removeObjectAtIndex:currentScorePosition];
		[highscores addObject:[NSArray arrayWithObjects:@"newplayer",[NSNumber numberWithInt:0],nil]];
		[self saveHighscores];
		Highscores *h = [[Highscores alloc] initWithScore:currentScore];
		CCScene *scene = [[CCScene node] addChild:h z:0];
		[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:1 scene:scene withColorRGB:0xffffff]];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	NSLog(@"alertView:clickedButtonAtIndex: %i",buttonIndex);
	
	if(buttonIndex == 0) {
		[self changePlayerDone];
	} else {
		// nothing
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	NSLog(@"textFieldShouldReturn");
	[changePlayerAlert dismissWithClickedButtonIndex:0 animated:YES];
	[self changePlayerDone];
	return YES;
}

@end
