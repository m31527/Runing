//
//  Coffee.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Coffee : NSObject {
	
	NSInteger imageID;
	NSString *title;
	UIImage *imageData; 
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}


@property (nonatomic, readonly) NSInteger imageID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIImage *imageData;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteCoffee;
- (void) addCoffee;
- (void) hydrateDetailViewData;
- (void) saveAllData;

@end
