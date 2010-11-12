//
//  LPMapViewController.h
//  
//
//  Created by Abraham Barrera Curin  
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>

#import "CSMapAnnotation.h"
#import "CSImageAnnotationView.h"
#import "CSRouteView.h"
#import "CSRouteAnnotation.h"
#import "LPMapViewController.h"
#import "LPConfigMenuItem.h"

@interface LPMapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate>  {

	IBOutlet UIView *loadingView;
	IBOutlet UIView *mapPlacesView;	
	IBOutlet MKMapView *mkmapView;
 
	LPConfigMenuItem *selectedMenuItem;		

	CLLocationManager *locationManagerMap;
	CLLocationCoordinate2D location;
	CLLocationCoordinate2D oldlocation;
 
	NSMutableArray *allStores;
	NSMutableArray *anotations;
	NSMutableArray *anotationsRoute;
	NSMutableArray *anotationsImages;
	NSDictionary *selectedStore;
	
	NSMutableDictionary* _routeViews;

}

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIView *mapPlacesView;	
@property (nonatomic, retain) IBOutlet MKMapView *mkmapView;
@property (nonatomic, retain) LPConfigMenuItem *selectedMenuItem;	

- (void) initData;
- (void) reloadStores;
- (void) centerMap;
- (void) centerMapDefault;
- (void) showItemsAtMap;
- (void) putItemsAtMap;
- (void) traceRouteAtMap;
- (void) loading:(BOOL)show;
- (void) geoLocalize; 
- (void) putAllOthers;
- (void) reloadWithRefresh:(BOOL)refresh;

- (NSMutableArray *) getClosestStoreToLocation:(CLLocationCoordinate2D)location2D
										  Type:(NSString*)type;
- (NSDictionary *) getRouteFromPoint:(CLLocationCoordinate2D)fromLocation
							 ToPoint:(CLLocationCoordinate2D)toLocation;
- (NSMutableArray *) getDataAllStoresBySearch:(NSString *)text 
										Cateory:(NSDictionary *)category 
									SubCategory:(NSDictionary *)subCategory 
										  State:(NSDictionary *)state
										   Town:(NSDictionary *)town 
										   Type:(NSString*)type
										 Locate:(NSString*)locate
									 Location:(CLLocationCoordinate2D)location2D;

@end
