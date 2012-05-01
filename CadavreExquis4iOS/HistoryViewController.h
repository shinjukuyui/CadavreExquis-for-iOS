//
//  SecondViewController.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/01.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface HistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    DictionaryProxy* proxy;
    UITableView* historyTable;
}
@property(strong, nonatomic) IBOutlet UITableView* historyTable;

@end
