//
//  UploadController.m
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 3/08/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//

#import "UploadController.h"
#import "Upload.h"

@interface UploadController ()

- (void)addPhoto;
- (void)addPhotoFromLibrary;
- (void)addPhotoFromCamera;


@end


@implementation UploadController

@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;
		
		
		UITextField* textField = [[[UITextField alloc] init] autorelease];
		textField.placeholder = @"UITextField";
		textField.font = TTSTYLEVAR(font);
		
		UITextField* textField2 = [[[UITextField alloc] init] autorelease];
		textField2.font = TTSTYLEVAR(font);
		textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		TTTableControlItem* textFieldItem = [TTTableControlItem itemWithCaption:@"TTTableControlItem"
																		control:textField2];
		
		UITextView* textView = [[[UITextView alloc] init] autorelease];
		textView.text = @"UITextView";
		textView.font = TTSTYLEVAR(font);
		
		TTTextEditor* editor = [[[TTTextEditor alloc] init] autorelease];
		editor.font = TTSTYLEVAR(font);
		editor.backgroundColor = TTSTYLEVAR(backgroundColor);
		editor.autoresizesToText = NO;
		editor.minNumberOfLines = 3;
		editor.placeholder = @"TTTextEditor";
		
		UISwitch* switchy = [[[UISwitch alloc] init] autorelease];
		TTTableControlItem* switchItem = [TTTableControlItem itemWithCaption:@"UISwitch" control:switchy];
		
		UISlider* slider = [[[UISlider alloc] init] autorelease];
		TTTableControlItem* sliderItem = [TTTableControlItem itemWithCaption:@"UISlider" control:slider];
		
		
		self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
						   @"Photos",
						   textField,
						   editor,
						   textView,
						   textFieldItem,
						   switchItem,
						   sliderItem,
						   nil];
	}
	return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor greenColor];
	
	
	UIButton* c = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[c setTitle:@"Choose Photo" forState:UIControlStateNormal];
	[c addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
	c.frame = CGRectMake(0,0,100,40);
	self.tableView.tableHeaderView = c;
	
	
	
	// play around and do stuff with the object context
	
	// first add a new upload, see how she flies
	Upload* upload = [NSEntityDescription insertNewObjectForEntityForName:@"Upload" inManagedObjectContext:self.managedObjectContext];
	upload.title = @"blah adadsd blah";
	
	NSError* error;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"%@",[error localizedDescription]);
	}
	
	// read all of them
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Upload" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
		NSLog(@"fetch error");
	}
	
	for (Upload* u in mutableFetchResults) {
		NSLog(@"%@",u.title);
	}
	
	[request release];
	 
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
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
#pragma mark Adding Photos

#define ACTIONSHEET_BUTTON_ADD_FROM_LIBRARY @"Add from Library"
#define ACTIONSHEET_BUTTON_TAKE_PHOTO @"Take Photo"

- (void)addPhoto {
	
	// if no camera is available
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
		[self addPhotoFromLibrary];
		return;
	}
	
	
	UIActionSheet* s = [[UIActionSheet alloc] initWithTitle:nil 
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
									 destructiveButtonTitle:nil 
										  otherButtonTitles:ACTIONSHEET_BUTTON_ADD_FROM_LIBRARY,ACTIONSHEET_BUTTON_TAKE_PHOTO,nil];
	
	[s showInView:self.view];
	
	[s release];
}

- (void)addPhotoFromLibrary {
	NSLog(@"add photo from lib");
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.allowsEditing = YES;
	picker.allowsImageEditing = YES;
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
	
}

- (void)addPhotoFromCamera {
	NSLog(@"add photo from cam");
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.allowsEditing = YES;
	picker.allowsImageEditing = YES;
	
	[picker takePicture];
	[picker release];
}

#pragma mark - 
#pragma mark UIActionSheetDelegate


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:ACTIONSHEET_BUTTON_ADD_FROM_LIBRARY]) {
		[self addPhotoFromLibrary];
		return;
	}
	
	if ([title isEqualToString:ACTIONSHEET_BUTTON_TAKE_PHOTO]) {
		[self addPhotoFromCamera];
		return;
	}
	
	return;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	NSLog(@"did finish picking");
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	NSLog(@"did cancel");
	[self dismissModalViewControllerAnimated:YES];
}


@end
