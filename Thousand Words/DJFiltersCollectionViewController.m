//
//  DJFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/26/14.
//
//

#import "DJFiltersCollectionViewController.h"
#import "DJPhotoCollectionViewCell.h"
#import "Photo.h"

@interface DJFiltersCollectionViewController ()

// An array to hold the filters
@property (strong, nonatomic) NSMutableArray *filters;
// Creat a context for the conversion of image and to apply filters
@property (strong, nonatomic) CIContext *context;

@end

@implementation DJFiltersCollectionViewController

// Lazy instantiation of the filters array
-(NSMutableArray *)filters
{
    if (!_filters) {
        _filters = [[NSMutableArray alloc]init];
    }
    return _filters;
}

// Lazy instanttiation of context
-(CIContext *)context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

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
    
    // call the class method to initialize this view controller with all the filters
    self.filters = [[[self class]photoFilters]mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

+(NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues:nil];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:nil];
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil];
    CIFilter *unsharper = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues:nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:nil];
    
    // Create an NSArray to hold the filters
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharper, monochrome];
    return allFilters;
}

-(UIImage *)filteredImageForImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    /* Create a CIImage object
     create filter
     apply the respective filter to the CIImage
     Convert the CIImage to CIImageRef
     Convert to UIImage */
    
    CIImage *unFilteredImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    [filter setValue:unFilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];
    CGRect extent = [filteredImage extent];
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    return finalImage;
}

#pragma mark - UICOllection view data source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Photo Cell";
    DJPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    // Create a block to handle this process
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    dispatch_async(filterQueue, ^{
        UIImage *filteredImage = [self filteredImageForImage:self.photo.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filteredImage;
        });
    });
    
    //    cell.imageView.image = [self filteredImageForImage:self.photo.image andFilter:self.filters[indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}

#pragma mark - UICollectio view delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DJPhotoCollectionViewCell *selectedCell = (DJPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;
    
    // to make the app pop the VC only when an image is seected
    if(self.photo.image)
    {
        NSError *error = nil;
        if (![[self.photo managedObjectContext]save:&error]) {
            NSLog(@"Error applying filters");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
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

@end
