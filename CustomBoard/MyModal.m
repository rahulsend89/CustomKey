//
//  MyModal.m
//  CustomKey
//
//  Created by Rahul Malik on 17/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "MyModal.h"
#define defaultsVal @"firstStart"
#define maxLenKey @"maxLen"
#define defaultKeyGroup @"defaultKeyGroup"
NSString * const kGroupKey = @"group.myKey";
@implementation MyModal
+ (MyModal*)sharedInstance{
    static id sharedInstance = nil;
    if (sharedInstance == nil){
        sharedInstance = [[MyModal alloc] init];
    }
    return sharedInstance;
}
-(void)initMyDBIfNeeded{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    if(![defaults boolForKey:defaultsVal]){
        [self resetData];
    }
}
-(NSString*)getValueForKey:(NSString*)defaultKey{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    if (!defaultKey) {
        defaultKey = [defaults valueForKey:defaultKeyGroup];
    }
    NSMutableString *appendString = [NSMutableString stringWithString:@""];
    NSInteger maxlength = [defaults integerForKey:[NSString stringWithFormat:@"%@:%@",defaultKey,maxLenKey]];
    if(!maxlength){
        [[MyModal sharedInstance] initMyDBIfNeeded];
    }
    for (int i=0; i<maxlength; i++) {
        NSString *str = [NSString stringWithFormat:@"%@:val%d",defaultKey,i];
        [appendString appendString:[defaults valueForKey:str]];
        [appendString appendString:@"\n"];
    }
    return appendString;
}
-(NSString *)getDefaultKeyGroup{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    NSString *defaultKey = [defaults valueForKey:defaultKeyGroup];
    if (!defaultKey) {
        [defaults setValue:@"Default" forKey:defaultKeyGroup];
        [defaults synchronize];
        defaultKey = @"Default";
    }
    
    return defaultKey;
}
-(void)setDefaultKeyGroup:(NSString*)defaultKey{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    [defaults setValue:defaultKey forKey:defaultKeyGroup];
    [defaults synchronize];
}
-(void)resetData{
    NSString *defaultKey = @"Default";
    NSArray *defaultData = @[@"Bus Started",@"Srishti",@"Highway",@"Toll",@"Gokul Anand",@"National Park",@"Rivali park",@"Sai Dham",@"Growels"];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    [defaults setInteger:9 forKey:[NSString stringWithFormat:@"%@:maxLen",defaultKey]];
    [defaults synchronize];
    for (int i =0; i<9; i++) {
        NSString *strVal = [NSString stringWithFormat:@"%@:val%d",defaultKey,i];
        [defaults setObject:[defaultData objectAtIndex:i] forKey:strVal];
        [defaults synchronize];
    }
    [defaults setValue:defaultKey forKey:defaultKeyGroup];
    [defaults setBool:YES forKey:defaultsVal];
    [defaults synchronize];
}

//Notification Helper function

-(void)updateValuesWithString:(NSString*)myString forKey:(NSString*)defaultKey{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupKey];
    if (!defaultKey) {
        defaultKey = [defaults valueForKey:defaultKeyGroup];
    }
    int i=0;
    NSArray *array = [myString componentsSeparatedByString:@"\n"];
    for (NSString *childString in array) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        if(![childString isEqual:@""]){
            [defaults setObject:childString forKey:[NSString stringWithFormat:@"%@:%@",defaultKey,str]];
            [defaults synchronize];
            i++;
        }
    }
    [defaults setInteger:i forKey:[NSString stringWithFormat:@"%@:%@",defaultKey,maxLenKey]];
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupKey];
    //return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"keyTable" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"keyTable.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tableData" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    int maxCount = (int)[sectionInfo numberOfObjects];
    NSString *appededString = [NSString stringWithFormat:@"CustomKeyNode:%d",maxCount];
    if (!maxCount) {
        appededString = @"Default";
    }
    
    [newManagedObject setValue:appededString forKey:@"tableData"];
    [[MyModal sharedInstance] saveContext];
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
