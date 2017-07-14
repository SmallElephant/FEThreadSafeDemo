//
//  ViewController.m
//  FEThreadSafe
//
//  Created by keso on 2017/7/14.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import "BarrierObject.h"

@interface ViewController ()

@property (assign, atomic) NSInteger numA;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testAtomic];
//    [self testsynchronized];
//    [self testlock];
//    [self testRecursiveLock];
//    [self testConditionLock];
//    [self testCondition];
//    [self testPthreadmutex];
//    [self testsemphore];
//    [self testSerialQueue];
    [self testBarrier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)testAtomic {
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_group_async(group, queue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            self.numA = self.numA + 1;
//        }
//    });
//    
//    
//    dispatch_group_async(group, queue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            self.numA = self.numA + 1;
//        }
//    });
//    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"最后的数据:%ld",self.numA);
//    });
    
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);


    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"%ld----dispatch_get_global_queue--开始numA:%ld",i,self.numA);
            self.numA = self.numA + 1;
            NSLog(@"%ld---dispatch_get_global_queue--结束numA:%ld",i,self.numA);
        }
    });
    
    
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"%ld----customQueue--开始numA:%ld",i,self.numA);
            self.numA = self.numA + 1;
            NSLog(@"%ld---customQueue--结束numA:%ld",i,self.numA);
        }
    });
}

