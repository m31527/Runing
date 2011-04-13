//
//  Coffee.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Coffee.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation Coffee

@synthesize imageID,title, imageData, isDirty, isDetailViewHydrated,;

+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select title, imageData from image";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Coffee *coffeeObj = [[Coffee alloc] initWithPrimaryKey:primaryKey];
				coffeeObj.coffeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				
				coffeeObj.isDirty = NO;
				
				[appDelegate.coffeeArray addObject:coffeeObj];
				[coffeeObj release];
			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	coffeeID = pk;
	
	coffeeImage = [[UIImage alloc] init];
	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteCoffee {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from image where id = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, imageID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addCoffee {
	
	if(addStmt == nil) {
		const char *sql = "insert into image(title, imageData) Values(?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_text(addStmt, 1, [coffeeName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(addStmt, 2, [price doubleValue]);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		coffeeID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "Select title, imageData from image Where id = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(detailStmt, 1, coffeeID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		
		//Get the price in a temporary variable.
		NSDecimalNumber *priceDN = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(detailStmt, 0)];
		
		//Assign the price. The price value will be copied, since the property is declared with "copy" attribute.
		self.price = priceDN;
		
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(detailStmt, 1) length:sqlite3_column_bytes(detailStmt, 1)]; 
		
		if(data == nil)
			NSLog(@"No image found.");
		else
			self.coffeeImage = [UIImage imageWithData:data]; 
		
		//Release the temporary variable. Since we created it using alloc, we have own it.
		[priceDN release];
	}
	else
		NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllData:(UIImage*) image {
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update image Set title = ?, imageData = ? Where id = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [title UTF8String], -1, SQLITE_TRANSIENT);		
		NSData *imgData = UIImagePNGRepresentation(image);
		
		int returnValue = -1;
		if(self.coffeeImage != nil)
			returnValue = sqlite3_bind_blob(updateStmt, 2, [imgData bytes], [imgData length], NULL);
		else
			returnValue = sqlite3_bind_blob(updateStmt, 2, nil, -1, NULL);
		
		sqlite3_bind_int(updateStmt, 3, id);
		
		if(returnValue != SQLITE_OK)
			NSLog(@"Not OK!!!");
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[title release];
	title = nil;
	[imageData release];
	imageData = nil;
	
	isDetailViewHydrated = NO;
}

- (void) dealloc {
	
	[imageData release];
	[title release];
	[super dealloc];
}

//First open a blob connection using sqlite3_blob_open
//Using the above function will give you sqlite3_blob
//Read the image by passing sqlite3_blob struct in sqlite3_blob_read 


@end
