//
//  Settings.h
//  PK
//
//  Created by Kevin Yue on 7/30/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

typedef enum
{
    OPEN,
    BOX,
    DIRECTIONAL
} WorldType;


+(Settings*)getInstance;

@property (nonatomic, assign) WorldType wt;
@property (nonatomic, assign) int numPlayers;



@end
