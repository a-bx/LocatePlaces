//
//  GenericQueryJSONResponse.m
//

#import "GenericQueryJSONResponse.h"
#import "Menu.h"
#import "State.h"
#import "Town.h"

#import "JSON.h"

@implementation GenericQueryJSONResponse

- (void)setServiceConfig:(NSDictionary *)service {
	serviceConfig = [service copy];
}

- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [responseBody JSONValue];
    [responseBody release];
    
    totalObjectsAvailableOnServer = [json count];
	NSArray *outputs = [serviceConfig objectForKey:@"Outputs"];
	NSString *outputClass = [serviceConfig objectForKey:@"OutputClass"];
    for (NSDictionary *rawResult in json) {
		id result = [[[NSClassFromString(outputClass) alloc] init] autorelease];

		for (NSDictionary *output in outputs) {
			
			if ([[result valueForKey:[output objectForKey:@"local"]] isKindOfClass:[NSNumber class]])
				[result setValue:[rawResult objectForKey:[output objectForKey:@"remote"]]
					  forKey:[output objectForKey:@"local"]];
			else 
				[result setValue:[[rawResult objectForKey:[output objectForKey:@"remote"]] copy]
						  forKey:[output objectForKey:@"local"]];
			 			 
		}

        [self.objects addObject:result];
    }
    
    return nil;
}

- (NSString *)format { return @"json"; }

@end
