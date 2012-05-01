//
//  AppDelegate.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/01.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
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
