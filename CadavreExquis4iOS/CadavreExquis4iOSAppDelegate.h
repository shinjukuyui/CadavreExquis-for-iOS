//
//  CadavreExquis4iOSAppDelegate.h
//  CadavreExquis4iOS
//
//  Created by shinjuku yui on 11/08/13.
//  Copyright 2011年 Tragile Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CadavreExquis4iOSViewController;

@interface CadavreExquis4iOSAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CadavreExquis4iOSViewController *viewController;

@end
