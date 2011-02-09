//
//  ImageCollectionController.m
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 18/08/10.
//  Copyright 2010 Open Australia. All rights reserved.
//

#import "ImageCollectionController.h"
#import "ImageThumbnailer.h"
#import "ImageCollectionView.h"

#define THUMBNAIL_SIDE_LENGTH 80

@interface ImageCollectionController ()

@property (nonatomic,retain) NSMutableArray* images;
@property (nonatomic,retain) NSMutableArray* thumbnails;

@end



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageCollectionController

@synthesize images=_images;
@synthesize thumbnails=_thumbnails;
@synthesize delegate=_delegate;

- (void) dealloc
{
	self.thumbnails = nil;
	self.images = nil;
	self.delegate = nil;
	[super dealloc];
}


- (id) init
{
	self = [super init];
	if (self != nil) {
		self.thumbnails = [NSMutableArray array];
		self.images = [NSMutableArray array];
		self.delegate = nil;
	}
	return self;
}

- (id)initWithImage:(UIImage*) image {
	self = [super init];
	if (self != nil) {
		[self.images addObject:image];
		[self.thumbnails addObject:[ImageThumbnailer exactSquareFromImage:image sideLength:THUMBNAIL_SIDE_LENGTH]];
	}
	return self;
	
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	ImageCollectionView* v = [[ImageCollectionView alloc] initWithFrame:self.view.frame];
	self.view = v;
}



#pragma mark -
#pragma mark Add Image


- (void)addImage:(UIImage*) image {
	[self.images addObject:image];
	[self.thumbnails addObject:[ImageThumbnailer exactSquareFromImage:image sideLength:THUMBNAIL_SIDE_LENGTH]];
}




@end

