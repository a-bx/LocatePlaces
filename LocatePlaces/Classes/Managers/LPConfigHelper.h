//
//  LPConfigHelper.h
//  LocatePlaces
//
//  Created by Abraham Barrera Curin  
//   
//

#import <Foundation/Foundation.h>


@interface LPConfigHelper : NSObject {

}
 
+ (NSString*)getPListValueForKey:(NSString *)key;
+ (NSMutableArray*)getPListArrayForKey:(NSString *)key;	
+ (NSDictionary*)getPListDicForKey:(NSString *)key;	
+ (bool)getPListBoolForKey:(NSString *)key;

@end
