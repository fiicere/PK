//
//  Clock.m
//  PK
//
//  Created by Kevin Yue on 8/9/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "Clock.h"

static Clock * instance;
CFTimeInterval startTime;


@implementation Clock

+(Clock *) getInstance{
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    startTime = CACurrentMediaTime();
	return self;
}


-(void) reset{
    instance = [[Clock alloc] init];
}

-(CGFloat) getTime{
    return fabsf(startTime - CACurrentMediaTime());
}

@end
