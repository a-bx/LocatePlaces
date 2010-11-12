//
//  MenuViewController.m
//  
//
//  Created by Abraham Barrera Curin  
//

#import "MenuViewController.h"
#import "Menu.h"
#import "QueryResultsModel.h"
#import "BNDefaultStylesheet.h"
#import "Three20/Three20.h"
 

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MenuViewController
 
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Home";
	}
	
	return self;
}
	 

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController
- (void)generateLauncher {


	_launcherView.backgroundColor = TTSTYLEVAR(backgroundColor);
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;

	
	id<QueryResultsModel> model = (id<QueryResultsModel>)CreateQueryModel(QueryServiceMenu, QueryResponseFormatJSON);
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ES_CL", @"loc",
                                @"CONTINUUM", @"app",							
                                nil];
	
	[model setQueryParams:params];
	[model load:TTURLRequestCachePolicyLocal more:NO];
	
	NSMutableArray *remoteArray = [[NSMutableArray alloc] init];
	
	for (Menu *result in [model results]) {
		TTLauncherItem *item = [[TTLauncherItem alloc] initWithTitle:result.title
															   image:result.imageURL
																 URL:result.linkURL
														   canDelete:NO];
	
		[remoteArray addObject:item];
	}
 	
	 
	_launcherView.pages = [NSArray arrayWithObjects:
						   remoteArray, 
						   nil
						   ];
	
	
}

- (void)loadView {
	[super loadView];
	
	CGRect mainFrame = self.view.bounds;
	CGRect logoFrame = self.view.bounds;
	
	UIImage *logoImage = [UIImage imageNamed:TTSTYLEVAR(logoImage)];
	
	logoFrame.size.height = logoImage.size.height;
	logoFrame.origin.y = mainFrame.size.height - logoImage.size.height;
	
	mainFrame.size.height -= TTStatusHeight();
	mainFrame.size.height -= logoFrame.size.height;	
	
	UIImageView *_logo = [[UIImageView alloc] initWithFrame:logoFrame];
	_launcherView = [[TTLauncherView alloc] initWithFrame:mainFrame];
	[_logo setImage:logoImage];
		
	[self generateLauncher];
	
	[self.view addSubview:_logo];
	[self.view addSubview:_launcherView];
 	
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setTintColor:TTSTYLEVAR(navigationBarTintColor)];

 }

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	if (item.URL != nil) {
		TTNavigator *navigator = [TTNavigator navigator]; 
		[navigator setOpensExternalURLs:YES]; 
		UIViewController* vc = [navigator openURLAction:[TTURLAction actionWithURLPath:item.URL]];
		vc.view.transform = CGAffineTransformMakeScale(0.1,0.1);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.25];
		vc.view.transform = CGAffineTransformMakeScale(1,1);
		vc.view.alpha = 1.0;
		[UIView commitAnimations];
 	}
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end
