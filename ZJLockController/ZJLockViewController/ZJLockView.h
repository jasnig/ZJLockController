//
//  ZJLockView.h
//  ZJLockController
//
//  Created by ZeroJ on 16/9/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLockButton.h"

@class ZJLockView;
@protocol ZJLockViewDelegate <NSObject>

- (void)lockView:(ZJLockView *)lockView didFinishCreatingPassword:(NSString *)password;

@end

@interface ZJLockView : UIView
/** x和y 的两边间隙 默认为20 */
@property (assign, nonatomic) CGFloat margin;
/** 密码块的边长 默认为 44.0f */
@property (assign, nonatomic) CGFloat pwdBtnSlideLength;
/** 连接线的宽度 默认2.0f */
@property (assign, nonatomic) CGFloat lineWidth;
/** 连接线的颜色 默认红色 */
@property (strong, nonatomic) UIColor *lineColor;
/** 绘制的密码, 只读 */
@property (strong, nonatomic, readonly) NSString *password;
@property (weak, nonatomic) id<ZJLockViewDelegate> delegate;
/**
 *  初始化方法
 *
 *  @param delegate delegate
 *
 *  @return
 */
- (instancetype)initWithDelegate:(id<ZJLockViewDelegate>)delegate;
/**
 *  重置状态
 */
- (void)resetDrawing;
/**
 *  显示错误的密码
 *
 *  @param errorPassword errorPassword
 *  @param time          显示时间
 *  @param handler       handler 显示完毕的处理block
 */
- (void)showErrorPassword:(NSString *)errorPassword withTime:(CGFloat)time finishHandler:(void(^)(ZJLockView *lockView))handler;

/**
 *  展示密码
 *
 *  @param Password 字符串密码(0~~~8)最多9位并且无重复
 *  @param status   展示的状态
 *  @param handler  handler
 */
- (void)showPassword:(NSString *)password withButtonStatus:(ZJLockButtonState)status finishHandler:(void(^)(ZJLockView *lockView))handler;
/**
 *  设置不同状态的图片
 *
 *  @param image 图片
 *  @param state 状态
 */
- (void)setBtnImage:(UIImage *)image forState:(ZJLockButtonState)state;

@end
