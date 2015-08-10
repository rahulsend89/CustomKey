//
//  keyView.h
//  CustomKey
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol keyBoardDel <NSObject>

-(void)KeyPressedWithString:(NSString*)string;
-(void)deletePress;
@optional
-(void)ChangeGroupDefault;
@end
@interface keyView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nextKeyboardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (nonatomic) id<keyBoardDel> delegate;
@property (nonatomic) NSMutableArray *allButtons;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
-(void)didReceiveMessageNotification:(NSNotification *)notification;
-(void)initVariables;
-(void)updateValues;
-(void)updateFrames;
@end

