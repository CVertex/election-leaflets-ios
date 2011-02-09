//
//  ImageThumbnailer.h
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 18/08/10.
//  Copyright 2010 Open Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>




@interface ImageThumbnailer : NSObject {

}

+ (UIImage*) exactSquareFromImage:(UIImage*)source 
					   sideLength:(CGFloat)length;


+ (UIImage*) exactSquareWithoutDistortionFromImage:(UIImage*)source 
										sideLength:(CGFloat)length
									backgroundColor:(UIColor*)backgroundColor;



@end
