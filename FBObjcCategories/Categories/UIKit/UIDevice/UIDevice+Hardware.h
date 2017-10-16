//
//  UIDevice+Hardware.h
//  TestTable
//
//  Created by Inder Kumar Rathore on 19/01/13.
//  Copyright (c) 2013 Rathore. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define DEVICE_IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define DEVICE_HARDWARE_BETTER_THAN(i) [[UIDevice currentDevice] isCurrentDeviceHardwareBetterThan:i]

#define DEVICE_HAS_RETINA_DISPLAY (fabs([UIScreen mainScreen].scale - 2.0) <= fabs([UIScreen mainScreen].scale - 2.0)*DBL_EPSILON)
#define IS_IOS7_OR_LATER (((double)(DEVICE_IOS_VERSION)-7.0) > -((double)(DEVICE_IOS_VERSION)-7.0)*DBL_EPSILON)
#define NSStringAdd568hIfIphone4inch(str) [NSString stringWithFormat:[UIDevice currentDevice].isIphoneWith4inchDisplay ? @"%@-568h" : @"%@", str]

#define IS_IPHONE_5 [[UIScreen mainScreen] applicationFrame].size.height == 568

typedef NS_ENUM(NSUInteger,  kDeviceType){
    //Apple UnknownDevices
    kDeviceType_Unknown = 0,
    
    //Simulator
    kDeviceType_Simulator,
    
    //AirPod
    kDeviceType_AirPod,
    //kDeviceType_AirPod_Right,
    //kDeviceType_AirPod_Left,
    //kDeviceType_AirPod_ChargingCase, //AirPod charging case
    
    //Apple TV
    kDeviceType_TV2G, //2nd generation
    kDeviceType_TV3G,
    kDeviceType_TV4G,
    kDeviceType_4K, //Aplle TV 4K
    
    //Apple Watch
    kDeviceType_1G, //1st generation
    kDeviceType_S1, //series 1
    kDeviceType_S2,
    kDeviceType_S3,
    
    //Apple iPad
    kDeviceType_Ipad,
    kDeviceType_Ipad2,
    kDeviceType_Ipad3,
    kDeviceType_Ipad4,
    kDeviceType_Ipad5,
    kDeviceType_IpadAir,
    kDeviceType_IpadAir2,
    kDeviceType_IpadPro,
    kDeviceType_IpadPro2,
    kDeviceType_IpadMini,
    kDeviceType_IpadMini2,
    kDeviceType_IpadMini3,
    kDeviceType_IpadMini4,
    
    //Apple iPhone
    kDeviceType_Iphone2G,
    kDeviceType_Iphone3G,
    kDeviceType_Iphone3GS,
    kDeviceType_Iphone4,
    kDeviceType_Iphone4S,
    kDeviceType_Iphone5,
    kDeviceType_Iphone5C,
    kDeviceType_Iphone5S,
    kDeviceType_Iphone6,
    kDeviceType_Iphone6P,
    kDeviceType_Iphone6S,
    kDeviceType_Iphone6SP,
    kDeviceType_IphoneSE,
    kDeviceType_Iphone7,
    kDeviceType_Iphone7P,
    kDeviceType_Iphone8,
    kDeviceType_Iphone8P,
    kDeviceType_IphoneX,
    
    //Apple iPod touch
    kDeviceType_IpodTouch,
    kDeviceType_IpodTouch2G,
    kDeviceType_IpodTouch3G,
    kDeviceType_IpodTouch4G,
    kDeviceType_IpodTouch5G,
    kDeviceType_IpodTouch6G
};


@interface UIDevice (Hardware)
/** This method retruns the hardware type */
- (NSString*)hardwareString;

- (BOOL)isSimulator;

/** Whether the device is jailbroken */
- (BOOL)isJailbroken;

/** This method returns the Hardware enum depending upon harware string */
- (kDeviceType)getDeviceType;

/** This method returns the readable description of hardware string */
- (NSString*)hardwareDescription;

/** This method returs the readble description without identifier (GSM, CDMA, GLOBAL) */
- (NSString *)hardwareSimpleDescription;

/** This method returns YES if the current device is better than the hardware passed */
//- (BOOL)isCurrentDeviceHardwareBetterThan:(kDeviceType)deviceType;

/** This method returns the resolution for still image that can be received 
 from back camera of the current device. Resolution returned for image oriented landscape right. **/
- (CGSize)backCameraStillImageResolutionInPixels;

/** This method returns YES if the currend device is iPhone and has 4" display **/
- (BOOL)isIphoneWith4inchDisplay;

+ (NSString *)macAddress;

//Return the current device CPU frequency
+ (NSUInteger)cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)busFrequency;
//current device RAM size
+ (NSUInteger)ramSize;
//Return the current device CPU number
+ (NSUInteger)cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)totalDiskSpaceBytes;
@end
