//
//  User.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "User.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyUserId = @"userid";
static NSString* const kKeyReferral = @"refer_code";
static NSString* const kKeyName = @"name";
static NSString* const kKeyEmail = @"email";
static NSString* const kKeyZipcode = @"zipcode";
static NSString* const kKeyPhone = @"mobile_no";
static NSString* const kTxType = @"txtype";
static NSString* const kKeyPassword = @"password";
static NSString* const kKeyFacebook = @"fbid";
static NSString* const kKeyUniqueId = @"sessionid";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kKeyUserValidate = @"userValidated";
static NSString* const kKeyPaymentProfileCreated = @"paymentProfile";
static NSString* const kKeyTotalMiles = @"totalMiles";
static NSString* const kEmailRegister = @"EMAIL-REGISTER";
static NSString* const kFacebookRegister = @"FACEBOOK-REGISTER";
static NSString* const kEmailLogin= @"EMAIL-LOGIN";
static NSString* const kFacebookLogin = @"FACEBOOK-LOGIN";
static NSString* const kUserFilename = @"user.sav";

@implementation User
@synthesize referralCode = _referralCode;
@synthesize userId = _userId;
@synthesize username = _username;
@synthesize email = _email;
@synthesize password = _password;
@synthesize zipcode = _zipcode;
@synthesize phone = _phone;
@synthesize uniqueId = _uniqueId;
@synthesize isUserValidated = _isUserValidated;
@synthesize isPaymentProfileCreated = _isPaymentProfileCreated;
@synthesize totalMiles = _totalMiles;

- (id) init
{
    self = [super init];
    if(self)
    {
        [self clearUser];
    }
    return self;
}

- (void) clearUser
{
    _createdVersion = @"1.0";
    _referralCode = @"";
    _userId = @"";
    _username = @"";
    _email = @"";
    _password = @"";
    _zipcode = @"";
    _phone = @"";
    _facebookId = @"";
    [self getUniqueId];
    _isUserValidated = FALSE;
    _totalMiles = [NSNumber numberWithInt:10];
    
    _callType = no_call;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_userId forKey:kKeyUserId];
    [aCoder encodeObject:_username forKey:kKeyName];
    [aCoder encodeObject:_email forKey:kKeyEmail];
    [aCoder encodeObject:_phone forKey:kKeyPhone];
    [aCoder encodeObject:_zipcode forKey:kKeyZipcode];
    [aCoder encodeObject:_facebookId forKey:kKeyFacebook];
    [aCoder encodeObject:_uniqueId forKey:kKeyUniqueId];
    [aCoder encodeObject:_referralCode forKey:kKeyReferral];
    [aCoder encodeBool:_isPaymentProfileCreated forKey:kKeyPaymentProfileCreated];
    [aCoder encodeBool:_isUserValidated forKey:kKeyUserValidate];
    [aCoder encodeObject:_totalMiles forKey:kKeyTotalMiles];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
     _userId = [aDecoder decodeObjectForKey:kKeyUserId];
    _username = [aDecoder decodeObjectForKey:kKeyName];
    _email = [aDecoder decodeObjectForKey:kKeyEmail];
    _phone = [aDecoder decodeObjectForKey:kKeyPhone];
    _zipcode = [aDecoder decodeObjectForKey:kKeyZipcode];
    _facebookId = [aDecoder decodeObjectForKey:kKeyFacebook];
    _uniqueId = [aDecoder decodeObjectForKey:kKeyUniqueId];
    _referralCode = [aDecoder decodeObjectForKey:kKeyReferral];
    _isPaymentProfileCreated = [aDecoder decodeBoolForKey:kKeyPaymentProfileCreated];
    _isUserValidated = [aDecoder decodeBoolForKey:kKeyUserValidate];
    _totalMiles = [aDecoder decodeObjectForKey:kKeyTotalMiles];
    return self;
}

#pragma mark - private functions

-(void) facebookLogin
{    
    [[FacebookFacade sharedInstance] setCallbackDelegate:self];
    [[FacebookFacade sharedInstance] apiLogin];
}

