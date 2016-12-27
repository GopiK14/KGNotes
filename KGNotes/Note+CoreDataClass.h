//
//  Note+CoreDataClass.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FolderList, SingleNote;

NS_ASSUME_NONNULL_BEGIN

@interface Note : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Note+CoreDataProperties.h"
