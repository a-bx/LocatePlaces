//
//  LPCacheManager.h
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPCacheManager : NSObject {

}

- (void) cacheImage: (NSString *) ImageURLString;
- (UIImage *) getCachedImage: (NSString *) ImageURLString;
- (UIImage *) roundCorners: (UIImage*) img;

@end
