//
//  ViewController.m
//  GCDDemo
//
//  Created by lvzhao on 2020/7/27.
//  Copyright © 2020 吕VV. All rights reserved.
//

#import "ViewController.h"


//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL(globalQueueBlock)   dispatch_async(dispatch_get_global_queue(0, 0), globalQueueBlock);



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    /**
        简书地址:https://www.jianshu.com/u/e42bc3f050b7
     
            最近面试, 看了一些GCD的文章, 于是决定自己写一下,增加自己的理解
     */
    /*dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //执行耗时操作
    ……
    dispatch_async(dispatch_get_main_queue(), ^{
    //回到主线程进行UI刷新操作
    };
    };

    作者：不死鸟fj
    链接：https://www.jianshu.com/p/46500f070e9c
    来源：简书
    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。**/
    
    
    /**
     最常用用的一个
     */
    //执行耗时的操作
        
         
    
    
   
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 100; i++){
            NSLog(@"%d",i);
        }
                
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"执行完毕, 到主线程了");
        });
    });

    
    
    
    
    //宏定义
    kDISPATCH_GLOBAL(^{
        for (int i = 0; i < 1000; i++){
            NSLog(@"%d",i);
        }
        kDISPATCH_MAIN_THREAD(^{
            NSLog(@"执行完毕, 到主线程了");
        });
    });
    
    
    
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
          NSLog(@"start task 1");
          [NSThread sleepForTimeInterval:3];
          NSLog(@"end task 1");
      });
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
          NSLog(@"start task 2");
          [NSThread sleepForTimeInterval:3];
          NSLog(@"end task 2");
      });
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
          NSLog(@"start task 3");
          [NSThread sleepForTimeInterval:3];
          NSLog(@"end task 3");
      });
      
    */
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 1");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 2");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"end task 3");
    });
    
    
    //结果很明显已经完全按照我们的优先级进行执行的
    //DISPATCH_QUEUE_PRIORITY_HIGH>DISPATCH_QUEUE_PRIORITY_DEFAULT>DISPATCH_QUEUE_PRIORITY_LOW

    /*
    相信大家已经明白第一个参数的作用了吧，如果你的需求需要某个并发线程先执行，可以通过设置优先级来达到目的，但是因为线程是并发执行的，所以你不能保证哪个线程会先执行完，也就是不能保证我们的耗时任务是按照顺序执行的。
    那么如何才能保证按顺序执行呢？这就需要我们自定义串行的queue来解决，系统为我们提供了这个方法dispatch_queue_create(const char *label, dispatch_queue_attr_t attr)，这个方法同样也有两个参数，第一个参数是确定唯一queue的一个标识，第二个参数创建queue的类型，串行的还是并行的。下面看一个例子：
     **/
    /**
     *  我们创建了一个串行的queue
     *
     *  @ "com.gcd.test.queue"  唯一标识这个queue
     *  @ DISPATCH_QUEUE_SERIAL 说明是串行的queue
     */
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
    
    /**
     有两点需要注意的地方，第一，串行queue严格按照顺序执行耗时任务。第二，GCD在执行串行queue时，其实是在一个线程中完成的。而在并发的queue中，我们会发现线程ID都是不一样的，说明是多个线程。
     如果我们在queue的创建时dispatch_queue_t myQueue = dispatch_queue_create("com.gcd.test.queue", DISPATCH_QUEUE_SERIAL)，我们把参数DISPATCH_QUEUE_SERIAL变成DISPATCH_QUEUE_CONCURRENT，将会创建一个并发的queue，此处的结果和global_queue无异，这里不在赘述。
     dispatch_group_queue
        GCD另一个比较常用的方法就是dispatch_group_queue，
        在我们平时实际项目中经常会有这样的需求，就是在多个任务异步处理后我们需要一个统一的回调通知去处理接下来的业务，这个时候我们就想到了dispatch group了，当所有任务完成后会调用dispatch_group_notify，来看一个例子：
     */

   
    /**
     *  创建一个并发的queue
     */
//    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.queue", DISPATCH_QUEUE_CONCURRENT);
//    /**
//     *  创建一个group
//     */
//    dispatch_group_t group = dispatch_group_create();
//    /**
//     *  执行3个耗时任务
//     */
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"start task 1");
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"end task 1");
//    });
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"start task 2");
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"end task 2");
//    });
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"start task 3");
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"end task 3");
//    });
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"task over");
//    });
  
    
    /*
     当三个异步耗时操作完成后，统一一个回调，两点注意：

     回调回来的数据异步线程中。所以如果后续执行刷新UI操作需要到主线程中完成。
     接收回调的这个线程就是任务最后执行完的那个线程，系统做了优化并没有多开一个线程来处理。
     很多同学比较容易犯一个错误，假如我们有两个请求需要同时发送，并统一回调，很多同学这时候就会想到了dipatch_group。
  。**/
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t group = dispatch_group_create();
//
//    dispatch_group_async(group, queue, ^{
//        [self sendRequest1:^{
//        }];
//    });
//
//    dispatch_group_async(group, queue, ^{
//        [self sendRequest2:^{
//        }];
//    });
//
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"dispatch_group_notify task over");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"dispatch_async refresh ui");
//        });
//    });
    
    /**
     其中sendRequest1和sendRequest2是两个异步请求，可以简单理解为我们的业务请求API，我们最初的设想是task1和task2完成后统一回调回来，但结果确实这样：
        dispatch_group_notify task over ispatch_async refresh ui 直接就运行了 结果肯定不是我们想要的
     dispatch_group_enter() & dispatch_group_leave这对组合。我们把这个需求重新实现一下：
     
     */
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [self sendRequest1:^{
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [self sendRequest2:^{
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, queue, ^{
        NSLog(@"dispatch_group_notify task over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatch_async refresh ui");
        });
    });
    

}

- (void)sendRequest1:(void(^)(void))block {
   //异步请求，请求结果后block回调
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSLog(@"sendRequest1 start task 1");
       [NSThread sleepForTimeInterval:3];
       NSLog(@"sendRequest1 end task 1");
       dispatch_async(dispatch_get_main_queue(), ^{
           if (block) {
               block();
           }
       });
   });
}
   
- (void)sendRequest2:(void(^)(void))block {
   //异步请求，请求结果后block回调
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSLog(@"sendRequest2 start task 2");
       [NSThread sleepForTimeInterval:3];
       NSLog(@"sendRequest2 end task 2");
       dispatch_async(dispatch_get_main_queue(), ^{
           if (block) {
               block();
           }
       });
   });

}

@end
