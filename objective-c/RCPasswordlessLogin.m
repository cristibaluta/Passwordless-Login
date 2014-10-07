//
//  RCPasswordlessLogin.m
//  Passwordless Login
//
//  Created by Baluta Cristian on 28/09/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import "RCPasswordlessLogin.h"
#import "RCPasswordlessUser.h"

@interface RCPasswordlessLogin ()

@property (nonatomic, copy) NSString *request;
@property (nonatomic, strong) NSURL *serviceURL;

@end


@implementation RCPasswordlessLogin

static RCPasswordlessLogin *_instance = nil;
static dispatch_once_t _oncePredicate;

+ (instancetype)sharedLogin {
	dispatch_once(&_oncePredicate, ^{
		NSLog(@"Not good, this shouldn't be called ever. Use [RCPasswordlessLogin initWithServiceURL:...]; first");
		_instance = [[self alloc] init];
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
		NSLog(@"Register user with serviceURL: %@", serviceURL);
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
	[self loginWithEmail:nil facebookID:nil completion:completionBlock];
}

- (void)loginWithEmail:(NSString *)email completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	[self loginWithEmail:email facebookID:nil completion:completionBlock];
}

- (void)loginWithFacebookID:(NSNumber *)facebookID completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	[self loginWithEmail:nil facebookID:facebookID completion:completionBlock];
}

- (void)loginWithEmail:(NSString *)email facebookID:(NSNumber *)facebookID
			completion:(RCPasswordlessLoginLoginBlock)completionBlock {
	
	NSDictionary *parameters = @{
								 @"uuid":_currentDevice.uuid,
								 @"deviceModel":_currentDevice.deviceModel,
								 @"deviceName":_currentDevice.deviceName,
								 @"systemVersion":_currentDevice.systemVersion,
								 @"facebookID":facebookID,
								 @"email":email,
								 @"command":@"login_or_register"};
	
}

- (void)unregisterThisDevice {
	NSDictionary *parameters = @{
								 @"uuid":_currentDevice.uuid,
								 @"command":@"deregister"};
}

@end
