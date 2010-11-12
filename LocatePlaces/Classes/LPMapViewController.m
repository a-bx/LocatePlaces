//
//  LPMapViewController.m
//  
//
//  Created by Abraham Barrera Curin  
//

#import "LPMapViewController.h"
#import "LPConfigHelper.h"
#import "JSON/JSON.h"

@implementation LPMapViewController
@synthesize loadingView, mapPlacesView, mkmapView, selectedMenuItem;

#pragma mark -
#pragma mark View lifecycle

- (void) loading:(BOOL)show {
	if (show) {
		[self.view addSubview:loadingView];
	} else {
		[loadingView removeFromSuperview];
	}

	
}

- (void) geoLocalize {
	[self loading:YES];
	locationManagerMap = [[CLLocationManager alloc] init];
	locationManagerMap.delegate = self;
	locationManagerMap.desiredAccuracy = kCLLocationAccuracyBest;
	locationManagerMap.distanceFilter = 100;
	[locationManagerMap startUpdatingLocation];
}

- (id)initWithName:(NSString *)nibName store:(NSString *)store {
	return [self initWithNibName:nibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:@"LPMapViewController" bundle:nibBundleOrNil])) {
		self.title = @"Donde Queda?";
		[self.navigationController.navigationBar setTranslucent:YES];
		[self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];	
		LPConfigMenuItem *selected = [[LPConfigMenuItem alloc] init];
	
		selected.aroundUser = YES;
		selected.drawLine = YES;
		selected.showList = NO;
		selected.filtered = NO;
 
		self.selectedMenuItem = selected;
    }
    return self;
}

- (void) centerMapDefault {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	CLLocationCoordinate2D location_default = location;
	location_default.latitude =  [defaults floatForKey:@"slider_latitude"];
	location_default.longitude = [defaults floatForKey:@"slider_longitude"];
	
	MKCoordinateRegion region;
	region.center = location_default;
	MKCoordinateSpan span;
	span.latitudeDelta = .050;
	span.longitudeDelta = .050;
	region.span = span;
	
	[mkmapView setRegion:region animated:FALSE];
 
	
}

- (void)viewDidLoad {
	self.selectedMenuItem.aroundUser = YES;
	[self centerMapDefault];
	mkmapView.delegate = self;
	
	[mkmapView setShowsUserLocation:YES];
	
	[self reloadWithRefresh:YES];
 
	[super viewDidLoad];
}


- (void) initData {
	selectedStore = nil;
	allStores = [[NSMutableArray alloc] init];
}
 
- (void) refreshData {
	
	[self loading:NO];
	
	if (self.selectedMenuItem.aroundUser) {
		[self initData];
		[self geoLocalize];
	}
}

- (void) reloadWithRefresh:(BOOL)refresh {
	if (refresh) {		
		[self loading:YES];
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshData) userInfo:nil repeats:NO];
	}
}
 
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
 
  

#pragma mark -
#pragma mark locationManager Delegate & Trace routes
- (NSString *)stringWithGetUrl:(NSURL *)url{
	
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
	
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	
	
}

- (id) objectWithGetUrl:(NSURL *)url{
	
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSString *jsonString = [self stringWithGetUrl:url];
	return [jsonParser objectWithString:jsonString error:NULL];
}

