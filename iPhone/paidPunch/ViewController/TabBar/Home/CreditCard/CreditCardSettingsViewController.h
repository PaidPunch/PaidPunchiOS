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

@property (strong, nonatomic) IBOutlet UIButton *deleteCardBtn;
@property (strong, nonatomic) IBOutlet UIButton *addCardBtn;
@property (strong, nonatomic) IBOutlet UILabel *cardMaskedCodeLbl;
@property (strong, nonatomic) IBOutlet UILabel *linkAddCardLbl;
@property (strong, nonatomic) IBOutlet UIImageView *creditCardPinImageView;
@property (nonatomic,strong) NSString *maskedId;

- (id)init:(NSString *)creditCardMaskedId;
- (void)setUpUI;
- (void)goToAddCardView;

- (IBAction)addCardBtnTouchUpInsideHandler:(id)sender;
- (IBAction)deleteCardBtnTouchUpInsideHandler:(id)sender;
- (IBAction)goBack:(id)sender;

@end
