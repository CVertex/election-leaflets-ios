//
//  Helper.m
//  Election Leaflets
//
//  Created by Vijay Santhanam on 28/07/10.
//  Copyright 2010 Vijay Santhanam. All rights reserved.
//

#import "Helper.h"


@implementation Helper


+ (NSURL*) createURLFromString:(NSString*)url {
	NSString * cleaned = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	return [NSURL URLWithString:cleaned];
}

@end
