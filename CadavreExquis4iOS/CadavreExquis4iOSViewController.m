//
//  CadavreExquis4iOSViewController.m
//  CadavreExquis4iOS
//
//  テクスト生成アルゴリズム及び辞書データの著作権はAkiyoshi Sumi氏に属します。
//  Created by shinjuku yui on 11/08/13.
//  Copyrught © 1994 by Akiyoshi Sumi All Rights reserved.
//  Copyright 2011年 Tragile Eden. All rights reserved.
//

#import "CadavreExquis4iOSViewController.h"
#import "Dictionary.h"
#import "History.h"

@implementation CadavreExquis4iOSViewController
@synthesize textView;

#pragma mark - dictionary licensed by 
- (void) initialize {
    sentence = nil;
    proxy = [DictionaryProxy sharedInstance];
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
#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView setEditable:NO];
    [textView setOpaque:YES];
    [textView setTextAlignment:UITextAlignmentCenter];
    [textView setTextColor:[UIColor grayColor]];
    [textView setText:@"タップして開始"];
    textView.alpha = 0.8;
    [self adjust];
    [self initialize];
//    [self createInitialData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - core data initialize methods
- (void) createInitialData {
    // CoreDataの初期データ作成用メソッド：配列から初期データを作る
    int id = 0;
    for (int i = 0; i < 3; i++) {
        NSArray* target = nil;
        switch (i) {
            case 0:
                target = sentences;
                break;
            case 1:
                target = nouns;
                break;
            case 2:
                target = qualifications;
                break;
        }
        for (int j = 0; j < [target count]; j++) {
            Dictionary* dictionary = (Dictionary* )[proxy newEntity:@"Dictionary"];
            [dictionary setInitial:[NSNumber numberWithBool:YES]];
            [dictionary setInUse:[NSNumber numberWithBool:YES]];
            [dictionary setSentence:[target objectAtIndex:j]];
            [dictionary setType:[NSNumber numberWithInt:(i)]];
            [dictionary setId:[NSNumber numberWithInt:(id)]];
            id++;
        }
    }
    [proxy save];
}
#pragma mark - methods
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
-(void) reset {
    textView.alpha = 0.0;
}
-(void) adjust {
    CGRect frame = [textView frame];
    CGSize size = [textView contentSize];
    frame.size.height = size.height;
    float height = [[UIScreen mainScreen] applicationFrame].size.height;
    float offset = (height - size.height) / 2;
    frame.origin.y = offset;
    [textView setFrame:frame];
}
-(void) redraw {
    [UIView animateWithDuration:2.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         textView.alpha = 0.8;
                     }
                     completion:nil];
}
-(IBAction) create {
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
-(IBAction) home {
}
-(IBAction) history {
}
-(IBAction) manage {
}
-(IBAction) post {
}
-(IBAction) about {
}
@end
