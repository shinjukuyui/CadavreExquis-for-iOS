//
//  TextView.m
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/04/30.
//  Copyright (c) 2012年 Tragile Eden. All rights reserved.
//

#import "TextView.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation TextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.homeViewController create];
}

@end
