//
//  ServerResponseXmlParser.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerXmlResponseConstants.h"
#import "InfoExpert.h"
#import "PunchCard.h"
#import "DatabaseManager.h"
#import "Base64.h"

@interface ServerResponseXmlParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentValue; //This will hold element values as we build them piece by piece
    
    NSString *statusCode;
    NSString *statusMessage;
    
    NSData *barcodeImage;
    NSString *barcodeValue;
    
    NSString *maskedId;
    NSString *paymentId;
    
    NSString *offer;
    
    PunchCard *punchCardDetails;
    
}

@property (nonatomic,retain) NSMutableString *currentValue;
@property (nonatomic,retain) NSString *statusCode;
@property (nonatomic,retain) NSString *statusMessage;
@property (nonatomic,retain) NSData *barcodeImage;
@property (nonatomic,retain) NSString *barcodeValue;
@property (nonatomic,assign) PunchCard *punchCardDetails;
@property (nonatomic,retain) NSString *maskedId;
@property (nonatomic,retain) NSString *paymentId;
@property (nonatomic,retain) NSString *offer;

- (BOOL) parse:(NSString*)responseXml; 
- (id)init;

@end
