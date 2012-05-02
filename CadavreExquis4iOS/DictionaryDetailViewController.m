//
//  DictionaryDetailViewController.m
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/05/02.
//  Copyright (c) 2012年 Puella-Ex-Machina. All rights reserved.
//

#import "DictionaryDetailViewController.h"
#import "Dictionary.h"

@interface DictionaryDetailViewController ()

@end

@implementation DictionaryDetailViewController
@synthesize table;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    [table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [proxy counts:@"Dictionary" withType:0];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSUInteger row = [indexPath row];
    Dictionary* dictionary = (Dictionary*)[proxy selectAt:@"Dictionary" withType:0 ascending:NO indexOf:row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dictionary.sentence;
    return cell;
}	 
- (IBAction) edit {
    // TODO
}
- (IBAction) add {
    // TODO
}
@end
