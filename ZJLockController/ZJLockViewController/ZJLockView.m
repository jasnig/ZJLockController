//
//  ZJLockView.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJLockView.h"
@interface ZJLockView () {
    CGPoint _point;
}
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *selectedButtons;
@property (strong, nonatomic) NSString *password;

@end

static const int kTotalCount = 9;
//static NSString *const kPasswordSeparateStr = @",";

@implementation ZJLockView

- (instancetype)initWithDelegate:(id<ZJLockViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _margin = 20.f;
    _pwdBtnSlideLength = 44.f;
    _lineWidth = 2.0f;
    _lineColor = [UIColor redColor];
    _password = @"";
    // 添加密码块
    for (int i=0; i<kTotalCount; i++) {
        ZJLockButton *button = [[ZJLockButton alloc] init];
        button.lockBtnState = ZJLockButtonStateNormal;
        button.tag = i;
        [self.buttons addObject:button];
        [self addSubview:button];
    }
    
}

- (void)setBtnImage:(UIImage *)image forState:(ZJLockButtonState)state {
    for (ZJLockButton *lockBtn in self.buttons) {
        [lockBtn setBtnImage:image forState:state];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0.f;
    CGFloat y = 0.f;
    // 中间块的间隙
    // 乘3表示3个块的边长  乘2表示左右两边间隙 除以2是因为三个块之间有两个间隙
    CGFloat centerMargin = (self.bounds.size.width - 3*_pwdBtnSlideLength - 2*_margin)/2;

    for (int i=0; i<kTotalCount; i++) {
        // 行 一共3行
        NSInteger row = i / 3;
        // 列 一共3列
        NSInteger col = i % 3;
        x = col * (centerMargin + _pwdBtnSlideLength) + _margin;
        y = row * (centerMargin + _pwdBtnSlideLength) + _margin;
        
        ZJLockButton *button = self.buttons[i];
        button.frame = CGRectMake(x, y, _pwdBtnSlideLength, _pwdBtnSlideLength);
    }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    if (self.selectedButtons.count == 0) {// 只有从按钮上手指开始移动才开始draw
        return;
    }
    
    // 这里使用UIBezierPath, 当然也可以类似使用CGContextRef
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 设置线的宽度
    path.lineWidth = _lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    // 设置颜色
    [_lineColor set];
    
    int i = 0;
    for (ZJLockButton *button in _selectedButtons) {
        if (i == 0) {
            // 第一个点首先设置初始点
            [path moveToPoint:button.center];
        }
        else {
            // 将选中的按钮之间的中心用线连接起来
            [path addLineToPoint:button.center];

        }
        i++;
    }
    // 从最后一个选中按钮的中心随着手指移动绘制直线
    [path addLineToPoint:_point];
    // 绘制所有的路径
    [path stroke];
}

- (void)updateDrawing {
    
    for (ZJLockButton *button in _buttons) {
        
        // 如果手指在其中的一个按钮之内, 并且这个按钮之前还未被选中
        // 就将按钮标记为选中状态, 并且触发重新绘制
        if (CGRectContainsPoint(button.frame, _point)) {
            if (button.lockBtnState == ZJLockButtonStateNormal) {
                [_selectedButtons addObject:button];
                button.lockBtnState = ZJLockButtonStateSelected;
                break;
            }
        }
    }
    // 触发重新调用drawRect绘制
    [self setNeedsDisplay];

}

- (void)showErrorPassword:(NSString *)errorPassword withTime:(CGFloat)time finishHandler:(void(^)(ZJLockView *lockView))handler {
    
    // 清空选中值
    self.selectedButtons = nil;
    
    // 这种方式使用C语言的方式来获取字符串的每一位值, 比较方便
    const char *cPassword = [errorPassword cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i < errorPassword.length; i++) {
        int index = cPassword[i] - '0'; // 将char 转换为对应的int (ASII 48)
        ZJLockButton *errorBtn = self.buttons[index];
        errorBtn.lockBtnState = ZJLockButtonStateError;
        [self.selectedButtons addObject:errorBtn];
    }
    
    // 这种方式使用NSString的直接取得特定字符的功能 比较方便
//    for (int i = 0; i < errorPassword.length; i++) {
//        char indexChar = [errorPassword characterAtIndex:i];
//        int index = indexChar - '0'; // 将char 转换为对应的int
//        ZJLockButton *errorBtn = self.buttons[index];
//        errorBtn.lockBtnState = ZJLockButtonStateError;
//        [self.selectedButtons addObject:errorBtn];
//    }
    
    
    [self setNeedsDisplay];
    // 这个时候不接受触摸事件
    self.userInteractionEnabled = NO;
    __weak ZJLockView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZJLockView *strongSelf = weakSelf;
        if (strongSelf) {
            // 展示错误 延时后重置状态
            [strongSelf resetDrawing];
            // 开启交互
            strongSelf.userInteractionEnabled = YES;
            if (handler) {
                handler(strongSelf);
            }
        }

    });
}

- (void)showPassword:(NSString *)password withButtonStatus:(ZJLockButtonState)status finishHandler:(void(^)(ZJLockView *lockView))handler {
    // 清空选中值
    self.selectedButtons = nil;
    
    for (int i = 0; i < password.length; i++) {
        char indexChar = [password characterAtIndex:i];
        int index = indexChar - '0'; // 将char 转换为对应的int
        ZJLockButton *passwordBtn = self.buttons[index];
        passwordBtn.lockBtnState = status;
        [self.selectedButtons addObject:passwordBtn];
    }
    [self setNeedsDisplay];
    if (handler) {
        handler(self);
    }

}

- (void)dealloc {
    NSLog(@"ZJLockView---销毁");
}

- (void)resetDrawing {
    for (ZJLockButton *button in _selectedButtons) {
        button.lockBtnState = ZJLockButtonStateNormal;
    }
    [_selectedButtons removeAllObjects];
    [self setNeedsDisplay];
}

- (void)setUpPassword {
    NSString *password = @"";
    // 拼接所有选中按钮的tag值
    for (ZJLockButton *button in _selectedButtons) {
        password = [password stringByAppendingString:[NSString stringWithFormat:@"%ld", button.tag]];

    }
    _password = password;
    // 通过代理传递给外界
    if (_delegate && [_delegate respondsToSelector:@selector(lockView:didFinishCreatingPassword:)]) {
        [_delegate lockView:self didFinishCreatingPassword:_password];
    }
}

// Apple建议需要同时重写以下四个方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _point = [[touches anyObject] locationInView:self];
    // 更新密码绘制状态
    [self updateDrawing];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    _point = [[touches anyObject] locationInView:self];
    // 更新密码绘制状态
    [self updateDrawing];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    // 获取绘制好的密码
    [self setUpPassword];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    // 获取绘制好的密码
    [self setUpPassword];
}

- (NSMutableArray *)selectedButtons {
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray arrayWithCapacity:kTotalCount];
    }
    return _selectedButtons;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:kTotalCount];
    }
    return _buttons;
}


@end
