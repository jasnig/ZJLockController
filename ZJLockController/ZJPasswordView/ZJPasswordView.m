//
//  ZJPassword.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/23.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJPasswordView.h"
#import "ZJPasswordInputView.h"

@interface ZJPasswordView ()<UITextFieldDelegate> {
    CGFloat _keyboardHeight; ///<键盘的高度--- 不要写成固定的, 需要根据通知获取
}
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) ZJPasswordInputView *passwordInputView;
@property (copy, nonatomic) InputFinishHandler inputFinishHandler;

@property (strong, nonatomic) UIImage *normalImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) int passwordLength;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end
@implementation ZJPasswordView


- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage lineColor:(UIColor *)lineColor passwordLength:(int)passwordLength finishHandler:(InputFinishHandler)handler {
    if (self = [super init]) {
        _normalImage = normalImage;
        _selectedImage = selectedImage;
        _passwordLength = passwordLength;
        _lineColor = lineColor;
        self.inputFinishHandler = [handler copy];
        [self commonInit];
    }
    return self;

}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)commonInit {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    
    [self addSubview:self.passwordTextField];
    [self addSubview:self.passwordInputView];
    [self addGestureRecognizer:self.tapGesture];
    [self.passwordTextField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)dealloc {
//    NSLog(@"ZJPasswordTextField-------dealloc");
    // 只移除我们添加的监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.superview) { // 已经被添加到了window中就设置frame
        self.frame = self.superview.bounds; // 这样可以适配旋转
        CGFloat passwordInputViewHeight = 44.0f;
        // 键盘上方
        CGFloat y = self.bounds.size.height - _keyboardHeight - passwordInputViewHeight;
        self.passwordTextField.frame = CGRectMake(0, y, self.bounds.size.width, passwordInputViewHeight);
        self.passwordInputView.frame = self.passwordTextField.frame;
    }
}

// 文本改变
- (void)textFieldValueDidChanged:(UITextField *)textField {
    
    NSString *text = textField.text;
    // 设置已经输入的密码位数 --- 调整状态
    [self.passwordInputView setupBtnWithCurrentPasswordLength:text.length];
    // 输入位数完整 调用handler
    if (text.length >= _passwordLength) {
        // 延时0.1 为了让上面设置的显示输入密码的图片切换完成在调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_inputFinishHandler) {
                self.inputFinishHandler(self, text);
            }

        });
    }
}
// 是否要改变文本
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= _passwordLength) {// 限制密码输入位
        return NO;
    }
    return YES;
}

- (void)keyboardWillshow:(NSNotification *)noti {
//    NSLog(@"%@",noti.userInfo);
    // 键盘将要出现 获取到键盘高度 不要使用UIKeyboardBoundsUserInfoKey(废弃)
    CGRect keyboardBounds = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardBounds.size.height;
    // 标记为需要重新调整frame --- 不应该直接调用layoutSubviews
    [self setNeedsLayout];
}

- (void)handlerTap:(UITapGestureRecognizer *)tap {
    [self hide];
}

- (ZJPasswordInputView *)passwordInputView {
    if (!_passwordInputView) {
        _passwordInputView = [[ZJPasswordInputView alloc] initWithNormalImage:_normalImage selectedImage:_selectedImage lineColor:_lineColor passwordLength:_passwordLength];
    }
    return _passwordInputView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap:)];
        _tapGesture = tapGesture;
    }
    return _tapGesture;
}

// 输入框
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [UITextField new];
        _passwordTextField.secureTextEntry = YES;
        //  键盘类型为输入数字
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        // 设置代理 利用代理来处理输入位数的限制
        _passwordTextField.delegate = self;
        
        /**
         *  添加文字改变的处理响应 <<< 这个可以监听通知 UITextFieldTextDidChangeNotification
         * 但是使用要注意, 利用通知的时候输入一个中文会多次触发通知
         * 不过在我们这里不输入中文两种方法并没有区别
         */
        [_passwordTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];

    }
    return _passwordTextField;
}
@end
