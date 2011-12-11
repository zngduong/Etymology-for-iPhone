//
//  GenericViewController.h
//  SearchExample
//
//  Created by Patrick Crosby on 4/27/10.
//  Copyright 2010 XB Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface GenericViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
        NSMutableArray* _data;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
