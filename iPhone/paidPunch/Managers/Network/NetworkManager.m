//
//  NetworkManager.m
//  
//
//  Created by mobimedia technologies on 13/07/11.
//  Copyright 2011 mobimedia. All rights reserved.
//

#import "AFClientManager.h"
#import "NetworkManager.h"

@implementation NetworkManager

@synthesize delegate;
@synthesize webData;
//@synthesize activity;
@synthesize view;
@synthesize requestType;
@synthesize xmlParser;

-(id) init
{
	if ((self=[super init]))
	{
		xmlParser=[[ServerResponseXmlParser alloc] init];
        popupHUD = NULL;
        uniqueID = nil;
	}
	return self;
}

-(id) initWithView:(UIView *)parentView{
	
	if ((self=[super init]))
	{
        self.view = parentView;
		xmlParser=[[ServerResponseXmlParser alloc]init];
        popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:popupHUD];
        uniqueID = nil;
	}
	return self;	
}

#pragma mark -
#pragma mark Cleanup

-(void)dealloc{
	if(self.webData)
    ;
    uniqueID = nil;
     NSLog(@"In dealloc of NetworkManager");
}

#pragma mark -


#pragma mark -
#pragma mark Request For AppIp

-(void) appIpRequest{
    
    self.requestType=APP_IP_REQ;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"AppIPURL", @"")]]];  
    [request setHTTPMethod:@"GET"];      
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in appIpRequest!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Delete Profile

/*
 <https://192.168.1.55:8443/paid_punch/payment_detail>
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <userid>31</userid>
    <txtype>Delete-Profile-REQ</txtype>
    <sessionid>354043045839414</sessionid>
 </paidpunch-req>


 <?xml version='1.0' ?>
 <paidpunch-resp>
    <statusCode>00</statusCode>
    <statusMessage>Successful.</statusMessage>
    <is_profileid_created>false</is_profileid_created>
 </paidpunch-resp>

*/
-(void)deleteProfile
{
    self.requestType=DELETE_PROFILE_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",DELETE_PROFILE_REQ,[[User getInstance] userId], [[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"DeleteProfileUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in deleteProfile!");
    }
    [self showPopup];

}

#pragma mark -
#pragma mark Request For Mystery Offer

/*<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <userid>41</userid>
    <txtype>Mystery-REQ</txtype>
    <sessionid>354043045839414</sessionid>
    <punchcardid>9</punchcardid>
    <punch_card_downloadid>76</punch_card_downloadid>
</paidpunch-req>

response

<?xml version="1.0" encoding="UTF-8" standalone="no"?>
 <paidpunch-resp>
    <statusCode>00</statusCode>
    <statusMessage>successfully</statusMessage>
    <offer>coke</offer>
 </paidpunch-resp>
*/

-(void)getMysteryOffer:(NSString *)userId withPunchCardId:(NSString *)punchId withPunchCardDownloadId:(NSString *)punchCardDownloadId
{
    self.requestType=MYSTERY_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><punchcardid>%@</punchcardid><punch_card_downloadid>%@</punch_card_downloadid><sessionid>%@</sessionid></paidpunch-req>",MYSTERY_REQ,userId,punchId,punchCardDownloadId,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"MysteryPunchUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in getMysteryOffer!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Get Users Profile

/*
 <https://192.168.1.55:8443/paid_punch/payment_detail>
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <name>vishal@gmail.com</name>
    <userid>34</userid>
    <txtype>Get-Profile-REQ</txtype>
    <sessionid>356812046238562</sessionid>
 </paidpunch-req>
 
 response
 
 <?xml version='1.0' ?>
 <paidpunch-resp>
    <statusCode>00</statusCode>
    <masked>XXXX1352</masked>
    <paymentid>6034765</paymentid>
    <statusMessage>Successful</statusMessage>
 </paidpunch-resp>
 */


-(void)getProfileRequest:(NSString *)userId withName:(NSString *)name
{
    self.requestType=GET_PROFILE_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><name>%@</name><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",GET_PROFILE_REQ,name,userId,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:NSLocalizedString(@"ProfileCreationUrl", @"")]]];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"ProfileCreationUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in getProfileRequest!");
    }
    [self showPopup];

}

