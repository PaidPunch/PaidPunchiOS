//
//  BalanceViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BalanceViewController.h"
#import "CreditCardSettingsViewController.h"
#import "ConfirmPaymentViewController.h"
#import "InviteFriendsViewController.h"
#import "Product.h"
#import "Products.h"
#import "User.h"

static CGFloat const kButtonWidth = 220;
static CGFloat const kButtonHeight = 43;
static CGFloat const kHorizontalSpacing = (stdiPhoneWidth - kButtonWidth)/2;
static CGFloat const kVerticalSpacing = 10;

@interface BalanceViewController ()
{
    BOOL _addCreditCardAlert;
}
@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createMainView:[UIColor blackColor]];
    
    [self createNavBar:@"Back" rightString:nil middle:@"My Balance" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    [self createSilverBackgroundWithImage];
    
    [self createWhiteNotificationBar:[NSString stringWithFormat:@"%@", [[User getInstance] getCreditAsString]]];
    
    // Create get free credit button
    UIButton* freeCreditButton = [self createButton:@"green-suggest-button" ypos:(_lowestYPos + kVerticalSpacing) btnText:@"Get FREE Credit" textColor:[UIColor whiteColor] action:@selector(didPressFreeCreditButton:)];
    [_mainView addSubview:freeCreditButton];
    _lowestYPos = freeCreditButton.frame.origin.y + freeCreditButton.frame.size.height;
    
    // Create Purchase Credit label
    UILabel* purchaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + kVerticalSpacing, stdiPhoneWidth, 20)];
    [purchaseLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    purchaseLabel.text = @"Purchase Credit";
    [purchaseLabel setBackgroundColor:[UIColor clearColor]];
    [purchaseLabel setTextAlignment:UITextAlignmentCenter];
    [_mainView addSubview:purchaseLabel];
    _lowestYPos = purchaseLabel.frame.origin.y + purchaseLabel.frame.size.height;
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([[Products getInstance] needsRefresh])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Retrieving Products";
        
        [[Products getInstance] retrieveProductsFromServer:self];
    }
    else
    {
        [self createProductButtons];
        if ([[User getInstance] needsRefresh])
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Retrieving User Info";
            [[User getInstance] getUserInfoFromServer:self];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private function

- (UIButton*)createButton:(NSString*)buttonName ypos:(CGFloat)ypos btnText:(NSString*)btnText textColor:(UIColor*)textColor action:(SEL)action
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:buttonName ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect newRect = CGRectMake(kHorizontalSpacing, ypos, kButtonWidth, kButtonHeight);
    
    newButton.frame = newRect;
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    [newButton setTitle:btnText forState:UIControlStateNormal];
    [newButton setTitleColor:textColor forState:UIControlStateNormal];
    newButton.titleLabel.font = textFont;
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return newButton;
}

- (void)createWhiteNotificationBar:(NSString*)barText
{
    UIFont* textFont = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
    
    // Green bar for notifications
    CGFloat whitebarLabelHeight = 50;
    _whitebarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos, stdiPhoneWidth, whitebarLabelHeight)];
    _whitebarLabel.backgroundColor = [UIColor whiteColor];
    _whitebarLabel.text = barText;
    _whitebarLabel.textColor = [UIColor colorWithRed:0.0f green:153.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    [_whitebarLabel setNumberOfLines:2];
    [_whitebarLabel setFont:textFont];
    _whitebarLabel.textAlignment = UITextAlignmentCenter;
    
    [_mainView addSubview:_whitebarLabel];
    
    _lowestYPos = whitebarLabelHeight + _whitebarLabel.frame.origin.y;
}

- (void) createProductButtons
{
    NSMutableArray* productsArray = [[Products getInstance] productsArray];
    NSUInteger productsCount = [productsArray count];
    const NSUInteger maxProductsCount = MAX(5, productsCount);
    NSUInteger index = 0;
    
    // Maximum of 5 products
    while (index < maxProductsCount)
    {
        SEL currentAction = nil;
        switch (index)
        {
            case 0:
                currentAction = @selector(creditBtn1TouchUpInsideHandler:);
                break;
                
            case 1:
                currentAction = @selector(creditBtn2TouchUpInsideHandler:);
                break;
                
            case 2:
                currentAction = @selector(creditBtn3TouchUpInsideHandler:);
                break;
                
            case 3:
                currentAction = @selector(creditBtn4TouchUpInsideHandler:);
                break;
                
            case 4:
                currentAction = @selector(creditBtn5TouchUpInsideHandler:);
                break;
                
            default:
                break;
        }
        
        Product* current = [productsArray objectAtIndex:index];
        UIButton* nextButton = [self createButton:@"grey-button" ypos:(_lowestYPos + kVerticalSpacing) btnText:[current name] textColor:[UIColor blackColor] action:currentAction];
        [_mainView addSubview:nextButton];
        _lowestYPos = nextButton.frame.origin.y + nextButton.frame.size.height;
        index++;
    }
}

- (void)handleCreditPurchase:(NSUInteger)index
{
    if ([[User getInstance] isPaymentProfileCreated])
    {
        ConfirmPaymentViewController *confirmPaymentViewController = [[ConfirmPaymentViewController alloc] init:index];
        [self.navigationController pushViewController:confirmPaymentViewController animated:YES];
    }
    else
    {
        _addCreditCardAlert = TRUE;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Credit Card"
                                                          message:@"You do not have a credit card registered with us, and cannot purchase additional credit until you do so. Please press OK to register a credit card."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:@"Cancel",nil];
        [message show];
    }
}

-(void) goToCreditCardSettingsView:(NSString *)maskedId
{
    CreditCardSettingsViewController *creditCardSettingsView = [[CreditCardSettingsViewController alloc] init:maskedId];
    [self.navigationController pushViewController:creditCardSettingsView animated:YES];
}

#pragma mark - event actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && _addCreditCardAlert)
    {
        [self goToCreditCardSettingsView:nil];
    }
    _addCreditCardAlert = FALSE;
}

- (void) didPressFreeCreditButton:(id)sender
{
    InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc] init:TRUE];
    [self.navigationController pushViewController:inviteFriendsViewController animated:NO];
}

- (IBAction)creditBtn1TouchUpInsideHandler:(id)sender
{
    [self handleCreditPurchase:0];
}

- (IBAction)creditBtn2TouchUpInsideHandler:(id)sender
{
    [self handleCreditPurchase:1];
}

- (IBAction)creditBtn3TouchUpInsideHandler:(id)sender
{
    [self handleCreditPurchase:2];
}

- (IBAction)creditBtn4TouchUpInsideHandler:(id)sender
{
    [self handleCreditPurchase:3];
}

- (IBAction)creditBtn5TouchUpInsideHandler:(id)sender
{
    [self handleCreditPurchase:4];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{    
    if (success)
    {
        if ([type compare:kKeyProductsRetrieve] == NSOrderedSame)
        {
            [self createProductButtons];
            if ([[User getInstance] needsRefresh])
            {
                _hud.labelText = @"Retrieving User Info";
                [[User getInstance] getUserInfoFromServer:self];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            }
        }
        else if ([type compare:kKeyProductsPurchase] == NSOrderedSame)
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Credit Updated"
                                                              message:@"Additional credit has been purchased and added to your account"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else if ([type compare:kKeyUsersGetInfo] == NSOrderedSame)
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            [_whitebarLabel setText:[[User getInstance] getCreditAsString]];
        }
        else
        {
            NSLog(@"Unknown http call in SettingsViewController");
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


@end
