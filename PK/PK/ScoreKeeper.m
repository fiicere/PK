//
//  ScoreKeeper.m
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "ScoreKeeper.h"

static ScoreKeeper *instance;
int score;

@implementation ScoreKeeper

+(ScoreKeeper *) getInstance{
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

-(void)setup{
    score = 0;
}

-(void)incScore:(int)inc{
    score += inc;
}

-(void)setScore:(int)newScore{
    score = newScore;
}

-(int) getScore{
    return score;
}
@end
