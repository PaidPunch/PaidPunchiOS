//
//  StartPageScrollViewController.h
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartPageScrollViewController : UIViewController {

    int pageNumber;
    UIImageView *placardImage;
}

- (id)initWithPageNumber:(int)page;

@end
