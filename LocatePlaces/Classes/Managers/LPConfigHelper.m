//
//  ConfigHelper.m
//  LocatePlaces
//
//  Created by Abraham Barrera Curin  
//   
//

#import "LPConfigHelper.h"


@implementation LPConfigHelper


+ (NSString*)getPListValueForKey:(NSString *)key {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

+ (NSMutableArray*)getPListArrayForKey:(NSString *)key {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

+ (NSDictionary*)getPListDicForKey:(NSString *)key {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];	
}

+ (bool)getPListBoolForKey:(NSString *)key {
	return [[[NSBundle mainBundle] objectForInfoDictionaryKey:key] boolValue];
}


@end
