//
//  DictionaryAddViewController.m
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden*. All rights reserved.
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
@synthesize label;
@synthesize messageView;
@synthesize type;
@synthesize selectedId;
@synthesize selectedText;

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
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.clipsToBounds = YES;
    [textView setEditable:YES];
    [textView setDelegate:self];
    [textView setReturnKeyType:UIReturnKeyDone];
    [textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [textView.textContainer setLineFragmentPadding:0];
//    UIEdgeInsets edge = textView.textContainerInset;
//    NSLog(@"%f, %f, %f, %f, %f", edge.top, edge.left, edge.bottom, edge.right, textView.textContainer.lineFragmentPadding); // -> 0, 0, 0, 0, 5
    [messageView setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    switch ([type intValue]) {
        case 0:
            self.title = NSLocalizedString(@"Templates", nil);
            maxLength = 60;
            break;
        case 1:
            self.title = NSLocalizedString(@"Nouns", nil);
            maxLength = 20;
            break;
        default:
            self.title = NSLocalizedString(@"Qualifications", nil);
            maxLength = 20;
            break;
    }
    [textView setText:selectedText];
    [label setText:[[NSNumber numberWithInt:(maxLength - [textView.text length])] stringValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textView:(UITextView*)view shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (view.text.length + text.length - range.length > maxLength) {
        [label setText:@"0"];
        return NO;
    }
    int remain = maxLength - (view.text.length + text.length - range.length);
    [label setText:[[NSNumber numberWithInt:remain] stringValue]];
    return YES;
}
-(NSString*) removeSuffix:(NSString*)sentence suffix:(NSString*)suffix {
    if ([sentence hasSuffix:suffix]) {
        NSRange range = [sentence rangeOfString:suffix options:NSBackwardsSearch];
        sentence = [sentence stringByReplacingOccurrencesOfString:sentence withString:suffix options:0 range:range];
    }
    return sentence;
}
-(NSString*) checkSentence:(NSString*)sentence {
    sentence = [sentence stringByReplacingOccurrencesOfString:@"＊" withString:@"*"];
    sentence = [sentence stringByReplacingOccurrencesOfString:@"＃" withString:@"#"];
    sentence = [self removeSuffix:sentence suffix:@"、"];
    sentence = [self removeSuffix:sentence suffix:@"。"];
    sentence = [self removeSuffix:sentence suffix:@"，"];
    sentence = [self removeSuffix:sentence suffix:@"．"];
    sentence = [self removeSuffix:sentence suffix:@"？"];
    sentence = [self removeSuffix:sentence suffix:@"！"];
    sentence = [self removeSuffix:sentence suffix:@","];
    sentence = [self removeSuffix:sentence suffix:@"."];
    sentence = [self removeSuffix:sentence suffix:@"?"];
    sentence = [self removeSuffix:sentence suffix:@"!"];
    return sentence;
}
-(IBAction)add {
    if ([textView.text length] > 0) {
        Dictionary* entry = nil;
        if (selectedId != nil && [selectedId length] > 0) {
            entry = (Dictionary*)[proxy selectById:@"Dictionary" byId:[selectedId intValue]];
        } else {
            Dictionary* last = (Dictionary*)[proxy select:@"Dictionary" withType:-1 isRandom:NO withLimit:1 ascending:NO];
            entry = (Dictionary*)[proxy newEntity:@"Dictionary"];
            [entry setId:[NSNumber numberWithInt:[last.id intValue] + 1]];
            [entry setInitial:[NSNumber numberWithBool:YES]];
            [entry setInUse:[NSNumber numberWithBool:YES]];
            [entry setType:self.type];
        }
        [entry setSentence:[self checkSentence:textView.text]];
        [proxy save];
        [textView setText:@""];
        messageView.alpha = 0;
        [messageView setHidden:NO];
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             messageView.alpha = 0.8;
                         }
                         completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(dismissMessage:)
                                       userInfo:nil
                                        repeats:NO];
    }
}
-(void) dismissMessage:(NSTimer*) timer {
    [timer invalidate];
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         messageView.alpha = 0.0;
                         [messageView setHidden:YES];
                     }
                     completion:nil];
}
@end
