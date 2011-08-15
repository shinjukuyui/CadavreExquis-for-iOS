//
//  CadavreExquis4iOSViewController.h
//  CadavreExquis4iOS
//
//  Created by shinjuku yui on 11/08/13.
//  Copyright 2011年 Tragile Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CadavreExquis4iOSViewController : UIViewController {
    NSString* sentence;
    NSArray* nouns;
    NSArray* qualifications;
    NSArray* sentences;
}
@property (nonatomic, retain) IBOutlet UITextView* textView;
-(IBAction)create;
@end
