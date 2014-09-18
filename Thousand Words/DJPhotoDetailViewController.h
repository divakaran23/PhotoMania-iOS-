//
//  DJPhotoDetailViewController.h
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/25/14.
//
//

#import <UIKit/UIKit.h>

// Create a class for photo to access the photos in this VC
// This is a lightweight import statement
@class Photo;

@interface DJPhotoDetailViewController : UIViewController

// Create a property for the photo class
@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;

@end
