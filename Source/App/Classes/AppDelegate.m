#import "AppDelegate.h"

#import "HomeController.h"
#import "UploadController.h"

#import "Helper.h"
#import "Upload.h"
#import "HasManagedObjectContext.h"


@interface AppDelegate ()

- (NSString *)applicationDocumentsDirectory;

- (void)playAround;

@end


@implementation AppDelegate

@synthesize managedObjectModel=_managedObjectModel;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication*)application {

	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
	navigator.delegate = self;

	TTURLMap* map = navigator.URLMap;

	// Any URL that doesn't match will fall back on this one, and open in the web browser
	[map from:@"*" toViewController:[TTWebController class]];

	[map from:@"tt://home" toSharedViewController:[HomeController class]];	
	[map from:@"tt://upload" toModalViewController:[UploadController class]];		

	
	// Before opening the tab bar, we see if the controller history was persisted the last time
	if (![navigator restoreViewControllers]) {
	// This is the first launch, so we just start with the tab bar

	  [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://home"] applyAnimated:NO]]; 
	}
	
	//
	// hide the navigation bar
	navigator.visibleViewController.navigationController.navigationBarHidden = YES;
	
	
	//
	[self playAround];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	
	
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:URL.absoluteString] applyAnimated:NO]];	
  return YES;
}

- (void) applicationWillTerminate:(UIApplication *)application {
	
	NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Recipes.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Uploads" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return _persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Playing ARound

- (void)playAround {
	
	
	
}


#pragma mark TTNavigatorDelegate

- (void)navigator:(TTBaseNavigator*)navigator willOpenURL:(NSURL*)URL
 inViewController:(UIViewController*)controller {
	
	// set the managed object context
	if ([controller conformsToProtocol:@protocol(HasManagedObjectContext)]) {
		id<HasManagedObjectContext> c = (id<HasManagedObjectContext>)controller;
		c.managedObjectContext = self.managedObjectContext;
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIViewController*)confirmOrder {
  TTAlertViewController* alert = [[[TTAlertViewController alloc]
                                 initWithTitle:@"Are you sure?"
                                 message:@"Sure you want to order?"] autorelease];
  [alert addButtonWithTitle:@"Yes" URL:@"tt://order/send"];
  [alert addCancelButtonWithTitle:@"No" URL:nil];
  return alert;
}

- (void)sendOrder {
  TTDINFO(@"SENDING THE ORDER...");
}




@end
