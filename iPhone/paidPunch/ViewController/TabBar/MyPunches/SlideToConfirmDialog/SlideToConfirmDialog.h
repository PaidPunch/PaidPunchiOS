//
//  SlideToConfirmDialog.h
//  paidPunch
//
//  Created by mobimedia technologies on 16/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "PunchUsedViewController.h"
#import "InstructionsView.h"
#import "SlideToCancelViewController.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;
@interface SlideToConfirmDialog : UIViewController<SDWebImageManagerDelegate,NetworkManagerDelegate,SlideToCancelDelegate>
{
    NetworkManager *networkManager;
    SlideToCancelViewController *slideToCancel;
    

}
@property(nonatomic,retain) PunchCard *punchCardDetails;
@property (retain, nonatomic) IBOutlet UIImageView *businessLogoImageView;
@property (retain, nonatomic) IBOutlet UILabel *businessNameLbl;
//@property (retain, nonatomic) IBOutlet UILabel *punchLbl;
@property (retain, nonatomic) IBOutlet UILabel *valueLbl;
@property (retain, nonatomic) IBOutlet UILabel *purchaseLbl;
@property (retain, nonatomic) IBOutlet UISlider *slideToUnlock;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *showSlideLbl;
@property (retain, nonatomic) IBOutlet UIImageView *slideBgImageView;
@property (retain, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (retain, nonatomic) NSString *mysteryoffer;
@property (retain, nonatomic) IBOutlet UIImageView *orangeStripImageView;

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
