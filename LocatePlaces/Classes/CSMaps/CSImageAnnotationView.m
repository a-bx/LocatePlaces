//
//  CSImageAnnotationView.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSImageAnnotationView.h"
#import "CSMapAnnotation.h"
#import "LPCacheManager.h"

#define kHeight 100
#define kWidth  100
#define kBorder 2

@implementation CSImageAnnotationView
@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	LPCacheManager *cachemanager = [[LPCacheManager alloc] init];
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if ([reuseIdentifier isEqualToString:@"loc"])
		self.frame = CGRectMake(0, 0, 50 / 2, 50 / 2);
	else
		self.frame = CGRectMake(0, 0, kWidth / 2, kHeight /2);
	
	self.opaque = NO;
	
	CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
	
	UIImage *image = [[UIImage alloc] init];
	image = [cachemanager getCachedImage:[csAnnotation.imageUrl copy]];
	
	_imageView = [[UIImageView alloc] initWithImage:image];
	_imageView.opaque = NO;
	self.frame = _imageView.frame;
	if ([reuseIdentifier isEqualToString:@"loc"])  
		_imageView.frame = CGRectMake(0, 0, 50 / 2 , 50 / 2);
	
	[self addSubview:_imageView];
	
	return self;
	
}

-(void) dealloc
{
	[_imageView release];
	[super dealloc];
}

	 
@end
