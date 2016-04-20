//
//  Copyright (c) Samuel Défago. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "HLSInMemoryCacheEntry.h"

#import "HLSLogger.h"

@interface HLSInMemoryCacheEntry ()

@property (nonatomic, weak) NSMutableDictionary *parentItems;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *data;

@end

@implementation HLSInMemoryCacheEntry

#pragma mark Object creation and destruction

- (instancetype)initWithParentItems:(NSMutableDictionary *)parentItems
                               name:(NSString *)name
                               data:(NSData *)data
{
    if (self = [super init]) {
        if (! parentItems || ! name || ! data) {
            HLSLoggerError(@"Missing parameter");
            return nil;
        }
        
        self.parentItems = parentItems;
        self.name = name;
        self.data = data;
    }
    return self;
}

- (instancetype)init
{
    return nil;
}

#pragma mark Accessors and mutators

- (NSUInteger)cost
{
    return [self.data length];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name: %@; parentItems: %p; cost: %lu>",
            [self class],
            self,
            self.name,
            self.parentItems,
            (unsigned long)self.cost];
}

@end
