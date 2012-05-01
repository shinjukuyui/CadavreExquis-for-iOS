//
//  AboutViewController.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/01.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    UILabel* label;    
}
@property (nonatomic, strong) IBOutlet UILabel* label;
- (IBAction)help;
@end
