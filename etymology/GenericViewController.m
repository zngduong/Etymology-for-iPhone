//
//  GenericViewController.m
//  SearchExample
//
//  Created by Patrick Crosby on 4/27/10.
//  Copyright 2010 XB Labs, LLC. All rights reserved.
//

#import "GenericViewController.h"
#import "etymologyAppDelegate.h"
#import "DetailViewController.h"

@implementation GenericViewController

@synthesize detailViewController;

@synthesize fetchedResultsController;

@synthesize managedObjectContext;

- (void)viewDidLoad
{
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame] autorelease];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textured-toolbar.png"]];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    /*
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame] autorelease];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.image = [UIImage imageNamed:@"NavBar-iPhone.png"];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];*/
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        // Overriden to allow any orientation.
        return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"term"] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the detail item in the detail view controller.
    NSManagedObject *selectedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;  
    
    NSLog(@"Click");
    
    [[DetailViewController alloc] setDetailItem:selectedObject];
}

- (NSFetchedResultsController *)fetchedResultsController
{      
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSManagedObjectContext *moc = [[etymologyAppDelegate alloc] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Words" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    //Set the predicate
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"term LIKE %@ AND meaning LIKE %@", @"*pr*", @"*"];
    [fetchRequest setPredicate:predicate];
    NSLog(@"Filtering");*/
    NSLog(@"%@", self.searchDisplayController.searchBar.text);
    if (self.searchDisplayController.searchBar.text != nil)
    {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"term LIKE %@ AND meaning LIKE %@", [NSString stringWithFormat:@"*%@*", self.searchDisplayController.searchBar.text], @"*"];
        [fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"term LIKE %@", @"*loading*"];
        [fetchRequest setPredicate:predicate];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"term" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:NO];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}    

- (void)mockSearch:(NSTimer*)timer
{
    NSLog(@"Call");
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self mockSearch:nil];
    return NO;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self mockSearch:nil];    
}

/*
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self mockSearch:nil];
}*/

- (void)dealloc {
        [_data release];
        [super dealloc];
}

@end