- (void)testsynchronized {
    
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            @synchronized (self) {
//                NSLog(@"%ld----dispatch_get_global_queue--开始numA:%ld",i,self.numA);
//                self.numA = self.numA + 1;
//                NSLog(@"%ld---dispatch_get_global_queue--结束numA:%ld",i,self.numA);
//            }
//
//        }
//    });
//    
//    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            @synchronized (self) {
//                NSLog(@"%ld----customQueue--开始numA:%ld",i,self.numA);
//                self.numA = self.numA + 1;
//                NSLog(@"%ld---customQueue--结束numA:%ld",i,self.numA);
//            }
//        }
//    });
    
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    TestObject *obj = [[TestObject alloc] init];
    
    dispatch_async(customQueue, ^{
        @synchronized (obj) {
            NSLog(@"1---customQueue---开始");
            sleep(3); // 执行耗时操作
            NSLog(@"1---customQueue---结束");
        }
    });
    
    dispatch_async(customQueue, ^{
        sleep(1);
        @synchronized (obj) {
            NSLog(@"2---customQueue---执行");
        }
    });
    
//    dispatch_async(customQueue, ^{
//        NSLog(@"1---customQueue---开始");
//        sleep(3); // 执行耗时操作
//        NSLog(@"1---customQueue---结束");
//    });
//    
//    dispatch_async(customQueue, ^{
//        sleep(1);
//        NSLog(@"2---customQueue---执行");
//    });
}


- (void)testlock {
    
    NSLock *lock = [[NSLock alloc] init];
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_async(customQueue, ^{
//        [lock lock];
//        NSLog(@"1---NSLock---开始");
//        sleep(3); // 执行耗时操作
//        NSLog(@"1---NSLock---结束");
//        [lock unlock];
//    });
//    
//    dispatch_async(customQueue, ^{
//        [lock lock];
//        sleep(1);
//        NSLog(@"2---NSLock---执行");
//        [lock unlock];
//    });
    
    
    dispatch_async(customQueue, ^{
        [lock lock];
        NSLog(@"1---NSLock---开始");
        sleep(3); // 执行耗时操作
        NSLog(@"1---NSLock---结束");
        [lock unlock];
    });
    
    dispatch_async(customQueue, ^{
        sleep(1);

        if ([lock tryLock]) {
            NSLog(@"锁可用的操作");
            [lock unlock];
        } else {
            NSLog(@"锁不可用的操作");
        }
        
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:1];
        if ([lock lockBeforeDate:date]) {
            NSLog(@"获得锁，并成功解锁");
            [lock unlock];
        } else {
            NSLog(@"超时，没有获得锁");
        }
    });
    
}

- (void)testRecursiveLock {
    
//    NSLock *lock = [[NSLock alloc] init];
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_async(customQueue, ^{
//        [lock lock];
//        NSLog(@"1---NSLock---开始");
//        [lock lock];
//        NSLog(@"1---NSLock---执行");
//        [lock unlock];
//        NSLog(@"1---NSLock---结束");
//        [lock unlock];
//    });
//
//    dispatch_async(customQueue, ^{
//        [lock lock];
//        sleep(1);
//        NSLog(@"2---NSLock---执行");
//        [lock unlock];
//    });
    
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(customQueue, ^{
        [lock lock];
        NSLog(@"1---NSLock---开始");
        [lock lock];
        NSLog(@"1---NSLock---执行");
        [lock unlock];
        NSLog(@"1---NSLock---结束");
        [lock unlock];
    });
    
    dispatch_async(customQueue, ^{
        [lock lock];
        sleep(1);
        NSLog(@"2---NSLock---执行");
        [lock unlock];
    });
}

- (void)testConditionLock {
    
    NSConditionLock *lock = [[NSConditionLock alloc] init];
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(customQueue, ^{
        
        for (NSInteger i = 0; i <= 5 ; i++) {
            [lock lock];
            NSLog(@"1---customQueue:%ld",i);
            sleep(1);
            [lock unlockWithCondition:i];
        }
    });

    
    dispatch_async(customQueue, ^{
        [lock lockWhenCondition:5];
        NSLog(@"2---customQueue----执行");
        [lock unlock];
    });
    
}

- (void)testCondition {
    NSCondition *lock = [[NSCondition alloc] init];
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(customQueue, ^{
        [lock lock];
        NSLog(@"1---等待产品");
        [lock wait];
        NSLog(@"1---被唤醒");
        [products removeObjectAtIndex:0];
        NSLog(@"1---消费者移除了一个产品");
        [lock unlock];
    });
    
    
    dispatch_async(customQueue, ^{
        [lock lock];
        sleep(1);
        [products addObject:@"FlyElephant"];
        NSLog(@"2---生产者生产了一个产品");
        [lock broadcast];
        [lock unlock];
    });
    
}

- (void)testPthreadmutex {
    
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(customQueue, ^{
        pthread_mutex_lock(&mutex);
        NSLog(@"1---customQueue----开始");
        sleep(3);
        NSLog(@"1---customQueue----结束");
        pthread_mutex_unlock(&mutex);
    });

    
    dispatch_async(customQueue, ^{
        pthread_mutex_lock(&mutex);
        NSLog(@"2---customQueue----执行");
        pthread_mutex_unlock(&mutex);
    });
}

- (void)testOSSpinLock {
//    __block OSSpinLock spinlock = OS_SPINLOCK_INIT;
//    
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(customQueue, ^{
//        OSSpinLockLock(&spinlock);
//        NSLog(@"1---customQueue----开始");
//        sleep(3);
//        NSLog(@"1---customQueue----结束");
//        OSSpinLockUnlock(&spinlock);
//    });
//    
//    
//    dispatch_async(customQueue, ^{
//        OSSpinLockLock(&spinlock);
//        NSLog(@"2---customQueue----执行");
//        OSSpinLockUnlock(&spinlock);
//    });
    
    __block os_unfair_lock fairlock = OS_UNFAIR_LOCK_INIT;
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(customQueue, ^{
        os_unfair_lock_lock(&fairlock);
        NSLog(@"1---customQueue----开始");
        sleep(3);
        NSLog(@"1---customQueue----结束");
        os_unfair_lock_unlock(&fairlock);
    });
    
    
    dispatch_async(customQueue, ^{
        os_unfair_lock_lock(&fairlock);
        NSLog(@"2---customQueue----执行");
        os_unfair_lock_unlock(&fairlock);
    });
}

- (void)testsemphore {
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    dispatch_async(customQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // semaphore 为1 减去1 大于等于0 继续执行
        NSLog(@"1---customQueue----开始");
        sleep(3);
        NSLog(@"1---customQueue----结束");
        dispatch_semaphore_signal(semaphore); // semaphore 加1
    });

    
    dispatch_async(customQueue, ^{
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// semaphore 为0 减去1 小于0 等待
        NSLog(@"2---customQueue----执行");
        dispatch_semaphore_signal(semaphore);// semaphore 加1
    });
}

- (void)testSerialQueue {
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"%ld----dispatch_get_global_queue--开始numA:%ld",i,self.numA);
            self.numA = self.numA + 1;
            NSLog(@"%ld---dispatch_get_global_queue--结束numA:%ld",i,self.numA);
        }
    });
    
    
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"%ld----customQueue--开始numA:%ld",i,self.numA);
            self.numA = self.numA + 1;
            NSLog(@"%ld---customQueue--结束numA:%ld",i,self.numA);
        }
    });
    
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
//    
//    TestObject *obj = [[TestObject alloc] init];
//    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            NSLog(@"%ld----dispatch_get_global_queue--开始numA:%ld",i,obj.data.count);
//            [obj addItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---dispatch_get_global_queue--结束numA:%ld",i,obj.data.count);
//        }
//    });
//    
//    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            NSLog(@"%ld----customQueue--开始numA:%ld",i,obj.data.count);
//            [obj addItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---customQueue--结束numA:%ld",i,obj.data.count);
//        }
//    });
    

    
    
}

