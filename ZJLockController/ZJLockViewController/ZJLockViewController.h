//
//  ZJLockViewController.h
//  ZJLockController
//
//  Created by ZeroJ on 16/9/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLockView.h"
@class ZJLockViewController;
typedef NS_ENUM(NSInteger, ZJLockOperationType) {
    ZJLockOperationTypeCreate,     // 创建密码
    ZJLockOperationTypeValidate,   // 验证密码
    ZJLockOperationTypeModify,     // 修改密码
    ZJLockOperationTypeRemove      // 移除密码
};

@protocol ZJLocViewControllerDelegate <NSObject>

@optional
/**
 *  创建密码成功
 *
 *  @param controller controller
 *  @param password   password
 */
- (void)lockViewController:(ZJLockViewController *)lockViewController didSuccessFullyCreatePassword:(NSString *)password;
/**
 *  验证密码
 *
 *  @param controller   controller description
 *  @param password     password description
 *  @param isSuccessful 是否验证成功
 */
- (void)lockViewController:(ZJLockViewController *)lockViewController validatePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;
/**
 *  修改密码
 *
 *  @param controller   controller description
 *  @param password     修改后的密码
 *  @param isSuccessful 是否修改成功
 */
- (void)lockViewController:(ZJLockViewController *)lockViewController modifyPassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;
/**
 *  删除密码
 *
 *  @param controller   controller description
 *  @param password
 *  @param isSuccessful 是否删除成功
 */
- (void)lockViewController:(ZJLockViewController *)lockViewController removePassword:(NSString *)password isSuccessful:(BOOL)isSuccessful;


@end

@interface ZJLockViewController : UIViewController
// 密码输入view
@property (strong, nonatomic, readonly) ZJLockView *lockView;
/** 提示文字的label, 可以设置他的属性 */
@property (strong, nonatomic, readonly) UILabel *statusLabel;
/** 最少要连接的密码位数 默认为3 */
@property (assign, nonatomic) NSInteger mininumCount;


/** 密码view的边长, 默认屏幕2/3 */
@property (assign, nonatomic) CGFloat lockViewSlideLength;

/** 是否设置过密码 */
+ (BOOL *)isAllreadySetPassword;

/** 获取本地的密码 */
+ (NSString *)getCurrentPassword;
/** 保存密码到本地 */
+ (void)setCurrentPassword:(NSString *)password;

/**
 *  初始化方法
 *
 *  @param type     将要进行的操作类型
 *  @param delegate 代理-- 通过代理方法获取到对应的操作结果
 *
 *  @return
 */
- (instancetype)initWithOperationType:(ZJLockOperationType)type delegate:(id<ZJLocViewControllerDelegate>)delegate;
@end
