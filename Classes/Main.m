#import "Main.h"
#import <mach/mach_time.h>

#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))

@interface Main(Private)
- (void)initClouds;
- (void)initCloud;
@end


@implementation Main

- (id)init {
//	NSLog(@"Main::init");
	
	if(![super init]) return nil;
	
	RANDOM_SEED();
	NSString *player=[self readPlist:@"Player"];
	NSLog(@"player:%@",player);
	CCSpriteSheet *spriteManager;
	
	if ([player isEqualToString:@"1"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites.png" capacity:10];
	}else if ([player isEqualToString:@"2"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites2.png" capacity:10];
	}else if ([player isEqualToString:@"3"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites3.png" capacity:10];
	}else if ([player isEqualToString:@"4"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites4.png" capacity:10];
	}else if ([player isEqualToString:@"5"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites5.png" capacity:10];
	}else if ([player isEqualToString:@"6"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites6.png" capacity:10];
	}else if ([player isEqualToString:@"7"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites7.png" capacity:10];
	}else if ([player isEqualToString:@"8"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites8.png" capacity:10];
	}else if ([player isEqualToString:@"9"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites9.png" capacity:10];
	}else if ([player isEqualToString:@"10"]) {
		spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites10.png" capacity:10];
	}else if ([player isEqualToString:@"11"]) {
			spriteManager = [CCSpriteSheet spriteSheetWithFile:@"sprites11.png" capacity:10];	
	}
	
	[self addChild:spriteManager z:-1 tag:kSpriteManager];

	CCSprite *background = [CCSprite spriteWithSpriteSheet:spriteManager rect:CGRectMake(0,0,320,480)];
	[spriteManager addChild:background];
	background.position = CGPointMake(160,240);

	[self initClouds];

	[self schedule:@selector(step:)];
	
	return self;
}

- (void)dealloc {
//	NSLog(@"Main::dealloc");
	[super dealloc];
}

- (void)initClouds {
//	NSLog(@"initClouds");
	
	currentCloudTag = kCloudsStartTag;
	while(currentCloudTag < kCloudsStartTag + kNumClouds) {
		[self initCloud];
		currentCloudTag++;
	}
	
	[self resetClouds];
}

- (void)initCloud {
	
	CGRect rect;
	switch(random()%3) {
		case 0: rect = CGRectMake(336,16,256,108); break;
		case 1: rect = CGRectMake(336,128,257,110); break;
		case 2: rect = CGRectMake(336,240,252,119); break;
	}	
	
	CCSpriteSheet *spriteManager = (CCSpriteSheet*)[self getChildByTag:kSpriteManager];
	CCSprite *cloud =[CCSprite spriteWithSpriteSheet:spriteManager rect:rect];
	[spriteManager addChild:cloud z:3 tag:currentCloudTag];
	
	cloud.opacity = 128;
}

- (void)resetClouds {
//	NSLog(@"resetClouds");
	
	currentCloudTag = kCloudsStartTag;
	
	while(currentCloudTag < kCloudsStartTag + kNumClouds) {
		[self resetCloud];

		CCSpriteSheet *spriteManager = (CCSpriteSheet*)[self getChildByTag:kSpriteManager];
		CCSprite *cloud = (CCSprite*)[spriteManager getChildByTag:currentCloudTag];
		ccVertex2F pos = cloud.position;
		pos.y -= 480.0f;
		cloud.position = pos;
		
		currentCloudTag++;
	}
}

- (void)resetCloud {
	
	CCSpriteSheet *spriteManager = (CCSpriteSheet*)[self getChildByTag:kSpriteManager];
	CCSprite *cloud = (CCSprite*)[spriteManager getChildByTag:currentCloudTag];
	
	float distance = random()%20 + 5;
	
	float scale = 5.0f / distance;
	cloud.scaleX = scale;
	cloud.scaleY = scale;
	if(random()%2==1) cloud.scaleX = -cloud.scaleX;
	
	CGSize size = cloud.contentSize;
	float scaled_width = size.width * scale;
	float x = random()%(320+(int)scaled_width) - scaled_width/2;
	float y = random()%(480-(int)scaled_width) + scaled_width/2 + 480;
	
	cloud.position = ccp(x,y);
}

- (void)step:(ccTime)dt {
//	NSLog(@"Main::step");
	
	CCSpriteSheet *spriteManager = (CCSpriteSheet*)[self getChildByTag:kSpriteManager];
	
	int t = kCloudsStartTag;
	for(t; t < kCloudsStartTag + kNumClouds; t++) {
		CCSprite *cloud = (CCSprite*)[spriteManager getChildByTag:t];
		CGPoint pos = cloud.position;
		CGSize size = cloud.contentSize;
		pos.x += 0.1f * cloud.scaleY;
		if(pos.x > 320 + size.width/2) {
			pos.x = -size.width/2;
		}
		cloud.position = pos;
	}
	
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


@end
