//
//  MyModal.m
//  CustomKey
//
//  Created by Rahul Malik on 17/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "MyModal.h"
#define defaultsVal @"firstStart"
@implementation MyModal
+ (MyModal*)sharedInstance{
    static id sharedInstance = nil;
    if (sharedInstance == nil){
        sharedInstance = [[MyModal alloc] init];
    }
    return sharedInstance;
}
-(void)initMyDBIfNeeded{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    if(![defaults boolForKey:defaultsVal]){
        [self resetData];
    }
}
-(void)resetData{
    NSArray *defaultData = @[@"Bus Started",@"Srishti",@"Reaching Highway",@"Highway",@"Reaching Toll",@"Crossing Toll",@"Rivali park",@"Sai Dham",@"Growels"];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    [defaults setInteger:9 forKey:@"maxLen"];
    [defaults synchronize];
    for (int i =0; i<9; i++) {
        NSString *strVal = [NSString stringWithFormat:@"val%d",i];
        [defaults setObject:[defaultData objectAtIndex:i] forKey:strVal];
        [defaults synchronize];
    }
    [defaults setBool:YES forKey:defaultsVal];
    [defaults synchronize];
}

//Notification Helper function

-(void)updateValuesWithString:(NSString*)myString forKey:(NSString*)key{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    int i=0;
    NSArray *array = [myString componentsSeparatedByString:@"\n"];
    for (NSString *childString in array) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        if(![childString isEqual:@""]){
            [defaults setObject:childString forKey:str];
            [defaults synchronize];
            i++;
        }
    }
    [defaults setInteger:i forKey:@"maxLen"];
    [defaults synchronize];
    [self sendNotificationForMessageWithIdentifier:NSUserDefaultsDidChangeNotification];
}
- (void)registerForNotificationsWithIdentifier:(NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterAddObserver(center,
                                    (__bridge const void *)(self),
                                    NotificationCallback,
                                    str,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)unregisterForNotificationsWithIdentifier:(NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterRemoveObserver(center,
                                       (__bridge const void *)(self),
                                       str,
                                       NULL);
}

void NotificationCallback(CFNotificationCenterRef center,
                          void * observer,
                          CFStringRef name,
                          void const * object,
                          CFDictionaryRef userInfo) {
    NSString *identifier = (__bridge NSString *)name;
    [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDefaultsDidChangeNotification
                                                        object:nil
                                                      userInfo:@{@"identifier" : identifier}];
}
- (void)sendNotificationForMessageWithIdentifier:(NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFDictionaryRef const userInfo = NULL;
    BOOL const deliverImmediately = YES;
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterPostNotification(center, str, NULL, userInfo, deliverImmediately);
}
-(void)removeAllNotification{
CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterRemoveEveryObserver(center, (__bridge const void *)(self));
}
@end
