//
//  DictionaryAddViewController.m
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

#import "DictionaryAddViewController.h"
#import "Dictionary.h"

@interface DictionaryAddViewController ()

@end

@implementation DictionaryAddViewController
@synthesize textView;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    proxy = [DictionaryProxy sharedInstance];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    switch ([type intValue]) {
        case 0:
            self.title = @"テンプレート登録";
            break;
        case 1:
            self.title = @"名詞登録";
            break;
        default:
            self.title = @"形容詞登録";
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)add {
    if ([textView.text length] > 0) {
        // TODO 入力されたテキストのチェック：末尾の句読点を削除、全角の＊と＃は半角に変換
        Dictionary* last = (Dictionary*)[proxy select:@"Dictionary" withType:-1 isRandom:NO withLimit:1 ascending:NO];
        Dictionary* entry = (Dictionary*)[proxy newEntity:@"Dictionary"];
        [entry setId:[NSNumber numberWithInt:[last.id intValue] + 1]];
        [entry setInitial:[NSNumber numberWithBool:YES]];
        [entry setInUse:[NSNumber numberWithBool:YES]];
        [entry setSentence:textView.text];
        [entry setType:self.type];
        [proxy save];
        [textView setText:@""];
    }
}
@end
