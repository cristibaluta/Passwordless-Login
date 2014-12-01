//
//  RCPasswordlessLogin.m
//  Passwordless Login
//
//  Created by Baluta Cristian on 28/09/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import "RCPasswordlessLogin.h"
#import "RCPasswordlessUser.h"

@interface RCPasswordlessLogin () <NSURLSessionDelegate>

@property (nonatomic, copy) NSString *request;
@property (nonatomic, strong) NSURL *serviceURL;

@end


@implementation RCPasswordlessLogin

static RCPasswordlessLogin *_instance = nil;
static dispatch_once_t _oncePredicate;

+ (instancetype)sharedLogin {
	dispatch_once(&_oncePredicate, ^{
		assert(@"Call [RCPasswordlessLogin initWithServiceURL:...] before using this method");
	});
	return _instance;
}

+ (instancetype)initWithServiceURL:(NSURL *)serviceURL {
	dispatch_once(&_oncePredicate, ^{
		_instance = [[self alloc] initWithServiceURL:serviceURL];
	});
	return _instance;
}

- (instancetype)initWithServiceURL:(NSURL *)serviceURL {
	self = [super init];
	if (self) {
		_serviceURL = serviceURL;
		
		_otherDevices = [NSArray array];
		
		_currentDevice = [[RCPasswordlessUser alloc] init];
		_currentDevice.uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		_currentDevice.deviceModel = [[UIDevice currentDevice] model];
		_currentDevice.deviceName = [[UIDevice currentDevice] name];
		_currentDevice.systemVersion = [[UIDevice currentDevice] systemVersion];
	}
	return self;
}

- (void)loginWithCompletion:(RCPasswordlessLoginLoginBlock)completionBlock {
	[self loginWithEmail:nil facebookID:nil extraInfo:nil completion:completionBlock];
}

- (void)loginWithEmail:(NSString *)email
			 extraInfo:(NSDictionary *)info
			completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	
	[self loginWithEmail:email facebookID:nil extraInfo:info completion:completionBlock];
}

- (void)loginWithFacebookID:(NSNumber *)facebookID
				  extraInfo:(NSDictionary *)info
				 completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	
	[self loginWithEmail:nil facebookID:facebookID extraInfo:info completion:completionBlock];
}

- (void)loginWithEmail:(NSString *)email
			facebookID:(NSNumber *)facebookID
			 extraInfo:(NSDictionary *)info
			completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
		  @"uuid":_currentDevice.uuid,
		  @"deviceModel":_currentDevice.deviceModel,
		  @"deviceName":_currentDevice.deviceName,
		  @"systemVersion":_currentDevice.systemVersion,
		  @"facebookID":facebookID==nil ? @"0" : facebookID,
		  @"email":email==nil ? @"" : email,
		  @"command":@"login_or_register"}];
	
	if (info != nil) [parameters addEntriesFromDictionary:info];
	
	[self requestWithDictionary:parameters completion:completionBlock];
}

- (void)unregisterThisDevice {
	NSDictionary *parameters = @{
		 @"uuid":_currentDevice.uuid,
		 @"command":@"deregister"};
	
	[self requestWithDictionary:parameters completion:^(BOOL success) {
		
	}];
}

- (RCPasswordlessUser *)deviceForUUID:(NSString *)uuid {
	for (RCPasswordlessUser *user in _otherDevices) {
		if ([user.uuid isEqualToString:uuid]) {
			return user;
		}
	}
	return nil;
}


#pragma mark Utils

- (void)requestWithDictionary:(NSDictionary *)info completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	NSLog(@"requestWithDictionary %@", info);
	
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_serviceURL
														   cachePolicy:NSURLRequestReloadIgnoringCacheData
													   timeoutInterval:60.0];
	
	NSMutableString *postStr = [[NSMutableString alloc] init];
	for (id key in info) [postStr appendFormat:@"%@=%@&", key, [info objectForKey:key]];
	NSData *postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	
	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
													completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		
		if (!error) {
			NSError *jsonError;
			NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			NSLog(@"%@", responseDict);
			if (!jsonError) {
				[self parseUsersFromDictionary:responseDict];
			}
			_loggedIn = YES;
			
			completionBlock (jsonError == nil);
//			RCLog(@"%@", error_);
//			NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//			NSLogO(newStr);
		}
		else {
			completionBlock(NO);
		}
	}];
	
	[postDataTask resume];
}

- (void)parseUsersFromDictionary:(NSDictionary *)dict {
	
	NSMutableArray *arr = [NSMutableArray array];
	NSArray *users = dict[@"users"];
	
	for (NSDictionary *user in users) {
		RCPasswordlessUser *u = [[RCPasswordlessUser alloc] init];
		u.uuid = user[@"uuid"];
		u.email = user[@"email"];
		u.name = user[@"name"];
		u.deviceModel = user[@"deviceModel"];
		u.deviceName = user[@"deviceName"];
		u.systemVersion = user[@"systemVersion"];
		
		if ( ! [_currentDevice.uuid isEqualToString:u.uuid]) {
			[arr addObject:u];
		}
		else {
			_currentDevice.email = u.email;
			_currentDevice.name = u.name;
		}
	}
	_otherDevices = [NSArray arrayWithArray:arr];
}

@end
