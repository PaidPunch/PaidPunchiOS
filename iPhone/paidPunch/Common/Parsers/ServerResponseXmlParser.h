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
    
    PunchCard *__weak punchCardDetails;
    
}

@property (nonatomic,strong) NSMutableString *currentValue;
@property (nonatomic,strong) NSString *statusCode;
@property (nonatomic,strong) NSString *statusMessage;
@property (nonatomic,strong) NSData *barcodeImage;
@property (nonatomic,strong) NSString *barcodeValue;
@property (nonatomic,weak) PunchCard *punchCardDetails;
@property (nonatomic,strong) NSString *maskedId;
@property (nonatomic,strong) NSString *paymentId;
@property (nonatomic,strong) NSString *offer;

- (BOOL) parse:(NSString*)responseXml; 
- (id)init;

@end
