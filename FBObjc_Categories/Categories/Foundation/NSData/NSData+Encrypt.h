//
//  NSData+Encrypt.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encrypt)

/**
 *  AES CBC
 *
 *  @param key
 *  @param iv
 *
 *  @return
 */
- (NSData *)encryptedWithAESCBCUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWithAESCBCUsingKey:(NSString*)key andIV:(NSData*)iv;


/**
 *  AES EBC
 *
 *  @param key
 *  @param iv
 *
 *  @return
 */
- (NSData *)encryptedWithAESECBUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWithAESECBUsingKey:(NSString*)key andIV:(NSData*)iv;



/**
 *  利用AES加密数据
 *
 *  @param key key
 *  @param iv  iv description
 *
 *  @return data
 */
- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  @brief  利用AES解密据
 *
 *  @param key key
 *  @param iv  iv
 *
 *  @return 解密后数据
 */
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 *  利用3DES加密数据
 *
 *  @param key key
 *  @param iv  iv description
 *
 *  @return data
 */
- (NSData *)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  @brief   利用3DES解密数据
 *
 *  @param key key
 *  @param iv  iv
 *
 *  @return 解密后数据
 */
- (NSData *)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 *  @brief  NSData 转成UTF8 字符串
 *
 *  @return 转成UTF8 字符串
 */
- (NSString *)UTF8String;
@end
