//
//  SecondViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface HistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    DictionaryProxy* proxy;
    UITableView* historyTable;
}
@property(strong, nonatomic) IBOutlet UITableView* historyTable;

@end
