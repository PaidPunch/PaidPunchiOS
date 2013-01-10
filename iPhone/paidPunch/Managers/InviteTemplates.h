//
//  InviteTemplates.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

@interface InviteTemplates : NSObject
{
    NSDate* _lastUpdate;
    
    // internal
    NSString* _createdVersion;
    
    // Templates
    NSString* _emailTemplate;
    NSString* _facebookTemplate;
    
    __weak NSObject<HttpCallbackDelegate>* facebookDelegate;
}
@property(nonatomic,strong) NSString* emailTemplate;
@property(nonatomic,strong) NSString* facebookTemplate;

- (BOOL) needsRefresh;
- (void) retrieveTemplatesFromServer:(NSObject<HttpCallbackDelegate>*) delegate;

+ (InviteTemplates*) getInstance;
+ (void) destroyInstance;

@end
