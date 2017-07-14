//
//  BarrierObject.m
//  FEThreadSafe
//
//  Created by keso on 2017/7/14.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "BarrierObject.h"

@implementation BarrierObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
//        _subItems = [NSArray array];
    }
    return self;
}

//- (void)addItem:(NSString *)item {
//    
//    [self.data addObject:item];
//}



- (NSMutableArray *)data {
    __block NSMutableArray *array;
    dispatch_sync(self.syncQueue, ^{
        array = _data;
    });
    return array;
}

- (void)addItem:(NSString *)item {
    dispatch_barrier_async(self.syncQueue, ^{
        [_data addObject:item];
    });
}

//- (NSArray *)subItems {
//    __block NSArray *array;
//    dispatch_sync(self.syncQueue, ^{
//        array = _subItems;
//    });
//    return array;
//}

//- (void)setsubItems:(NSArray *)subItemsArray {
//    __block NSArray * array = subItemsArray.copy;
//    dispatch_barrier_async(self.syncQueue, ^{
//        _subItems = array;
//    });
//}

//- (void)addsubItem:(NSString *)string
//{
//    dispatch_barrier_async(self.syncQueue, ^{
//        NSMutableArray * array = [NSMutableArray arrayWithArray:_subItems];
//        [array addObject:string];
//        self.subItems = array;
//    });
//}

#pragma mark - Private

- (dispatch_queue_t)syncQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

@end
