//
//  DetailViewController.m
//  etymology
//
//  Created by Matt on 11/19/11.
//  Copyright 2011 St. Timothy. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

UITextView *desc;
UILabel *term;

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize popoverController=_myPopoverController;

@synthesize rootViewController=_rootViewController;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject
{
    /*NSLog(@"Should edit %@", desc);
    [desc setText:@"blah"];
    NSLog(@"Setting");

    [self.detailDescriptionLabel setText:@"Meaning"];
    self.detailDescriptionLabel.text = @"Meaning";
    NSLog(@"Meaning: %@", self.detailDescriptionLabel.text);*/
	if (_detailItem != managedObject) {
		[_detailItem release];
		_detailItem = [managedObject retain];
		
        // Update the view.
        [self configureView];
	}
    
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }	        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    // Normally should use accessor method, but using KVC here avoids adding a custom class to the template.
    desc.text = [[[self.detailItem valueForKey:@"meaning"] description] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    term.text = [[self.detailItem valueForKey:@"term"] description];
    //[detailLbl setText:[[self.detailItem valueForKey:@"meaning"] description]];
     NSLog(@"%@", [[self.detailItem valueForKey:@"meaning"] description]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Should edit %@", detailLbl);
    
    desc = detailLbl;
    term = termLbl;
    
//     self.navigationController.navigationBar.barStyle = UIBarStyleBlack;   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{        
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:self.toolbar.frame] autorelease];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textured-toolbar.png"]];
    [self.toolbar insertSubview:imageView atIndex:0];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.gif"]];
    
    [super viewDidLoad];
}
 

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

#pragma mark - Object insertion

- (IBAction)insertNewObject:(id)sender
{
	[self.rootViewController insertNewObject:sender];	
}

@end
