//
//  StartPageViewcontroller.h
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoviePlayer.h"
#import "DualSignInViewController.h"
#import "FAQViewController.h"
#import "LoginView.h"
#import "SigninView.h"
#import "UsingPaidPunchViewController.h"

@interface StartPageViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL onLoginView;
    LoginView* loginView;
    SigninView* signinView;
    UIView* containerView;
    
	UIScrollView* scrollView;
	UIPageControl* pageControl;
	
	BOOL pageControlBeingUsed;
    
    NSTimer     *pagingTimer;
    BOOL        userHasInteracted;
    
    int totalContentCount;
}

@property (nonatomic, retain) IBOutlet UIScrollView  *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) NSMutableArray *viewControllers;


- (IBAction)changePage:(id)sender;

- (IBAction)showFAQ:(id)sender;
- (IBAction)pressPlay:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

- (void)autoChangePage;

@end
