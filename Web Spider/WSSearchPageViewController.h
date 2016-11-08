//
//  WSSearchPageViewController.h
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSState;

@interface WSSearchPageViewController : UITableViewController<UISearchBarDelegate>

@property (nonatomic, strong) WSState *currentState;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


- (void)presentURLEditPopup:(id)sender;
- (void)cancel;
- (void)pause;
- (void)resume;

- (void)disableSearchBar;
- (void)enableSearchBar;

@end
