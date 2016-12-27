//
//  Location+CoreDataProperties.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nullable, nonatomic, retain) SingleNote *note;

@end

NS_ASSUME_NONNULL_END
