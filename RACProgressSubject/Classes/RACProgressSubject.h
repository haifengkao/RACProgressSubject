//
//  RACProgressSubject.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/10/27.
//
//

#import <Foundation/Foundation.h>

@import ReactiveCocoa;
@interface RACProgressSubject : RACSubject

- (instancetype)initWithProgresses:(NSArray*)theProgresses NS_DESIGNATED_INITIALIZER;
@end
