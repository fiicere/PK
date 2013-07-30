//
//  Settings.m
//  PK
//
//  Created by Kevin Yue on 7/30/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "Settings.h"

@implementation Settings

static Settings *instance;


+(Settings*) getInstance{
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

@end
