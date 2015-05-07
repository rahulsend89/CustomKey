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
@end
@interface keyView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nextKeyboardButton;
@property (nonatomic) id<keyBoardDel> delegate;
@property (nonatomic) NSMutableArray *allButtons;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
-(void)initVariables;
-(void)updateValues;
-(void)updateFrames;
@end

