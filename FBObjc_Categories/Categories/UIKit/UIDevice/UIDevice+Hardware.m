//
//  UIDevice+Hardware.m
//  TestTable
//
//  Created by Inder Kumar Rathore on 19/01/13.
//  Copyright (c) 2013 Rathore. All rights reserved.
//

#import "UIDevice+Hardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import <sys/socket.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/processor_info.h>

@implementation UIDevice (Hardware)
- (NSString*)hardwareString {
    int name[] = {CTL_HW,HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);

    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)isJailbroken {
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}


/* This is another way of gtting the system info
 * For this you have to #import <sys/utsname.h>
 */

/*
- (NSString*)hardwareString {
 struct utsname systemInfo;
 uname(&systemInfo);
 return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
 }
 */

- (kDeviceType)getDeviceType {
    NSString *identifier = [self hardwareString];

    //Simulator
    if ([identifier isEqual:@"i386"] || [identifier isEqualToString:@"x86_64"])      return kDeviceType_Simulator;
    
    //Apple TV
    if ([identifier isEqual:@"AppleTV2,1"])      return kDeviceType_TV2G;
    if ([identifier isEqual:@"AppleTV3,1"] || [identifier isEqualToString:@"AppleTV3,2"])      return kDeviceType_TV3G;
    if ([identifier isEqual:@"AppleTV5,3"])      return kDeviceType_TV4G;
    
    //Apple Watch
    if ([identifier isEqual:@"Watch1,1"] || [identifier isEqualToString:@"Watch1,2"])      return kDeviceType_Watch;
    
    //Apple iPad
    if ([identifier isEqual:@"iPad1,1"])      return kDeviceType_Ipad;
    if ([identifier isEqual:@"iPad2,1"] || [identifier isEqualToString:@"iPad2,2"] || [identifier isEqualToString:@"iPad2,3"] || [identifier isEqualToString:@"iPad2,4"])      return kDeviceType_Ipad2;
    if ([identifier isEqual:@"iPad3,1"] || [identifier isEqualToString:@"iPad3,2"] || [identifier isEqualToString:@"iPad3,3"])      return kDeviceType_Ipad3;
    if ([identifier isEqual:@"iPad3,4"] || [identifier isEqualToString:@"iPad3,5"] || [identifier isEqualToString:@"iPad3,6"])      return kDeviceType_Ipad4;
    if ([identifier isEqual:@"iPad4,1"] || [identifier isEqualToString:@"iPad4,2"] || [identifier isEqualToString:@"iPad4,3"])      return kDeviceType_IpadAir;
    if ([identifier isEqual:@"iPad5,3"] || [identifier isEqualToString:@"iPad5,4"])      return kDeviceType_IpadAir2;
    if ([identifier isEqual:@"iPad6,7"] || [identifier isEqualToString:@"iPad6,7"])      return kDeviceType_IpadPro;
    if ([identifier isEqual:@"iPad2,5"] || [identifier isEqualToString:@"iPad2,6"] || [identifier isEqualToString:@"iPad2,7"])      return kDeviceType_IpadMini;
    if ([identifier isEqual:@"iPad4,4"] || [identifier isEqualToString:@"iPad4,5"] || [identifier isEqualToString:@"iPad4,6"])      return kDeviceType_IpadMini2;
    if ([identifier isEqual:@"iPad4,7"] || [identifier isEqualToString:@"iPad4,8"] || [identifier isEqualToString:@"iPad4,9"])      return kDeviceType_IpadMini3;
    if ([identifier isEqual:@"iPad5,1"] || [identifier isEqualToString:@"iPad5,2"])      return kDeviceType_IpadMini4;
    
    //Apple iPhone
    if ([identifier isEqual:@"iPhone1,1"])      return kDeviceType_Iphone2G;
    if ([identifier isEqual:@"iPhone1,2"])      return kDeviceType_Iphone3G;
    if ([identifier isEqual:@"iPhone2,1"])      return kDeviceType_Iphone3GS;
    if ([identifier isEqual:@"iPhone3,1"] || [identifier isEqualToString:@"iPhone3,2"] || [identifier isEqualToString:@"iPhone3,3"])      return kDeviceType_Iphone4;
    if ([identifier isEqual:@"iPhone4,1"])      return kDeviceType_Iphone4S;
    if ([identifier isEqual:@"iPhone5,1"] || [identifier isEqualToString:@"iPhone5,2"])      return kDeviceType_Iphone5;
    if ([identifier isEqual:@"iPhone5,3"] || [identifier isEqualToString:@"iPhone5,4"])      return kDeviceType_Iphone5C;
    if ([identifier isEqual:@"iPhone6,1"] || [identifier isEqualToString:@"iPhone6,2"])      return kDeviceType_Iphone5S;
    if ([identifier isEqual:@"iPhone7,2"])      return kDeviceType_Iphone6;
    if ([identifier isEqual:@"iPhone7,1"])      return kDeviceType_Iphone6P;
    if ([identifier isEqual:@"iPhone8,1"])      return kDeviceType_Iphone6S;
    if ([identifier isEqual:@"iPhone8,2"])      return kDeviceType_Iphone6SP;
    if ([identifier isEqual:@"iPHone8.4"])      return kDeviceType_IphoneSE;
    if ([identifier isEqual:@"iPHone9.1"])      return kDeviceType_Iphone7;
    if ([identifier isEqual:@"iPHone9.2"])      return kDeviceType_Iphone7P;
    
    //Apple iPod touch
    if ([identifier isEqual:@"iPod1,1"])      return kDeviceType_IpodTouch;
    if ([identifier isEqual:@"iPod2,1"])      return kDeviceType_IpodTouch2G;
    if ([identifier isEqual:@"iPod3,1"])      return kDeviceType_IpodTouch3G;
    if ([identifier isEqual:@"iPod4,1"])      return kDeviceType_IpodTouch4G;
    if ([identifier isEqual:@"iPod5,1"])      return kDeviceType_IpodTouch5G;
    if ([identifier isEqual:@"iPod7,1"])      return kDeviceType_IpodTouch6G;
    
    //Apple UnknownDevices
    return kDeviceType_Unknown;
}

