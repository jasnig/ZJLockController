//
//  ZJLockButton.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJLockButton.h"

@interface ZJLockButton ()
@property (strong, nonatomic) UIImage *normalStateImage;
@property (strong, nonatomic) UIImage *selectedStateImage;
@property (strong, nonatomic) UIImage *errorStateImage;

@end

@implementation ZJLockButton

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = self.bounds.size.width/2;
//}

- (void)setBtnImage:(UIImage *)image forState:(ZJLockButtonState)state {
    switch (state) {
        case ZJLockButtonStateNormal:
            self.normalStateImage = image;
            break;
        case ZJLockButtonStateSelected:
            self.selectedStateImage = image;
            break;
        case ZJLockButtonStateError:
            self.errorStateImage = image;
            break;
    }
    // 设置图片后 设置为默认状态
    self.lockBtnState = ZJLockButtonStateNormal;
}

- (void)setLockBtnState:(ZJLockButtonState)lockBtnState {
    _lockBtnState = lockBtnState;

    switch (lockBtnState) {
        case ZJLockButtonStateNormal:
            self.image = self.normalStateImage;
            break;
        case ZJLockButtonStateSelected:
            self.image = self.selectedStateImage;

            break;
        case ZJLockButtonStateError:
            self.image = self.errorStateImage;

            break;
    }
}
//- (void)dealloc {
//    NSLog(@"ZJLockButton---销毁");
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

@end
