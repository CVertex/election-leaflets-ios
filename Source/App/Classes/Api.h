/*
 *  Api.h
 *  Election Leaflets
 *
 *  Created by Vijay Santhanam on 26/07/10.
 *  Copyright 2010 Vijay Santhanam. All rights reserved.
 *
 */

#define API_BASE @"http://ec2-204-236-186-66.us-west-1.compute.amazonaws.com"
#define API(__PATH) ([NSString stringWithFormat:@"%@%@",API_BASE,__PATH])


#define CACHE_EXPIRATION_AGE_IN_SECONDS (60.0*60.0*24) // 1 day
#define THUMBNAIL_WIDTH 89.0
#define THUMBNAIL_HEIGHT 50.0