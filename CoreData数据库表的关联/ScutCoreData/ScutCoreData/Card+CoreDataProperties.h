//
//  Card+CoreDataProperties.h
//  ScutCoreData
//
//  Created by bwu on 16/5/19.
//  Copyright © 2016年 wubiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *no;
@property (nullable, nonatomic, retain) Student *student;

@end

NS_ASSUME_NONNULL_END
