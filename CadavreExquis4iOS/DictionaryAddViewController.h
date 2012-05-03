//
//  DictionaryAddViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>
#import "DictionaryProxy.h"

@interface DictionaryAddViewController : UIViewController<UITextViewDelegate> {
    DictionaryProxy* proxy;
    UITextView* textView;
    UILabel* label;
    NSNumber* type;
}
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property (nonatomic, strong) IBOutlet UILabel* label;
@property(strong, nonatomic) IBOutlet NSNumber* type;
- (IBAction)add;
@end