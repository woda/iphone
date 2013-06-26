// AFHTTPRequestLogger.h
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPRequestOperationLogger.h"
#import "AFHTTPRequestOperation.h"
#import <objc/runtime.h>
#import "DDTTYLogger.h"

#if !__has_feature(objc_arc)
#error AFHTTPRequestOperationLogger must be built with ARC.
// You can turn on ARC for only AFHTTPRequestOperationLogger files by adding -fobjc-arc to the build phase for each of its files.
#endif

static const int ddLogLevel = LOG_LEVEL_VERBOSE;


@implementation AFHTTPRequestOperationLogger
@synthesize level = _level;
@synthesize filterPredicate = _filterPredicate;

+ (AFHTTPRequestOperationLogger *)sharedLogger {
    static AFHTTPRequestOperationLogger *_sharedLogger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor] backgroundColor:nil forFlag:LOG_LEVEL_INFO];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor grayColor] backgroundColor:nil forFlag:LOG_LEVEL_VERBOSE];
        
        _sharedLogger = [[self alloc] init];
    });
    
    return _sharedLogger;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.level = AFLoggerLevelInfo;
    
    return self;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)startLogging {
    [self stopLogging];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification

static void *AFHTTPRequestOperationStartDate = &AFHTTPRequestOperationStartDate;

- (void)HTTPOperationDidStart:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    
    if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        return;
    }
    
    objc_setAssociatedObject(operation, AFHTTPRequestOperationStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.filterPredicate && [self.filterPredicate evaluateWithObject:operation]) {
        return;
    }
    
    NSString *body = nil;
    if ([operation.request HTTPBody]) {
        body = [[NSString alloc] initWithData:[operation.request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    switch (self.level) {
        case AFLoggerLevelDebug:
            DDLogVerbose(@"%@ '%@': %@ %@", [operation.request HTTPMethod], [[operation.request URL] absoluteString], [operation.request allHTTPHeaderFields], body);
            break;
        case AFLoggerLevelInfo:
            DDLogVerbose(@"%@ '%@'", [operation.request HTTPMethod], [[operation.request URL] absoluteString]);
            break;
        default:
            break;
    }
}

- (void)HTTPOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    
    if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        return;
    }
    
    if (self.filterPredicate && [self.filterPredicate evaluateWithObject:operation]) {
        return;
    }
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(operation, AFHTTPRequestOperationStartDate)];
    
    if (operation.error) {
        switch (self.level) {
            case AFLoggerLevelDebug:
            case AFLoggerLevelInfo:
            case AFLoggerLevelWarn:
            case AFLoggerLevelError:
                DDLogError(@"[Error] %@ '%@' (%ld) [%.04f s]: %@", [operation.request HTTPMethod], [[operation.response URL] absoluteString], (long)[operation.response statusCode], elapsedTime, operation.error);
            default:
                break;
        }
    } else {
        switch (self.level) {
            case AFLoggerLevelDebug:
                DDLogVerbose(@"%ld '%@' [%.04f s]: %@ %@", (long)[operation.response statusCode], [[operation.response URL] absoluteString], elapsedTime, [operation.response allHeaderFields], operation.responseString);
                break;
            case AFLoggerLevelInfo:
                DDLogVerbose(@"%ld '%@' [%.04f s]", (long)[operation.response statusCode], [[operation.response URL] absoluteString], elapsedTime);
                break;
            default:
                break;
        }
    }
}

@end