#pragma mark -
#pragma mark Request For Users Profile Creation
/*
 ----------------Profile Creation Request------------
 https://192.168.1.28:8443/paid_punch/payment_detail
 <?xmlversion=”1.0” Unicode=”UTF-08”?>
 <paidpunch-req>
    <txtype>profile-REQ </txtype>
    <userid>9</userid><!--- mandatory-->
    <name>vishal</name><!--- mandatory-->
    <email>vishal@paidpunch.in</email ><!--- mandatory-->
    <cardno>123456789</ cardno ><!--- mandatory-->
    <exp_date>mm-dd-yyyy</exp_date><!--- mandatory-->
    <cvv>420</cvv><!--- mandatory-->
 </paidpunch-req>
*/
-(void) createProfile:(NSString *)name withUserID:(NSString *)userId withEmail:(NSString *)email withExpDate:(NSString *)expDate withCVV:(NSString *)cvv withCardNo:(NSString *)cardNo
{
    self.requestType=PROFILE_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><name>%@</name><email>%@</email ><userid>%@</userid><cardno>%@</cardno><exp_date>%@</exp_date><cvv>%@</cvv><sessionid>%@</sessionid></paidpunch-req>",PROFILE_REQ,name,email,userId,cardNo,expDate,cvv,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:NSLocalizedString(@"ProfileCreationUrl", @"")]]];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"ProfileCreationUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in createProfile!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Users Profile Creation
/*
 ---------------FBLogin-------------------
 http://localhost:8080/paid_punch/FB_login
 <?xml version='1.0' encoding='UTF-8' standalone='yes'?>
 <paidpunch-req>
    <txtype> FB-LOGIN-REQ </txtype>
    <name>john  Whyte</ name ><!--- mandatory-->	
    <email>john@gmail.com</email ><!--- mandatory-->
    <FBid>9890232323</FBid><!--- mandatory-->
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/

-(void) fbLogin:(NSString*)username withEmailId:(NSString *)email withFBId:(NSString *)fbid
{    
    self.requestType=FB_LOGIN_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><name>%@</name><email>%@</email ><FBid>%@</FBid><sessionid>%@</sessionid></paidpunch-req>",FB_LOGIN_REQ,username,email,fbid,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"FBLoginUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in fbLogin!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Loading Users Feeds
/*
 ---------------Feeds Request-------------------
 <?xmlversion=”1.0” Unicode=”UTF-08”?>
 <paidpunch-req>
    <txtype> FEEDS-REQ </txtype>
    <FBid>2323</FBid>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) loadFeeds:(NSString *)fbid withFriendsList:(NSDictionary *)dict
{
    self.requestType=GET_FEEDS_REQ;
    SBJSON *jsonWriter = [SBJSON new];
    NSString *jsonRequest =[jsonWriter stringWithObject:dict];// @"{\"username\":\"user\",\"password\":\"letmein\"}";
    if(dict==nil)
    {
        jsonRequest=@"{\"data\":[]}";
    }
    else
    {
        //jsonRequest=[NSString stringWithFormat:@"{\"data\":%@}",jsonRequest];
    }
    //NSLog(@"Request: %@", jsonRequest);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"FeedsUrl", @"")]]];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in loadFeeds!");
    }
    [self showPopup];
}
          

#pragma mark -
#pragma mark Request For Login
/*
 ---------------Login---------------------
 http://localhost:8080/paid_punch/app_registration
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>LOGIN-REQ</txtype>
    <name>aaa@gmail.com</name>	
    <password>123456</password>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) login:(NSString*)username loginPassword:(NSString *)password{

    self.requestType=LOGIN_REQ;
	NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><name>%@</name><password>%@</password><sessionid>%@</sessionid></paidpunch-req>",LOGIN_REQ,username,password,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"AppRegistrationUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in login!");
    }
    [self showPopup];
}


#pragma mark -
#pragma mark Request For Logout
/*
 ------------------logout-------------------
 <!-- url http://localhost:8080/paid_punch/app_registration  !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>LOGOUT-REQ</txtype>
    <userid>26</userid>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) logout:(NSString *)userid
{
    self.requestType=LOGOUT_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",LOGOUT_REQ,userid,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"AppRegistrationUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in logout!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Sending Feedback
/*
 ------------------feedback---------------
 <!-- url http://localhost:8080/paid_punch/feedback   !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>SENDFEEDBACK-REQ</txtype>
    <userid>1</userid>
    <feedbackText>The concept is very good and beneficial. Hope will get to see many more feature like new product offers</feedbackText>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) sendFeedBack:(NSString*)feedback loggedInUserId:(NSString *)userID
{
    self.requestType=SENDFEEDBACK_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><feedbackText>%@</feedbackText><sessionid>%@</sessionid></paidpunch-req>",SENDFEEDBACK_REQ,userID,feedback,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"FeedBackUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in sendFeedBack!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Marking Punch Used
/*
 ----------------punch use --------------
 <!-- url http://192.168.1.55:8080/paid_punch/punch!-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>MARKPUNCHUSED-REQ</txtype>
    <userid>1</userid>
    <punchcardid>1</punchcardid>
    <punch_card_downloadid>3</punch_card_downloadid>
    <sessionid>11111</sessionid>
    <is_mystery_punch></is_mystery_punch>
    <expirestatus><expirestatus>
 </paidpunch-req>
*/
-(void) markPunchUsed:(NSString *)punchCardId punchCardDownloadId:(NSString *)downloadId loggedInUserId:(NSString *)userID isMysteryPunch:(BOOL)isMystery isPunchExpired:(BOOL)punchExpired
{
    self.requestType=MARKPUNCHUSED_REQ;
    
    NSString *s=@"false";
    if(isMystery)
        s=@"true";
    else
        s=@"false";
    
    NSString *s1=@"false";
    if(punchExpired)
        s1=@"true";
    else
        s1=@"false";
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><punchcardid>%@</punchcardid><punch_card_downloadid>%@</punch_card_downloadid><sessionid>%@</sessionid><is_mystery_punch>%@</is_mystery_punch><expirestatus>%@</expirestatus></paidpunch-req>",MARKPUNCHUSED_REQ,userID,punchCardId,downloadId,[[User getInstance] uniqueId],s,s1];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"PaidPunchUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in markPunchUsed!");
    }
    [self showPopup];

}

