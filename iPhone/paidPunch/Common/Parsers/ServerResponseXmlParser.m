//
//  ServerResponseXmlParser.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "ServerResponseXmlParser.h"

@implementation ServerResponseXmlParser

// Synthesize our properties
@synthesize currentValue;
@synthesize statusCode;
@synthesize statusMessage;
@synthesize punchCardDetails;
@synthesize barcodeImage;
@synthesize barcodeValue;
@synthesize maskedId;
@synthesize paymentId;
@synthesize offer;

-(id)init
{
    if ((self=[super init]))
    {
    }
    return self ;
}

#pragma mark -
#pragma mark Cleanup

-(void)dealloc{
    NSLog(@"In dealloc of ServerResponseXmlParser");
    
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods Implementation

// This method gets called every time NSXMLParser encounters a new element
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    // If element is named "item", set bool to true so we know
    // we are inside the element in other methods. This is needed
    // because "item" contains most of the data we need
    
    if ([elementName isEqualToString:BUSINESS_ID])
	{
        punchCardDetails=[[DatabaseManager sharedInstance] getPunchCardObject];
        [punchCardDetails setValue:[NSNumber numberWithBool:NO] forKey:@"flag"];
    }
    if([elementName isEqualToString:@"punchcardlist"])
    {
        //punchList=[[NSMutableArray alloc] init];
    }
}

// This method gets called for every character NSXMLParser finds.
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (!currentValue) {
		currentValue = [[NSMutableString alloc] init];
    }
    
    [currentValue appendString:string];
}

