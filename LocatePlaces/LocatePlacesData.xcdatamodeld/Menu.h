//
//  Menu.h
//  LocatePlaces
//
//  Created by Abraham Barrera on 23-08-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
#import "IModel.h"

@interface Menu :  NSObject <IModel> 
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * idMenu;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * linkURL;

@end



