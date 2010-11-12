//
//  AppDelegate.h
//  
//
//  Created by Abraham Barrera Curin  
//

#import "Three20/Three20.h"
#import "SearchResultsPhotoSource.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	TTNavigator* navigator;
	SearchResultsPhotoSource *photoSource;
	
}

@property (nonatomic, retain) TTNavigator* navigator;

@end

