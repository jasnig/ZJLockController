//
//  ZJPassword.h
//  ZJLockController
//
//  Created by ZeroJ on 16/9/23.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPasswordView : UIView
// 输入完成的block
typedef void(^InputFinishHandler)(ZJPasswordView *passwordView, NSString *password);
/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param lineColor      分割线的颜色
 *  @param passwordLength 密码的位数
 *  @param handler        结束输入的处理block
 *
 *  @return ZJPasswordView
 */
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength finishHandler:(InputFinishHandler)handler;

/** 展示 */
- (void)show;
/** 移除 */
- (void)hide;

@end
