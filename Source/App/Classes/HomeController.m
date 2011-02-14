    //
//  HomeController.m
//  ElectionLeaflets
//
//  Created by Vijay Santhanam on 3/08/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//

#import "HomeController.h"
#import <Three20Style/TTFlowLayout.h>
#import "Api.h"
#import "ImageCollectionController.h"

@interface HomeController ()

@property (nonatomic,retain) ASIFormDataRequest* uploadRequest; 

- (void) upload;
- (void) addPhoto;

@end

@implementation HomeController

@synthesize uploadRequest=_uploadRequest;

- (void)dealloc {
	[self.uploadRequest cancel];
	self.uploadRequest = nil;
    [super dealloc];
}


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
	
	
	// get a viewstate
	ASIHTTPRequest* first = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:API_ADD_UPLOAD]];
	[first startSynchronous];
	NSString* firstResponseString = [first responseString];
	
	NSString* viewState = @"";
	
	NSRegularExpression* viewStateRegex = [[NSRegularExpression alloc] initWithPattern:@"<input type=\"hidden\" name=\"_viewstate\" value=\"(.*)\" />" options:NSRegularExpressionCaseInsensitive error:nil];
	
	NSTextCheckingResult *match = [viewStateRegex firstMatchInString:firstResponseString
													options:0
													  range:NSMakeRange(0, [firstResponseString length])];
	if (match) {
		NSRange matchRange = [match range];
		NSRange viewStateMatchRange = [match rangeAtIndex:1];
		
		viewState = 	[firstResponseString substringWithRange:viewStateMatchRange];
		NSLog(@"%@",viewState);
		
	}
	
	self.uploadRequest = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:API_ADD_UPLOAD_POST]] autorelease];
	NSString* fp =  [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"];
	
	ASIFormDataRequest* r = self.uploadRequest;
	
	[r setFile:fp forKey:@"uplFile_1"];
	[r setPostValue:@"10000000000" forKey:@"MAX_FILE_SIZE"];
	[r setPostValue:@"1" forKey:@"_is_postback"];
	[r setPostValue:viewState forKey:@"_viewstate"];
	
	self.uploadRequest.delegate = self;
	self.uploadRequest.uploadProgressDelegate = self;
	[self.uploadRequest start];
	
	
	[viewStateRegex release];
	[first release];
	//ImageCollectionController* c = [[ImageCollectionController alloc] initWithImage:[UIImage imageNamed:@"example.jpg"]];
}


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




#pragma mark -
#pragma mark Upload

- (void) upload {
	
	TTOpenURL(@"tt://upload");
}

- (void) addPhoto {
	
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate


// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(ASIHTTPRequest *)request {
	NSLog(@"started");
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
	NSLog(@"did receive headers %@",responseHeaders );
}


- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
	NSLog(@"Will redirect to URL %@", [newURL absoluteString]);
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"request finished");
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"request failed");
}

- (void)requestRedirected:(ASIHTTPRequest *)request {
	NSLog(@"request redirected");
}

#pragma mark -
#pragma mark ASIProgressDelegate
- (void)setProgress:(float)newProgress {
	NSLog(@"%.2f",newProgress);
}


@end
