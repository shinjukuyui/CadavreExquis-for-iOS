//
//  FirstViewController.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DictionaryProxy.h"
#import "BackgroundView.h"
#import "HistoryView.h"

@interface HomeViewController : UIViewController {
    NSString* sentence;
    NSArray* nouns;
    NSArray* qualifications;
    NSArray* sentences;
    DictionaryProxy* proxy;
    UIActionSheet* postAction;
    UIView* currentView;
}
@property (nonatomic, strong) IBOutlet BackgroundView* backgroundView;
@property (nonatomic, strong) IBOutlet UITextView* textView;
- (IBAction) create;
- (NSString*) getSentence;
@end
