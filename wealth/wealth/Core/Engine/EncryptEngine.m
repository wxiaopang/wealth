//
//  EncryptEngine.m
//  wealth
//
//  Created by wangyingjie on 15/1/20.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "EncryptEngine.h"

@implementation EncryptEngine

+ (NSData *)encryptSHA1:(NSData *)data {
    NSData * hash = nil;
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
    
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[data bytes], (CC_LONG)[data length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    hash = [[NSData alloc] initWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
    if (hashBytes) {
        free(hashBytes);
    }
    return hash;
}

+ (NSData *)encryptSHA256:(NSData *)data {
    NSData * hash = nil;
    CC_SHA256_CTX ctx;
    uint8_t * hashBytes = NULL;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA256_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, CC_SHA256_DIGEST_LENGTH);
    
    // Initialize the context.
    CC_SHA256_Init(&ctx);
    // Perform the hash.
    CC_SHA256_Update(&ctx, (void *)[data bytes], (CC_LONG)[data length]);
    // Finalize the output.
    CC_SHA256_Final(hashBytes, &ctx);
    
    hash = [[NSData alloc] initWithBytes:hashBytes length:CC_SHA256_DIGEST_LENGTH];
    if (hashBytes) {
        free(hashBytes);
    }
    return hash;
}

+ (NSData *)encryptAES256OfString:(NSData *)plainData withKey:(NSString *)key {
    if ( plainData || key ) {
        return plainData;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1];   // room for terminator (unused)
    
    bzero(keyPtr, sizeof(keyPtr));     // fill with zeroes (for padding)
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = [plainData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [plainData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    
    return nil;
}

+ (NSData *)decryptAES256:(NSData *)plainData withKey:(NSString *)key {
    if ( plainData || key ) {
        return plainData;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1];
    
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [plainData length];
    
    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [plainData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    
    return nil;
}

+ (NSString *)bytes2HexString:(NSData *)data {
    NSMutableString* hexString = [[NSMutableString alloc] initWithCapacity:0];
    unsigned const char* pointer = [data bytes];
    NSUInteger length = [data length];
    for(unsigned short i = 0 ; i < length ; i++) {
        [hexString appendFormat:@"%02X", *(pointer++)];
    }
    return hexString;
}

+ (NSData *)hexString2Bytes:(NSString*)hexString {
    const char *buf = [hexString UTF8String];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    if (buf) {
        size_t len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2) {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) ) {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp)length:1];
            } else {
                break;
            }
        }
    }
    return data;
}

