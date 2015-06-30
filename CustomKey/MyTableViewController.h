//
//  MyTableViewController.h
//  CustomKey
//
//  Created by Malik, Rahul (US - Mumbai) on 6/30/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModal.h"
#import <CoreData/CoreData.h>

@interface MyTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
