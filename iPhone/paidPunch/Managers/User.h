//
//  User.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookPaidPunchDelegate.h"
#import "FBRequest.h"
#import "HttpCallbackDelegate.h"

static NSString* const kUser_EmailRegistration = @"User_EmailRegistration";
static NSString* const kUser_FacebookRegistration = @"User_FacebookRegistration";

typedef enum
{
    no_call,
    register_call,
    login_call
} CallType;

@interface User : NSObject<FBRequestDelegate, FacebookPaidPunchDelegate>
{
    // internal
    NSString* _createdVersion;
    
    // User attributes
    NSString* _userId;
    NSString* _facebookId;
    NSString* _referralCode;
    NSString* _username;
    NSString* _email;
    NSString* _zipcode;
    NSString* _phone;
    NSString* _uniqueId;
    BOOL _isUserValidated;
    BOOL _isPaymentProfileCreated;
    NSNumber* _totalMiles;
    NSDecimalNumber* _credits;
    NSString* _maskedId;
    
    __weak NSObject<HttpCallbackDelegate>* facebookDelegate;
    
    CallType _callType;
    
    
}
@property(nonatomic,strong) NSString* userId;
@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* referralCode;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* zipcode;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,strong) NSString* uniqueId;
@property(nonatomic,strong) NSString* userCode;
@property(nonatomic,strong) NSString* maskedId;
@property(nonatomic) BOOL isUserValidated;
@property(nonatomic) BOOL isPaymentProfileCreated;
@property(nonatomic) NSNumber* totalMiles;

- (void) clearUser;
- (void) saveUserData;
- (void)updateFacebookFeed:(NSString*)message;
- (void) registerUserWithEmail:(NSObject<HttpCallbackDelegate>*)delegate password:(NSString*)password;
- (void) registerUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate;
- (void) loginUserWithEmail:(NSObject<HttpCallbackDelegate>*)delegate password:(NSString*)password;
- (void) loginUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate;
- (void) changePassword:(NSObject<HttpCallbackDelegate>*)delegate oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword;
- (void) changeInfo:(NSObject<HttpCallbackDelegate>*)delegate parameters:(NSMutableDictionary*)parameters;
- (void) getUserProfileInfo;
- (BOOL) isFacebookProfile;
- (NSString*) getCreditAsString;

+ (User*) getInstance;
+ (void) destroyInstance;

@end
