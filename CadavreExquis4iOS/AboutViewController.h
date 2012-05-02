//
//  AboutViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    UILabel* label;    
}
@property (nonatomic, strong) IBOutlet UILabel* label;
- (IBAction)help;
@end