- (NSString*)hardwareDescription {
    NSString *identifier = [self hardwareString];
    if ([identifier isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([identifier isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([identifier isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([identifier isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([identifier isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev. A)";
    if ([identifier isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([identifier isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([identifier isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([identifier isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    if ([identifier isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([identifier isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([identifier isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([identifier isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    if ([identifier isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([identifier isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([identifier isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([identifier isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([identifier isEqualToString:@"iPHone8.4"])    return @"iPhone 6SE";
    if ([identifier isEqualToString:@"iPHone9.1"])    return @"iPhone 7";
    if ([identifier isEqualToString:@"iPHone9.2"])    return @"iPhone 7 Plus";
    
    
    if ([identifier isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([identifier isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([identifier isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([identifier isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([identifier isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([identifier isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";
    
    
    if ([identifier isEqualToString:@"iPad1,1"])      return @"iPad (WiFi)";
    if ([identifier isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([identifier isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([identifier isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([identifier isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([identifier isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi Rev. A)";
    if ([identifier isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([identifier isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([identifier isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([identifier isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([identifier isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([identifier isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([identifier isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([identifier isEqualToString:@"iPad3,5"])      return @"iPad 4 (CDMA)";
    if ([identifier isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    if ([identifier isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([identifier isEqualToString:@"iPad4,2"])      return @"iPad Air (WiFi+GSM)";
    if ([identifier isEqualToString:@"iPad4,3"])      return @"iPad Air (WiFi+CDMA)";
    if ([identifier isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([identifier isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (WiFi+CDMA)";
    if ([identifier isEqualToString:@"i386"])         return @"Simulator";
    if ([identifier isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", identifier);
    if ([identifier hasPrefix:@"iPhone"]) return @"iPhone";
    if ([identifier hasPrefix:@"iPod"]) return @"iPod";
    if ([identifier hasPrefix:@"iPad"]) return @"iPad";
    return nil;
}

- (NSString*)hardwareSimpleDescription
{
    NSString *identifier = [self hardwareString];
    if ([identifier isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([identifier isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([identifier isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([identifier isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([identifier isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([identifier isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([identifier isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([identifier isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([identifier isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([identifier isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([identifier isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([identifier isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([identifier isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([identifier isEqualToString:@"iPhone7,1"])    return @"iPhone 6P";
    if ([identifier isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([identifier isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([identifier isEqualToString:@"iPhone8,2"])    return @"iPhone 6P";
    if ([identifier isEqualToString:@"iPHone8.4"])    return @"iPhone 6SE";
    if ([identifier isEqualToString:@"iPHone9.1"])    return @"iPhone 7";
    if ([identifier isEqualToString:@"iPHone9.2"])    return @"iPhone 7P";
    
    if ([identifier isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([identifier isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([identifier isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([identifier isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([identifier isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([identifier isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    if ([identifier isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([identifier isEqualToString:@"iPad1,2"])      return @"iPad";
    if ([identifier isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([identifier isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([identifier isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([identifier isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([identifier isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([identifier isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([identifier isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([identifier isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([identifier isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([identifier isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([identifier isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([identifier isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([identifier isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([identifier isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([identifier isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([identifier isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([identifier isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina";
    if ([identifier isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina";
    
    if ([identifier isEqualToString:@"i386"])         return @"Simulator";
    if ([identifier isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", identifier);
    
    if ([identifier hasPrefix:@"iPhone"]) return @"iPhone";
    if ([identifier hasPrefix:@"iPod"]) return @"iPod";
    if ([identifier hasPrefix:@"iPad"]) return @"iPad";
    
    return nil;
}


//- (float)hardwareNumber:(kDeviceType)deviceType {
//    switch (deviceType) {
//        case kDeviceType_Iphone2G: return 1.1f;
//        case kDeviceType_Iphone3G: return 1.2f;
//        case kDeviceType_Iphone3GS: return 2.1f;
//        case kDeviceType_Iphone4:    return 3.0f;
//        case kDeviceType_Iphone4S:    return 4.0f;
//        case kDeviceType_Iphone5:    return 5.0f;
//        case kDeviceType_Iphone5C:    return 5.3f;
//        case kDeviceType_Iphone5S:    return 6.1f;
//        case kDeviceType_Iphone6:         return 7.2f;
//        case kDeviceType_Iphone6P:    return 7.1f;
//        case kDeviceType_Iphone6S:         return 8.1f;
//        case kDeviceType_Iphone6SP:    return 8.2f;
//        case kDeviceType_IphoneSE:         return 8.4f;
//        case kDeviceType_Iphone7:    return 9.1f;
//        case kDeviceType_Iphone7P:         return 9.2f;
//            
//        case kDeviceType_IpodTouch:    return 1.1f;
//        case kDeviceType_IpodTouch2G:    return 2.1f;
//        case kDeviceType_IpodTouch3G:    return 3.1f;
//        case kDeviceType_IpodTouch4G:    return 4.1f;
//        case kDeviceType_IpodTouch5G:    return 5.1f;
//        case kDeviceType_IpodTouch6G:    return 6.1f;
//            
//        case kDeviceType_Ipad:    return 1.1f;
//        case kDeviceType_Ipad2:    return 2.1f;
//        case kDeviceType_Ipad3:    return 3.2f;
//        case kDeviceType_Ipad4:    return 3.5f;
//        case kDeviceType_IpadAir:    return 4.2f;
//        case kDeviceType_IpadAir2:    return 5.4f;
//        case kDeviceType_IpadPro:    return 6.7f;
//        case kDeviceType_IpadMini:    return 2.6f;
//        case kDeviceType_IpadMini2:    return 4.5f;
//        case kDeviceType_IpadMini3:    return 4.8f;
//        case kDeviceType_IpadMini4:    return 5.2f;
//            
//        case kDeviceType_Simulator:    return 100.0f;
//        case kDeviceType_Unknown:    return 200.0f;
//    }
//    return 200.0f; //Device is not available
//}
//
//- (BOOL)isCurrentDeviceHardwareBetterThan:(kDeviceType)deviceType {
//    float otherHardware = [self hardwareNumber:hardware];
//    float currentHardware = [self hardwareNumber:[self getDeviceType]];
//    return currentHardware >= otherHardware;
//}

- (CGSize)backCameraStillImageResolutionInPixels
{
    switch ([self getDeviceType]) {
        case kDeviceType_Iphone2G:
        case kDeviceType_Iphone3G:
            return CGSizeMake(1600, 1200);
            break;
        case kDeviceType_Iphone3GS:
            return CGSizeMake(2048, 1536);
            break;
        case kDeviceType_Iphone4:
        case kDeviceType_Ipad3:
        case kDeviceType_Ipad4:
            return CGSizeMake(2592, 1936);
            break;
        case kDeviceType_Iphone4S:
        case kDeviceType_Iphone5:
        case kDeviceType_Iphone5S:
            return CGSizeMake(3264, 2448);
            break;
            
        case kDeviceType_IpodTouch4G:
            return CGSizeMake(960, 720);
            break;
        case kDeviceType_IpodTouch5G:
            return CGSizeMake(2440, 1605);
            break;
            
        case kDeviceType_Ipad2:
            return CGSizeMake(872, 720);
            break;
            
        case kDeviceType_IpadMini:
            return CGSizeMake(1820, 1304);
            break;
        default:
            NSLog(@"We have no resolution for your device's camera listed in this category. Please, make photo with back camera of your device, get its resolution in pixels (via Preview Cmd+I for example) and add a comment to this repository on GitHub.com in format Device = Hpx x Wpx.");
            NSLog(@"Your device is: %@", [self hardwareDescription]);
            break;
    }
    return CGSizeZero;
}

- (BOOL)isIphoneWith4inchDisplay
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        double height = [[UIScreen mainScreen] bounds].size.height;
        if (fabs(height-568.0f) < DBL_EPSILON) {
            return YES;
        }
    }
    return NO;
}


+ (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
#pragma mark - sysctl utils

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark - memory information
+ (NSUInteger)cpuFrequency {
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)busFrequency {
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger)ramSize {
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)cpuNumber {
    return [self getSysInfo:HW_NCPU];
}


+ (NSUInteger)totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)freeMemoryBytes
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

#pragma mark - disk information

+ (long long)freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

+ (long long)totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}
@end
