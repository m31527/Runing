//
//  Player.h
//  Runing
//
//  Created by Mac on 2010/8/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RuningAppDelegate.h"

@interface Player : CCLayer {
	RuningAppDelegate *appDelegate;
}
+ (id)scene;
@end
