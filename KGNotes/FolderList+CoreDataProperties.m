//
//  FolderList+CoreDataProperties.m
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "FolderList+CoreDataProperties.h"

@implementation FolderList (CoreDataProperties)

+ (NSFetchRequest<FolderList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FolderList"];
}

@dynamic folderTitle;
@dynamic notes;

@end
