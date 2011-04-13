//
//  RuningAppDelegate.h
//  Runing
//
//  Created by Mac on 2010/7/29.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "cocos2d.h"

@interface RuningAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate>{
	UIWindow *window;
	NSMutableArray *itemArray;

}
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) UIWindow *window;

@end
