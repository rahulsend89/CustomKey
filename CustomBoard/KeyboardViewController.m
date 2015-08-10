//
//  KeyboardViewController.m
//  CustomBoard
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "KeyboardViewController.h"
#import "keyView.h"
#import "MyModal.h"
#define defaultsVal @"firstStart1"
@interface KeyboardViewController ()<keyBoardDel>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic) keyView *keyboard;


@property (nonatomic) CGFloat portraitHeight;
@property (nonatomic) CGFloat landscapeHeight;
@property (nonatomic) BOOL isLandscape;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) NSLayoutConstraint *widthConstraint;
@property (nonatomic) NSMutableArray *defaultConstGroupAr;
@property (nonatomic) NSString *defaultConstGroup;

@end

@implementation KeyboardViewController


- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboard = [[[NSBundle mainBundle] loadNibNamed:@"keyView" owner:nil options:nil] objectAtIndex:0];
    self.inputView = (id)self.keyboard;
    [self.keyboard initVariables];
    self.keyboard.delegate = self;
    self.nextKeyboardButton = self.keyboard.nextKeyboardButton;
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    [[MyModal sharedInstance] initMyDBIfNeeded];
    [[self keyboard] updateValues];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[self keyboard] updateFrames];
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
-(void)ChangeGroupDefault{
    [[MyModal sharedInstance] changeMyDefaultGroup:^(BOOL val) {
        if (val) {
            [[self keyboard] didReceiveMessageNotification:nil];
        }
    }];
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
