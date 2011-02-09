//
//  ModelViewControllerBase.m
//  Election Leaflets
//
//  Created by Vijay Santhanam on 27/07/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//

#import "ModelViewControllerBase.h"

@interface ModelViewControllerBase ()

- (CGRect)rectForOverlayView;
- (void)fadeOutView:(UIView*)view;

@end


@implementation ModelViewControllerBase

@synthesize overlayView			= _overlayView;
@synthesize loadingView         = _loadingView;
@synthesize errorView           = _errorView;
@synthesize emptyView           = _emptyView;


- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}


- (void)dealloc {
	TT_RELEASE_SAFELY(_loadingView);
	TT_RELEASE_SAFELY(_errorView);
	TT_RELEASE_SAFELY(_emptyView);
	TT_RELEASE_SAFELY(_overlayView);
	[super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle


- (void)viewDidUnload {
	[super viewDidUnload];
	[_overlayView removeFromSuperview];
	TT_RELEASE_SAFELY(_overlayView);
	[_loadingView removeFromSuperview];
	TT_RELEASE_SAFELY(_loadingView);
	[_errorView removeFromSuperview];
	TT_RELEASE_SAFELY(_errorView);
	[_emptyView removeFromSuperview];
	TT_RELEASE_SAFELY(_emptyView);
}

#pragma mark -
#pragma mark Error/Empty/Loading



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show {
	if (show) {
		if (!self.model.isLoaded || ![self canShowModel]) {
			NSString* title = @"Loading";
			if (title.length) {
				TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleWhiteBox]
										  autorelease];
				label.text = title;
				label.backgroundColor = self.view.backgroundColor;
				self.loadingView = label;
			}
		}
	} else {
		self.loadingView = nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show {
	if (show) {
		if (!self.model.isLoaded || ![self canShowModel]) {
			NSString* title = @"There has been an error";
			NSString* subtitle = @"Error loading";
			UIImage* image = [UIImage imageWithContentsOfFile:@"bundle://Three20.bundle/images/error.png"];
			if (title.length || subtitle.length || image) {
				TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:title
																	subtitle:subtitle
																	   image:image] autorelease];
				errorView.backgroundColor = self.view.backgroundColor;
				self.errorView = errorView;
			} else {
				self.errorView = nil;
			}
		}
	} else {
		self.errorView = nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show {
	if (show) {
		NSString* title = @"Empty";
		NSString* subtitle = @"Empty dawg";
		UIImage* image = [UIImage imageWithContentsOfFile:@"bundle://Three20.bundle/images/empty.png"];
		if (title.length || subtitle.length || image) {
			TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:title
																subtitle:subtitle
																   image:image] autorelease];
			errorView.backgroundColor = self.view.backgroundColor;
			self.emptyView = errorView;
		} else {
			self.emptyView = nil;
		}
	} else {
		self.emptyView = nil;
	}
}




#pragma mark -
#pragma mark Overlay View


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToOverlayView:(UIView*)view {
	if (!_overlayView) {
		CGRect frame = [self rectForOverlayView];
		_overlayView = [[UIView alloc] initWithFrame:frame];
		_overlayView.autoresizesSubviews = YES;
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth
		| UIViewAutoresizingFlexibleBottomMargin;
		 
		[self.view addSubview:_overlayView];
	}
	
	view.frame = _overlayView.bounds;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_overlayView addSubview:view];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resetOverlayView {
	if (_overlayView && !_overlayView.subviews.count) {
		[_overlayView removeFromSuperview];
		TT_RELEASE_SAFELY(_overlayView);
	}
}

- (void)layoutOverlayView {
	if (_overlayView) {
		_overlayView.frame = [self rectForOverlayView];
	}
}



- (void)setOverlayView:(UIView*)overlayView animated:(BOOL)animated {
	if (overlayView != _overlayView) {
		if (_overlayView) {
			if (animated) {
				[self fadeOutView:_overlayView];
			} else {
				[_overlayView removeFromSuperview];
			}
		}
		
		[_overlayView release];
		_overlayView = [overlayView retain];
		
		if (_overlayView) {
			_overlayView.frame = [self rectForOverlayView];
			[self addToOverlayView:_overlayView];
		}
		
		// XXXjoe There seem to be cases where this gets left disable - must investigate
		//_tableView.scrollEnabled = !_tableOverlayView;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLoadingView:(UIView*)view {
	if (view != _loadingView) {
		if (_loadingView) {
			[_loadingView removeFromSuperview];
			TT_RELEASE_SAFELY(_loadingView);
		}
		_loadingView = [view retain];
		if (_loadingView) {
			[self addToOverlayView:_loadingView];
		} else {
			[self resetOverlayView];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorView:(UIView*)view {
	if (view != _errorView) {
		if (_errorView) {
			[_errorView removeFromSuperview];
			TT_RELEASE_SAFELY(_errorView);
		}
		_errorView = [view retain];
		
		if (_errorView) {
			[self addToOverlayView:_errorView];
		} else {
			[self resetOverlayView];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView*)view {
	if (view != _emptyView) {
		if (_emptyView) {
			[_emptyView removeFromSuperview];
			TT_RELEASE_SAFELY(_emptyView);
		}
		_emptyView = [view retain];
		if (_emptyView) {
			[self addToOverlayView:_emptyView];
		} else {
			[self resetOverlayView];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadeOutView:(UIView*)view {
	[view retain];
	[UIView beginAnimations:nil context:view];
	[UIView setAnimationDuration:TT_TRANSITION_DURATION];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadingOutViewDidStop:finished:context:)];
	view.alpha = 0;
	[UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadingOutViewDidStop:(NSString*)animationID finished:(NSNumber*)finished
                     context:(void*)context {
	UIView* view = (UIView*)context;
	[view removeFromSuperview];
	[view release];
}


- (CGRect)rectForOverlayView {
	return [self.view frame];
}


@end
