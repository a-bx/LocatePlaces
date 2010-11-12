//
//  Store.h
//  LocatePlaces
//
//  Created by Abraham Barrera on 23-08-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
#import "IModel.h"


@interface Store :  NSObject  <IModel>
{
}

@property (nonatomic, retain) NSString * idStore;
@property (nonatomic, retain) NSString * townName;
@property (nonatomic, retain) NSNumber * codTown;
@property (nonatomic, retain) NSString * className;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;


@end



