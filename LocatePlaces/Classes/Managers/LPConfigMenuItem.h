//
//  LPConfigMenuItem.h
//   
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@interface LPConfigMenuItem : NSObject {
	NSString *title;
	NSString *secondTitle;
	NSInteger type;
	NSString *paramTypeId;
	BOOL aroundUser;
	BOOL drawLine;
	BOOL showList;
	BOOL filtered;
	BOOL reload;
	NSString *filterKey;
	NSInteger filterLevel;
	UITableViewCellAccessoryType indicator;
	NSInteger tabNumber;
	NSInteger indexMenu;
}
 

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *secondTitle;
@property (nonatomic) NSInteger type;
@property (nonatomic, retain) NSString *paramTypeId;
@property (nonatomic) BOOL aroundUser;
@property (nonatomic) BOOL drawLine;
@property (nonatomic) BOOL showList;
@property (nonatomic) BOOL filtered;
@property (nonatomic) BOOL reload;
@property (nonatomic, retain) NSString *filterKey;
@property (nonatomic) NSInteger filterLevel;
@property (nonatomic) UITableViewCellAccessoryType indicator;
@property (nonatomic) NSInteger tabNumber;
@property (nonatomic) NSInteger indexMenu;

- (id)initWithIndex:(NSInteger)index MenuItems:(NSMutableArray *)menuItems;
- (id)initWithTabNumber:(NSInteger)number  MenuItems:(NSMutableArray *)menuItems;
- (id)initWithMenuItem:(NSDictionary *)myMenuItem;

@end
