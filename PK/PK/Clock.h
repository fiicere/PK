//
//  Clock.h
//  PK
//
//  Created by Kevin Yue on 8/9/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clock : NSObject

+(Clock *) getInstance;

-(void)reset;

-(CGFloat)getTime;

@end
