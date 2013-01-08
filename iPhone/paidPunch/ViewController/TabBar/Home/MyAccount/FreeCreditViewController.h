//
//  FreeCreditViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeCreditViewController : UIViewController
{
    UIButton* _btnFacebook;
    UIButton* _btnEmail;
    UIButton* _btnBusiness;
    UILabel* _lblFreeCredit;
}
@property (nonatomic,strong) UIButton* btnFacebook;

- (IBAction)goBack:(id)sender;

@end
