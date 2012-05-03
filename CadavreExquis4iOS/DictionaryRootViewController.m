//
//  DictionaryRootViewController.m
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

#import "DictionaryRootViewController.h"
#import "DictionaryDetailViewController.h"

@interface DictionaryRootViewController ()

@end

@implementation DictionaryRootViewController
@synthesize templates;
@synthesize nouns;
@synthesize qualifications;

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
    [templates setText:[NSString stringWithFormat:@"%d", [proxy counts:@"Dictionary" withType:0]]];
    [nouns setText:[NSString stringWithFormat:@"%d", [proxy counts:@"Dictionary" withType:1]]];
    [qualifications setText:[NSString stringWithFormat:@"%d", [proxy counts:@"Dictionary" withType:2]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DictionaryDetailViewController *controller = (DictionaryDetailViewController*)[segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"templates"]) {
        [controller setType:[NSNumber numberWithInt:0]];
    } else if ([[segue identifier] isEqualToString:@"nouns"]) {
        [controller setType:[NSNumber numberWithInt:1]];
    } else {
        [controller setType:[NSNumber numberWithInt:2]];
    }
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            // TODO 初期化の仕方：既にデータがロードされている状態でstoreを削除してファイルを元に戻そうとしたらうまくいかなかった
            [proxy initializeData];
            break;
    }
}
- (IBAction)initialize {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"初期化"
                                                    message:@"初期化すると登録済みのデータと履歴が全て失われます。よろしいですか。"
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"初期化",nil];
    [alert show];
}

@end
