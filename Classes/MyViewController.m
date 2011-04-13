//
//  MyViewController.m
//  ScrollViewWithPaging
//
//  Created by Yuen Ying Kit on 18/05/2010.
//  Url: http://ykyuen.wordpress.com/2010/05/22/iphone-uiscrollview-with-paging-example/
//

#import "MyViewController.h"

static NSArray *__pageControlColorList = nil;

@implementation MyViewController

@synthesize pageNumberLabel;

// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
    if (__pageControlColorList == nil) {
        __pageControlColorList = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor magentaColor],
                                  [UIColor blueColor], [UIColor orangeColor], [UIColor brownColor], [UIColor grayColor], nil];
    }
    // Mod the index by the list length to ensure access remains in bounds.
    return [__pageControlColorList objectAtIndex:index % [__pageControlColorList count]];
}

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"MyViewController" bundle:nil]) {
        pageNumber = page;
    }
    return self;
}

- (void)dealloc {
    [pageNumberLabel release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
	// UIImageView *imageView = [[UIImageView alloc] initWithImage:[MyViewController pageControlColorWithIndex:pageNumber]];
	//[self.view addSubview:imageView];
    self.view.backgroundColor = [MyViewController pageControlColorWithIndex:pageNumber];
}

@end
