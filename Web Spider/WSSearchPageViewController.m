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

@interface WSSearchPageViewController ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) WSURL *siteURL;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) WSSettings *settings;
@end


const NSInteger kMaxThreadsCount = 8;

@implementation WSSearchPageViewController

- (void)awakeFromNib {
  [super awakeFromNib];
  _settings = [[WSSettings alloc] initWithSearchViewControler:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentURLEditPopup:)];
    [self.navigationController.view addGestureRecognizer:tapGestureRecognizer];
    [self.settings refreshTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    
    [[self operationQueue] addOperation:[WSRequestOperation operationWithURL:self.siteURL andKeyword:self.keyWord]];
    
  }
}

- (BOOL)isValidForSearch {
  return YES;
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

@end
