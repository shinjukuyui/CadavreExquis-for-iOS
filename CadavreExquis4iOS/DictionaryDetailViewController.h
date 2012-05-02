//
//  DictionaryDetailViewController.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/02.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface DictionaryDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    DictionaryProxy* proxy;
    UITableView* table;
}
@property(strong, nonatomic) IBOutlet UITableView* table;
- (IBAction) edit;
- (IBAction) add;
@end
