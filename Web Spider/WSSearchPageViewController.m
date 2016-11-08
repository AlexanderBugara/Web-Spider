//
//  WSSearchPageViewController.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSSearchPageViewController.h"
#import "WSURL.h"
#import "WSRequestOperation.h"
#import "WSSettings.h"
#import "WSState.h"
#import "WSEditState.h"
#import "WSSearchState.h"
#import "WSPauseState.h"
#import "CEObservableMutableArray.h"

@interface WSSearchPageViewController ()<CEObservableMutableArrayDelegate>
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) WSURL *siteURL;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) WSSettings *settings;
@property (nonatomic, strong) CEObservableMutableArray *operations;
@property (nonatomic, strong) NSMutableSet *urlsSet;
@property (assign) NSInteger keywordFoundedNumber;
@property (atomic, assign) NSInteger activeOperationsCount;
@property (atomic, assign) NSInteger parsedPagesCount;
@property (atomic, assign) NSInteger foundedKewordPagesCount;
@end


const NSInteger kMaxThreadsCount = 8;
const NSInteger kMaxKeywordCount = 500;


@implementation WSSearchPageViewController

- (void)awakeFromNib {
  [super awakeFromNib];
  _settings = [[WSSettings alloc] initWithSearchViewControler:self];
  _operations = [[CEObservableMutableArray alloc] init];
  _operations.delegate = self;
  _urlsSet = [NSMutableSet set];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.settings refreshTitle];
    self.currentState = [WSEditState stateWithSearchController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.operations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search.result.cell" forIndexPath:indexPath];
  
    WSRequestOperation *requestOperation = self.operations[indexPath.row];
    if (requestOperation.error) {
      cell.textLabel.text = [requestOperation.error localizedDescription];
    } else {
      cell.textLabel.text = [requestOperation.url absoluteString];
    }
  
    return cell;
}

- (void)presentURLEditPopup:(id)sender {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", @"Popup.controller.enterurl.title") message:NSLocalizedString(@"Please, enter your url", @"Popup.controller.enterurl.message") preferredStyle:UIAlertControllerStyleAlert];
  
  __weak __typeof (self) weakSelf = self;
  
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
   {
     textField.placeholder = NSLocalizedString(@"http://", @"Popup.controller.enterurl.placeholder");
     textField.text = [weakSelf.settings searchURLAbsolutePath];
   }];
  
  
  UIAlertAction *ok = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"OK", @"Popup.controller.enterurl.OK")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                  [weakSelf okAction:alertController];
                                }];
  
  [alertController addAction:ok];
  
  UIAlertAction *no = [UIAlertAction
                       actionWithTitle:NSLocalizedString(@"NO", @"Popup.controller.enterurl.NO")
                       style:UIAlertActionStyleCancel
                       handler:^(UIAlertAction *action)
                       {
                         
                       }];
  
  [alertController addAction:no];
  
  [self presentViewController:alertController animated:YES completion:^{
    
  }];
  
}

- (void)okAction:(UIAlertController *)alertController {
  UITextField *urlField = alertController.textFields.firstObject;
  if ([WSURL isStringValidForCreationURL:urlField.text]) {
      [self.settings updateTitle:urlField.text];
      self.siteURL = [WSURL URLWithString:urlField.text];
  } else {
    
  }
}

#pragma mark Search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  self.keyWord = searchBar.text;
  
  if ([self isValidForSearch]) {
    [self switchToSearch];
    
    WSRequestOperation *requestoperation = [WSRequestOperation operationWithURL:self.siteURL andKeyword:self.keyWord];
    
    [self.operations addObject:requestoperation];
    
  }
}

- (BOOL)isValidForSearch {
  BOOL result = NO;
  if ([WSURL isStringValidForCreationURL:self.urlLabel.text]) {
    self.siteURL = [WSURL URLWithString:self.urlLabel.text];
    result = YES;
  } else {
    self.urlLabel.text = @"Wrong URL...";
  }
  return result;
}

- (NSOperationQueue *)operationQueue {
  if (!_operationQueue) {
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:kMaxThreadsCount];
  }
  return _operationQueue;
}

- (WSURL *)siteURL {
  if (!_siteURL) {
    _siteURL = [self.settings searchURL];
  }
  return _siteURL;
}

- (void)switchToSearch {
  [self.currentState goToState:[WSSearchState stateWithSearchController:self]];
}

- (void)cancel {
  [self.currentState goToState:[WSEditState stateWithSearchController:self]];
}

- (void)pause {
  [self.currentState goToState:[WSPauseState stateWithSearchController:self]];
}

- (void)resume {
  [self.currentState goToState:[WSSearchState stateWithSearchController:self]];
}

- (void)enableSearchBar {
  self.searchBar.userInteractionEnabled = YES;
  self.searchBar.translucent = YES;
  self.searchBar.searchBarStyle = UISearchBarStyleDefault;
  self.searchBar.backgroundColor = [UIColor clearColor];
}

- (void)disableSearchBar {
  self.searchBar.userInteractionEnabled = NO;
  self.searchBar.translucent = NO;
  self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
  self.searchBar.backgroundColor = [UIColor lightGrayColor];
}

- (void)array:(CEObservableMutableArray *)array didAddItemAtIndex:(NSUInteger) index {
  WSRequestOperation *requestOperation = array[index];
  
  [requestOperation addObserver:self forKeyPath:@"isExecuting" options:NSKeyValueObservingOptionNew context:nil];
  
  [self setupComplitionHandler:requestOperation];
  
  [[self operationQueue] addOperation:requestOperation];
  [self.tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  __weak __typeof (self) weakSelf = self;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    if ([keyPath stringByAppendingString:@"isExecuting"] &&
        [change[@"new"] boolValue]) {
      ++weakSelf.activeOperationsCount;
    } else if ([keyPath stringByAppendingString:@"isExecuting"] &&
               ![change[@"new"] boolValue]) {
      --weakSelf.activeOperationsCount;
    }
    
    
  });
 
}

- (void)setupComplitionHandler:(WSRequestOperation *)requestOperation {
  
  __weak WSRequestOperation *weakRequestOperation = requestOperation;
  __weak __typeof (self) weakSelf = self;
  
  requestOperation.completionBlock = ^(void) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (!weakRequestOperation.error) {
        NSArray *nextLevelOperations = [weakRequestOperation nextLevelOperations];
        
        for (WSRequestOperation *requestOperation in nextLevelOperations) {
          [weakSelf.operations addObject:requestOperation];
          [weakSelf setupComplitionHandler:requestOperation];
        }
        
        ++weakSelf.parsedPagesCount;
        
        if (weakRequestOperation.foundedKeywordCount > 0) {
          ++weakSelf.foundedKewordPagesCount;
        }
        
        [weakSelf.operations removeObject:weakRequestOperation];
        
        [weakSelf updateStatusBar];
      }
      
    });
    
    
  };
}

- (void)updateStatusBar {
  self.statusLabel.text = [NSString stringWithFormat:@"th: %ld p: %ld p result: %ld",(long)self.activeOperationsCount, (long)self.parsedPagesCount, (long)self.foundedKewordPagesCount];

}

- (void)array:(CEObservableMutableArray *)array didRemoveItemAtIndex:(NSUInteger) index {
  [self updateStatusBar];
  [self.tableView reloadData];
}
@end
