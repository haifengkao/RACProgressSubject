//
//  Tests.m
//  RACProgressSubject
//
//  Created by Hai Feng Kao on 2016/10/27.
//

#import <Kiwi/Kiwi.h>
#import "RACProgressSubject.h"

SPEC_BEGIN(Tests)

describe(@"RACProgressSubject", ^{

    context(@"empty", ^{
        let(testee, ^{ // Occurs before each enclosed "it"
            return [[RACProgressSubject alloc] initWithProgresses:nil];
        });
        let(subject, ^{ // Occurs before each enclosed "it"
            return [RACSubject subject];
        });
        let(subject2, ^{ // Occurs before each enclosed "it"
            return [RACSubject subject];
        });
        let(done, ^{ // Occurs before each enclosed "it"
            return @0;
        });
        let(count, ^{ // Occurs before each enclosed "it"
            return @0;
        });

        it(@"will get the whole progress", ^{
            [testee subscribeNext:^(RACSignal* signal) {
                
                [signal subscribeNext:^(NSNumber* progress) {
                    // should receive 0.0, 0.1, 0.8 
                    count = @(count.integerValue + 1);
                }];
            }];
            [testee sendNext:subject];
            [testee sendNext:subject2];
            [subject2 sendNext:@2.0];
            [subject sendNext:@0.0];
            [subject2 sendNext:@3.0];
            [subject sendNext:@0.1];
            [subject sendNext:@0.8];

            [[expectFutureValue(count) shouldEventuallyBeforeTimingOutAfter(100000.0)] beGreaterThan:@2];
        });
        
        it(@"will get the last progress", ^{
            [testee sendNext:subject];
            [testee sendNext:subject2];
            [subject2 sendNext:@2.0];
            [subject sendNext:@0.0];
            [subject2 sendNext:@3.0];
            [subject sendNext:@0.0];
            [subject sendNext:@1.0];

            [testee subscribeNext:^(RACSignal* signal) {
                [signal subscribeNext:^(NSNumber* progress) {
                    done = @1;
                }];
            }];
            [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(100000.0)] beTrue];
        });
    });

    context(@"single progress", ^{
        let(testee, ^{ // Occurs before each enclosed "it"
            return [[RACProgressSubject alloc] initWithProgresses:@[@0.5]];
        });
        
        let(subject, ^{ // Occurs before each enclosed "it"
            return [RACSubject subject];
        });
        let(subject2, ^{ // Occurs before each enclosed "it"
            return [RACSubject subject];
        });
        let(done, ^{ // Occurs before each enclosed "it"
            return @0;
        });
        let(count, ^{ // Occurs before each enclosed "it"
            return @0;
        });

        it(@"will get the progress from subject2", ^{
            NSMutableArray* res = [NSMutableArray new];
            [testee subscribeNext:^(RACSignal* signal) {
                
                [signal subscribeNext:^(NSNumber* progress) {
                    [res addObject:progress];
                }];
            }];
            [testee sendNext:subject];
            [testee sendNext:subject2];
            [subject sendNext:@0.0];
            [subject sendNext:@0.1];
            [subject sendNext:@1.0];
            [subject2 sendNext:@0.0];
            [subject2 sendNext:@1.0];

            [[expectFutureValue(res) shouldEventuallyBeforeTimingOutAfter(100000.0)] equal:@[@0.0, @0.5, @1.0]];
        });

        it(@"will get the whole progress", ^{
            NSMutableArray* res = [NSMutableArray new];
            [testee subscribeNext:^(RACSignal* signal) {
                
                [signal subscribeNext:^(NSNumber* progress) {
                    [res addObject:progress];
                }];
            }];
            [testee sendNext:subject];
            [subject sendNext:@0.0];
            [subject sendNext:@0.1];
            [subject sendNext:@1.0];

            [testee sendNext:subject2];
            [subject2 sendNext:@0.0];
            [subject2 sendNext:@1.0];

            [[expectFutureValue(res) shouldEventuallyBeforeTimingOutAfter(100000.0)] equal:@[@0.0, @0.05, @0.5, @1.0]];
        });
    });


});

SPEC_END

