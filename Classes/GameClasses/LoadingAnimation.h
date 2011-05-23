//
//  LoadingAnimation.h
//  game
//
//  Created by FIH on 2009/10/6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"

@interface LoadingAnimation : NSObject {
	Texture2D *loadingDot;
    NSInteger dots;
}

-(BOOL)initLoadAnim:(id)view;
-(BOOL)drawLoadAnim:(id)view fadeLevel:(GLfloat)fadeLevel;
-(BOOL)endLoadAnim:(id)view;

@end
