//
//  ActionViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "ActionViewController.h"
#import "AppDelegate.h"
#import "FBNetworkReachability.h"

@interface ActionViewController ()

@end

@implementation ActionViewController
@synthesize textView;
@synthesize mailButton;
@synthesize tweetButton;

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
    [textView setEditable:NO];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.cornerRadius = 10;
    textView.clipsToBounds = YES;
    twitterAccounts = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    FBNetworkReachabilityConnectionMode mode = [FBNetworkReachability sharedInstance].connectionMode;
    if (mode == FBNetworkReachableNon) {
        [self alert:@"エラー" withMessage:@"インターネットに接続されていません。"];
        [mailButton setHidden:YES];
        [tweetButton setHidden:YES];
    } else {
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString* sentence = [delegate.homeViewController getSentence];
        if (sentence != nil && [sentence length] != 0) {
            if (twitterAccounts == nil) {
                [self prepareTweet];
            }
            [textView setText:sentence];
            if ([MFMailComposeViewController canSendMail]) {
                [mailButton setHidden:NO];
                [mailButton setEnabled:YES];
            } else {
                [mailButton setEnabled:NO];
                [mailButton setHidden:YES];
            }
            if (twitterAccounts != nil && [twitterAccounts count] > 0) {
                [tweetButton setHidden:NO];
                [tweetButton setEnabled:YES];
            } else {
                [tweetButton setEnabled:NO];
                [tweetButton setHidden:YES];
            }
        } else {
            [textView setText:@"テキストが生成されていません。"];
            [mailButton setEnabled:NO];
            [tweetButton setEnabled:NO];
            [mailButton setHidden:YES];
            [tweetButton setHidden:YES];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) prepareTweet {
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (granted) {
                 twitterAccounts = [[NSMutableArray alloc] init];
                 NSArray* accounts = [accountStore accountsWithAccountType:accountType];
                 if (accounts != nil && [accounts count] > 0) {
                     for (int i = 0; i < [accounts count]; i++) {
                         ACAccount* account = (ACAccount*)[accounts objectAtIndex:i];
                         [twitterAccounts addObject:[account identifier]];
                     }
                     [tweetButton setHidden:NO];
                     [tweetButton setEnabled:YES];
                 }
             } else {
                 twitterAccounts = nil;
             }
         });
     }];
}
- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error {
    // メールの送信結果がどうであっても何もしない
    switch (result){
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
        case MFMailComposeResultFailed:
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void) alert:(NSString*)title withMessage:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    
    [alert show];
}
- (void) mail {
    MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
    [mailer setMailComposeDelegate:self];
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* sentence = [delegate.homeViewController getSentence];
    [mailer setMessageBody:sentence isHTML:NO];
    [self presentModalViewController:mailer animated:YES];
}
- (void) tweetWithAccount:(NSString*) account {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary* parameter = [NSDictionary dictionaryWithObject:[delegate.homeViewController getSentence] forKey:@"status"];
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    TWRequest* request = [[TWRequest alloc] initWithURL:url parameters:parameter requestMethod:TWRequestMethodPOST];
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    request.account = [accountStore accountWithIdentifier:account];
    // TODO インジケータ
    TWRequestHandler requestHandler = ^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // TODO インジケータ隠す
            if (error != nil) {
            }
        });
    };
    [request performRequestWithHandler:requestHandler];
}
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([twitterAccounts count] > buttonIndex) {
        [self tweetWithAccount:[twitterAccounts objectAtIndex:buttonIndex]];
    }
}
- (void) tweet {
    if (twitterAccounts != nil && [twitterAccounts count] > 0) {
        if ([twitterAccounts count] > 1) {
            if (accountSelector != nil && [accountSelector isVisible]) {
                [accountSelector dismissWithClickedButtonIndex:-1 animated:YES];
            } else {
                accountSelector = [[UIActionSheet alloc] init];
                [accountSelector setDelegate:self];
                accountSelector.title = @"アカウントを選択";
                for (ACAccount* account in twitterAccounts) {
                    [accountSelector addButtonWithTitle:account.username];
                }
                [accountSelector addButtonWithTitle:@"キャンセル"];
                [accountSelector setCancelButtonIndex:[twitterAccounts count]];
                [accountSelector showInView:self.view];
            }
        } else {
            [self tweetWithAccount:[twitterAccounts objectAtIndex:0]];
        }
    }
}
@end
