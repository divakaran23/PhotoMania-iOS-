//
//  DJPhotoCollectionsViewController.h
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/23/14.
//
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface DJPhotoCollectionsViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
