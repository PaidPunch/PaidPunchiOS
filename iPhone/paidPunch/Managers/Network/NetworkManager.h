//
//  NetworkManager.h
//  
//
//  This handles communication with the server.Also it handles sending and receiving of http requests.
//
//  Created by mobimedia technologies on 13/07/11.
//  Copyright 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerResponseXmlParser.h"
#import "Registration.h"
#import "AppDelegate.h"
#import "PunchCard.h"
#import "SBJSON.h"
#import "Business.h"
#import "NSString+HTML.h"
#import "MBProgressHUD.h"

@class ServerResponseXmlParser;

//custom delegate
@protocol NetworkManagerDelegate<NSObject>

@optional
-(void) didFinishLoadingAppURL:(NSString *)url;
-(void) didFinishSigningUp:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishLogin:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishWithFacebookLogin:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishLoggingOut:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishSendingFeedback:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard;
-(void) didFinishMarkingPunchUsed:(NSString *)statusCode statusMessage:(NSString *)message barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
-(void) didFinishUpdate:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishChangingPassword:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishBuying:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishSearchByName:(NSString*)statusCode;
-(void) didFinishGetUsersPunch:(NSString*)statusCode;
-(void) didFinishSendingForgotPasswordRequest:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishLoadingFeeds:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishCreatingProfile:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didFinishGettingProfile:(NSString *)statusCode statusMessage:(NSString *)message withMaskedId:(NSString *)maskedId withPaymentId:(NSString *)paymentId;
-(void) didFinishGettingMysteryOffer:(NSString *)statusCode statusMessage:(NSString *)message withOffer:(NSString *)offer;
-(void) didFinishDeletingProfile:(NSString *)statusCode statusMessage:(NSString *)message;
-(void) didConnectionFailed :(NSString *)responseStatus;

@end

@interface NetworkManager : NSObject {
    
	NSMutableData *webData;

	id <NetworkManagerDelegate> delegate;
    NSString *requestType;
    NSString *uniqueID;
    ServerResponseXmlParser *xmlParser;
    MBProgressHUD *popupHUD;
}

//@property(nonatomic,retain) IBOutlet UIView *activity;
@property(nonatomic,strong) IBOutlet UIView *view;
@property(nonatomic,strong) NSString *requestType;

@property(nonatomic,strong) id <NetworkManagerDelegate> delegate;
@property(nonatomic,strong) NSMutableData *webData;

@property(nonatomic,strong) ServerResponseXmlParser *xmlParser;

-(id) initWithView:(UIView *)parentView;

-(void) appIpRequest;
-(void) getMysteryOffer:(NSString *)userId withPunchCardId:(NSString *)punchId withPunchCardDownloadId:(NSString *)punchCardDownloadId;
-(void) getProfileRequest:(NSString *)userId withName:(NSString *)name;
-(void) createProfile:(NSString *)name withUserID:(NSString *)userId withEmail:(NSString *)email withExpDate:(NSString *)expDate withCVV:(NSString *)cvv withCardNo:(NSString *)cardNo;
-(void) fbLogin:(NSString*)username withEmailId:(NSString *)email withFBId:(NSString *)fbid;
-(void) login:(NSString*)username loginPassword:(NSString *)password;
-(void) logout:(NSString *)userid;
-(void) signUp:(Registration *)registrationDetails;
-(void) sendFeedBack:(NSString*)feedback loggedInUserId:(NSString *)userID;
-(void) markPunchUsed:(NSString *)punchCardId punchCardDownloadId:(NSString *)downloadId loggedInUserId:(NSString *)userID isMysteryPunch:(BOOL)isMystery isPunchExpired:(BOOL)punchExpired;
-(void) update:(NSString *)email withMobileNumber:(NSString *)mobileNo loggedInUserId:(NSString *)userID;
-(void) changePassword:(NSString *)oldPassword newPassword:(NSString*)password loggedInUserId:(NSString *)userID;
-(void) getBusinessOffer:(NSString*)scannedQrCode loggedInUserId:(NSString *)userID;
-(void) buy:(NSString*)scannedQrCode loggedInUserId:(NSString *)userID punchCardId:(NSString *)pid orangeQrCodeScanned:(NSString *)orangeCode isFreePunch:(BOOL)unlockedFreePunch withTransactionId:(NSString*)tid withAmount:(NSNumber *)amount withPaymentId:(NSString *)paymentId;
-(void) searchByName:(NSString *)business_name loggedInUserId:(NSString *)userID; 
-(void) getUserPunches:(NSString *)userId;
-(void) forgotPassword:(NSString *)emailId;
-(void) loadFeeds:(NSString *)fbid withFriendsList:(NSDictionary *)dict;
-(void) deleteProfile;

-(NSString *)getUniqueId;

-(void) showPopup;
-(void) removePopup;

-(void) goToDualSignInView;

@end


