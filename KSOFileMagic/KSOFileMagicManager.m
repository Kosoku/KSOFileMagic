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
#import "magic.h"

#import <Stanley/Stanley.h>

static magic_t kMagic;

@interface KSOFileMagicManager ()
@property (assign,nonatomic) magic_t magic;

- (instancetype)initWithMagic:(magic_t)magic;
@end

@implementation KSOFileMagicManager

+ (void)initialize {
    if (self == KSOFileMagicManager.class) {
        kMagic = magic_open(MAGIC_NONE);
        
        NSURL *fileURL = [[NSBundle KSO_fileMagicFrameworkBundle] URLForResource:@"magic" withExtension:@"mgc"];
        
        KSTLog(@"fileURL %@",fileURL);
        
        if (magic_load(kMagic, fileURL.fileSystemRepresentation) == -1) {
            KSTLog(@"failed to open magic db: %s",strerror(errno));
        }
    }
}

- (instancetype)init {
    return [self initWithMagic:kMagic];
}
- (instancetype)initWithMagic:(magic_t)magic {
    if (!(self = [super init]))
        return nil;
    
    _magic = magic;
    
    return self;
}

- (void)checkFileURL:(NSURL *)fileURL {
    magic_setflags(self.magic, MAGIC_MIME);
    const char *output = magic_file(self.magic, fileURL.fileSystemRepresentation);
    NSString *string = [NSString stringWithUTF8String:output];
    
    KSTLog(@"check file URL %@, result %@",fileURL,string);
}

+ (KSOFileMagicManager *)sharedManager {
    static KSOFileMagicManager *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSOFileMagicManager alloc] init];
    });
    return kRetval;
}

@end
