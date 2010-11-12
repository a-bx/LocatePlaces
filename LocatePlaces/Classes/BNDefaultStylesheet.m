//
//  BNDefaultStylesheet.m
//  LocatePlaces
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import "BNDefaultStylesheet.h"


@implementation BNDefaultStylesheet

- (UIColor*)backgroundColor {  
    return RGBCOLOR(200, 200, 200);  
}  

- (UIColor*)navigationBarTintColor {  
    return RGBACOLOR(0, 0, 0, 1);
	
}

- (UIColor*)toolbarTintColor {
    return RGBACOLOR(0, 0, 0, 0.5);
}

- (NSString*)logoImage {  
    return @"logo.png";  
}

- (TTStyle*)launcherButton:(UIControlState)state { 
	return [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE (launcherButtonImage:, state) next: 
	 [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11] 
						  color:RGBCOLOR(0, 0, 0) 
				minimumFontSize:11 shadowColor:nil 
				   shadowOffset:CGSizeZero next:nil]]; 
} 



@end
