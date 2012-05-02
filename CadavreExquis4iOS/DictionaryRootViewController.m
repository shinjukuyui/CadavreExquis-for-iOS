//
//  DictionaryRootViewController.m
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/02.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import "DictionaryRootViewController.h"

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
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
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
