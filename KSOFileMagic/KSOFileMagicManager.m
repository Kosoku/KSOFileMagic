//
//  KSOFileMagicManager.m
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

#import "KSOFileMagicManager.h"
#import "NSBundle+KSOFileMagicExtensionsPrivate.h"
#import "KSOFileMagicAttributes+KSOFileMagicExtensionsPrivate.h"
#import "magic.h"

#import <Stanley/Stanley.h>

#if (TARGET_OS_IPHONE)
#import <MobileCoreServices/MobileCoreServices.h>
#endif

static magic_t kMagic;

@interface KSOFileMagicManager ()
@property (assign,nonatomic) magic_t magic;
@property (readonly,nonatomic) int baseMagicFlags;

- (instancetype)initWithMagic:(magic_t)magic;

- (NSString *)_MIMETypeForFileURL:(NSURL *)fileURL magicFlags:(int)magicFlags;
- (NSString *)_MIMETypeForData:(NSData *)data magicFlags:(int)magicFlags;
- (KSOFileMagicAttributes *)_attributesForMIMEType:(NSString *)magicString;
@end

@implementation KSOFileMagicManager
#pragma mark *** Subclass Overrides ***
+ (void)initialize {
    if (self == KSOFileMagicManager.class) {
        kMagic = magic_open(MAGIC_NONE);
        
        NSURL *fileURL = [[NSBundle KSO_fileMagicFrameworkBundle] URLForResource:@"magic" withExtension:@"mgc"];
        
        if (magic_load(kMagic, fileURL.fileSystemRepresentation) == -1) {
            KSTLog(@"failed to open magic db: %s",strerror(errno));
        }
    }
}
#pragma mark *** Public Methods ***
- (KSOFileMagicAttributes *)attributesForFileURL:(NSURL *)fileURL {
    // if we have a path extension, see if the system can identify it, otherwise fall back to magic functions
    if (fileURL.pathExtension.length > 0) {
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileURL.pathExtension, NULL);
        
        if (UTTypeIsDeclared((__bridge CFStringRef)UTI)) {
            NSString *MIMEType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
            NSArray *fileExtensions = (__bridge_transfer NSArray *)UTTypeCopyAllTagsWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
            NSSet *fileExtensionsSet = [NSSet setWithArray:fileExtensions];
            
            return [[KSOFileMagicAttributes alloc] initWithUniformTypeIdentifier:UTI MIMEType:MIMEType fileExtensions:fileExtensionsSet];
        }
    }
    
    return [self _attributesForMIMEType:[self _MIMETypeForFileURL:fileURL magicFlags:self.baseMagicFlags]];
}
- (KSOFileMagicAttributes *)attributesForPath:(NSString *)path {
    return [self attributesForFileURL:[NSURL fileURLWithPath:path]];
}
- (KSOFileMagicAttributes *)attributesForData:(NSData *)data {
    return [self _attributesForMIMEType:[self _MIMETypeForData:data magicFlags:self.baseMagicFlags]];
}
#pragma mark Properties
+ (KSOFileMagicManager *)sharedManager {
    static KSOFileMagicManager *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSOFileMagicManager alloc] initWithMagic:kMagic];
    });
    return kRetval;
}

#pragma mark *** Private Methods ***
- (instancetype)initWithMagic:(magic_t)magic {
    if (!(self = [super init]))
        return nil;
    
    _magic = magic;
    
    return self;
}

- (NSString *)_MIMETypeForFileURL:(NSURL *)fileURL magicFlags:(int)magicFlags; {
    magic_setflags(self.magic, magicFlags);
    const char *MIMEType = magic_file(self.magic, fileURL.fileSystemRepresentation);
    
    return [[NSString stringWithUTF8String:MIMEType] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}
- (NSString *)_MIMETypeForData:(NSData *)data magicFlags:(int)magicFlags; {
    magic_setflags(self.magic, magicFlags);
    const char *MIMEType = magic_buffer(self.magic, data.bytes, data.length);
    
    return [[NSString stringWithUTF8String:MIMEType] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}
- (KSOFileMagicAttributes *)_attributesForMIMEType:(NSString *)MIMEType; {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, NULL);
    
    if (UTTypeIsDynamic((__bridge CFStringRef)UTI)) {
        return nil;
    }
    
    NSArray *fileExtensions = (__bridge_transfer NSArray *)UTTypeCopyAllTagsWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
    NSSet *fileExtensionsSet = [NSSet setWithArray:fileExtensions];
    
    return [[KSOFileMagicAttributes alloc] initWithUniformTypeIdentifier:UTI MIMEType:MIMEType fileExtensions:fileExtensionsSet];
}

- (int)baseMagicFlags {
    return MAGIC_MIME_TYPE;
}

@end
