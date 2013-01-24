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

+ (BOOL) validateEmail: (NSString *) emailId
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:emailId];
	return isValid;
}

+ (CGRect) resizeProportionally:(CGRect)originalFrame maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    CGRect newFrame = originalFrame;
    CGFloat originalWidth = originalFrame.size.width;
    CGFloat originalHeight = originalFrame.size.height;
    
    if (originalWidth > maxWidth)
    {
        newFrame.size.width = maxWidth;
        newFrame.size.height = maxWidth * (originalHeight/originalWidth);
    }
    
    if (newFrame.size.height > maxHeight)
    {
        newFrame.size.height = maxHeight;
        newFrame.size.width = maxHeight * (newFrame.size.width/originalHeight);
    }
    
    return newFrame;
}

@end
