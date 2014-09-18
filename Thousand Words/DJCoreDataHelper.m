//
//  DJCoreDataHelper.m
//  Thousand Words
//
//  Created by Divakaran Jeyachandran on 7/23/14.
//
//

#import "DJCoreDataHelper.h"

@implementation DJCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
