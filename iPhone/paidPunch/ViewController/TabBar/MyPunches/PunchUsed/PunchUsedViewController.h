//
//  PunchUsedViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "FBDialog.h"
#import "FBRequest.h"
#import "Reachability.h"

@interface PunchUsedViewController : UIViewController<UIAlertViewDelegate,FBRequestDelegate,FBDialogDelegate>
{
    PunchCard *punchCardDetails;
    NSTimer *timer;
    int seconds;
    int minutes;
    int cnt;
    CGFloat initialScreenBrightness;
}
@property (retain, nonatomic) IBOutlet UIWebView *contentsWebView;

@property(nonatomic,retain)PunchCard *punchCardDetails;
@property (retain, nonatomic) IBOutlet UILabel *offerLbl;

@property (retain, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (nonatomic,retain) NSData *barcodeImageData;
@property (nonatomic,retain) NSString *barcodeValue;

@property (retain, nonatomic) IBOutlet UIImageView *businessLogoImageView;

@property (retain, nonatomic) IBOutlet UILabel *businessNameLbl;

@property (retain, nonatomic) IBOutlet UILabel *timeLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalMinsLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalSecsLbl;
@property (retain, nonatomic) IBOutlet UILabel *secLbl;
@property (retain, nonatomic) IBOutlet UILabel *minLbl;
@property (retain, nonatomic) NSDate *lastRefreshTime;

- (id)init:(PunchCard *)punchCard barcodeImageData:(NSData *)imageData barcodeValue:(NSString *)bValue;
- (void)setUpUI;
- (void)gotoRootView;
- (IBAction)doneBtnTouchUpInsideHandler:(id)sender;
- (IBAction)shareToFaceBtnTouchUpInsideHandler:(id)sender;
- (void)shareOnFacebook; 
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt; 
- (void)apiPromptPostToWallPermissions; 
- (void)loggedIn;
@end