#pragma mark -
#pragma mark Request For Updating Email
/*
 ---------------- email update----------
 <!-- url http://localhost:8080/paid_punch/updation   !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>EMAILUPDATE-REQ</txtype>
    <userid>1</userid>
    <email>j@gmail.com</email>
    <mobilenumber>99999999</mobilenumber>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) update:(NSString *)email withMobileNumber:(NSString *)mobileNo loggedInUserId:(NSString *)userID
{
    self.requestType=EMAILUPDATE_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><email>%@</email><mobilenumber>%@</mobilenumber><sessionid>%@</sessionid></paidpunch-req>",EMAILUPDATE_REQ,userID,email,mobileNo,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"UpdateUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in update!");
    }
    [self showPopup];
}


#pragma mark -
#pragma mark Request For Changing Password
/*
  ---------------- password update----------
 <!-- url http://localhost:8080/paid_punch/updation   !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>VERIFICATION-REQ</txtype>
    <userid>1</userid>
    <oldpassword>j@gmail.com</oldpassword>
    <password>99999999</password>
    <sessionid>11111</sessionid>
 </paidpunch-req>
 */

-(void) changePassword:(NSString *)oldPassword newPassword:(NSString*)password loggedInUserId:(NSString *)userID
{
    self.requestType=VERIFICATION_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><oldpassword>%@</oldpassword><password>%@</password><sessionid>%@</sessionid></paidpunch-req>",VERIFICATION_REQ,userID,oldPassword,password,[[User getInstance] uniqueId]];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"UpdateUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in changePassword!");
    }
    [self showPopup];

}


#pragma mark -
#pragma mark Request For Getting Business Offer
/*
 ----------------- Get Business Offer --------------
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>BUSSINESSOFFER-REQ</txtype>
    <scannedcode>mobi</scannedcode>
    <userid>1</userid>
    <sessionid>11111</sessionid>
 </paidpunch-req>
 */
