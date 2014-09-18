//
//  DJAlbumTableViewController.h
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/21/14.
//
//

#import <UIKit/UIKit.h>

@interface DJAlbumTableViewController : UITableViewController

// Create a property for managing the data on the tableView
@property (strong, nonatomic) NSMutableArray *album;

- (IBAction)newAlbumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
