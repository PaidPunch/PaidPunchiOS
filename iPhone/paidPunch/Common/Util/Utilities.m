//
//  Utilities.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/12/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "AFJSONUtilities.h"
#import "Utilities.h"

@implementation Utilities

+ (NSString*) getStatusMessageFromResponse:(AFHTTPRequestOperation*)operation
{
    NSData *responseData = operation.responseData;
    NSError *error = nil;
    id responseJSON = AFJSONDecode(responseData, &error);
    return [responseJSON valueForKeyPath:@"statusMessage"];
}

@end
