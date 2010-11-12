//
//  AppDelegate.m
//  
//
//  Created by Abraham Barrera Curin  
//

#import "MenuViewController.h"
#import "LPMapViewController.h"
#import "BNDefaultStylesheet.h"
#import "AppDelegate.h"

#import "ForwardingAdapters.h"
#import "SearchResultsModel.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate
@synthesize navigator;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;

	TTURLMap* map = navigator.URLMap;

	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"lp://launcher" toViewController:[MenuViewController class]];
	[map from:@"lp://photogallery/(init:)" toViewController:[MyThumbsViewController class]];
	[map from:@"lp://call/(makeCall:)" toViewController:self selector:@selector(makeCall:)];
	[map from:@"lp://map/(initWithName:)/(store:)" toViewController:[LPMapViewController class]];

	
	[TTStyleSheet setGlobalStyleSheet:[[[BNDefaultStylesheet alloc]  
                                        init] autorelease]];

	
	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"lp://launcher"]];	
	}
	
}

 
							   
-(UIViewController*)makeCall:(NSString *)number {
	TTActionSheetController *action = [[[TTActionSheetController alloc]
										initWithTitle:@"Realizar Llamada"] autorelease];
	[action addButtonWithTitle:number URL:[@"tel:" stringByAppendingString:number]];
	[action addButtonWithTitle:@"Cancelar" URL:nil];
	return action;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString] ];
  return YES;
}


@end
