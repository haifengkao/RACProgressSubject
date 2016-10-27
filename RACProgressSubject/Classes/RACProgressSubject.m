//
//  RACProgressSubject.m
//  RACProgressSubject
//
//  Created by Hai Feng Kao on 2016/10/27.
//
//  It will receive multiple signals
//  and combine them to send one progress signal

#import "RACProgressSubject.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"

@interface RACProgressSubject()
@property (assign) NSUInteger currentIndex;
@property (assign) double lastestProgress;
@property (strong) RACDisposable* disposable;
@property (strong, readonly) NSArray* progresses;
@property (nonatomic, assign) BOOL hasCompleted;
@end

@implementation RACProgressSubject

- (instancetype)initWithProgresses:(NSArray*)theProgresses
{
    if (self = [super init]) {
        // add the beginning and ending progress
        // the progress value will always in [0, 1]
        theProgresses = theProgresses ?:[NSArray new]; // make sure it is not nil
        NSMutableArray* progresses = [theProgresses mutableCopy];
        [progresses insertObject:@(0.0) atIndex:0];
        [progresses addObject:@(1.0)];
        _progresses = progresses;
    }
    return self;
}

#pragma mark RACSignal

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
    [subscriber sendNext:[RACObserve(self, lastestProgress) distinctUntilChanged]];
    [subscriber sendCompleted];

    return nil;
}

#pragma mark RACSubscriber

/** 
  * someone sends a new signal
  * the lastestProgress will subscribe from the new one
  * it will also invalidate the previous signal
  */
- (void)sendNext:(id)value {
    @synchronized (self) {
        if (![value isKindOfClass:[RACSignal class]]) {
            return;
        }
        NSUInteger index = self.currentIndex;
        if (index + 1 >= self.progresses.count) {
            return;
        } 
        double begin = [(NSNumber*)self.progresses[index] doubleValue];
        double end = [(NSNumber*)self.progresses[index+1] doubleValue];
        RACSignal* signal = [(RACSignal*)value map:^NSNumber*(NSNumber* progress){
            // map the progress value to [begin, end]
            return @(progress.doubleValue * (end - begin) + begin);
        }];

        @weakify(self);
        [self.disposable dispose]; // stop the previous signal
        self.disposable = [signal subscribeNext:^(NSNumber* p) {
            @strongify(self);
            self.lastestProgress = p.doubleValue;
        }];

        ++self.currentIndex;
    }
}

- (void)sendCompleted {
    // don't send completion
    // progressSubject will complete itself when the all progress signals are finished
}

- (void)sendError:(NSError *)e {
    // don't send error
    // progressSubject should not send errors (cannot be displayed anyway)
}

@end

