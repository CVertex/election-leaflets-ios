/*
 *  HasManagedObjectContext.h
 *  ElectionLeaflets
 *
 *  Created by Vijay Santhanam on 14/08/10.
 *  Copyright 2010 Vijay Santhanam. All rights reserved.
 *
 */
#import <CoreData/CoreData.h>

@protocol HasManagedObjectContext

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end