-(NSString *)getUniqueId
{
    if (!_uniqueId)
    {
        // Create universally unique identifier (object)
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        
        // Get the string representation of CFUUID object.
        _uniqueId = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
        CFRelease(uuidObject);
    }
    
    return _uniqueId;
}

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) userFilepath
{
    NSString* docsDir = [User documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kUserFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (User*) loadUserData
{
    User* current_user = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [User userFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_user = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_user;
}

- (void) saveUserData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[User userFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"user file saved successfully");
    }
    else
    {
        NSLog(@"user file save failed: %@", error);
    }
}

- (void) removeUserData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [User userFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - Server calls

- (void) registerUserWithEmail:(NSObject<HttpCallbackDelegate>*) delegate
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kEmailRegister, kTxType,
                                _username, kKeyName,
                                _password, kKeyPassword,
                                _email, kKeyEmail,
                                _phone, kKeyPhone,
                                _zipcode, kKeyZipcode,
                                _referralCode, kKeyReferral,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient postPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
                    [self saveUserData];
                    [delegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                    [delegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) registerUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate
{
    facebookDelegate = delegate;
    [self facebookLogin];
    _callType = register_call;
}

- (void) registerUserWithFacebookInternal
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kFacebookRegister, kTxType,
                                _username, kKeyName,
                                _email, kKeyEmail,
                                _facebookId, kKeyFacebook,
                                _uniqueId, kKeyUniqueId,
                                _referralCode, kKeyReferral,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient postPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
                     _isUserValidated = TRUE;
                     [self saveUserData];
                     [facebookDelegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                     [facebookDelegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (void) loginUserWithEmail:(NSObject<HttpCallbackDelegate>*) delegate
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kEmailLogin, kTxType,
                                _email, kKeyEmail,
                                _password, kKeyPassword,
                                _uniqueId, kKeyUniqueId,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient putPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
                     [self saveUserData];
                     [delegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User registration failed with status code: %d", [operation.response statusCode]);
                     [delegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (void) loginUserWithFacebook:(NSObject<HttpCallbackDelegate>*) delegate
{
    facebookDelegate = delegate;
    [self facebookLogin];
    _callType = login_call;
}

- (void) loginUserWithFacebookInternal
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                kFacebookLogin, kTxType,
                                _email, kKeyEmail,
                                _facebookId, kKeyFacebook,
                                _uniqueId, kKeyUniqueId,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient putPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     _userId = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:kKeyUserId]];
                     _isUserValidated = TRUE;
                     [self saveUserData];
                     [facebookDelegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"User login failed with status code: %d", [operation.response statusCode]);
                     [facebookDelegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

#pragma mark - Facebook data

- (void) didCompleteFacebookLogin:(BOOL) success
{
    [self getUserProfileInfo];
}

- (void)getUserProfileInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name ,email FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response %@",response);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{    
    if ([result isKindOfClass:[NSArray class]])
    {
        result = [result objectAtIndex:0];
    }
    
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"])
    {
        // Store the information retrieved from facebook
        _username = [result objectForKey:@"name"];
        if([result objectForKey:@"uid"])
        {
            _facebookId = [NSString stringWithFormat:@"%@", [result objectForKey:@"uid"]];
        }
        if([result objectForKey:@"email"])
        {
            _email=[result objectForKey:@"email"];
        }
        
        if (_callType == register_call)
        {
            // Call the facebook registration API
            [self registerUserWithFacebookInternal];
        }
        else if (_callType == login_call)
        {
            // Call the facebook login API
            [self loginUserWithFacebookInternal];
        }
        else
        {
            NSLog(@"Unknown callType in didLoad.");
        }
    }
    else
    {
        NSLog(@"Unknown facebook callback in didLoad.");
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

- (void)requestLoading:(FBRequest *)request
{
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
}

#pragma mark - Singleton
static User* singleton = nil;
+ (User*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [User loadUserData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[User alloc] init];
            }
		}
	}
	return singleton;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		singleton = nil;
	}
}

@end
