//
//  LPConfigMenuItem.m
//
//  Created by Abraham Barrera  .
//  Copyright 2010  All rights reserved.
//

#import "LPConfigMenuItem.h"


@implementation LPConfigMenuItem
 

@synthesize title;
@synthesize secondTitle;
@synthesize type;
@synthesize paramTypeId;
@synthesize aroundUser;
@synthesize drawLine;
@synthesize showList;
@synthesize filtered;
@synthesize reload;
@synthesize filterKey;
@synthesize filterLevel;
@synthesize indicator;
@synthesize tabNumber;
@synthesize indexMenu;


- (id)initWithMenuItem:(NSDictionary *)myMenuItem {
	
	self.title = [myMenuItem objectForKey:@"Title"];
	self.secondTitle = [myMenuItem objectForKey:@"SecondTitle"];
	self.type = (NSInteger)[[myMenuItem objectForKey:@"Type"] intValue];
	self.paramTypeId = [myMenuItem objectForKey:@"ParamTypeId"];
	self.indicator =  (UITableViewCellAccessoryType)[[myMenuItem objectForKey:@"Indicator"] intValue];
	self.tabNumber = (NSInteger)[[myMenuItem objectForKey:@"TabNumber"] intValue];
	
	
	switch (self.type) {
		case menuItemTypeWeb:
			self.aroundUser = NO;
			self.drawLine = NO;
			self.showList = NO;
			self.filtered = NO;
			self.filterKey = @"";
			self.filterLevel = 0;
			self.reload = [[myMenuItem objectForKey:@"Reload"] boolValue];
			break;			
		case menuItemTypeMap:
			self.aroundUser = [[myMenuItem objectForKey:@"AroundUser"] boolValue];
			self.drawLine = [[myMenuItem objectForKey:@"DrawLine"] boolValue];
			self.showList = [[myMenuItem objectForKey:@"ShowList"] boolValue];
			self.filtered = [[myMenuItem objectForKey:@"Filtered"] boolValue];
			self.filterKey = [myMenuItem objectForKey:@"FilterKey"];
			self.filterLevel = (NSInteger)[[myMenuItem objectForKey:@"FilterLevel"] intValue];
			self.reload = [[myMenuItem objectForKey:@"Reload"] boolValue];
			break;		
		case menuItemTypeLinkList:
			self.aroundUser = NO;
			self.drawLine = NO;
			self.showList = NO;
			self.filtered = [[myMenuItem objectForKey:@"Filtered"] boolValue];
			self.filterKey = [myMenuItem objectForKey:@"FilterKey"];
			self.filterLevel = (NSInteger)[[myMenuItem objectForKey:@"FilterLevel"] intValue];
			self.reload = [[myMenuItem objectForKey:@"Reload"] boolValue];			
			break;
			
		default:
			break;
	}
	
	return self;
	
}

- (id)initWithTabNumber:(NSInteger)number  MenuItems:(NSMutableArray *)menuItems{

	for (int i=0; i<[menuItems count]; i++) {
		NSDictionary *myMenuItem = [menuItems objectAtIndex:i];
		if ((NSInteger)[[myMenuItem objectForKey:@"TabNumber"] intValue]== number) {
			self.indexMenu = i;
			return [self initWithMenuItem:myMenuItem];
		}	
	}
	return self;
}

- (id)initWithIndex:(NSInteger)index MenuItems:(NSMutableArray *)menuItems {
	
	NSDictionary *myMenuItem = [menuItems objectAtIndex:index];
	self.indexMenu = index;
	return [self initWithMenuItem:myMenuItem];
	
}


@end


