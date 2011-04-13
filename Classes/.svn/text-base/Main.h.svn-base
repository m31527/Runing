#import "cocos2d.h"

//#define RESET_DEFAULTS

#define kFPS 60

#define kNumClouds			12

#define kMinPlatformStep	30
#define kMaxPlatformStep	100
#define kNumPlatforms		20
#define kPlatformTopPadding 20
//1O 10 TO 20 20

#define kMinBonusStep		30
#define kMaxBonusStep		50
//30 50
enum {
	kSpriteManager = 0,
	kBird,
	kScoreLabel,
	kMonster,
	kCloudsStartTag = 100,
	kPlatformsStartTag = 200,
	kBonusStartTag = 300
};

enum {
	kBonus5 = 0,
	kBonus10,
	kBonus50,
	kBonus100,
	kBonusdown50,
	kBonusdown100,
	kfly1000,
	kfly500,
	kNumBonuses
};

@interface Main : CCLayer
{
	int currentCloudTag;
}
- (void)resetClouds;
- (void)resetCloud;
- (void)step:(ccTime)dt;
@end
