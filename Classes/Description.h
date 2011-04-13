//
//  Description.h
//  Runing
//
//  Created by Mac on 2010/8/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Description : UIViewController {
	UILabel *pageNumberLabel;
    int pageNumber;
}

@property (nonatomic, retain) IBOutlet UILabel *pageNumberLabel;

- (id)initWithPageNumber:(int)page;

@end
