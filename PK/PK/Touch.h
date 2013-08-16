//
//  Touch.h
//  PK
//
//  Created by Kevin Yue on 8/16/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Touch : NSObject

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, assign) CGFloat numTaps;


-(id)initWithLoc:(CGPoint)loc Time:(CGFloat)t NumTaps:(CGFloat)nt;

@end
