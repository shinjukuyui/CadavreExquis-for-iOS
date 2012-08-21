//
//  SecondViewController.m
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

#import "HistoryViewController.h"
#import "ActionViewController.h"
#import "AppDelegate.h"
#import "History.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize historyTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    proxy = [DictionaryProxy sharedInstance];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated{
    [historyTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ActionViewController* controller = (ActionViewController*)[segue destinationViewController];
    NSLog(@"history segure called");
    if ([[segue identifier] isEqualToString:@"action"]) {
//        UITableViewCell* target = [historyTable cellForRowAtIndexPath:[historyTable indexPathForSelectedRow]];
//        [[controller textView] setText:target.textLabel.text];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [proxy counts:@"History" withType:-1];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"action"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"action"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSUInteger row = [indexPath row];
    History* history = (History*)[proxy selectAt:@"History" withType:-1 ascending:NO indexOf:row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 2];
    cell.textLabel.text = history.sentence;
    return cell;
}	 
@end
