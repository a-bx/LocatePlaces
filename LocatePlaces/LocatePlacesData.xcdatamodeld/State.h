//
//  State.h
//  LocatePlaces
//
//  Created by Abraham Barrera on 23-08-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
#import "IModel.h"

@interface State :  NSObject <IModel> 
{
}

@property (nonatomic, retain) NSNumber * codState;
@property (nonatomic, retain) NSString * name;

@end



