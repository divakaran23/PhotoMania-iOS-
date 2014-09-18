//
//  DJAlbumTableViewController.m
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/21/14.
//
//

#import "DJAlbumTableViewController.h"
#import "Album.h"
#import "DJCoreDataHelper.h"
#import "DJPhotoCollectionsViewController.h"


@interface DJAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation DJAlbumTableViewController

-(NSMutableArray *)album
{
    if (!_album) {
        _album = [[NSMutableArray alloc] init];
    }
    return _album;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    NSError *error = nil;
    NSArray *fetchedAlbum = [[DJCoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.album = [fetchedAlbum mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction method

- (IBAction)newAlbumBarButtonItemPressed:(UIBarButtonItem *)sender
{
    // Add an AlertView
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Enter New Album name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

#pragma mark - Helper Methods

-(Album *)albumWithName:(NSString *)name
{
    NSManagedObjectContext *context = [DJCoreDataHelper managedObjectContext];
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    }
    return album;
}

#pragma mark - UIAlertView delegate method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.album addObject:[self albumWithName:alertText]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.album count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        //        Album *newAlbum = [self albumWithName:alertText];
        //        [self.album addObject:newAlbum];
        //        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.album count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Album *selectedAlbum = self.album[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Album Chosen"])
    {
        if ([segue.destinationViewController isKindOfClass:[DJPhotoCollectionsViewController class]]) {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            DJPhotoCollectionsViewController *targetViewController = segue.destinationViewController;
            targetViewController.album = self.album[path.row];
        }
    }
}


@end
