//
//  KeyboardViewController.m
//  CustomBoard
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "KeyboardViewController.h"
#import "keyView.h"
#define defaultsVal @"firstStart1"
@interface KeyboardViewController ()<keyBoardDel>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic) keyView *keyboard;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboard = [[[NSBundle mainBundle] loadNibNamed:@"keyView" owner:nil options:nil] objectAtIndex:0];
    self.inputView = self.keyboard;
    [self.keyboard initVariables];
    self.keyboard.delegate = self;
    self.nextKeyboardButton = self.keyboard.nextKeyboardButton;
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    if(![defaults boolForKey:defaultsVal]){
        [self resetData];
    }
    [[self keyboard] updateValues];
}
-(void)resetData{
    NSArray *defaultData = @[@"Bus Started",@"Srishti",@"Reaching Highway",@"Highway",@"Reaching Toll",@"Crossing Toll",@"Rivali park",@"Sai Dham",@"Growels"];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    for (int i =0; i<9; i++) {
        NSString *strVal = [NSString stringWithFormat:@"val%d",i];
        [defaults setObject:[defaultData objectAtIndex:i] forKey:strVal];
        [defaults synchronize];
    }
    [defaults setBool:YES forKey:defaultsVal];
    [defaults synchronize];
    
}
-(void)KeyPressedWithString:(NSString *)string{
    [self deletePress];
    [[self textDocumentProxy] insertText:string];
}
-(void)deletePress{
    NSString *precedingContext = self.textDocumentProxy.documentContextBeforeInput;
    for (int i=0; i<precedingContext.length; i++) {
        [self.textDocumentProxy deleteBackward];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
