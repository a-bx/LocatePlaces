//
//  CSMapAnnotation.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// types of annotations for which we will provide annotation views. 
typedef enum {
	CSMapAnnotationTypeStart = 0,
	CSMapAnnotationTypeEnd   = 1,
	CSMapAnnotationTypeImage = 2
} CSMapAnnotationType;

@interface CSMapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D _coordinate;
	CSMapAnnotationType    _annotationType;
	NSString*              _title;
	NSString*              _userData;
	NSString*			   _imageUrl;
	NSURL*                 _url;
	NSString*			   _color;
	NSInteger*			   _indx;
	BOOL				   _opened;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
		  annotationType:(CSMapAnnotationType) annotationType
				   title:(NSString*)title
				   color:(NSString*)color
				imageUrl:(NSString*)imageUrl
					indx:(NSInteger*)indx
				  opened:(BOOL)opened;

@property CSMapAnnotationType annotationType;
@property (nonatomic, retain) NSString* userData;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) NSString* color;
@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic) NSInteger* indx;
@property (nonatomic) BOOL opened;

@end
