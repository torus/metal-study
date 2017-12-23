//
//  Renderer.h
//  metal-game-study
//
//  Created by Toru Hisai on 2017/12/23.
//  Copyright © 2017年 Toru Hisai. All rights reserved.
//

#import <MetalKit/MetalKit.h>

// Our platform independent renderer class.   Implements the MTKViewDelegate protocol which
//   allows it to accept per-frame update and drawable resize callbacks.
@interface Renderer : NSObject <MTKViewDelegate>

-(nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view;

@end

