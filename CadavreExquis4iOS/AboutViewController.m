//
//  AboutViewController.m
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize label;

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
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 7;
    label.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)help {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://tragile-eden.jp/works/cadavreExquis4iOS/"]]; 
}
@end
