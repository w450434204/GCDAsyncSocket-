//
//  Status+CoreDataProperties.h
//  ScutCoreData
//
//  Created by bwu on 16/5/19.
//  Copyright © 2016年 wubiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Status.h"

NS_ASSUME_NONNULL_BEGIN

@interface Status (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
