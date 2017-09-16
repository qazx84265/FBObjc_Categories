//
//  ViewController.m
//  FBObjc_Categories
//
//  Created by 123 on 16/4/6.
//  Copyright © 2016年 com.pureLake. All rights reserved.
//

#import "ViewController.h"
#import "NSData+Extends.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *str = @"Encrypt test.";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"origin: ------->>>>>> %@", data);
    
    NSData *data1 = [data encryptedWithAESCBCUsingKey:@"123" andIV:data];
    NSLog(@"encrypted: ------->>>>>> %@", data1);
    
    NSData *data2 = [data1 decryptedWithAESCBCUsingKey:@"123" andIV:data];
    NSLog(@"decrypted: ------->>>>>> %@", data2);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
