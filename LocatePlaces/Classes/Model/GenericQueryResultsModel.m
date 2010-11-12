//
//  GenericQueryResultsModel.m
//
//  
//

#import "GenericQueryResultsModel.h"
#import "GenericQueryJSONResponse.h"
#import "GTMNSDictionary+URLArguments.h"
#import "LPConfigHelper.h"

@implementation GenericQueryResultsModel

@synthesize queryParams;

- (id)initWithResponseFormat:(QueryResponseFormat)responseFormat andService:(QueryService)queryService
{
    if ((self = [super init])) {
        switch ( responseFormat ) {
            case QueryResponseFormatJSON:
                responseProcessor = [[GenericQueryJSONResponse alloc] init];
				service = queryService;
                break;
        }
    }
    return self;
}

- (id)init
{
    return [self initWithResponseFormat:CurrentQueryResponseFormat  andService:CurrentQueryService];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more 
{
    if (!queryParams) {
        NSLog(@"No params specified. Cannot load the model resource.");
        return;
    }
    
    [responseProcessor.objects removeAllObjects];  
    
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent:@"ServiceMapping.plist"];
	NSDictionary *plistDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	
	NSArray *services =  [plistDictionary objectForKey:@"Services"];
	NSDictionary *serviceLoc = [services objectAtIndex:service];
	NSDictionary *remoteParams =  [serviceLoc objectForKey:@"Parameters"];
	
	[responseProcessor setServiceConfig:serviceLoc];

    NSString *hostpath = [serviceLoc objectForKey:@"ServiceLocation"];
    NSString *url = [hostpath stringByAppendingFormat:@"?%@", [queryParams gtm_httpArgumentsStringWithDict:remoteParams]];
    TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
    request.cachePolicy = cachePolicy;
    request.response = responseProcessor;
    request.httpMethod = @"GET";
	 
	
    [request sendSynchronously];
}

- (void)reset
{
    [super reset];
    [queryParams release];
    [[responseProcessor objects] removeAllObjects];
}

- (void)setQueryParams:(NSDictionary *)theQueryParams
{
    if (![theQueryParams isEqual:queryParams]) {
        [queryParams release];
        queryParams = [theQueryParams retain];
    }
}

- (NSArray *)results
{
    return [[[responseProcessor objects] copy] autorelease];
}

- (NSUInteger)totalResultsAvailableOnServer
{
    return [responseProcessor totalObjectsAvailableOnServer];
}

- (void)dealloc
{
    [queryParams release];
    [responseProcessor release];
    [super dealloc];
}


@end
