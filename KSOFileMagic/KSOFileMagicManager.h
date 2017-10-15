//
//  KSOFileMagicManager.h
//  KSOFileMagic-iOS
//
//  Created by William Towe on 10/14/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFileMagicAttributes;

/**
 KSOFileMagicManager provides an interface to the Darwin file command, which can examine the contents of a file to determine its type. This is useful if the file URL or path does not provide a file extension from which to determine the type. Similarly, if you have raw data, from a network request for example, its contents can be inspected to determine its type.
 
 For methods that take a NSURL or NSString, if a file extension is available, the UTType family of functions are used to determine the attributes before falling back to file I/O.
 */
@interface KSOFileMagicManager : NSObject

/**
 Get the shared manager. This class is a singleton and you cannot create additional instances of it.
 */
@property (class,readonly,nonatomic) KSOFileMagicManager *sharedManager;

/**
 Returns the attributes for the file at *fileURL*. This method will not perform file I/O unless the attributes cannot be determined by the file extension (e.g. the *fileURL* is missing a file extension).
 
 @param fileURL The URL of the file to examine
 @return The file magic attributes
 */
- (nullable KSOFileMagicAttributes *)attributesForFileURL:(NSURL *)fileURL;
/**
 Returns the attributes for the file at *path*. This calls through to attributesForFileURL:, passing [NSURL fileURLWithPath:path].
 
 @param path The path of the file to examine
 @return The file magic attributes
 */
- (nullable KSOFileMagicAttributes *)attributesForPath:(NSString *)path;
/**
 Returns the attributes for the *data*. This always performs I/O, but not necessarily file I/O if the data is in memory.
 
 @param data The data to examine
 @return The file magic attributes
 */
- (nullable KSOFileMagicAttributes *)attributesForData:(NSData *)data;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
