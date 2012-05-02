//
//  AppDelegate.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "HistoryViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    HomeViewController* homeViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet HomeViewController* homeViewController;

@end