// This method is called whenever NSXMLParser reaches the end of an element
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSLog(@"The element Name %@",elementName);
	NSLog(@"value %@",currentValue);
	NSString *newCurrentValue;
	if (currentValue==nil)
	{
        newCurrentValue= @"";
	}
	else
	{
		newCurrentValue = [[NSString alloc] initWithString:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	
    //chking for root element
    if ([elementName isEqualToString:STATUS_CODE])
    {
        self.statusCode=newCurrentValue;
    }
    if ([elementName isEqualToString:STATUS_MESSAGE])
    {
        self.statusMessage=newCurrentValue;
    }
    if([elementName isEqualToString:BUSINESS_ID])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"business_id"];
    }
    if([elementName isEqualToString:BUSINESS_NAME])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"business_name"];
    }
    if([elementName isEqualToString:PUNCH_CARD_ID])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"punch_card_id"];
    }
    if([elementName isEqualToString:PUNCH_CARD_NAME])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"punch_card_name"];
    }
    if([elementName isEqualToString:PUNCH_CARD_CODE])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"code"];
    }
    if([elementName isEqualToString:PUNCH_CARD_DESC])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"punch_card_desc"];
    }
    if([elementName isEqualToString:REDEEM_TIME_DIFF])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"redeem_time_diff"];
    }
    if([elementName isEqualToString:TOTAL_NO_PUNCHES])
    {
        [punchCardDetails setValue:[NSNumber numberWithInt:[newCurrentValue doubleValue]] forKey:@"total_punches"];
    }
    if([elementName isEqualToString:TOTAL_PUNCHES_USED])
    {
        [punchCardDetails setValue:[NSNumber numberWithInt:[newCurrentValue doubleValue]] forKey:@"total_punches_used"];
    }
    if([elementName isEqualToString:EACH_PUNCH_VALUE])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"each_punch_value"];
    }
    if([elementName isEqualToString:ACTUAL_PRICE])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"actual_price"];
    }
    if([elementName isEqualToString:SELLING_PRICE])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"selling_price"];
    }
    if([elementName isEqualToString:DISCOUNT])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"discount"];
    }
    if([elementName isEqualToString:DISCOUNT_VALUE_OF_EACH_PUNCH])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"discount_value_of_each_punch"];
    }
    if([elementName isEqualToString:MINIMUM_VALUE])
    {
        [punchCardDetails setValue:[NSNumber numberWithDouble:[newCurrentValue doubleValue]] forKey:@"minimum_value"];
    }
    if([elementName isEqualToString:NO_OF_EXPIRY_DAYS])
    {
        [punchCardDetails setValue:[NSNumber numberWithInt:[newCurrentValue intValue]] forKey:@"expire_days"];
    }
    
    if([elementName isEqualToString:EXPIRY_DATE])
    {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy"];
        [punchCardDetails setValue:[df dateFromString:newCurrentValue] forKey:@"expiry_date"];
    }
    if([elementName isEqualToString:BUSINESS_LOGO])
    {
        //business_logo_url 
        //business_logo_img
        if([newCurrentValue rangeOfString:@"https://"].location == NSNotFound)
        {
            //NSData *b64DecData = [Base64 decode:newCurrentValue];
            //[punchCardDetails setValue:b64DecData forKey:@"business_logo_img"];
        }
        else
        {
            NSString *urlString=[newCurrentValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //[punchCardDetails setValue:newCurrentValue forKey:@"business_logo_url"];
            [punchCardDetails setValue:urlString forKey:@"business_logo_url"];
        }
    }
    if([elementName isEqualToString:BUSINESS_LOGO_URL])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"business_logo_url"];
    }
    if([elementName isEqualToString:PUNCH_CARD_DOWNLOAD_ID])
    {
        [punchCardDetails setValue:newCurrentValue forKey:@"punch_card_download_id"];
    }
    if([elementName isEqualToString:PUNCH_EXPIRE])
    {
        if([newCurrentValue isEqualToString:@"true"])
            [punchCardDetails setValue:[NSNumber numberWithBool:YES] forKey:@"punch_expire"];
        else
            [punchCardDetails setValue:[NSNumber numberWithBool:NO] forKey:@"punch_expire"];
    }
    if([elementName isEqualToString:IS_FREE_PUNCH])
    {
        if([newCurrentValue isEqualToString:@"true"])
            [punchCardDetails setValue:[NSNumber numberWithBool:YES] forKey:@"is_free_punch"];
        else
            [punchCardDetails setValue:[NSNumber numberWithBool:NO] forKey:@"is_free_punch"];
    }
    if([elementName isEqualToString:IS_MYSTERY_USED])
    {
        if([newCurrentValue isEqualToString:@"true"])
        {
            [punchCardDetails setValue:[NSNumber numberWithBool:YES] forKey:@"is_mystery_used"];
            if([punchCardDetails.is_mystery_punch intValue]==1)
            {
                if([punchCardDetails.total_punches intValue]-[punchCardDetails.total_punches_used intValue]==1)
                {
                    punchCardDetails.total_punches=[NSNumber numberWithInt:[punchCardDetails.total_punches intValue]-1];
                }
            }
        }
        else
        {
            [punchCardDetails setValue:[NSNumber numberWithBool:NO] forKey:@"is_mystery_used"];
        }
    }
    if([elementName isEqualToString:IS_MYSTERY_PUNCH])
    {
        if([newCurrentValue isEqualToString:@"true"])
        {
            [punchCardDetails setValue:[NSNumber numberWithBool:YES] forKey:@"is_mystery_punch"];
            // TODO: Do not add mystery punches to total_punches
            //punchCardDetails.total_punches=[NSNumber numberWithInt:[punchCardDetails.total_punches intValue]+1];
        }
        else
            [punchCardDetails setValue:[NSNumber numberWithBool:NO] forKey:@"is_mystery_punch"];
    }
    if([elementName isEqualToString:@"punchcard"])
    {
        [punchCardDetails setValue:[NSNumber numberWithBool:YES] forKey:@"flag"];
    }
    if([elementName isEqualToString:MASKED_ID])
    {
        self.maskedId=newCurrentValue;
    }
    if([elementName isEqualToString:PAYMENT_ID])
    {
        self.paymentId=newCurrentValue;
    }
    if([elementName isEqualToString:BARCODE_IMAGE])
    {
        NSData *b64DecData = [Base64 decode:newCurrentValue];
        self.barcodeImage=b64DecData;
    }
    if([elementName isEqualToString:BARCODE_VALUE])
    {
        self.barcodeValue=newCurrentValue;
    }
    if([elementName isEqualToString:OFFER])
    {
        self.offer=newCurrentValue;
    }
	//releasing variables
	newCurrentValue =nil;
	currentValue = nil;
}

- (BOOL)parse:(NSString *)responseXml{
	
	//NSLog(@"Start parsing................................. ");
	//NSLog(@"----%@",responseXml);
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[responseXml dataUsingEncoding:NSUTF8StringEncoding]];
	
    //Tell NSXMLParser that this class is its delegate
    [parser setDelegate:self];
    // Kick off file parsing
    [parser parse];
	[parser setDelegate:nil];
    return TRUE;
}
@end
