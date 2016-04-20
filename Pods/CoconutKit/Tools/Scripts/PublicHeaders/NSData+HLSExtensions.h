//
//  Copyright (c) Samuel Défago. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface NSData (HLSExtensions)

/**
 * Calculates the MD2 hash
 */
- (NSString *)md2hash;

/**
 * Calculates the MD4 hash
 */
- (NSString *)md4hash;

/**
 * Calculates the MD5 hash
 */
- (NSString *)md5hash;

/**
 * Calculates the SHA-1 hash
 */
- (NSString *)sha1hash;

/**
 * Calculates the SHA-224 hash
 */
- (NSString *)sha224hash;

/**
 * Calculates the SHA-256 hash
 */
- (NSString *)sha256hash;

/**
 * Calculates the SHA-384 hash
 */
- (NSString *)sha384hash;

/**
 * Calculates the SHA-512 hash
 */
- (NSString *)sha512hash;

@end
