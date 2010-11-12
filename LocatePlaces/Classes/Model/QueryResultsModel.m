//
//  SearchResultsModel.m
//
//  Created by Keith Lazuka on 7/25/09.
//

#import "QueryResultsModel.h"
#import "GenericQueryResultsModel.h"
 
QueryService CurrentQueryService = QueryServiceDefault;
QueryResponseFormat CurrentQueryResponseFormat = QueryResponseFormatDefault;


id<QueryResultsModel> CreateQueryModel(QueryService service, QueryResponseFormat responseFormat)
{
    id<QueryResultsModel> model = nil;
	
    switch ( service ) {
        case QueryServiceMenu:
            model = [[[GenericQueryResultsModel alloc] initWithResponseFormat:responseFormat andService:service] autorelease];
            break;	
		case QueryServiceState:
            model = [[[GenericQueryResultsModel alloc] initWithResponseFormat:responseFormat andService:service] autorelease];
            break;	
		case QueryServiceTown:
            model = [[[GenericQueryResultsModel alloc] initWithResponseFormat:responseFormat andService:service] autorelease];
            break;	
		case QueryServiceStore:
            model = [[[GenericQueryResultsModel alloc] initWithResponseFormat:responseFormat andService:service] autorelease];
            break;	
        case QueryServiceParameter:
            model = [[[GenericQueryResultsModel alloc] initWithResponseFormat:responseFormat andService:service] autorelease];
            break;
		
    }
    return model;
}

id<QueryResultsModel> CreateQueryModelWithCurrentSettings(void)
{
    return CreateQueryModel(CurrentQueryService, CurrentQueryResponseFormat);
}