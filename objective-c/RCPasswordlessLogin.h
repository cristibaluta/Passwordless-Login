//
//  RCPasswordlessLogin.h
//  Passwordless Login
//
//  Created by Baluta Cristian on 28/09/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @typedef RCPasswordlessLoginLoginBlock
 
 @abstract
 A block that is passed when a login request was completed
 
 @discussion
 Pass a block of this type when calling one of the login methods. This will be called on the UI
 thread, once the login completes.
 
 @param success Indicates if the login was successful or not
 */
typedef void(^RCPasswordlessLoginLoginBlock)(BOOL success);

@class RCPasswordlessUser;

/*!
 @class RCPasswordlessLogin
 
 @abstract
 The RCPasswordlessLogin object is used to register your device on the server
 and to access the other devices that are registered under the same email or facebookID.
 It is a fast way of recognizing devices of the same person in order to sync data to all of them.
 */
@interface RCPasswordlessLogin : NSObject

/*!
 A list of devices that are registered with the same email or facebook id.
 Can be accessed after one of the login methods was called.
 */
@property (nonatomic, readonly, strong) NSArray *otherDevices;

/*!
 The details of your current device. Can be accessed after one of the login methods was called.
 */
@property (nonatomic, readonly, strong) RCPasswordlessUser *currentDevice;


/*!
 @abstract The singleton to access your users.
 Before using this singleton you must init it first with loginWithServiceURL or initWithServiceURL
 */
+ (instancetype)sharedLogin;

/*!
 @abstract Static initialization.
 @param serviceURL Is the API of the serverside app that handles your users.
 */
+ (instancetype)initWithServiceURL:(NSURL *)serviceURL;

/*!
 @abstract Convenience initialization.
 @param serviceURL Is the API of the serverside app that handles your users.
 */
- (instancetype)initWithServiceURL:(NSURL *)serviceURL;

/*!
 Login convenience method
 
 @param completionBlock Returns a success or failure response
 */
- (void)loginWithCompletion:(RCPasswordlessLoginLoginBlock)completionBlock;

/*!
 Login convenience method. 
 
 @discussion You can call this method any time and it updates the server with the new info
 
 @param email
 @param extraInfo Extra info that you want to send to the server
 @param completionBlock
 */
- (void)loginWithEmail:(NSString *)email
			 extraInfo:(NSDictionary *)info
			completion:(RCPasswordlessLoginLoginBlock)completionBlock;

/*!
 Login convenience method
 
 @discussion You can call this method any time and it updates the server with the new info
 
 @param facebookID
 @param extraInfo Extra info that you want to send to the server
 @param completionBlock
 */
- (void)loginWithFacebookID:(NSNumber *)facebookID
				  extraInfo:(NSDictionary *)info
				 completion:(RCPasswordlessLoginLoginBlock)completionBlock;

/*!
 Login convenience method
 
 @discussion You can call this method any time and it updates the server with the new info
 
 @param email
 @param facebookID
 @param extraInfo Extra info that you want to send to the server
 @param completionBlock
 */
- (void)loginWithEmail:(NSString *)email
			facebookID:(NSNumber *)facebookID
			 extraInfo:(NSDictionary *)info
			completion:(RCPasswordlessLoginLoginBlock)completionBlock;

/*!
 Remove this device from server
 */
- (void)unregisterThisDevice;

@end
