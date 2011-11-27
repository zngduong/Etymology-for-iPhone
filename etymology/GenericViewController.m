//
//  GenericViewController.m
//  SearchExample
//
//  Created by Patrick Crosby on 4/27/10.
//  Copyright 2010 XB Labs, LLC. All rights reserved.
//

#import "GenericViewController.h"


@implementation GenericViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        _data = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        // Overriden to allow any orientation.
        return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
        return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString *CellIdentifier = @"CellIdentifier";

        // Dequeue or create a cell of the appropriate type.
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
        }

        // Configure the cell.
        cell.textLabel.text = [NSString stringWithFormat:@"Row %d: %@", indexPath.row, [_data objectAtIndex:indexPath.row]];
        return cell;
}

- (void)mockSearch:(NSTimer*)timer
{
        [_data removeAllObjects];
        int count = 1 + random() % 20;
        for (int i = 0; i < count; i++) {
                [_data addObject:timer.userInfo];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(mockSearch:) userInfo:searchString repeats:NO];
        return NO;
}

- (void)dealloc {
        [_data release];
        [super dealloc];
}

@end
