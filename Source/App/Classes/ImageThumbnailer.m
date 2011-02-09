//
//  ImageThumbnailer.m
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 18/08/10.
//  Copyright 2010 Open Australia. All rights reserved.
//

#import "ImageThumbnailer.h"


@implementation ImageThumbnailer


+ (UIImage*) exactSquareFromImage:(UIImage*)source 
					   sideLength:(CGFloat)length {
	
	// taken from http://www.nickkuh.com/iphone/how-to-create-square-thumbnails-using-iphone-sdk-cg-quartz-2d/2010/
	UIImage *thumbnail;
	
	//couldn’t find a previously created thumb image so create one first…
	UIImage *mainImage = source;
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
	BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
	float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
	
	//creating a square context the size of the final image which we will then
	// manipulate and transform before drawing in the original image
	UIGraphicsBeginImageContext(CGSizeMake(length, length));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextClipToRect( currentContext, clippedRect);
	CGFloat scaleFactor = length/sideFull;
	if (widthGreaterThanHeight) {
		//a landscape image – make context shift the original image to the left when drawn into the context
		CGContextTranslateCTM(currentContext, - ((mainImage.size.width - sideFull) /2) * scaleFactor,0);

		//CGContextTranslateCTM(currentContext, -((mainImage.size.width – sideFull) / 2) * scaleFactor, 0);
	}
	else {
		//a portrait image – make context shift the original image upwards when drawn into the context
		CGContextTranslateCTM(currentContext, 0, - ((mainImage.size.width - sideFull) /2) * scaleFactor);
	}
	//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
	CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
	[mainImageView.layer renderInContext:currentContext];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSData *imageData = UIImagePNGRepresentation(thumbnail);
	thumbnail = [UIImage imageWithData:imageData];

	return thumbnail;
}
									  
									  
+ (UIImage*) exactSquareWithoutDistortionFromImage:(UIImage*)source 
						 sideLength:(CGFloat)length
					backgroundColor:(UIColor*)backgroundColor {
	// TODO
	return nil;
}


@end
