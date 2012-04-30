//
//  CadavreExquis4iOSAppDelegate.h
//  CadavreExquis4iOS
//
//  Created by shinjuku yui on 11/08/13.
//  Copyright 2011年 Tragile Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundView.h"

@class CadavreExquis4iOSViewController;

@interface CadavreExquis4iOSAppDelegate : NSObject <UIApplicationDelegate> {
    CadavreExquis4iOSViewController* viewController;
    BackgroundView* backgroundView;
}

@property (nonatomic, strong) IBOutlet UIWindow* window;
@property (nonatomic, strong) IBOutlet CadavreExquis4iOSViewController* viewController;
@property (nonatomic, strong) IBOutlet BackgroundView* backgroundView;

@end
