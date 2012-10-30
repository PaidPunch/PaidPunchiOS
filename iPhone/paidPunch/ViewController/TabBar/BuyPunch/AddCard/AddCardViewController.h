//
//  AddCardViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmPaymentViewController.h"
#import "NetworkManager.h"
#import "AddCardViewCell.h"
#import "InfoExpert.h"
#import "PunchCard.h"
#import "HomeViewController.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface AddCardViewController : UIViewController<NetworkManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NetworkManager *networkManager;
    
    NSString *name;
    NSString *email;
    NSString *cardNumber;
    NSString *expDate;
    NSString *cvv;
    
    UIPickerView *pickerView;
	NSMutableArray *pickerDataSource;
	UIActionSheet *actionSheet;
    int selectedYear;
    int selectedMonth;
    
    UIToolbar *numberToolBar;
}
@property (retain, nonatomic) IBOutlet UITableView *addCardDetailsTableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *secureNetworkLbl;
@property (retain, nonatomic) IBOutlet UITableView *cardDetailsTableView;
@property (nonatomic,retain) PunchCard *punchCardDetails;
@property(nonatomic,retain)NSMutableArray *monthsDataSource;
@property(nonatomic,retain)NSMutableArray *yearsDataSource;

- (id)init:(PunchCard *)punchCard;
- (void)goToConfirmPaymentView:(NSString *)paymentId withMaskedId:(NSString *)maskedId;

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;

- (IBAction)goBack:(id)sender;

- (BOOL)validate;
- (void)dismissKeyboard;
- (void)populateFields;
- (BOOL)validateEmail:(NSString *)emailId;
- (BOOL)validateCard:(NSString *)ccNumberString;
- (void)showPickerView;
- (void)cancelNumberPad;
- (void)doneWithNumberPad;

@end
