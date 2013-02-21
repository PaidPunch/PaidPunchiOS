//
//  ServerXmlResponseConstants.m
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "ServerXmlResponseConstants.h"

@implementation ServerXmlResponseConstants

NSString * const STATUS_CODE=@"statusCode";
NSString * const STATUS_MESSAGE=@"statusMessage";
NSString * const USER_ID=@"userid";
NSString * const EMAIL=@"email";
NSString * const MOBILE_NUMBER=@"mobilenumber";
NSString * const NEW_PIN=@"newpin";
NSString * const ZIP_CODE=@"pin";
NSString * const USERNAME=@"name";
NSString * const IS_PROFILE_CREATED=@"is_profileid_created";

NSString * const BUSINESS_ID=@"bussinessid";
NSString * const BUSINESS_NAME=@"bussinessname";
NSString * const BUSINESS_LOGO=@"bussinesslogo";
NSString * const BUSINESS_LOGO_URL=@"bussinesslogo_url";
NSString * const PUNCH_CARD_ID=@"punchcardid";
NSString * const PUNCH_CARD_NAME=@"punchcardname";
NSString * const PUNCH_CARD_DESC=@"pucnchcarddesc";
NSString * const PUNCH_CARD_CODE=@"punchcard_code";
NSString * const TOTAL_NO_PUNCHES=@"totalnoofpunches";
NSString * const EACH_PUNCH_VALUE=@"eachpunchvalue";
NSString * const ACTUAL_PRICE=@"actualprice";
NSString * const SELLING_PRICE=@"sellingprice";
NSString * const DISCOUNT=@"discount";
NSString * const TOTAL_PUNCHES_USED=@"totalpunchesused";
NSString * const EXPIRY_DATE=@"expiredate"; 
NSString * const PUNCH_CARD_DOWNLOAD_ID=@"punch_card_downloadid";
NSString * const PUNCH_EXPIRE=@"punchexpire";
NSString * const DISCOUNT_VALUE_OF_EACH_PUNCH=@"discount_value_of_each_punch";
NSString * const IS_FREE_PUNCH=@"isfreepunch";
NSString * const IS_MYSTERY_PUNCH=@"is_mystery_punch";
NSString * const IS_MYSTERY_USED=@"mystery_punch_used";
NSString * const MINIMUM_VALUE=@"minimum_value";
NSString * const NO_OF_EXPIRY_DAYS=@"expire_days";
NSString * const REDEEM_TIME_DIFF=@"redeem_time_diff";


NSString * const BARCODE_IMAGE=@"barcodeimage";
NSString * const BARCODE_VALUE=@"barcodevalue";

NSString * const MASKED_ID=@"masked";
NSString * const PAYMENT_ID=@"paymentid";

NSString * const OFFER=@"offer";

//request types
NSString * const APP_IP_REQ=@"APP-IP-REQ";
NSString * const LOGIN_REQ=@"LOGIN-REQ";
NSString * const LOGOUT_REQ=@"LOGOUT-REQ";
NSString * const SENDFEEDBACK_REQ=@"SENDFEEDBACK-REQ";
NSString * const MARKPUNCHUSED_REQ=@"MARKPUNCHUSED-REQ";
NSString * const EMAILUPDATE_REQ=@"EMAILUPDATE-REQ";
NSString * const BUYBUSSINESSOFFER_REQ=@"BUYBUSSINESSOFFER-REQ";
NSString * const BUSINESSOFFER_REQ=@"BUSSINESSOFFER-REQ";
NSString * const SEARCHBYBUSINESSNAME_REQ=@"SEARCHBYBUSINESSNAME-REQ";
NSString * const GETUSERPUCNHCARD_REQ=@"GETUSERPUCNHCARD-REQ";
NSString * const VERIFICATION_REQ=@"VERIFICATION-REQ";
NSString * const FORGOT_PASSWORD_REQ=@"FORGOT-PASSWORD-REQ";
NSString * const FB_LOGIN_REQ=@"FB-LOGIN-REQ";
NSString * const GET_FEEDS_REQ=@"FEEDS-REQ";
NSString * const PROFILE_REQ=@"profile-REQ";
NSString * const GET_PROFILE_REQ=@"Get-Profile-REQ";
NSString * const MYSTERY_REQ=@"Mystery-REQ";
NSString * const DELETE_PROFILE_REQ=@"Delete-Profile-REQ";

NSString * const SEARCH_BY_CURRENT_LOCATION=@"search-by-current-location";
NSString * const SEARCH_BY_CATEGORY=@"search-by-category";
NSString * const SEARCH_BY_NAME=@"search-by-name";
NSString * const SEARCH_BY_CITY=@"search-by-city";
NSString * const SEARCH_BY_ZIPCODE=@"search-by-zipcode";
NSString * const SEARCH_BY_CITY_OR_ZIPCODE=@"search-by-city-or-zipcode";


@end
