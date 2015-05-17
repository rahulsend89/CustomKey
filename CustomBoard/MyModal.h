//
//  MyModal.h
//  CustomKey
//
//  Created by Rahul Malik on 17/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModal : NSObject
+ (MyModal*)sharedInstance;
-(void)initMyDBIfNeeded;
-(void)updateValuesWithString:(NSString*)myString forKey:(NSString*)key;
- (void)registerForNotificationsWithIdentifier:(NSString *)identifier;
- (void)unregisterForNotificationsWithIdentifier:(NSString *)identifier;
-(void)removeAllNotification;
@end
