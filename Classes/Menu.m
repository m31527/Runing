//
//  Menu.m
//  Runing
//
//  Created by Mac on 2010/7/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "Player.h"
#import "SimpleAudioEngine.h"
#import "RuningAppDelegate.h"
#import <sqlite3.h>;
@implementation Menu
static sqlite3_stmt *insert_statement;
static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
@synthesize xmlParser;  
@synthesize appList;  
@synthesize item;  

@synthesize currentElement;  
@synthesize title, imageUrl,imageMapUrl,itemId;
@synthesize playerImage,mapImage,xmlId;
+ (id)scene{
	CCScene *scene=[CCScene node];
	Menu *layer=[Menu node];
	[scene addChild:layer];
	return scene;
}

- (id)init{
	if((self=[super init])){
		
		CCSprite *bg = [CCSprite spriteWithFile:@"start_game.png"];
		bg.position =ccp(160,240);
		[self addChild:bg];
		
		[CCMenuItemFont setFontName:@"Helvetica"];
		CCMenuItem *menuItem1 =[CCMenuItemFont itemFromString:@" Play" target:self selector:@selector(scene1:)];
		CCMenuItem *menuItem2 =[CCMenuItemFont itemFromString:@"Check Update" target:self selector:@selector(checkupdate:)];

		[self fontColor:menuItem1];
		[self fontColor:menuItem2];
		//CCMenuItem *menuItem2=[CCMenuItemFont itemFromString:@"About Game" target:self selector:@selector(scene2:)];
		CCMenu *menu=[CCMenu menuWithItems:menuItem1,menuItem2	,nil];
		[menu alignItemsVertically];
		[menu setPosition:ccp(160,240)];
		[self addChild:menu];
		//播放音樂
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Sheep.M4A"];
		

	}
	return self;
}

- (void)loadPlayerXML{
	//parse xml 產生各區
	NSString *url=nil;
	//http://putoo.myvnc.com/Game.xml
	url=[[NSString alloc] initWithFormat:@"http://127.0.0.1/~mac/Game.xml"];
	[self parseXMLFileAtURL:url];  
}

- (void) parseXMLFileAtURL:(NSString*)URL{
	appList = [[NSMutableArray alloc]init];  
	//you must then convert the path to a proper NSURL or it won't work  
	NSURL *xmlURL = [NSURL URLWithString:URL];  
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error  
	// this may be necessary only for the toolchain  
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL]; 
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.  
	[xmlParser setDelegate:self];  
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.  
	[xmlParser setShouldProcessNamespaces:NO];  
	[xmlParser setShouldReportNamespacePrefixes:NO];  
	[xmlParser setShouldResolveExternalEntities:NO];  
	[xmlParser parse];  
}  


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}  

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {  
	NSString * errorString = [[NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]]autorelease];  
	NSLog(@"error parsing XML: %@", errorString);  
	
	UIAlertView * errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];  
	[errorAlert show];  
}  

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{  
	currentElement = [elementName copy];  
	
	if ([elementName isEqualToString:@"item"]) {  
		item = [[NSMutableDictionary alloc]init];  
		title = [[NSMutableString alloc]init];  
		imageUrl = [[NSMutableString alloc]init];
		imageMapUrl = [[NSMutableString alloc]init];
		itemId = [[NSMutableString alloc]init];
		
	}  
}  


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{  
	
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...  
		[item setObject:title forKey:@"title"];  
		[item setObject:imageUrl forKey:@"imageUrl"];
		[item setObject:imageMapUrl forKey:@"imageMapUrl"];
		[item setObject:itemId forKey:@"itemId"];
		[appList addObject:[item copy]];	
		[item release];
	}  
}  


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{   
	if ([currentElement isEqualToString:@"title"]) {  
		[title appendString:string];  
	} else if ([currentElement isEqualToString:@"imageUrl"]) {  
		[imageUrl appendString:string];  
	} else if ([currentElement isEqualToString:@"imageMapUrl"]) {  
		[imageMapUrl appendString:string];  
	} else if ([currentElement isEqualToString:@"itemId"]) {  
		[itemId appendString:string];  		
	} 
}
 


- (void)scene1:(id)sender{

	CCScene *scene_new = [[CCScene node] addChild:[Player node]];
	[[CCDirector sharedDirector] pushScene:scene_new];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}
- (void)scene2:(id)sender{
}