-(void) getBusinessOffer:(NSString*)scannedQrCode loggedInUserId:(NSString *)userID 
{
    self.requestType=BUSINESSOFFER_REQ;
    NSString *post=@"";	
    
    scannedQrCode=[scannedQrCode stringByEncodingHTMLEntities:YES];
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><scannedcode>%@</scannedcode><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",BUSINESSOFFER_REQ,scannedQrCode,userID,[[User getInstance] uniqueId]];
	NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"AppRegistrationUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in getBusinessOffer!");
    }
    [self showPopup];
}


#pragma mark -
#pragma mark Request For Buying
/*
 ----------------- buy --------------
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>BUYBUSSINESSOFFER-REQ</txtype>
    <offerQRscannedcode>mobi</offerQRscannedcode>
    <userid>1</userid>
    <punchcardid>1</punchcardid>
    <orangeqrscannedvalue>test</orangeqrscannedvalue>
    <sessionid>11111</sessionid>
    <isfreepunch></isfreepunch>
    <amount>5</amount>
    <transactionid>1243456</transactionid>
    <paymentid>11111</paymentid>
 </paidpunch-req>
*/
-(void) buy:(NSString*)scannedQrCode loggedInUserId:(NSString *)userID punchCardId:(NSString *)pid orangeQrCodeScanned:(NSString *)orangeCode isFreePunch:(BOOL)unlockedFreePunch withTransactionId:(NSString*)tid withAmount:(NSNumber *)amount withPaymentId:(NSString *)paymentId
{
    self.requestType=BUYBUSSINESSOFFER_REQ;
    NSString *post=@"";
	NSString *isFree;
    if(unlockedFreePunch)
        isFree=@"true";
    else
    {
        isFree=@"false";
    }
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><offerQRscannedcode>%@</offerQRscannedcode><userid>%@</userid><punchcardid>%@</punchcardid><orangeqrscannedvalue>%@</orangeqrscannedvalue><sessionid>%@</sessionid><isfreepunch>%@</isfreepunch><transactionid>%@</transactionid><amount>%@</amount><paymentid>%@</paymentid></paidpunch-req>",BUYBUSSINESSOFFER_REQ,scannedQrCode,userID,pid,orangeCode,[[User getInstance] uniqueId],isFree,tid,[amount stringValue],paymentId];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"BuyPunchUrl", @"")]]];
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:NSLocalizedString(@"BuyPunchUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in buy!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Search By Name
/*
 -------------------- search by name---------------
 <!--url http://localhost:8080/paid_punch/punch --!>
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>SEARCHBYBUSINESSNAME-REQ</txtype>
    <business_name>a</business_name>
    <userid>1</userid>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) searchByName:(NSString *)business_name loggedInUserId:(NSString *)userID 
{
    self.requestType=SEARCHBYBUSINESSNAME_REQ;
    NSString *post=@"";
    NSString* sessionId = [[User getInstance] uniqueId];
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><business_name>%@</business_name><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",SEARCHBYBUSINESSNAME_REQ,business_name,userID,sessionId];
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl],NSLocalizedString(@"PaidPunchUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in searchByName!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For getting Users Punch
/*
 -------------- getuser punch-------------
 <!-- url http://localhost:8080/paid_punch/punch  !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
    <txtype>GETUSERPUCNHCARD-REQ</txtype>
    <userid>1</userid>
    <sessionid>11111</sessionid>
 </paidpunch-req>
*/
-(void) getUserPunches:(NSString *)userId
{
    self.requestType=GETUSERPUCNHCARD_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><userid>%@</userid><sessionid>%@</sessionid></paidpunch-req>",GETUSERPUCNHCARD_REQ,userId,[[User getInstance] uniqueId]];  
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"PaidPunchUrl", @"")]]];
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in getUserPunches!");
    }
    [self showPopup];
}

#pragma mark -
#pragma mark Request For Forgot Password
/*
 -------------- forgotPassword-------------
 <!-- url http://localhost:8080/paid_punch/forgotpassword  !-->
 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
 <paidpunch-req>
 <txtype>FORGOT-PASSWORD-REQ</txtype>
 <email>aaa@gmail.com</email>
 </paidpunch-req>
 */
