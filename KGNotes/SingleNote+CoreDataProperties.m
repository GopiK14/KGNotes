//
//  SingleNote+CoreDataProperties.m
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "SingleNote+CoreDataProperties.h"

@implementation SingleNote (CoreDataProperties)

+ (NSFetchRequest<SingleNote *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SingleNote"];
}

@dynamic detail;
@dynamic title;
@dynamic note;
@dynamic location;

@end
