//
//  DictionaryAddViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface DictionaryAddViewController : UIViewController {
    DictionaryProxy* proxy;
    UITextView* textView;
    NSNumber* type;
}
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property(strong, nonatomic) IBOutlet NSNumber* type;
- (IBAction)add;
@end
