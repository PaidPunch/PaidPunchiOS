//
//  Utilities.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/12/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface Utilities : NSObject

+ (NSString*) getStatusMessageFromResponse:(AFHTTPRequestOperation*)operation;
+ (BOOL) validateEmail: (NSString *) emailId;

@end
