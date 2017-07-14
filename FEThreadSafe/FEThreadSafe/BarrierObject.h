//
//  BarrierObject.h
//  FEThreadSafe
//
//  Created by keso on 2017/7/14.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarrierObject : NSObject

@property (strong, nonatomic) NSMutableArray *data;

- (void)addItem:(NSString *)item;

@end
