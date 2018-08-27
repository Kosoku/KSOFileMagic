//
//  KSOFileMagicAttributes.h
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

/**
 KSOFileMagicAttributes represent the type of a file. This includes its UTI, MIME type, and possible file extensions. Instances of this class are returned from the KSOFileMagicManager methods. You cannot create instances of this class on your own.
 */
@interface KSOFileMagicAttributes : NSObject

/**
 Get the uniform type identifier (UTI) of the receiver. See the UTCoreTypes.h header for possible values.
 */
@property (readonly,copy,nonatomic) NSString *uniformTypeIdentifier;
/**
 Get the MIME type of the receiver. See https://en.wikipedia.org/wiki/Media_type for examples.
 */
@property (readonly,copy,nonatomic) NSString *MIMEType;
/**
 Get the possible file extensions of the receiver. For example, public.jpeg returns a set of @"jpg", @"jpeg", and @"jpe".
 */
@property (readonly,copy,nonatomic) NSSet<NSString *> *fileExtensions;

/**
 Returns YES if the self.fileExtensions contains the lowercase version of *fileExtension*, otherwise NO.
 
 @param fileExtension The file extension to check
 @return YES if self.fileExtensions contains it, otherwise NO
 */
- (BOOL)hasFileExtension:(NSString *)fileExtension;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
