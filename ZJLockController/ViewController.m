//
//  ViewController.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJLockViewController.h"
#import "ZJPasswordView.h"
#import "ZJLockViewController/ZJLockView.h"
@interface ViewController ()<ZJLocViewControllerDelegate>
- (IBAction)createBtnOnClick:(id)sender;
- (IBAction)varifyBtnOnClick:(id)sender;
- (IBAction)deleteBtnOnClick:(id)sender;
- (IBAction)inputBtnOnClick:(id)sender;
- (IBAction)modifyBtnOnClick:(id)sender;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)lockViewController:(ZJLockViewController *)lockViewController didSuccessFullyCreatePassword:(NSString *)password {
    NSLog(@"创建密码成功:  %@", password);
    [lockViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)lockViewController:(ZJLockViewController *)lockViewController validatePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"验证成功" : @"验证失败";
    NSLog(@"验证结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];

    }
}

- (void)lockViewController:(ZJLockViewController *)lockViewController modifyPassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"修改成功" : @"修改失败";
    NSLog(@"修改结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
        
    }

}

- (void)lockViewController:(ZJLockViewController *)lockViewController removePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful {
    NSString *result = isSuccessful ? @"删除成功" : @"删除失败";
    NSLog(@"删除结果为: %@", result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createBtnOnClick:(id)sender {
    ZJLockViewController *lock = [[ZJLockViewController alloc] initWithOperationType:ZJLockOperationTypeCreate delegate:self];
    lock.lockView.pwdBtnSlideLength = 64.f;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:ZJLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:ZJLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:ZJLockButtonStateError];

    [self presentViewController:lock animated:YES completion:nil];
    

}

- (IBAction)varifyBtnOnClick:(id)sender {
    if (![ZJLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }

    ZJLockViewController *lock = [[ZJLockViewController alloc] initWithOperationType:ZJLockOperationTypeValidate delegate:self];
    lock.lockView.pwdBtnSlideLength = 64.f;
    lock.lockView.lineWidth = 8;
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:ZJLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:ZJLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:ZJLockButtonStateError];

    [self presentViewController:lock animated:YES completion:nil];
    

}

- (IBAction)modifyBtnOnClick:(id)sender {
    
    if (![ZJLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    
    ZJLockViewController *lock = [[ZJLockViewController alloc] initWithOperationType:ZJLockOperationTypeModify delegate:self];
    lock.lockView.pwdBtnSlideLength = 64.f;
    lock.lockView.lineWidth = 8;
    
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:ZJLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:ZJLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:ZJLockButtonStateError];

    [self presentViewController:lock animated:YES completion:nil];
    
}

- (IBAction)deleteBtnOnClick:(id)sender {
    if (![ZJLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    // 初始化
    ZJLockViewController *lock = [[ZJLockViewController alloc] initWithOperationType:ZJLockOperationTypeRemove delegate:self];
    // 宽度
    lock.lockView.pwdBtnSlideLength = 64.f;
    // 线宽
    lock.lockView.lineWidth = 8;
    // 设置不同状态的图片
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:ZJLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:ZJLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:ZJLockButtonStateError];

    [self presentViewController:lock animated:YES completion:nil];
    

}

- (IBAction)inputBtnOnClick:(id)sender {
    ZJPasswordView *pas = [[ZJPasswordView alloc] initWithNormalImage:nil selectedImage:[UIImage imageNamed:@"circle"] lineColor:[UIColor lightGrayColor] passwordLength:6 finishHandler:^(ZJPasswordView *passwordView, NSString *password) {
        NSLog(@"输入的密码是---- %@", password);
        [passwordView hide];
    }];
    
    [pas show];
}


@end