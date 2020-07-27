# GCDDemo
## GCD的一些用法
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 100; i++){
            NSLog(@"%d",i);
        }
                
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"执行完毕, 到主线程了");
        });
    });



    dispatch_queue_t myQueue = dispatch_queue_create("com.gcd.test.queue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(myQueue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 1");
    });

    dispatch_async(myQueue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 2");
    });

    dispatch_async(myQueue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 3");
    });
