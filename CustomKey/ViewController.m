//
//  ViewController.m
//  CustomKey
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "ViewController.h"
#define defaultsVal @"firstStart1"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)saveData:(id)sender {
    [self updateValues];
}
-(void)updateValues{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    int i=0;
    NSString *myString = [self.mytext text];
    NSArray *array = [myString componentsSeparatedByString:@"\n"];
    for (NSString *childString in array) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        if(![childString isEqual:@""]){
            [defaults setObject:childString forKey:str];
            [defaults synchronize];
            i++;
        }
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
    [self initValues];
}
-(void)initValues{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    NSMutableString *appendString = [NSMutableString stringWithString:@""];
    NSInteger maxlength = [defaults integerForKey:@"maxLen"];
    if(!maxlength){
        if(![defaults boolForKey:defaultsVal]){
            [self resetData];
        }
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
