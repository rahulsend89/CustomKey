//
//  ViewController.m
//  CustomKey
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "ViewController.h"
#import "MyModal.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)saveData:(id)sender {
    [[MyModal sharedInstance] updateValuesWithString:[self.mytext text] forKey:@""];
}
-(void)initValues{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    NSMutableString *appendString = [NSMutableString stringWithString:@""];
    NSInteger maxlength = [defaults integerForKey:@"maxLen"];
    if(!maxlength){
        [[MyModal sharedInstance] initMyDBIfNeeded];
    }
    for (int i=0; i<maxlength; i++) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        [appendString appendString:[defaults valueForKey:str]];
        [appendString appendString:@"\n"];
    }
    [self.mytext setText:appendString];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
