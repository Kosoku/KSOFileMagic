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

- (instancetype)initWithMagic:(magic_t)magic;

- (NSString *)_magicStringForFileURL:(NSURL *)fileURL magicFlags:(int)magicFlags;
- (KSOFileMagicAttributes *)_attributesForMagicString:(NSString *)magicString;
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
    return [self _attributesForMagicString:[self _magicStringForFileURL:fileURL magicFlags:MAGIC_MIME_TYPE]];
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

- (NSString *)_magicStringForFileURL:(NSURL *)fileURL magicFlags:(int)magicFlags; {
    magic_setflags(self.magic, magicFlags);
    const char *magicString = magic_file(self.magic, fileURL.fileSystemRepresentation);
    
    return [NSString stringWithUTF8String:magicString];
}
- (KSOFileMagicAttributes *)_attributesForMagicString:(NSString *)magicString; {
    NSString *MIMEType = [magicString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, NULL);
    
    if (UTTypeIsDynamic((__bridge CFStringRef)UTI)) {
        return nil;
    }
    
    NSArray *fileExtensions = (__bridge_transfer NSArray *)UTTypeCopyAllTagsWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
    NSSet *fileExtensionsSet = [NSSet setWithArray:fileExtensions];
    
    return [[KSOFileMagicAttributes alloc] initWithUniformTypeIdentifier:UTI MIMEType:MIMEType fileExtensions:fileExtensionsSet];
}

@end
