//
//  ModelViewControllerBase.h
//  Election Leaflets
//
//  Created by Vijay Santhanam on 27/07/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface ModelViewControllerBase : TTModelViewController {
	UIView*       _overlayView;
	UIView*       _loadingView;
	UIView*       _errorView;
	UIView*       _emptyView;
}

@property (nonatomic, retain) UIView* overlayView;

@property (nonatomic, retain) UIView* loadingView;
@property (nonatomic, retain) UIView* errorView;
@property (nonatomic, retain) UIView* emptyView;


@end
