//
//  UploadController.h
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 3/08/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//


#import <Three20/Three20.h>
#import <Three20/Three20+Additions.h>
#import <CoreData/CoreData.h>
#import "HasManagedObjectContext.h"

/*
 
 FIELDS (* is mandatory):
 *Title
 *Photos[]
 Transcript/Description
 Tags[]
 Targeting parties
 and more...
 
 ...Then Upload and Cancel Buttons
 
 */

@interface UploadController : TTTableViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HasManagedObjectContext
>
{
	NSManagedObjectContext* _managedObjectContext;
}

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end
