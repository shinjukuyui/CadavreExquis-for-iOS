//
//  DictionaryRootViewController.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/02.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface DictionaryRootViewController : UITableViewController {
    DictionaryProxy* proxy;
    UILabel* templates;
    UILabel* nouns;
    UILabel* qualifications;
}
@property(strong, nonatomic) IBOutlet UILabel* templates;
@property(strong, nonatomic) IBOutlet UILabel* nouns;
@property(strong, nonatomic) IBOutlet UILabel* qualifications;
- (IBAction)initialize;
@end
