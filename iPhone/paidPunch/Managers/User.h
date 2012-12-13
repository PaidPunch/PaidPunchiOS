//
//  User.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

@interface User : NSObject
{
    // internal
    NSString* _createdVersion;
    
    // User attributes
    NSString* _userId;
    NSString* _referralCode;
    NSString* _username;
    NSString* _email;
    NSString* _password;
    NSString* _zipcode;
    NSString* _phone;
}
@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* referralCode;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,strong) NSString* zipcode;
@property(nonatomic,strong) NSString* phone;

- (void) registerUser:(NSObject<HttpCallbackDelegate>*) delegate;

+ (User*) getInstance;
+ (void) destroyInstance;

@end
