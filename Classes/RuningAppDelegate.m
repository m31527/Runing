//
//  RuningAppDelegate.m
//  Runing
//
//  Created by Mac on 2010/7/29.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RuningAppDelegate.h"
#import "Game.h"
#import "Main.h"
#import "Menu.h"

@implementation RuningAppDelegate
@synthesize itemArray;
@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	itemArray = [[NSMutableArray alloc] init];
	//self.itemArray = tempArray;
	//[tempArray release];
	
	[self createEditableCopyOfDatabaseIfNeeded];

	
	[application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	//	[window setUserInteractionEnabled:YES];
	//	[window setMultipleTouchEnabled:YES];	
	
	[[CCDirector sharedDirector] setPixelFormat:kRGBA8];
	[[CCDirector sharedDirector] attachInWindow:window];
	//	[[Director sharedDirector] setDisplayFPS:YES];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/kFPS];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888]; 
	
	[window makeKeyAndVisible];
	
	//這裡可以加入很多場景
	CCScene *scene = [[CCScene node] addChild:[Menu node] z:0];
	[[CCDirector sharedDirector] runWithScene: scene];
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	
	NSLog(@"Creating editable copy of database");
	// First, test for existence.
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"putoo.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"putoo.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

/*
- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
		[Menu finalizeStatements];
}
*/ 

- (void)dealloc {
	[window release];
	[super dealloc];
}

- (void)applicationWillResignActive:(UIApplication*)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
	[[CCDirector sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
	//[[CCDirector sharedDirector] purgeCachedData];
}

- (void)applicationSignificantTimeChange:(UIApplication*)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


@end