- (void)testBarrier {
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_sync(customQueue, ^{
//        NSLog(@"1---customQueue---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_sync(customQueue, ^{
//        NSLog(@"2---customQueue---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_sync(customQueue, ^{
//        NSLog(@"21---customQueue---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_sync(customQueue, ^{
//        NSLog(@"22---customQueue---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_barrier_async(customQueue, ^{
//        NSLog(@"3----barrier---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_async(customQueue, ^{
//        NSLog(@"4---customQueue---%@", [NSThread currentThread]);
//    });
//    
//    dispatch_async(customQueue, ^{
//        NSLog(@"5---customQueue---%@", [NSThread currentThread]);
//    });
    
//    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
//    
//    BarrierObject *obj = [[BarrierObject alloc] init];
//    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            NSLog(@"%ld---线程1---开始numA:%ld",i,obj.subItems.count);
//            [obj addsubItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---线程1---结束numA:%ld",i, obj.subItems.count);
//        }
//    });
//    
//    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            NSLog(@"%ld---customQueue---开始numA:%ld",i,obj.subItems.count);
//            [obj addsubItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---customQueue---结束numA:%ld",i,obj.subItems.count);
//        }
//    });
    //DISPATCH_QUEUE_SERIAL
    
    dispatch_queue_t customQueue = dispatch_queue_create("com.flyelephant.www", DISPATCH_QUEUE_CONCURRENT);
    
    __block BarrierObject *obj = [[BarrierObject alloc] init];
    
    [obj addItem:@"keso"];
    
    dispatch_async(customQueue, ^{
         NSLog(@"1---线程1---总数:%ld",obj.data.count);
    });
    
    dispatch_async(customQueue, ^{
        NSLog(@"2---线程1---总数:%ld",obj.data.count);
    });
    
    dispatch_async(customQueue, ^{
        NSLog(@"3---线程1---总数:%ld",obj.data.count);
    });
    
    dispatch_async(customQueue, ^{
        NSLog(@"4---线程1---总数:%ld",obj.data.count);
    });
    
    dispatch_async(customQueue, ^{
        NSLog(@"barrier---线程1---总数:%ld",obj.data.count);
        [obj addItem:@"FlyElephant"];
    });
    
    dispatch_async(customQueue, ^{
        sleep(1);
        NSLog(@"6---线程1---总数:%ld",obj.data.count);
    });

  
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//           
//            [obj addItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---线程1---结束numA:%ld",i, obj.data.count);
//        }
//    });
    
//    dispatch_async(customQueue, ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            NSLog(@"%ld---customQueue---开始numA:%ld",i,obj.data.count);
//            [obj addItem:[NSString stringWithFormat:@"%ld",i]];
//            NSLog(@"%ld---customQueue---结束numA:%ld",i, obj.data.count);
//        }
//    });

    
}

@end
