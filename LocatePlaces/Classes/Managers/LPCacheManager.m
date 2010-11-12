//
//  LPCacheManager.m
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import "LPCacheManager.h"

#define TMP NSTemporaryDirectory()

@implementation LPCacheManager


- (void) cacheImage: (NSString *) ImageURLString
{
    NSURL *ImageURL = [[NSURL alloc] initWithString:ImageURLString];
    
    NSString *filename = [[ImageURLString lastPathComponent] stringByDeletingPathExtension];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
 
		NSData *data = [NSData dataWithContentsOfURL:ImageURL];		
		UIImage *image = [[UIImage alloc] initWithData:data];
		
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
    }
}

- (UIImage *) getCachedImage: (NSString *) ImageURLString
{
    NSString *filename = [[ImageURLString lastPathComponent] stringByDeletingPathExtension];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image = [[UIImage alloc] init];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile:uniquePath];  
    }
    else
    {
        [self cacheImage:ImageURLString];
        image = [UIImage imageWithContentsOfFile:uniquePath];
    }
	
    return image;
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    [img release];
    
    return [UIImage imageWithCGImage:imageMasked];
}


@end
