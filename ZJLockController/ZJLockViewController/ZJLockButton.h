//
//  ZJLockButton.h
//  ZJLockController
//
//  Created by ZeroJ on 16/9/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZJLockButtonState) {
    ZJLockButtonStateNormal,
    ZJLockButtonStateSelected,
    ZJLockButtonStateError,
};
// 每一个解锁的按钮
@interface ZJLockButton : UIImageView
/** 按钮状态, 根据不同的状态显示不同的图片, 或者绘制不同的内容 */
@property (assign, nonatomic) ZJLockButtonState lockBtnState;

- (void)setBtnImage:(UIImage *)image forState:(ZJLockButtonState)state;
@end
