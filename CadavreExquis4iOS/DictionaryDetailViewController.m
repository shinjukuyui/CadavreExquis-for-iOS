//
//  DictionaryDetailViewController.m
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

#import "DictionaryDetailViewController.h"
#import "DictionaryAddViewController.h"
#import "Dictionary.h"

@interface DictionaryDetailViewController ()

@end

@implementation DictionaryDetailViewController
@synthesize table;
@synthesize addButton;
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
//    [table setDelegate:self];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [table reloadData];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DictionaryAddViewController *controller = (DictionaryAddViewController*)[segue destinationViewController];
    [controller setType:self.type];
    if ([[segue identifier] isEqualToString:@"modify"]) {
        UITableViewCell* target = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]];
        [controller setSelectedText:target.textLabel.text];
        [controller setSelectedId:target.detailTextLabel.text];
    } else {
        [controller setSelectedText:@""];
        [controller setSelectedId:@""];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [proxy counts:@"Dictionary" withType:[type intValue]];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"modify"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"modify"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSUInteger row = [indexPath row];
    Dictionary* dictionary = (Dictionary*)[proxy selectAt:@"Dictionary" withType:[type intValue] ascending:NO indexOf:row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1];
    cell.textLabel.text = dictionary.sentence;
    cell.detailTextLabel.text = [dictionary.id stringValue];
    cell.detailTextLabel.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell* target = [table cellForRowAtIndexPath:indexPath];
        NSString* objectId = target.detailTextLabel.text;
        Dictionary* dictionary = (Dictionary*) [proxy selectById:@"Dictionary" byId:[objectId intValue]];
        [proxy remove:dictionary];
        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:animated];
    if (!editing) {
        [proxy save];
    }
}
@end
