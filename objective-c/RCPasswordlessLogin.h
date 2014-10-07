//
//  RCPasswordlessLogin.h
//  Passwordless Login
//
//  Created by Baluta Cristian on 28/09/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^RCPasswordlessLoginLoginBlock)(BOOL success);

@class RCPasswordlessUser;
@interface RCPasswordlessLogin : NSObject

@property (nonatomic, readonly, strong) NSArray *otherDevices;
@property (nonatomic, readonly, strong) RCPasswordlessUser *currentDevice;

+ (instancetype)sharedLogin;

// You need to provide a serverside script that processes your users
+ (instancetype)initWithServiceURL:(NSURL *)serviceURL;
- (instancetype)initWithServiceURL:(NSURL *)serviceURL;

- (void)loginWithCompletion:(RCPasswordlessLoginLoginBlock)completionBlock;
- (void)loginWithEmail:(NSString *)email completion:(RCPasswordlessLoginLoginBlock)completionBlock;
- (void)loginWithFacebookID:(NSNumber *)facebookID completion:(RCPasswordlessLoginLoginBlock)completionBlock;
- (void)loginWithEmail:(NSString *)email facebookID:(NSNumber *)facebookID
			completion:(RCPasswordlessLoginLoginBlock)completionBlock;
- (void)unregisterThisDevice;

@end