- (void)checkupdate:(id)sender{
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(150, 300, 37.0f, 37.0f);
	
	[[[CCDirector sharedDirector] openGLView] addSubview:activityIndicator];  

	[activityIndicator startAnimating];
	
	[Menu getNewDBConnection];
	[self loadPlayerXML];
	[self deleteAll];
	for (int i=0; i<[appList count]; i++) {
		NSDictionary *dictionary = [appList objectAtIndex:i];
		NSString *citemid = [dictionary objectForKey:@"itemId"];
		citemid = [citemid stringByReplacingOccurrencesOfString:@"\t" withString:@""];
		citemid = [citemid stringByReplacingOccurrencesOfString:@"\n" withString:@""];		
		NSString *ctitle = [dictionary objectForKey:@"title"];
		ctitle = [ctitle stringByReplacingOccurrencesOfString:@"\t" withString:@""];
		ctitle = [ctitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSString *cimageUrl = [dictionary objectForKey:@"imageUrl"];
		cimageUrl = [cimageUrl stringByReplacingOccurrencesOfString:@"\t" withString:@""];
		cimageUrl = [cimageUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		UIImage *loadimage=[self loadImageFromUrl:cimageUrl];
		NSString *cimageMapUrl = [dictionary objectForKey:@"imageMapUrl"];
		cimageMapUrl = [cimageMapUrl stringByReplacingOccurrencesOfString:@"\t" withString:@""];
		cimageMapUrl = [cimageMapUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		UIImage *loadimagemap=[self loadImageFromUrl:cimageMapUrl];
		[self addData:loadimage setTitle:ctitle setMapData:loadimagemap setItemId:citemid];
	}
	
	[activityIndicator stopAnimating];
}

- (void)fontColor:(CCMenuItem*)item{
	
	id color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
	id color_back = [color_action reverse];
	id seq = [CCSequence actions:color_action, color_back, nil];
	[item runAction:[CCRepeatForever actionWithAction:seq]];
	
}

+ (void) getNewDBConnection{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSLog(@"path%@",paths);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"putoo.sqlite"];
	//BOOL success = [fileManager fileExistsAtPath:path]; 
	/*
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"data.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
		
		if (!success) 
			NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
	*/
	
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSLog(@"Database Successfully Opened :)");		
	} else {
		NSLog(@"Error in opening database :(");
	}
}
- (UIImage*)loadImageFromUrl:(NSString*)url
{
	NSURL  *picUrl = [NSURL URLWithString:url];
	NSData *picData = [NSData dataWithContentsOfURL:picUrl];
	UIImage *image = [UIImage imageWithData:picData];
	return image;
}

- (void) addData:(UIImage*)image setTitle:(NSString*)ctitle setMapData:(UIImage*)imageMap setItemId:(NSString*)itemId{
	//NSString *ctitle=[NSString stringWithString:@"test"];
	NSData *ImageData = UIImagePNGRepresentation(image);
	NSInteger Imagelen = [ImageData length];
	
	NSData *ImageMapData = UIImagePNGRepresentation(imageMap);
	NSInteger ImageMaplen = [ImageMapData length];
	
	if(addStmt == nil) {
		const char *sql = "insert into item(title,imageData,imageMapData,itemId) values(?,?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}

	
	sqlite3_bind_text(addStmt, 1, [ctitle UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_blob(addStmt, 2, [ImageData bytes], Imagelen, SQLITE_TRANSIENT);
	sqlite3_bind_blob(addStmt, 3, [ImageMapData bytes], ImageMaplen, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 4, [itemId UTF8String], -1, SQLITE_TRANSIENT);

	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSLog(@"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}

//查詢全部
+ (void)queryList{
	RuningAppDelegate *appDelegate = (RuningAppDelegate *)[[UIApplication sharedApplication] delegate];
	const char *sql = "select itemId, imageData,imageMapData from item";
	sqlite3_stmt *selectstmt;
	if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(selectstmt) == SQLITE_ROW) {
			
			Menu *menuObj = [[Menu alloc] init];
			menuObj.itemId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSData *playerdata = [[NSData alloc] initWithBytes:sqlite3_column_blob(selectstmt, 1) length:sqlite3_column_bytes(selectstmt, 1)]; 
			NSData *mapdata = [[NSData alloc] initWithBytes:sqlite3_column_blob(selectstmt, 2) length:sqlite3_column_bytes(selectstmt, 2)]; 
			
			if(playerdata == nil || mapdata==nil){
				NSLog(@"No image found.");
			}else{
				//UIImage *ppi=[UIImage imageWithData:playerdata];
				//UIImage *ppim=[UIImage imageWithData:mapdata];
				menuObj.playerImage=playerdata;
				menuObj.mapImage=mapdata;
				//[ppi release];
				//[ppim release];
				//menuObj.playerImage=[UIImage imageNamed:@"pig.png"];
				//menuObj.mapImage=[UIImage imageNamed:@"pig.png"];		
			}
			
			[appDelegate.itemArray addObject:menuObj];
			[menuObj release];
		}
		
	}

	else
		sqlite3_close(database);
}
/*
- (void)setPlayerImage:(UIImage *)playimg {
	
	[playerImage release];
	playerImage = [playimg retain];
}

- (void)setMapImage:(UIImage *)mapimg {
	
	[mapImage release];
	mapImage = [mapimg retain];
}
*/ 

-(void) deleteAll{
	if(deleteStmt == nil) {
		const char *sql = "delete from item";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);

	
}

- (void) dealloc {
	
	[playerImage release];
	[mapImage release];
	[super dealloc];
}
@end
