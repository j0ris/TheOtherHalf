//
//  Copyright (c) Samuel Défago. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "HLSAssert.h"
#import "HLSTask.h"
#import "HLSTaskManager.h"

#import <Foundation/Foundation.h>

/**
 * Abstract class for implementing operations to be performed for a task by a task manager. Concrete subclasses
 * must include the HLSTaskOperation+Protected.h header file within their implementation file to benefit from the
 * full protected interface.
 *
 * Concrete subclasses must take into account the following constraints within their implementation:
 *  - the -operationMain method must be implemented. When this method returns, the operation must be completely over.
 *    In particular, no other threads which the operation might have spawned must still be running
 *  - when cancelling a task, each operation is sent a cancel message. You must especially be careful that
 *    if your operations are already running (e.g. downloading data), they will only be put in the cancelled state,
 *    but the corresponding thread will not be killed. Your operation implementation is therefore responsible to check
 *    its state regularly so that if a running operation is switched to the cancelled state it gracefully stops its
 *    current work as soon as possible
 *  - operations are instantiated by the HLSTaskManager using their designated initializer. Your subclass must therefore
 *    not define any other initializer since they would never be called
 */
@interface HLSTaskOperation : NSOperation

- (instancetype)initWithTaskManager:(HLSTaskManager *)taskManager task:(HLSTask *)task NS_REQUIRES_SUPER NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly, weak) HLSTask *task;           // weak ref; the manager is responsible to keep the strong ref

@end

@interface HLSTaskOperation (UnavailableMethods)

- (instancetype)init NS_UNAVAILABLE;

@end
