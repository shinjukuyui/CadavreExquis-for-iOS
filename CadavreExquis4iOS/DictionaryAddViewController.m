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

#import <QuartzCore/QuartzCore.h>
#import "DictionaryAddViewController.h"
#import "Dictionary.h"

@interface DictionaryAddViewController ()

@end

@implementation DictionaryAddViewController
@synthesize textView;
@synthesize label;
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
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.cornerRadius = 10;
    textView.clipsToBounds = YES;
    [textView setDelegate:self];
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
- (BOOL)textView:(UITextView*)view shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if (view.text.length + text.length > 60) {
        [label setText:@"0"];
        return NO;
    }
    int remain = 60 - (view.text.length + text.length);
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
        Dictionary* last = (Dictionary*)[proxy select:@"Dictionary" withType:-1 isRandom:NO withLimit:1 ascending:NO];
        Dictionary* entry = (Dictionary*)[proxy newEntity:@"Dictionary"];
        [entry setId:[NSNumber numberWithInt:[last.id intValue] + 1]];
        [entry setInitial:[NSNumber numberWithBool:YES]];
        [entry setInUse:[NSNumber numberWithBool:YES]];
        [entry setSentence:[self checkSentence:textView.text]];
        [entry setType:self.type];
        [proxy save];
        [textView setText:@""];
    }
}
@end
