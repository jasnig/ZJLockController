//
//  ZJPasswordView.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/23.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJPasswordInputView.h"

@interface ZJPasswordInputView ()
// 输入密码提示图片
@property (strong, nonatomic) NSMutableArray *buttonsArray;
// 分割线
@property (strong, nonatomic) NSMutableArray *linesArray;
// 下面的分割线
@property (strong, nonatomic) UIView *underLineView;
// 密码位数
@property (assign, nonatomic) int passwordLength;

@end

@implementation ZJPasswordInputView

- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength {
    if (self = [super init]) {
        
        _passwordLength = passwordLength;
        self.backgroundColor = [UIColor whiteColor];
        self.underLineView.backgroundColor = lineColor;
        [self addSubview:self.underLineView];
        // 初始化子控件
        for (int i = 0; i<passwordLength; i++) {
            UIImageView *button = [UIImageView new];
            button.contentMode = UIViewContentModeCenter;
            button.backgroundColor = [UIColor whiteColor];
            button.image = normalImage;
            button.highlightedImage= selectedImage;
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = lineColor;
            
            [self addSubview:button];
            [self addSubview:lineView];
            [self.buttonsArray addObject:button];
            [self.linesArray addObject:lineView];
        }
    }
    return self;
    
}

- (void)dealloc {
//    NSLog(@"inputView === dealloc");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lineX = 0.0f;
    CGFloat lineW = 1.f;
    
    CGFloat btnX = 0.0;
    // 平分除去分割线的宽度之和的部分
    CGFloat btnW = (self.bounds.size.width - (_passwordLength-1)*lineW)/_passwordLength;
    CGFloat height = self.bounds.size.height - lineW;
    
    for (int i = 0; i<_passwordLength; i++) {
        UIButton *button = self.buttonsArray[i];
        btnX = (btnW + lineW)*i;
        button.frame = CGRectMake(btnX, 0.0, btnW, height);
        
        UIView *lineView = self.linesArray[i];
        lineX = btnW*(i+1) + lineW*i;
        lineView.frame = CGRectMake(lineX, 0.0, lineW, height);
    }
    
    self.underLineView.frame = CGRectMake(0.f, height, self.bounds.size.width, lineW);

}

- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength {
    for (int i=0; i<_passwordLength; i++) {
        UIImageView *button = self.buttonsArray[i];
        // 切换图片显示
        if (i < currentPasswordLength) { // 显示已经输入状态的图片
            button.highlighted = YES;
        }
        else { // 显示未输入状态的图片
            button.highlighted = NO;
        }
    }
}

- (UIView *)underLineView {
    if (!_underLineView) {
        _underLineView = [UIView new];
    }
    return _underLineView;
}

- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:_passwordLength];
    }
    return _buttonsArray;
}

- (NSMutableArray *)linesArray {
    if (!_linesArray) {
        _linesArray = [NSMutableArray arrayWithCapacity:_passwordLength];
    }
    return  _linesArray;
}

@end
