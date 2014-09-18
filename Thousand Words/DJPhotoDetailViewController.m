//
//  DJPhotoDetailViewController.m
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/25/14.
//
//

#import "DJPhotoDetailViewController.h"
#import "DJFiltersCollectionViewController.h"

// Add this import to get the functionalities of the Photo class
// Adding it in .m file is like declaring it private. Other classes cant see this.
#import "Photo.h"

@interface DJPhotoDetailViewController ()

@end

@implementation DJPhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Filter Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[DJFiltersCollectionViewController class]]) {
            DJFiltersCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.photo = self.photo;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[self.photo managedObjectContext]deleteObject:self.photo];
   
    // The following part is to persist the deleted image (or) save the deletion, so that when the app is run the next time, the deleted images does not appear
    NSError *error = nil;
    [[self.photo managedObjectContext]save:&error];
    if (error) {
        NSLog(@"error!!");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
