//
//  StartPageScrollViewController.m
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "StartPageScrollViewController.h"

static NSArray *__pageControlImageList = nil;

@implementation StartPageScrollViewController

// Creates the image list the first time this method is invoked. Returns one color object from the list.
+ (NSString *)pageControlImageWithIndex:(NSUInteger)index {
    if(__pageControlImageList == nil) {
        __pageControlImageList = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"InformationPlacardThree.png"], [NSString stringWithFormat:@"InformationPlacardTwo.png"], [NSString stringWithFormat:@"InformationPlacardOne.png"], nil];
    }
    
    NSLog(@"pageControlImageWithIndex");
    return [__pageControlImageList objectAtIndex:index % [__pageControlImageList count]];
}

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    NSLog(@"initWithPageNumber");
    if (self = [super initWithNibName:@"PageControllerExample" bundle:nil]) {
        pageNumber = page;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    placardImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[StartPageScrollViewController pageControlImageWithIndex:pageNumber]]]];
    [self.view addSubview:placardImage];
    NSLog(@"ScrollViewcontroller: viewDidLoad");
}


@end