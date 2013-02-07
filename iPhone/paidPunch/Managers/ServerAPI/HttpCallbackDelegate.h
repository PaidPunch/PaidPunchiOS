//
//  HttpCallbackDelegate.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpCallbackDelegate <NSObject>
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message;
@end
