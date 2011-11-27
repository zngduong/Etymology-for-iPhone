//
//  GenericViewController.h
//  SearchExample
//
//  Created by Patrick Crosby on 4/27/10.
//  Copyright 2010 XB Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
        NSMutableArray* _data;
}

@end
