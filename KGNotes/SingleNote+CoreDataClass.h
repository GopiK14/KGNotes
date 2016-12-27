//
//  SingleNote+CoreDataClass.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, NSObject, Note;

NS_ASSUME_NONNULL_BEGIN

@interface SingleNote : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "SingleNote+CoreDataProperties.h"
