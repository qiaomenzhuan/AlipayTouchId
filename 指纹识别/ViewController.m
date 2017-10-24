//
//  ViewController.m
//  指纹识别
//
//  Created by YangLei on 16/7/28.
//  Copyright © 2016年 YangLei. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *touchBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)touch:(id)sender {
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        return;
    }
    LAContext *ctx = [[LAContext alloc] init];
    // 判断设备是否支持指纹识别
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        // 输入指纹 - 回调是异步的
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 //成功
                 UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"恭喜你" message:@"解锁成功!" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:confirmAction];
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             } else
             {
                 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                 // 判断错误类型是否是主动自行输入密码
                 if (error.code == LAErrorUserFallback)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //密码验证方法
                     });
                 }
             }
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
