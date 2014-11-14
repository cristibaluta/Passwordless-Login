//
//  RCPasswordlessUser.h
//  RCLogin
//
//  Created by Baluta Cristian on 30/09/14.
//
//

#import <Foundation/Foundation.h>

/*!
 @class RCPasswordlessUser
 
 @abstract
 The RCPasswordlessUser object contains info of a device belonging to the same user.
 You know is the same user if it has the same e-mail or facebookID
 */
@interface RCPasswordlessUser : NSObject

/*!
 - uuid is the unique identifier provided by Apple for each app
 - If the device is not an Apple device, uuid is a random string that is kept persistently
 */
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *email;

@end
