//
//  WoDGradient.m
//  PK
//
//  Created by PHILLIP SEO on 8/2/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "WoDGradient.h"
#import "WallOfDeath.h"

NSString* const gradfile = @"WoDGradient.tif";

@implementation WoDGradient

-(id) init {
    self = [super initWithFile:gradfile];
    if (self) {
        [self schedule:@selector(followWall:)];
    }
    return self;
}

-(void)followWall:(ccTime)dt{
    CGFloat xloc = [WallOfDeath getInstance].position.x;
    CGFloat yloc = [WallOfDeath getInstance].position.y;
    
    self.position = ccp(xloc + [WallOfDeath getInstance].boundingBox.size.width/2, yloc);
}

@end
