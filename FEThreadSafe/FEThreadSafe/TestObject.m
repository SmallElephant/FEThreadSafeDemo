//
//  TestObject.m
//  FEThreadSafe
//
//  Created by keso on 2017/7/14.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSArray array];
    }
    return self;
}

- (NSArray *)data {
    __block NSArray* array;
    dispatch_sync(self.syncQueue, ^{
        array = _data;
    });
    return array;
}

- (void)addItem:(NSString *)item {
    dispatch_async(self.syncQueue, ^{
        NSMutableArray * array = [NSMutableArray arrayWithArray:_data];
        [array addObject:item];
        self.data = array;
    });
}

#pragma mark - Private Properties

- (dispatch_queue_t)syncQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}



@end
