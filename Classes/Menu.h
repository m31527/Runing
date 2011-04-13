//
//  Menu.h
//  Runing
//
//  Created by Mac on 2010/7/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Menu : CCLayer {
	NSXMLParser *xmlParser;  
	NSMutableArray *appList;  
	NSMutableDictionary *item;  
	
	NSString *currentElement;  
	NSMutableString *title, *imageUrl ,*imageMapUrl ,*itemId;
	
	NSData *playerImage;
	NSData *mapImage;
	NSString *xmlId;
	
}
@property (nonatomic, retain) IBOutlet NSXMLParser *xmlParser;  
@property (nonatomic, retain) IBOutlet NSMutableArray *appList;  
@property (nonatomic, retain) IBOutlet NSMutableDictionary *item;  
@property (nonatomic, retain) IBOutlet NSString *currentElement;  
@property (nonatomic, retain) IBOutlet NSMutableString *title, *imageUrl, *imageMapUrl, *itemId;
@property (nonatomic, retain) IBOutlet NSData *playerImage;
@property (nonatomic, retain) IBOutlet NSData *mapImage;
@property (nonatomic, retain) IBOutlet NSString *xmlId;
+ (id)scene;
+ (void) finalizeStatements;
+ (void) getNewDBConnection;
+ (void) queryList;
@end
