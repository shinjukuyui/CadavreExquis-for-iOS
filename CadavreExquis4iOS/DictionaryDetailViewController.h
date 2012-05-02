//
//  DictionaryDetailViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface DictionaryDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    DictionaryProxy* proxy;
    UITableView* table;
    NSNumber* type;
}
@property(strong, nonatomic) IBOutlet UITableView* table;
@property(strong, nonatomic) IBOutlet NSNumber* type;
- (IBAction) edit;
- (IBAction) add;
- (IBAction) remove;
@end
