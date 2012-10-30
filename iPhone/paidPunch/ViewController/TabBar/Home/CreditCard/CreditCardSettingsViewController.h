//
//  CreditCardSettingsViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 12/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "AddCardViewController.h"

@interface CreditCardSettingsViewController : UIViewController<NetworkManagerDelegate,UIAlertViewDelegate>
{
    NetworkManager *networkManager;
}

@property (retain, nonatomic) IBOutlet UIButton *deleteCardBtn;
@property (retain, nonatomic) IBOutlet UIButton *addCardBtn;
@property (retain, nonatomic) IBOutlet UILabel *cardMaskedCodeLbl;
@property (retain, nonatomic) IBOutlet UILabel *linkAddCardLbl;
@property (retain, nonatomic) IBOutlet UIImageView *creditCardPinImageView;
@property (nonatomic,retain) NSString *maskedId;

- (id)init:(NSString *)creditCardMaskedId;
- (void)setUpUI;
- (void)goToAddCardView;

- (IBAction)addCardBtnTouchUpInsideHandler:(id)sender;
- (IBAction)deleteCardBtnTouchUpInsideHandler:(id)sender;
- (IBAction)goBack:(id)sender;

@end
