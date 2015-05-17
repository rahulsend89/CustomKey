//
//  keyView.m
//  CustomKey
//
//  Created by Rahul Malik on 03/05/15.
//  Copyright (c) 2015 Rahul Malik. All rights reserved.
//

#import "keyView.h"
#import "MyModal.h"
CGFloat const animationConst = 0.5;
CGFloat const maxTopSegmentedViewHeight = 29.0;
@interface keyView()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedView;
@property (nonatomic)CGFloat portraitHeight;
@property (nonatomic)CGFloat landscapeHeight;
@property (nonatomic)CGFloat addHeight;
@property (nonatomic)NSLayoutConstraint *heightConstraint;
@property (nonatomic)BOOL isLandscape;
@end
@implementation keyView
- (IBAction)keyPress:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"Delete"]){
        [self delete:sender];
    }else{
        NSArray *segArray = @[@"",@"Reaching",@"Crossing",@"Crossed"];
        if (![segArray[self.segmentedView.selectedSegmentIndex] isEqualToString:@""]) {
            [[self delegate] KeyPressedWithString:[NSString stringWithFormat:@"%@ %@",segArray[self.segmentedView.selectedSegmentIndex],sender.titleLabel.text]];
        }else{
            [[self delegate] KeyPressedWithString:sender.titleLabel.text];
        }
    }
}
- (IBAction)alterDefaults:(id)sender {
    self.addHeight =  (self.addHeight<20)?maxTopSegmentedViewHeight:0.0;
    if (self.isLandscape) {
        self.heightConstraint.constant = self.landscapeHeight+self.addHeight;
    } else {
        self.heightConstraint.constant = self.portraitHeight+self.addHeight;
    }
    [[self topLayoutConstraint] setConstant:self.addHeight];
    [self.segmentedView setHidden:NO];
    [UIView animateWithDuration:animationConst animations:^{
        [self segmentedView].alpha = (self.addHeight<20)?0.0:1.0;
        [self layoutIfNeeded];
    }];
}

- (void)updateViewConstraints {
    // Add custom view sizing constraints here
    if (self.frame.size.width == 0 || self.frame.size.height == 0)
        return;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenH = screenSize.height;
    CGFloat screenW = screenSize.width;
    BOOL isLandscape =  !(self.frame.size.width ==
                          (screenW*(screenW<screenH))+(screenH*(screenW>screenH)));
    NSLog(isLandscape ? @"Screen: Landscape" : @"Screen: Potriaint");
    self.isLandscape = isLandscape;
    if (isLandscape) {
        self.heightConstraint.constant = self.landscapeHeight+self.addHeight;
    } else {
        self.heightConstraint.constant = self.portraitHeight+self.addHeight;
    }
    
}


- (IBAction)delete:(id)sender {
    [[self delegate] deletePress];
}
-(void)initVariables{
    [self segmentedView].alpha = 0.0f;
    [self.segmentedView setHidden:YES];
    self.portraitHeight = 256;
    self.landscapeHeight = 203;
    self.addHeight = 0.0f;
    self.allButtons = [NSMutableArray array];
    [self addButtons];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    [[MyModal sharedInstance] registerForNotificationsWithIdentifier:NSUserDefaultsDidChangeNotification];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant: self.portraitHeight];
    
    [self addConstraint: _heightConstraint];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MyModal sharedInstance] unregisterForNotificationsWithIdentifier:NSUserDefaultsDidChangeNotification];
    [[MyModal sharedInstance] removeAllNotification];
}

-(void)didReceiveMessageNotification:(NSNotification *)notification{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    NSInteger maxlength = [defaults integerForKey:@"maxLen"];
    if(maxlength !=self.allButtons.count-1){
        for (UIButton *btn in self.allButtons) {
            [btn removeFromSuperview];
        }
        [self addButtons];
    }else{
        [self updateValues];
        [self updateFrames];
    }
    
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
        if(i ==  maxlength){
            button = [self buttonWithTitle:@"Delete" target:self selector:@selector(keyPress:) frame:buttonRect :i];
        }else{
            button = [self buttonWithTitle:buttonString target:self selector:@selector(keyPress:) frame:buttonRect :i];
        }
        [self.myScrollView addSubview:button];
        [self.myScrollView setContentInset:UIEdgeInsetsMake(-height, 0.0f, ypos+(height+(yspace*i))-height, 0.0f)];
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
    [defaults synchronize];
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
