//
//  ActionViewController.m
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
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
    textView.layer.cornerRadius = 7;
    textView.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    FBNetworkReachabilityConnectionMode mode = [FBNetworkReachability sharedInstance].connectionMode;
    if (mode == FBNetworkReachableNon) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"共有するにはネットワークに接続してください。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"初期化",nil];
        [alert show];
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
                [mailButton setEnabled:YES];
            } else {
                [mailButton setEnabled:NO];
                [mailButton setHidden:YES];
            }
            if (twitterAccounts != nil && [twitterAccounts count] > 0) {
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
                 twitterAccounts = [accountStore accountsWithAccountType:accountType];
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
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
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
- (void) tweetWithAccount:(ACAccount*) account {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *parameter = [NSDictionary dictionaryWithObject:[delegate.homeViewController getSentence] forKey:@"status"];
    NSURL *turl = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    TWRequest *request = [[TWRequest alloc] initWithURL:turl parameters:parameter requestMethod:TWRequestMethodPOST];
    request.account = account;
    // TODO インジケータ
    TWRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // TODO インジケータ隠す
            if (error != nil) {
            }
        });
    };
    [request performRequestWithHandler:requestHandler];
}
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([twitterAccounts count] != buttonIndex) {
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
                accountSelector.title = @"アカウントを選択してください。";
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
