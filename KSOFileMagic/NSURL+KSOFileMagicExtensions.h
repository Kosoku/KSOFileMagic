//
//  NSURL+KSOFileMagicExtensions.h
//  KSOFileMagic
//
//  Created by William Towe on 10/14/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
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

@interface NSURL (KSOFileMagicExtensions)

/**
 Returns the attributes for the file at *fileURL*. This method will not perform file I/O unless the attributes cannot be determined by the file extension (e.g. the *fileURL* is missing a file extension).
 
 @param fileURL The URL of the file to examine
 @return The file magic attributes
 */
+ (nullable KSOFileMagicAttributes *)KSO_fileMagicAttributesForFileURL:(NSURL *)fileURL;
/**
 Returns the attributes for the receiver.
 
 @return The file magic attributes
 */
- (nullable KSOFileMagicAttributes *)KSO_fileMagicAttributes;

@end

NS_ASSUME_NONNULL_END