-(void) forgotPassword:(NSString *)emailId
{
    self.requestType=FORGOT_PASSWORD_REQ;
    NSString *post=@"";	
    post=[NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes'?><paidpunch-req><txtype>%@</txtype><email>%@</email></paidpunch-req>",FORGOT_PASSWORD_REQ,emailId];  
	//NSLog(@"request format--->%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[AFClientManager sharedInstance] appUrl], NSLocalizedString(@"ForgotPasswordUrl", @"")]]];   
    [request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"]; 
	[request setHTTPBody:postData];  
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.webData = data;
    }
    else
    {
        NSLog(@"Connection creation failed in forgotPassword!");
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.webData setLength:0];
	int responseStatusCode=[((NSHTTPURLResponse*) response) statusCode];
	if (responseStatusCode!=200) //Bad Request
	{
        if([(UIViewController *)delegate respondsToSelector:@selector(didConnectionFailed:)])
        {
            [delegate didConnectionFailed:[NSString stringWithFormat:@"Server Error Code :%d",responseStatusCode]];
        }
        [self removePopup];
	}
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.webData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	/*[self.webData release];
	self.webData=nil;*/
    [self removePopup];
    if(self.requestType==SEARCHBYBUSINESSNAME_REQ && [[[DatabaseManager sharedInstance] getAllBusinesses] count]>0)
    {
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Could not connect to server. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    if([(UIViewController *)delegate respondsToSelector:@selector(didConnectionFailed:)])
    {
        [delegate didConnectionFailed:[NSString stringWithFormat:@"Server Error Code :%@",error]];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"DONE. Received Bytes:%d----", [self.webData length]);
	
	NSString *temp = [[NSString alloc] initWithBytes:[self.webData mutableBytes] length:[self.webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"request response ------%@",temp);
    [xmlParser parse:temp];
    
    if([self.requestType isEqualToString:SEARCHBYBUSINESSNAME_REQ])
    {
        SBJsonParser *parser=[SBJsonParser new];
        NSDictionary *dataList=[parser objectWithString:temp];
        //NSLog(@"%d",dataList.count);
        
        xmlParser.statusCode=[dataList objectForKey:@"statusCode"];
        xmlParser.statusMessage=[dataList objectForKey:@"statusMessage"];
        NSArray *arr=[dataList objectForKey:@"paidpunch"];
        for (NSDictionary *obj in arr) {
            
            NSString *bid=[obj objectForKey:@"bussinessid"];
            Business *b=[[DatabaseManager sharedInstance] getBusinessByBusinessId:bid];
            if(b==nil)
            {
                Business *business=[[DatabaseManager sharedInstance] getBusinessObject];
                [business setValue:[obj objectForKey:@"bussinessid"] forKey:@"business_id"];
                [business setValue:[obj objectForKey:@"bussinessname"] forKey:@"business_name"];
                [business setValue:[obj objectForKey:@"qrcode"] forKey:@"qrcode"];
            
                [business setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"latitude"] doubleValue]] forKey:@"latitude"];
                [business setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"longitude"] doubleValue]] forKey:@"longitude"];
                [business setValue:[obj objectForKey:@"category"] forKey:@"category"];

                NSString * mdateStr=[obj objectForKey:@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSString *formatString = @"yyyy-MM-dd HH:mm:ss.SSS";
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                [formatter setDateFormat:formatString];
                NSDate *date = [formatter dateFromString:mdateStr];
            
                //[business setValue:[obj objectForKey:@"modification_time"] forKey:@"modified_date"];
                [business setValue:date forKey:@"time"];
                [business setValue:[obj objectForKey:@"city"] forKey:@"city"];

                [business setValue:[obj objectForKey:@"state"] forKey:@"state"];
                [business setValue:[obj objectForKey:@"country"] forKey:@"country"];
                [business setValue:[obj objectForKey:@"pincode"] forKey:@"pincode"];
                [business setValue:[obj objectForKey:@"address"] forKey:@"address"];
            }
            else
            {
                NSString * mdateStr=[obj objectForKey:@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSString *formatString = @"yyyy-MM-dd HH:mm:ss.SSS";
                [formatter setDateFormat:formatString];
                NSDate *date = [formatter dateFromString:mdateStr];
                
                
                NSTimeZone *tz1 = [NSTimeZone systemTimeZone];
                NSInteger sec1 = [tz1 secondsFromGMTForDate: [NSDate date]];
                NSDate *dt=[NSDate dateWithTimeInterval: sec1 sinceDate: date];
                NSLog(@"%@",dt);
                //NSDate *dt1=[NSDate dateWithTimeInterval: sec1 sinceDate: b.time];
                NSLog(@"%@",b.time);
                NSComparisonResult res = [dt compare:b.time];
                NSLog(@"%d",res);
                if(res == NSOrderedDescending)
                {
                    if(b.punchCard!=nil)
                    {
                        [b setTime:dt];
                        [[DatabaseManager sharedInstance] saveEntity:nil];
                        [[DatabaseManager sharedInstance] deleteEntity:b.punchCard];
                    }
                }
                else
                {
                    
                }
            }
            
            [[DatabaseManager sharedInstance] saveEntity:nil];
        }
        [delegate didFinishSearchByName:xmlParser.statusCode];
    }
    if([self.requestType isEqualToString:GET_FEEDS_REQ])
    {
        SBJsonParser *parser=[SBJsonParser new];
        NSDictionary *dataList=[parser objectWithString:temp];
        //NSLog(@"%d",dataList.count);
        
        xmlParser.statusCode=[dataList objectForKey:@"statusCode"];
        xmlParser.statusMessage=[dataList objectForKey:@"statusMessage"];
        NSArray *arr=[dataList objectForKey:@"feedlist"];
        //NSLog(@"%@",arr);
        [[DatabaseManager sharedInstance] deleteAllFeeds];
        [[DatabaseManager sharedInstance] saveEntity:nil];
        for (NSDictionary *obj in arr) {
            Feed *feedsObj=[[DatabaseManager sharedInstance] getFeedObject];
            [feedsObj setValue:[obj objectForKey:@"fbid"] forKey:@"fbid"];
            [feedsObj setValue:[obj objectForKey:@"action"] forKey:@"action"];
            [feedsObj setValue:[obj objectForKey:@"name"] forKey:@"name"];
            [feedsObj setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"price"] doubleValue]] forKey:@"price"];
            [feedsObj setValue:[obj objectForKey:@"buss_name"] forKey:@"business_name"];
            [feedsObj setValue:[NSNumber numberWithInt:[[obj objectForKey:@"no_of_punches"] intValue]] forKey:@"no_of_punches"];
            [feedsObj setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"Value_of_each_punch"] doubleValue]] forKey:@"each_punch_value"];
            [feedsObj setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"selling_price"] doubleValue]] forKey:@"selling_price"];
            [feedsObj setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"actual_value_of_punch"] doubleValue]] forKey:@"actual_value_of_each_punch"];
            [feedsObj setValue:[obj objectForKey:@"offer"] forKey:@"offer"];
            [feedsObj setValue:[obj objectForKey:@"isfriend"] forKey:@"is_friend"];
            [feedsObj setValue:[NSNumber numberWithDouble:[[obj objectForKey:@"discount_value_of_each_punch"] doubleValue]] forKey:@"discount_value_of_each_punch"];
            NSString * mdateStr=[obj objectForKey:@"timestamp"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSString *formatString = @"yyyy-MM-dd HH:mm:ss.SSS";
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [formatter setDateFormat:formatString];
            NSDate *date = [formatter dateFromString:mdateStr];
            [feedsObj setValue:date forKey:@"time_stamp"];
            
            [[DatabaseManager sharedInstance] saveEntity:nil];
        }
        [delegate didFinishLoadingFeeds:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
    }
   
    if([self.requestType isEqualToString:APP_IP_REQ])
    {
        NSArray *arr=[temp componentsSeparatedByString:@"="];
        if([arr count]>1)
        {   
            [delegate didFinishLoadingAppURL:[arr objectAtIndex:1]];
        }
    }
    [self removePopup];
    
    if ([xmlParser.statusCode rangeOfString:@"400"].location == NSNotFound) {

        if([self.requestType isEqualToString:FB_LOGIN_REQ ])
        {
            [delegate didFinishWithFacebookLogin:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:LOGIN_REQ])
        {
            [delegate didFinishLogin:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:LOGOUT_REQ])
        {
            [delegate didFinishLoggingOut:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:SENDFEEDBACK_REQ])
        {
            [delegate didFinishSendingFeedback:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:BUSINESSOFFER_REQ])
        {
            [delegate didFinishLoadingBusinessOffer:xmlParser.statusCode statusMessage:xmlParser.statusMessage  punchCardDetails:xmlParser.punchCardDetails];
        }
        if([self.requestType isEqualToString:BUYBUSSINESSOFFER_REQ])
        {
            [delegate didFinishBuying:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:EMAILUPDATE_REQ])
        {
            [delegate didFinishUpdate:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:VERIFICATION_REQ])
        {
            [delegate didFinishChangingPassword:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:GETUSERPUCNHCARD_REQ])
        {
            [delegate didFinishGetUsersPunch:xmlParser.statusCode];
        }
        if([self.requestType isEqualToString:MARKPUNCHUSED_REQ])
        {
            [delegate didFinishMarkingPunchUsed:xmlParser.statusCode statusMessage:xmlParser.statusMessage barcodeImage:xmlParser.barcodeImage barcodeValue:xmlParser.barcodeValue];
        }
        if([self.requestType isEqualToString:FORGOT_PASSWORD_REQ])
        {
            [delegate didFinishSendingForgotPasswordRequest:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:PROFILE_REQ])
        {
            [delegate didFinishCreatingProfile:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
        if([self.requestType isEqualToString:GET_PROFILE_REQ])
        {
            [delegate didFinishGettingProfile:xmlParser.statusCode statusMessage:xmlParser.statusMessage withMaskedId:xmlParser.maskedId withPaymentId:xmlParser.paymentId];
        }
        if([self.requestType isEqualToString:MYSTERY_REQ])
        {
            [delegate didFinishGettingMysteryOffer:xmlParser.statusCode statusMessage:xmlParser.statusMessage withOffer:xmlParser.offer];
        }
        if([self.requestType isEqualToString:DELETE_PROFILE_REQ])
        {
            [delegate didFinishDeletingProfile:xmlParser.statusCode statusMessage:xmlParser.statusMessage];
        }
    }
    else
    {
        // TODO: Verify that this is not required and remove if necessary.
        /*
        if(self.requestType==APP_IP_REQ)
        {}
        else
        [self goToDualSignInView];
         */
        [self goToSignInView];
    }
}

#pragma mark -

-(void) showPopup
{
    /*if(self.requestType==SEARCHBYBUSINESSNAME_REQ && [[[DatabaseManager sharedInstance] getAllBusinesses] count]>0)
    {
        
    }
    else
    {
        NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
        activityView= [xibUIObjects objectAtIndex:0];
        activityView.backgroundColor=[UIColor clearColor];
        //[self.view addSubview:activityView];
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:activityView];
        [((UIActivityIndicatorView *)[activityView viewWithTag:2]) setHidden:YES];
        ((UITextView *)[activityView viewWithTag:1]).hidden=YES;
    }*/
    
    /*activityIndicator.hidden = NO;
    activityIndicator.center = CGPointMake(160.0f, 240.0f);
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:activityIndicator];*/
    [popupHUD show:YES];
}

#pragma mark -

-(void) removePopup
{
    /*// finished loading, hide the activity indicator in the status bar
    if([activityView respondsToSelector:@selector(viewWithTag:)])
	{
        [activityView removeFromSuperview];
        activityView=nil;
    }*/
    
    /*[activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    [activityIndicator removeFromSuperview];*/
    [popupHUD hide:YES];
}

#pragma mark -

-(void) goToSignInView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:xmlParser.statusMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Clear user info, which will force a login
    [[User getInstance] clearUser];
    
    [appDelegate initView];
}

@end
