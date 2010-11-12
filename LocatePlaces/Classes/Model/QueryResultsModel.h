/*
 *  QueryResultsModel.h
 *
//  Created by Keith Lazuka on 7/25/09.
 *
 */

#import "Three20/Three20.h"


typedef enum {
    QueryServiceMenu,
	QueryServiceState,
	QueryServiceTown,
    QueryServiceStore,	
	QueryServiceStoreDetail,
	QueryServiceParameter,
    QueryServiceDefault = QueryServiceParameter
} QueryService;

extern QueryService CurrentQueryService;

typedef enum {
    QueryResponseFormatJSON,
    QueryResponseFormatDefault = QueryResponseFormatJSON
} QueryResponseFormat;

extern QueryResponseFormat CurrentQueryResponseFormat;



#pragma mark -

@protocol QueryResultsModel <TTModel>

@property (nonatomic, readonly) NSArray *results;                           
@property (nonatomic, readonly) NSUInteger totalResultsAvailableOnServer;   
@property (nonatomic, retain) NSDictionary *queryParams;                        

- (id)initWithResponseFormat:(QueryResponseFormat)responseFormat andService:(QueryService)queryService;         

@end

#pragma mark -

id<QueryResultsModel> CreateQueryModelWithCurrentSettings(void);
id<QueryResultsModel> CreateQueryModel(QueryService service, QueryResponseFormat responseFormat);

