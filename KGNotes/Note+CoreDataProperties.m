//
//  Note+CoreDataProperties.m
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Note"];
}

@dynamic noteTitle;
@dynamic folder;
@dynamic noteDetail;

@end
