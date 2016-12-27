//
//  SingleNote+CoreDataProperties.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "SingleNote+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SingleNote (CoreDataProperties)

+ (NSFetchRequest<SingleNote *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *detail;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) Note *note;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END
