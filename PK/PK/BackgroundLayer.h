//
//  BackgroundLayer.h
//  PK
//
//  Created by Kevin Yue on 7/11/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FocusedLayer.h"

@interface BackgroundLayer : FocusedLayer {
    
}

-(BackgroundLayer*) initWithFile:(NSString*)filename withDepth:(int)depth;

@end
