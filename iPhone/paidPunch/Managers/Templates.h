//
//  InviteTemplates.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

@interface Templates : NSObject
{
    NSDate* _lastUpdate;
    
    // internal
    NSString* _createdVersion;
    
    // Templates
    NSMutableArray* _templatesArray;
    
    __weak NSObject<HttpCallbackDelegate>* facebookDelegate;
}
@property(nonatomic,strong) NSString* emailTemplate;
@property(nonatomic,strong) NSString* facebookTemplate;

- (BOOL) needsRefresh;
- (void) retrieveTemplatesFromServer:(NSObject<HttpCallbackDelegate>*) delegate;
- (NSString*) getTemplateByName:(NSString*)name;

+ (Templates*) getInstance;
+ (void) destroyInstance;

@end
