
#import "Three20/Three20.h"

/*
 *      GenericURLModelResponse
 *      ----------------
 *
 *  An abstract base class for HTTP response parsers
 *  that construct domain objects from the response.
 *
 *  Subclasses are responsible for setting the 
 *  |totalObjectsAvailableOnServer| property from
 *  the HTTP response. This enables features like
 *  the photo browsing systems automatic
 *  "Load More Photos" button.
 *
 */

@interface GenericURLModelResponse : NSObject <TTURLResponse>
{
    NSMutableArray *objects;
    NSUInteger totalObjectsAvailableOnServer;
}

@property (nonatomic, retain) NSMutableArray *objects; 
@property (nonatomic, readonly) NSUInteger totalObjectsAvailableOnServer;

+ (id)response;
- (NSString *)format;
- (void)setServiceConfig:(NSDictionary *)service;

@end
