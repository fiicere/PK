//
//  ScoreKeeper.h
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreKeeper : NSObject


+(ScoreKeeper *) getInstance;

-(void)incScore:(int)inc;

-(void)setScore:(int)newScore;

-(int)getScore;

@end
