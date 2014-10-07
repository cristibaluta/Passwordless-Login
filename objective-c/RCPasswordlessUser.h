//
//  RCPasswordlessUser.h
//  RCLogin
//
//  Created by Baluta Cristian on 30/09/14.
//
//

#import <Foundation/Foundation.h>

@interface RCPasswordlessUser : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *email;

@end