- (NSDictionary *) getRouteFromPoint:(CLLocationCoordinate2D)fromLocation
							 ToPoint:(CLLocationCoordinate2D)toLocation {
	
	NSString *GGServiceLocation = @"http://maps.google.com/maps/api";
	
	NSString *fromlat = [[NSString alloc] initWithFormat:@"%f", fromLocation.latitude]; 	
	NSString *fromlng = [[NSString alloc] initWithFormat:@"%f", fromLocation.longitude];
	NSString *tolat = [[NSString alloc] initWithFormat:@"%f", toLocation.latitude]; 	
	NSString *tolng = [[NSString alloc] initWithFormat:@"%f", toLocation.longitude];
	
	
	NSString *url=[[NSString alloc] 
				   initWithFormat:@"%@/directions/json?origin=%@,%@&destination=%@,%@&sensor=false&mode=walking&language=es", 
				   GGServiceLocation,
				   [fromlat  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
				   [fromlng  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
				   [tolat  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
				   [tolng  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
				   ];
	
 	NSURL *nurl = [NSURL URLWithString:url];
	id response = [self objectWithGetUrl:nurl];	
	NSDictionary *routes = (NSDictionary *)response;
	return routes;
	
	
}

- (void)traceRouteAtMap {
	
	NSMutableArray *closestStores = [[NSMutableArray alloc] init]; 

	_routeViews = [[NSMutableDictionary alloc] init];
	@try {
		if ([anotationsRoute count] > 0) {
			[mkmapView removeAnnotations:anotationsRoute];	
		}
	} @finally {
		//	nothing 
	}	
	anotationsRoute = [[NSMutableArray alloc] init]; 
	
 
	closestStores = [self getClosestStoreToLocation:location Type:selectedMenuItem.paramTypeId];
	if ([closestStores count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:selectedMenuItem.title 
														message:@"No existe ninguna sucursal cercana" 
													   delegate:self 
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
		[alert show]; 
		
		return;
	}
	
	NSDictionary *fields =  [closestStores objectAtIndex:0];		
	CLLocationCoordinate2D closestPoint;
	closestPoint.latitude = [[fields valueForKey:@"latitude"] floatValue];
	closestPoint.longitude = [[fields valueForKey:@"longitude"] floatValue];
	
 
	NSDictionary *route = [self  getRouteFromPoint:location
										   ToPoint:closestPoint];
	
	NSMutableArray *steps = [(NSMutableArray*)[[(NSDictionary*)
							 [(NSMutableArray*)[route valueForKey:@"routes"] objectAtIndex:0]
												valueForKey:@"legs"] objectAtIndex:0] valueForKey:@"steps"];
	
		
	NSInteger indstep = 0;
	
 
	NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:[steps count]];

	for (indstep=0; indstep < [steps count]; indstep++) {
		NSDictionary *step = [steps objectAtIndex:indstep];
		NSDictionary *start_location = (NSDictionary*)[step valueForKey:@"start_location"];
		NSDictionary *end_location = (NSDictionary*)[step valueForKey:@"end_location"];		
		
 
		CLLocationDegrees latitude_start  = [[start_location valueForKey:@"lat"] doubleValue];
		CLLocationDegrees longitude_start = [[start_location valueForKey:@"lng"] doubleValue];
		CLLocationDegrees latitude_end  = [[end_location valueForKey:@"lat"] doubleValue];
		CLLocationDegrees longitude_end = [[end_location valueForKey:@"lng"] doubleValue];
		
		
		CLLocation* startLocation = [[[CLLocation alloc] initWithLatitude:latitude_start longitude:longitude_start] autorelease];
		CLLocation* endLocation = [[[CLLocation alloc] initWithLatitude:latitude_end longitude:longitude_end] autorelease];

		[points addObject:startLocation];
		[points addObject:endLocation];		
		
	}
 
	CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
	[mkmapView addAnnotation:routeAnnotation];
    [anotationsRoute addObject:routeAnnotation];
	
	[points release];

	[mkmapView setRegion:routeAnnotation.region];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
 
	[manager stopUpdatingLocation];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 

	location = newLocation.coordinate;
	
	if ([defaults boolForKey:@"enabled_preference"]){
		location.latitude = [defaults floatForKey:@"slider_latitude"];
		location.longitude = [defaults floatForKey:@"slider_longitude"];
 	}

	NSLog(@"Localized at: (%f, %f)", location.latitude, location.longitude);
	[self reloadStores];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showItemsAtMap) userInfo:nil repeats:NO];
	
	if (selectedMenuItem.drawLine) {
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(traceRouteAtMap) userInfo:nil repeats:NO];
	}
}

 
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (selectedMenuItem.filtered) {
		return selectedMenuItem.filterLevel;
	} else {
		return 1;
	}
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		if (selectedMenuItem.filtered) {
			return selectedMenuItem.filterLevel;
		} else {
			return [allStores count];
		}
	} else {
		return [allStores count];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier =[NSString stringWithFormat:@"Cell%d-%d", indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	/*    
    // Configure the cell...
    */
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	 
	 */
	
}

- (void) centerMap {
	if (selectedStore != nil) {
		
		NSDictionary *storefields =  [selectedStore valueForKey:@"fields"];		  
		
		location.latitude = [[storefields valueForKey:@"latitude"] floatValue]; 
		location.longitude = [[storefields valueForKey:@"longitude"] floatValue]; 
		
	}
	
	
	MKCoordinateRegion region;
	region.center = location;
	MKCoordinateSpan span;
	span.latitudeDelta = .010;
	span.longitudeDelta = .010;
	region.span = span;
	
	[mkmapView setRegion:region animated:TRUE];
}

- (void) putAllOthers {
	NSInteger storeIndex = 0;
	for (storeIndex = 0; storeIndex < [allStores count]; storeIndex++) {
		
		CLLocationCoordinate2D mycords;
		NSDictionary *storeFields = [allStores objectAtIndex:storeIndex];
		mycords.latitude = [[storeFields valueForKey:@"latitude"] floatValue]; 
		mycords.longitude = [[storeFields valueForKey:@"longitude"] floatValue]; 
		NSString *name = [storeFields valueForKey:@"name"];
		NSString *color = [storeFields valueForKey:@"name"];		
		NSString *mapImage = [storeFields valueForKey:@"image"];
		
		
		CSMapAnnotation *annotation = nil;
		
		annotation = [[[CSMapAnnotation alloc]
					   initWithCoordinate:mycords 
					   annotationType:CSMapAnnotationTypeImage 
					   title:name 
					   color:color 
					   imageUrl:mapImage 
					   indx:(NSInteger*)storeIndex
					   opened:NO] autorelease];
		
		[anotations addObject:annotation];
		[mkmapView  addAnnotation:annotation];
		[annotation release];
		
	}
}

- (void) putItemsAtMap {
	 	
	@try {
		if ([anotations count] > 0) {
			[mkmapView removeAnnotations:anotations];	
		}
	} @finally {
		//	nothing 
	}	 
	
	anotations = [[NSMutableArray alloc] init];

	[self putAllOthers];
	

}

#pragma mark mapView delegate functions



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	/*
	
	 */
}





- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}	
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	
	MKAnnotationView* annotationView = nil;
	
	if (annotation == [mapView userLocation]) { 
		return nil;
	}  
	
	[mkmapView setDelegate:self];
	if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteView* routeView = [[[CSRouteView alloc] 
										initWithFrame:CGRectMake(0, 0, mkmapView.frame.size.width, mkmapView.frame.size.height)] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = mkmapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];

			annotationView = routeView;
		}
		
		return annotationView;
		 
	} else {
 
		CSImageAnnotationView *pinAnnotation=[[CSImageAnnotationView alloc] 
								 initWithAnnotation:annotation 
								 reuseIdentifier:@"store"];
	
		pinAnnotation.userInteractionEnabled=TRUE;
		pinAnnotation.canShowCallout=TRUE; 
	
		
		UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		myDetailButton.frame = CGRectMake(0, 0, 23, 23);
		myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
		pinAnnotation.rightCalloutAccessoryView = myDetailButton; 
	
		[pinAnnotation setTag:(NSInteger)[(CSMapAnnotation*)annotation indx]];
	
		return pinAnnotation;
	 
	 }
	
}


- (void) showItemsAtMap {
	[self centerMap];
	[self putItemsAtMap];
	[self loading:NO];
	
}

- (void) reloadStores {
	
	NSString *locate = [NSString stringWithFormat:@""];
	if (selectedMenuItem.aroundUser)
		locate = @"1";
	else 
		locate = @"0";
	
	
	selectedStore = nil;
	
	allStores = [[self getDataAllStoresBySearch:@"" 
										Cateory:nil 
									SubCategory:nil 
										  State:nil 
										   Town:nil 
										   Type:[self.selectedMenuItem paramTypeId] 
										 Locate:locate
									   Location:location]
				 copy];
	
}



#pragma mark -
#pragma mark Picker View Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 0;
}

#pragma mark -
#pragma mark Picker View Delegate 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return @"Todas";
}


#pragma mark -
#pragma mark self data Management


- (NSMutableArray *) getClosestStoreToLocation:(CLLocationCoordinate2D)location2D
										  Type:(NSString*)type {
	//la oficina más cercana - Implementar
	NSDictionary *store = [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"-33.41269", @"latitude",
						   @"-70.57909", @"longitude",		
						   @"Continuum Chile",@"name",
						   @"123456",@"phone_one",
						   @"http://abarrera.webfactional.com/continuum.png", @"image",
						   nil];
	
	NSMutableArray *closestSotres = [[NSMutableArray alloc] 
								 initWithObjects:store, nil];
	return closestSotres; 
}

- (NSMutableArray *) getDataAllStoresBySearch:(NSString *)text 
									  Cateory:(NSDictionary *)category 
								  SubCategory:(NSDictionary *)subCategory 
										State:(NSDictionary *)state
										 Town:(NSDictionary *)town 
										 Type:(NSString*)type
									 Locate:(NSString*)locate
									 Location:(CLLocationCoordinate2D)location2D {

	//Todas las oficinas -  Implementar
	NSDictionary *store = [[NSDictionary alloc] initWithObjectsAndKeys:
							@"-33.41269", @"latitude",
							@"-70.57909", @"longitude",		
							@"Continuum Chile",@"name",
							@"123456",@"phone_one",
						    @"http://abarrera.webfactional.com/continuum.png", @"image",						   
							nil];
						   
	NSMutableArray *allSotres = [[NSMutableArray alloc] 
								 initWithObjects:store, nil];
	return allSotres; 
	
}

 

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}


@end