+ (NSString *)encryptMD5OfString:(NSString *)string {
    return [EncryptEngine encryptMD5OfData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encryptMD5OfData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (NSString *)encodeBase64String:(NSString *)string {
    return [EncryptEngine encodeBase64Data:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64Data:(NSData *)data {
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSData *)decodeBase64String:(NSString *)string {
    return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSData *)decodeBase64Data:(NSData *)data {
    return [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (SecKeyRef)getPublicSecKeyRef:(NSString *)key {
    SecKeyRef publicKey = NULL;
    NSData *publicKeyData = [EncryptEngine decodeBase64String:key];
    if ( publicKeyData ) {
        OSStatus status = -1;
        SecTrustRef trust;
        SecTrustResultType trustResult;

        SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)publicKeyData);
        SecPolicyRef policy = SecPolicyCreateBasicX509();
        status = SecTrustCreateWithCertificates(cert, policy, &trust);
        if (status == errSecSuccess && trust) {
            NSArray *certs = [NSArray arrayWithObject:(__bridge id)(cert)];
            status = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certs);
            if (status == errSecSuccess) {
                status = SecTrustEvaluate(trust, &trustResult);
                // 自签名证书可信
                if (status == errSecSuccess && (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed)) {
                    publicKey = SecTrustCopyPublicKey(trust);
                    if (publicKey) {
//                        NSLog(@"Get public key successfully~ %@", publicKey);
                    }
                }
            }
        }

        if (cert) {
            CFRelease(cert);
        }
        if (policy) {
            CFRelease(policy);
        }
        if (trust) {
            CFRelease(trust);
        }
    }
    return publicKey;
}

+ (SecKeyRef)getPraviteSecKeyRef:(NSString *)key {
    SecKeyRef praviteKey = NULL;
    NSData *praviteKeyData = [EncryptEngine decodeBase64String:key];
    if ( praviteKeyData ) {
        SecIdentityRef identity;
        SecTrustRef trust;
        OSStatus status = -1;
        CFStringRef password = (__bridge CFStringRef)@"puhui";
        const void *keys[] = {
            kSecImportExportPassphrase
        };
        const void *values[] = {
            password
        };
        CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
        CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
        status = SecPKCS12Import((__bridge CFDataRef)praviteKeyData, options, &items);
        if (status == errSecSuccess) {
            CFDictionaryRef identity_trust_dic = CFArrayGetValueAtIndex(items, 0);
            identity = (SecIdentityRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemIdentity);
            trust = (SecTrustRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemTrust);
            // certs数组中包含了所有的证书
            CFArrayRef certs = (CFArrayRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemCertChain);
            if ([(__bridge NSArray *)certs count] && trust && identity) {
                // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
                status = SecTrustSetAnchorCertificates(trust, certs);
                if (status == errSecSuccess) {
                    SecTrustResultType trustResultType;
                    // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
                    status = SecTrustEvaluate(trust, &trustResultType);
                    if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess) {
                        // 证书可信，可以提取私钥与公钥，然后可以使用公私钥进行加解密操作
                        status = SecIdentityCopyPrivateKey(identity, &praviteKey);
                        if (status == errSecSuccess && praviteKey) {
                            // 成功提取私钥
//                            NSLog(@"Get private key successfully~ %@", praviteKey);
                        }
                    }
                }
            }
        }
        if (options) {
            CFRelease(options);
        }
    }
    return praviteKey;
}


+ (NSString *)encryptRSA:(NSString *)plainText publicKey:(NSString *)key {
    NSAssert(plainText != nil, nil);
    NSAssert(key != nil, nil);
    if (key && key.length > 0) {
        
    }else{
        key = [UserDefaultsWrapper userDefaultsObject:kRSAPublicKey];
        if (key && key.length > 0) {
            
        }else{
            key = kPublicKey;
        }
    }
    
    
    NSString *result = plainText;
    SecKeyRef publicKey = [EncryptEngine getPublicSecKeyRef:key];
    if ( publicKey ) {
        NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        // 分配内存块，用于存放加密后的数据段
        size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
        uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
        /*
         为什么这里要减12而不是减11?
         苹果官方文档给出的说明是，加密时，如果sec padding使用的是kSecPaddingPKCS1，
         那么支持的最长加密长度为SecKeyGetBlockSize()-11，
         这里说的最长加密长度，我估计是包含了字符串最后的空字符'\0'，
         因为在实际应用中我们是不考虑'\0'的，所以，支持的真正最长加密长度应为SecKeyGetBlockSize()-12
         */
        double totalLength = [plainData length];
        size_t blockSize = cipherBufferSize - 12;// 使用cipherBufferSize - 11是错误的!
        size_t blockCount = (size_t)ceil(totalLength / blockSize);
        NSMutableData *encryptedData = [NSMutableData data];
        // 分段加密
        for (int i = 0; i < blockCount; i++) {
            NSUInteger loc = i * blockSize;
            // 数据段的实际大小。最后一段可能比blockSize小。
            size_t dataSegmentRealSize = MIN(blockSize, [plainData length] - loc);
            // 截取需要加密的数据段
            NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
            OSStatus status = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, cipherBuffer, &cipherBufferSize);
            if (status == errSecSuccess) {
                NSData *encryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
                // 追加加密后的数据段
                [encryptedData appendData:encryptedDataSegment];
            } else {
                if (cipherBuffer) {
                    free(cipherBuffer);
                }
                if ( publicKey ) {
                    CFRelease(publicKey);
                }
                return result;
            }
        }
        if (cipherBuffer) {
            free(cipherBuffer);
        }
        if ( publicKey ) {
            CFRelease(publicKey);
        }
        result = [EncryptEngine encodeBase64Data:encryptedData];
    }
    return result;
}

+ (NSString *)decryptRSA:(NSString *)cipherText privateKey:(NSString *)key {
    NSAssert(cipherText != nil, nil);
    NSAssert(key != nil, nil);
    
    NSString *result = cipherText;
    SecKeyRef privateKey = [EncryptEngine getPraviteSecKeyRef:key];
    if ( privateKey ) {
        NSData *cipherData = [EncryptEngine decodeBase64String:cipherText];
        
        // 分配内存块，用于存放解密后的数据段
        size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
        uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
        // 计算数据段最大长度及数据段的个数
        double totalLength = cipherData.length;
        size_t blockSize = plainBufferSize;
        size_t blockCount = (size_t)ceil(totalLength / blockSize);
        NSMutableData *decryptedData = [[NSMutableData alloc] initWithCapacity:0];
        // 分段解密
        for (int i = 0; i < blockCount; i++) {
            NSUInteger loc = i * blockSize;
            // 数据段的实际大小。最后一段可能比blockSize小。
            int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
            // 截取需要解密的数据段
            NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
            OSStatus status = SecKeyDecrypt(privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);
            if (status == errSecSuccess) {
                NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
                [decryptedData appendData:decryptedDataSegment];
            } else {
                if (plainBuffer) {
                    free(plainBuffer);
                }
                return result;
            }
        }
        if (plainBuffer) {
            free(plainBuffer);
        }
        
        result = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    return result;
}

@end
