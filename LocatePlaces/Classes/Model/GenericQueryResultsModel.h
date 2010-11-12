//
//  GenericQueryResultsModel.h
//
//  
//

#import "Three20/Three20.h"
#import "QueryResultsModel.h"

@class GenericURLModelResponse;


@interface GenericQueryResultsModel : TTURLRequestModel <QueryResultsModel>
{
    GenericURLModelResponse *responseProcessor;
    NSDictionary *queryParams;
	QueryService service;
}

@end
