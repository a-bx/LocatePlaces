//
//  BNDefaultStylesheet.h
//  LocatePlaces
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import "Three20/Three20.h"  
 

@interface BNDefaultStylesheet : TTDefaultStyleSheet   
	
	@property(nonatomic,readonly) UIColor* backgroundColor;  
	@property(nonatomic,readonly) UIColor* navigationBarTintColor;
	@property(nonatomic,readonly) UIColor* toolbarTintColor;
	@property(nonatomic,readonly) NSString* logoImage;

@end
