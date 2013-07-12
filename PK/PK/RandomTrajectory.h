//
//  Trajectory.h
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomTrajectory : NSObject

@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat endX;
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) CGFloat endY;
@property (nonatomic, assign) CGFloat trajdX;
@property (nonatomic, assign) CGFloat trajdY;
@property (nonatomic, assign) CGFloat norm;

@end
