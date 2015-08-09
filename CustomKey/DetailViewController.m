//
//  DetailViewController.m
//  TableTest
//
//  Created by Malik, Rahul (US - Mumbai) on 6/30/15.
//  Copyright (c) 2015 Malik, Rahul (US - Mumbai). All rights reserved.
//

#import "DetailViewController.h"
#import "MyModal.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (IBAction)SaveDataDidPressed:(UIButton *)sender {
    NSString *keyVal = [[self.detailItem valueForKey:@"tableData"] description];
    [[MyModal sharedInstance] updateValuesWithString:self.detailDescriptionLabel.text forKey:keyVal];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *keyVal = [[self.detailItem valueForKey:@"tableData"] description];
        self.detailDescriptionLabel.text = [[MyModal sharedInstance] getValueForKey:keyVal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
