//
//  NetworkManagerDelegate.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/6/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerDelegate <NSObject>
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
