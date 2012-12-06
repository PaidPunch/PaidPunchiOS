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
@property (strong, nonatomic) IBOutlet UIWebView *contentsWebView;

@property(nonatomic,strong)PunchCard *punchCardDetails;
@property (strong, nonatomic) IBOutlet UILabel *offerLbl;

@property (strong, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (nonatomic,strong) NSData *barcodeImageData;
@property (nonatomic,strong) NSString *barcodeValue;

@property (strong, nonatomic) IBOutlet UIImageView *businessLogoImageView;

@property (strong, nonatomic) IBOutlet UILabel *businessNameLbl;

@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalMinsLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalSecsLbl;
@property (strong, nonatomic) IBOutlet UILabel *secLbl;
@property (strong, nonatomic) IBOutlet UILabel *minLbl;
@property (strong, nonatomic) NSDate *lastRefreshTime;

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
