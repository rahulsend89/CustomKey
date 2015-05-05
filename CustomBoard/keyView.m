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
    for (UIButton *btn in self.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            if(btn.tag == 1){
                [self.allButtons addObject:btn];
            }
        }
    }
}
-(void)updateValues{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.myKey"];
    int i=0;
    for (UIButton *btn in self.allButtons) {
        NSString *str = [NSString stringWithFormat:@"val%d",i];
        [btn setTitle:[defaults valueForKey:str] forState:UIControlStateNormal];
        i++;
    }
}
@end
