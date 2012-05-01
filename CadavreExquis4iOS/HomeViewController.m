//
//  FirstViewController.m
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/01.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Dictionary.h"
#import "History.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize textView;
@synthesize backgroundView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [textView setEditable:NO];
    [textView setOpaque:YES];
    [textView setTextAlignment:UITextAlignmentCenter];
    [textView setTextColor:[UIColor grayColor]];
    [textView setText:@"タップして開始"];
    textView.alpha = 0.8;
    [self adjust];
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate setHomeViewController:self];
    [self initialize];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
#pragma mark - dictionary licensed by 
- (void) initialize {
    sentence = nil;
    proxy = [DictionaryProxy sharedInstance];
    currentView = backgroundView;
    // 初期データをCoreDataに入れる前の残骸
    sentences = [NSArray arrayWithObjects:@"", nil];
    nouns = [NSArray arrayWithObjects:@"", nil];
    qualifications = [NSArray arrayWithObjects:@"", nil];
}
#pragma mark - algorithm licensed by
// テクスト生成アルゴリズムはHyperCardスタック「優美なる死体 v2.1」からObjective-Cに移植しました。
// 初期辞書データはHyperCardスタック「優美なる死体 v2.1」から作成しました。
// このアルゴリズム及び諸喜寿書データの著作権はAkiyoshi Sumi氏に属します。
-(NSString*) numbering:(NSString*) target {
    BOOL isFirst = YES;
    while (YES) {
        int number = isFirst ? (rand()%9)+1 : rand()%10;
        NSRange range = [target rangeOfString:@"#"];
        if (range.location == NSNotFound) {
            break;
        }
        target = [target stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%d", number]];
        isFirst = NO;
    }
    return target;
}
-(NSString*) getSentenceFromObject:(int)type {
    NSManagedObject* object = [proxy select:@"Dictionary" withType:type isRandom:YES withLimit:1 ascending:YES];
    if (object == nil) {
        return @"";
    }
    return [object valueForKey:@"sentence"];
}
-(NSString*) createSentence {
    NSString* creating = [self getSentenceFromObject:0];
    while (YES) {
        NSRange range = [creating rangeOfString:@"*"];
        if (range.location == NSNotFound) {
            break;
        }
        NSString* noun = [self getSentenceFromObject:1];
        NSString* nounWithQualification = nil;
        int using = rand()%100;
        if (using < 75) {
            NSString* qualification = [self getSentenceFromObject:2];
            nounWithQualification = [qualification stringByAppendingString:noun];
        } else {
            nounWithQualification = noun;
        }
        nounWithQualification = [self numbering:nounWithQualification];
        creating = [creating stringByReplacingCharactersInRange:range withString:nounWithQualification];
    }
    creating = [self numbering:creating];
    if (rand()%100 < 75) {
        creating = [creating stringByAppendingString:@"。"];
    } else {
        creating = [creating stringByAppendingString:@"！"];
    }
    return creating;
}
#pragma mark - methods
- (NSString*) getSentence {
    if (sentence == nil
        || sentence.length == 0
        || [sentence isEqualToString:@"タップして開始"]) {
        return @"";
    }
    return sentence;
}
- (void) addHistory {
    History* historied = (History*)[proxy select:@"History" withType:-1 isRandom:NO withLimit:1 ascending:NO];
    int id = 0;
    if (historied != nil) {
        id = [historied.id intValue] + 1;
        if ([historied.id intValue] > 100) {
            History* removing = (History*)[proxy select:@"History" withType:-1 isRandom:NO withLimit:1 ascending:YES];
            [proxy remove:removing];
        }
    }
    History* history = (History*)[proxy newEntity:@"History"];
    [history setId:[NSNumber numberWithInt:id]];
    [history setSentence:sentence];
    [proxy save];
}
- (void) reset {
    textView.alpha = 0.0;
}
- (void) adjust {
    CGRect frame = [textView frame];
    CGSize size = [textView contentSize];
    frame.size.height = size.height;
    float height = [[UIScreen mainScreen] applicationFrame].size.height;
    float offset = (height - size.height) / 2;
    frame.origin.y = offset;
    [textView setFrame:frame];
}
- (void) redraw {
    [UIView animateWithDuration:2.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         textView.alpha = 0.8;
                     }
                     completion:nil];
}
- (IBAction) create {
    [self reset];
    sentence = [self createSentence];
    if (sentence != nil) {
        [textView setText:sentence];
        [textView setTextAlignment:UITextAlignmentLeft];
        [textView setTextColor:[UIColor blackColor]];
        [self addHistory];
        [self adjust];
        [self redraw];
    }
}
@end
