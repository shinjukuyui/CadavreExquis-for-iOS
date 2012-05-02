//
//  DictionaryRootViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
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
