//
//  DJPictureDataTransformer.m
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/25/14.
//
//

#import "DJPictureDataTransformer.h"

@implementation DJPictureDataTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}
+(BOOL)allowsReverseTransformation
{
    return YES;
}
-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}
-(id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}

@end
