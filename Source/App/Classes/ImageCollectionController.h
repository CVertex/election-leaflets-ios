//
//  ImageCollectionController.h
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 18/08/10.
//  Copyright 2010 Open Australia. All rights reserved.
//

#import <Three20/Three20.h>
#import <Three20/Three20+Additions.h>

@protocol ImageCollectionControllerDelegate;


/*
 objectives:
 - manages a collection of images
 - the single image view is different from the multiple image view 
 - build the multi image view first
 - auto thumbnail images
 
 */
@interface ImageCollectionController : UIViewController {
	NSMutableArray* _thumbnails;
	NSMutableArray* _images;
	id<ImageCollectionControllerDelegate> _delegate;
}

@property (nonatomic,assign) id<ImageCollectionControllerDelegate> delegate;

- (id)initWithImage:(UIImage*) image;

- (void)addImage:(UIImage*) image;

@end

@protocol ImageCollectionControllerDelegate 

- (void)imageCollectionController:(ImageCollectionController*)controller
					  didAddImage:(UIImage*) image
						thumbnail:(UIImage*) thumbnail;

@end