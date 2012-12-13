//
//  User.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "AFHTTPRequestOperation.h"
#import "User.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyUserId = @"userid";
static NSString* const kKeyReferral = @"refer_code";
static NSString* const kKeyName = @"name";
static NSString* const kKeyEmail = @"email";
static NSString* const kKeyZipcode = @"zipcode";
static NSString* const kKeyPhone = @"mobile_no";
static NSString* const kTxType = @"txtype";
static NSString* const kKeyPassword = @"password";
static NSString* const kEmailRegister = @"EMAIL-REGISTER";
static NSString* const kFacebookRegister = @"FACEBOOK-REGISTER";
static NSString* const kUserFilename = @"user.sav";

@implementation User
@synthesize referralCode = _referralCode;
@synthesize username = _username;
@synthesize email = _email;
@synthesize password = _password;
@synthesize zipcode = _zipcode;
@synthesize phone = _phone;

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _referralCode = @"";
        _userId = @"";
        _username = @"";
        _email = @"";
        _password = @"";
        _zipcode = @"";
        _phone = @"";
    }
    return self;
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
    [aCoder encodeObject:_referralCode forKey:kKeyReferral];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
     _userId = [aDecoder decodeObjectForKey:kKeyUserId];
    _username = [aDecoder decodeObjectForKey:kKeyName];
    _email = [aDecoder decodeObjectForKey:kKeyEmail];
    _phone = [aDecoder decodeObjectForKey:kKeyPhone];
    _zipcode = [aDecoder decodeObjectForKey:kKeyZipcode];
    _referralCode = [aDecoder decodeObjectForKey:kKeyReferral];
    return self;
}

#pragma mark - private functions

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

- (void) registerUser:(NSObject<HttpCallbackDelegate>*) delegate
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
    
    // make a get request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"paid_punch/Users";
    [httpClient postPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"%@", responseObject);
                    [delegate didCompleteHttpCallback:TRUE, responseObject, @""];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Server Failure"
                                                                      message:@"Unable to retrieve player data. Please try again later."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    
                    [message show];
                    NSLog(@"Localized failure reason: %@", error.localizedFailureReason);
                    NSLog(@"Localized failure description: %@", error.localizedDescription);
                    NSLog(@"Recovery options: %@", error.localizedRecoveryOptions);
                    NSLog(@"Recover suggestion: %@", error.localizedRecoverySuggestion);
                    [delegate didCompleteHttpCallback:FALSE, NULL, error.localizedDescription];
                }
     ];
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
