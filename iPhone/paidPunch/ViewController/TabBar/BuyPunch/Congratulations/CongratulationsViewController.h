//
//  CongratulationsViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface CongratulationsViewController : UIViewController
{
    NSString *punchCardName;
}
@property (retain, nonatomic) IBOutlet UILabel *congratulationsLbl;
@property (retain, nonatomic) IBOutlet UILabel *punchCardDetailedLbl;
@property (retain, nonatomic) NSString *punchCardName;
@property (nonatomic) BOOL isFreePunch;

- (IBAction)doneBtnTouchUpInsideHandler:(id)sender;
- (void) goToBuyPunchView;
- (void)setUpUI;
- (id)init:(NSString *)bName isFreePunchUnlocked:(BOOL)isFreePunchUnlocked;

- (void)userViewedMyPunchesPage;

@end
