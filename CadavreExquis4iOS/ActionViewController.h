//
//  ActionViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ActionViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    UITextView* textView;
    UIButton* mailButton;
    UIButton* tweetButton;
}
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property (nonatomic, strong) IBOutlet UIButton* mailButton;
@property (nonatomic, strong) IBOutlet UIButton* tweetButton;
- (IBAction)mail;
- (IBAction)tweet;
@end
