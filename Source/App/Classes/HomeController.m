    //
//  HomeController.m
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 3/08/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//

#import "HomeController.h"
#import <Three20Style/TTFlowLayout.h>
#import "ImageCollectionController.h"

@interface HomeController ()

- (void) upload;
- (void) addPhoto;

@end

@implementation HomeController

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[b setTitle:@"Upload" forState:UIControlStateNormal];
	[b addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
	[b sizeToFit];
	[self.view addSubview:b];

	
	ImageCollectionController* c = [[ImageCollectionController alloc] initWithImage:[UIImage imageNamed:@"example.jpg"]];
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Upload

- (void) upload {
	
	TTOpenURL(@"tt://upload");
}

- (void) addPhoto {
	
}

@end
