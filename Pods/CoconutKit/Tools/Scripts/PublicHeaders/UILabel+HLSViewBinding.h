//
//  Copyright (c) Samuel Défago. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "UIView+HLSViewBindingImplementation.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Binding support for UILabel:
 *   - binds to NSString model values
 *   - displays the underlying model value, but cannot update it
 *   - does not animate updates
 */
@interface UILabel (HLSViewBindingImplementation) <HLSViewBindingImplementation>

/**
 * An optional placeholder to be displayed when the text to be displayed is nil. Default is nil
 */
@property (nonatomic, copy) IBInspectable NSString *bindPlaceholder;

@end
