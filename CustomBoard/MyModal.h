//
//  MyModal.h
//  CustomKey
//
//  Created by Rahul Malik on 17/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
FOUNDATION_EXPORT NSString *const kGroupKey;
@interface MyModal : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSMutableArray *defaultConstGroupAr;
@property (nonatomic) NSString *defaultConstGroup;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


+ (MyModal*)sharedInstance;
-(void)initMyDBIfNeeded;
- (void)insertNewObject:(id)sender;
-(NSString*)getValueForKey:(NSString*)defaultKey;
-(void)updateValuesWithString:(NSString*)myString forKey:(NSString*)defaultKey;
- (void)registerForNotificationsWithIdentifier:(NSString *)identifier;
- (void)unregisterForNotificationsWithIdentifier:(NSString *)identifier;
-(void)removeAllNotification;
-(NSString *)getDefaultKeyGroup;
-(void)changeMyDefaultGroup:(void(^)(BOOL val))callBack;
@end
