//
//  FolderList+CoreDataProperties.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "FolderList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FolderList (CoreDataProperties)

+ (NSFetchRequest<FolderList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *folderTitle;
@property (nullable, nonatomic, retain) NSSet<Note *> *notes;

@end

@interface FolderList (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet<Note *> *)values;
- (void)removeNotes:(NSSet<Note *> *)values;

@end

NS_ASSUME_NONNULL_END
