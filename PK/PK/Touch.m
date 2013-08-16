//
//  Touch.m
//  PK
//
//  Created by Kevin Yue on 8/16/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "Touch.h"

@implementation Touch

-(id)initWithLoc:(CGPoint)loc Time:(CGFloat)t NumTaps:(CGFloat)nt{
    self = [super init];
    if(self){
        _location = loc;
        _time = t;
        _numTaps = nt;
    }
    return self;
}

@end
