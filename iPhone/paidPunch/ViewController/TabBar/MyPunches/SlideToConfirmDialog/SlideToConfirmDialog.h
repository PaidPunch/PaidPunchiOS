//
//  SlideToConfirmDialog.h
//  paidPunch
//
//  Created by mobimedia technologies on 16/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "PunchCard.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "PunchUsedViewController.h"
#import "InstructionsView.h"
#import "SlideToCancelViewController.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;
@interface SlideToConfirmDialog : UIViewController<NetworkManagerDelegate,SDWebImageManagerDelegate,SlideToCancelDelegate>
{
    NetworkManager *networkManager;
    SlideToCancelViewController *slideToCancel;
    

}
@property(nonatomic,strong) PunchCard *punchCardDetails;
@property (strong, nonatomic) IBOutlet UIImageView *businessLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *businessNameLbl;
//@property (retain, nonatomic) IBOutlet UILabel *punchLbl;
@property (strong, nonatomic) IBOutlet UILabel *valueLbl;
@property (strong, nonatomic) IBOutlet UILabel *purchaseLbl;
@property (strong, nonatomic) IBOutlet UISlider *slideToUnlock;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *showSlideLbl;
@property (strong, nonatomic) IBOutlet UIImageView *slideBgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (strong, nonatomic) NSString *mysteryoffer;
@property (strong, nonatomic) IBOutlet UIImageView *orangeStripImageView;

-(id)init:(PunchCard *)punchCard withMysteryOffer:(NSString *)mOffer;

- (IBAction)goBack:(id)sender;

/*-(IBAction)LockIt;
-(IBAction)fadeLabel;
-(IBAction)UnLockIt; */
-(void)lockSlider;
-(void)hideSlider;

- (void)doneWithInstructions;

-(void)goToPunchUsedView:(PunchCard *)punchCard barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;

-(void)markPunch;
-(void)showInstructionsView;

@end
