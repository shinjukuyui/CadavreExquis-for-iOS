//
//  ActionViewController.m
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "ActionViewController.h"
#import "AppDelegate.h"

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
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* sentence = [delegate.homeViewController getSentence];
    if (sentence != nil && [sentence length] != 0) {
        [textView setText:sentence];
        if ([MFMailComposeViewController canSendMail]) {
            [mailButton setEnabled:YES];
        } else {
            [mailButton setEnabled:NO];
        }
        // TODO
        BOOL canTweet = NO;
        if (canTweet) {
            [tweetButton setEnabled:YES];
        } else {
            [tweetButton setEnabled:NO];
        }
    } else {
        [textView setText:@"テキストが生成されていません。"];
        [mailButton setEnabled:NO];
        [tweetButton setEnabled:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void) tweet {
    // TODO
}
@end
