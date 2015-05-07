//
//  keyView.m
//  CustomKey
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "keyView.h"

@implementation keyView
- (IBAction)keyPress:(UIButton*)sender {
    [[self delegate] KeyPressedWithString:sender.titleLabel.text];
}
- (IBAction)delete:(id)sender {
    [[self delegate] deletePress];
}
-(void)initVariables{
    self.allButtons = [NSMutableArray array];
    [self addButtons];
}
- (UIButton *)buttonWithTitle:(NSString *)title target:(id)target selector:(SEL)inSelector frame:(CGRect)frame :(int)fontSize{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.userInteractionEnabled = YES;
    button.titleLabel.shadowOffset    = CGSizeMake (1.0, 0.0);
    button.backgroundColor = [UIColor whiteColor];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:inSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)addButtons{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    NSInteger maxlength = [defaults integerForKey:@"maxLen"];
    CGFloat ypos = 0.0f;
    CGFloat xspace = 5.0f;
    CGFloat yspace = 5.0f;
    CGFloat xpos = xspace;
    [[self  myScrollView] setNeedsLayout];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat width = ((screenSize.width/2)-(xspace*2))-(53.0f/2);
    CGFloat height = 40.0f;
    for (int i=0; i<=maxlength; i++) {
        if(i%2==0){
            xpos = xspace;
            ypos += yspace+height;
        }else{
            xpos+= xspace+width;
        }
        CGRect buttonRect = CGRectMake(xpos, ypos, width, height);
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        NSString *buttonString = [defaults valueForKey:str];
        UIButton *button = nil;
        if([buttonString length]<=1){
            button = [self buttonWithTitle:@"Delete" target:self selector:@selector(keyPress:) frame:buttonRect :i];
        }else{
            button = [self buttonWithTitle:buttonString target:self selector:@selector(keyPress:) frame:buttonRect :i];
        }
        [self.myScrollView addSubview:button];
        [self.myScrollView setContentInset:UIEdgeInsetsMake(-height, self.myScrollView.frame.origin.y, ypos+(height+(yspace*i))-height, self.myScrollView.frame.size.width+100.0f)];
        [self.allButtons addObject:button];
    }
}
-(void)updateFrames{
    CGFloat ypos = 0.0f;
    CGFloat xspace = 5.0f;
    CGFloat yspace = 5.0f;
    CGFloat xpos = xspace;
    int i=0;
    [[self  myScrollView] setNeedsLayout];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat width = ((screenSize.width/2)-(xspace*2))-(53.0f/2);
    CGFloat height = 40.0f;
    for (UIButton *btn in self.allButtons) {
        if(i%2==0){
            xpos = xspace;
            ypos += yspace+height;
        }else{
            xpos+= xspace+width;
        }
        [btn setFrame:CGRectMake(xpos, ypos, width, height)];
        i++;
    }
}
-(void)updateValues{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    int i=0;
    int maxLen = (int)self.allButtons.count;
    for (UIButton *btn in self.allButtons) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        if(i== (maxLen-1)){
            [btn setTitle:@"Delete" forState:UIControlStateNormal];
        }else{
            [btn setTitle:[defaults valueForKey:str] forState:UIControlStateNormal];
        }
        i++;
    }
}
@end
