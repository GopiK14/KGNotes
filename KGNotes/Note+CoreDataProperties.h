//
//  Note+CoreDataProperties.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *noteTitle;
@property (nullable, nonatomic, retain) FolderList *folder;
@property (nullable, nonatomic, retain) SingleNote *noteDetail;

@end

NS_ASSUME_NONNULL_END
