//
//  ZJPasswordView.h
//  ZJLockController
//
//  Created by ZeroJ on 16/9/23.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPasswordInputView : UIView
/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param lineColor      分割线的颜色
 *  @param passwordLength 密码的位数
 *
 *  @return ZJPasswordInputView
 */
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength;
/**
 *  设置输入的密码的状态
 *
 *  @param count 已经输入的密码位数
 */
- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength;
@end
