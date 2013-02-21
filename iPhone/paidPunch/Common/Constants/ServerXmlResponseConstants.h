//
//  ServerXmlResponseConstants.h
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerXmlResponseConstants : NSObject

extern NSString * const STATUS_CODE;
extern NSString * const STATUS_MESSAGE;
extern NSString * const USER_ID;
extern NSString * const EMAIL;
extern NSString * const MOBILE_NUMBER;
extern NSString * const NEW_PIN;
extern NSString * const ZIP_CODE;
extern NSString * const USERNAME;
extern NSString * const IS_PROFILE_CREATED;

extern NSString * const BUSINESS_ID;
extern NSString * const BUSINESS_NAME;
extern NSString * const BUSINESS_LOGO;
extern NSString * const BUSINESS_LOGO_URL;
extern NSString * const PUNCH_CARD_ID;
extern NSString * const PUNCH_CARD_NAME;
extern NSString * const PUNCH_CARD_DESC;
extern NSString * const PUNCH_CARD_CODE;
extern NSString * const TOTAL_NO_PUNCHES;
extern NSString * const EACH_PUNCH_VALUE;
extern NSString * const ACTUAL_PRICE;
extern NSString * const SELLING_PRICE;
extern NSString * const DISCOUNT;
extern NSString * const TOTAL_PUNCHES_USED;
extern NSString * const EXPIRY_DATE; 
extern NSString * const PUNCH_CARD_DOWNLOAD_ID;
extern NSString * const PUNCH_EXPIRE;
extern NSString * const DISCOUNT_VALUE_OF_EACH_PUNCH;
extern NSString * const IS_FREE_PUNCH;
extern NSString * const IS_MYSTERY_PUNCH;
extern NSString * const IS_MYSTERY_USED;
extern NSString * const MINIMUM_VALUE;
extern NSString * const NO_OF_EXPIRY_DAYS;
extern NSString * const REDEEM_TIME_DIFF;

extern NSString * const BARCODE_IMAGE;
extern NSString * const BARCODE_VALUE;

extern NSString * const MASKED_ID;
extern NSString * const PAYMENT_ID;

extern NSString * const OFFER;

extern NSString * const APP_IP_REQ;
extern NSString * const LOGIN_REQ;
extern NSString * const LOGOUT_REQ;
extern NSString * const SENDFEEDBACK_REQ;
extern NSString * const MARKPUNCHUSED_REQ;
extern NSString * const EMAILUPDATE_REQ;
extern NSString * const BUSINESSOFFER_REQ;
extern NSString * const BUYBUSSINESSOFFER_REQ;
extern NSString * const SEARCHBYBUSINESSNAME_REQ;
extern NSString * const GETUSERPUCNHCARD_REQ;
extern NSString * const VERIFICATION_REQ;
extern NSString * const FORGOT_PASSWORD_REQ;
extern NSString * const FB_LOGIN_REQ;
extern NSString * const GET_FEEDS_REQ;
extern NSString * const PROFILE_REQ;
extern NSString * const GET_PROFILE_REQ;
extern NSString * const MYSTERY_REQ;
extern NSString * const DELETE_PROFILE_REQ;

extern NSString * const SEARCH_BY_CURRENT_LOCATION;
extern NSString * const SEARCH_BY_CATEGORY;
extern NSString * const SEARCH_BY_NAME;
extern NSString * const SEARCH_BY_CITY;
extern NSString * const SEARCH_BY_ZIPCODE;
extern NSString * const SEARCH_BY_CITY_OR_ZIPCODE;

@end
