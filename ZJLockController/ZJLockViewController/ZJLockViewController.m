//
//  ZJLockViewController.m
//  ZJLockController
//
//  Created by ZeroJ on 16/9/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJLockViewController.h"
typedef NS_ENUM(NSInteger, ZJLockViewControllerState) {
    ZJLockViewControllerStateCreate,       // 创建操作
    ZJLockViewControllerStateCreateEnsure, // 确认创建操作
    ZJLockViewControllerStateValidate      // 验证操作
};

static NSString *const kCurrentPasswordKey = @"kCurrentPasswordKey";

@interface ZJLockViewController ()<ZJLockViewDelegate>
// 密码输入view
@property (strong, nonatomic) ZJLockView *lockView;
// 提示文字label
@property (strong, nonatomic) UILabel *statusLabel;
// 当前操作的状态
@property (assign, nonatomic) ZJLockViewControllerState state;
// 是否发生错误
@property (assign, nonatomic) BOOL isMeetingError;
// 当前密码
@property (copy, nonatomic) NSString *currentPassword;
// 需要操作的类型
@property (assign, nonatomic) ZJLockOperationType operationType;
// 代理
@property (weak, nonatomic) id<ZJLocViewControllerDelegate> delegate;
@end

@implementation ZJLockViewController

+ (BOOL *)isAllreadySetPassword {
    return [ZJLockViewController getCurrentPassword] != nil;
}
// 获取本地的密码
+ (NSString *)getCurrentPassword {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPasswordKey];
}
// 保存密码到本地
+ (void)setCurrentPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:kCurrentPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (instancetype)initWithOperationType:(ZJLockOperationType)type delegate:(id<ZJLocViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        // 重写set方法, 设置初始状态
        self.operationType = type;
        // 获取本地的密码
        _currentPassword = [ZJLockViewController getCurrentPassword];
        _mininumCount = 3;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.statusLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    {
        if (_lockViewSlideLength == 0) {
            _lockViewSlideLength = MIN(self.view.bounds.size.width,self.view.bounds.size.height)*2/3;
        }
        CGRect lockViewFrame = CGRectMake(0.0f, 0.0f, _lockViewSlideLength, _lockViewSlideLength);
        _lockView.frame = lockViewFrame;
        _lockView.center = self.view.center;
    }
    // 自动计算文字的宽高
    [self.statusLabel sizeToFit];
    CGFloat margin = 20.f;
    CGFloat labelX = margin;
    CGFloat labelY = _lockView.frame.origin.y - self.statusLabel.bounds.size.height - 100.f;
    CGFloat labelWidth = self.view.bounds.size.width - 2*margin;
    
    self.statusLabel.frame = CGRectMake(labelX, labelY, labelWidth, self.statusLabel.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ZJLockViewDelegate
- (void)lockView:(ZJLockView *)lockView didFinishCreatingPassword:(NSString *)password {
    if (self.operationType == ZJLockOperationTypeCreate) {
        [self createPassword:password withLockView:lockView];
    }
    else if (self.operationType == ZJLockOperationTypeModify) {
        [self modifyPassword:password withLockView:lockView];
    }
    else if (self.operationType == ZJLockOperationTypeValidate) {
        [self validatePassword:password withLockView:lockView];
    }
    else {
        [self removePassword:password withLockView:lockView];
    }
}

#pragma mark - helper

- (void)removePassword:(NSString *)password withLockView:(ZJLockView *)lockView {
    if (self.state == ZJLockViewControllerStateValidate) {
        [self validatePassword:password withLockView:lockView];
    }
    
}
- (void)validatePassword:(NSString *)password withLockView:(ZJLockView *)lockView {
    self.statusLabel.text = @"请绘制旧密码";
    if ([password isEqualToString:_currentPassword]) {// 正确
        [lockView resetDrawing];
        if (self.operationType == ZJLockOperationTypeModify) {
            self.state = ZJLockViewControllerStateCreate;
            self.statusLabel.text = @"请绘制新密码";
            
        }
        else if (self.operationType == ZJLockOperationTypeValidate) {
            self.statusLabel.text = @"密码验证成功";
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:validatePassword:isSuccessful:)]) {
                [_delegate lockViewController:self validatePassword:password isSuccessful:YES];
            }
        }
        else if (self.operationType == ZJLockOperationTypeRemove) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePassword:isSuccessful:)]) {
                [_delegate lockViewController:self removePassword:password isSuccessful:YES];
                [ZJLockViewController setCurrentPassword:nil];
            }
            
        }
        
    }
    else {//错误
        
        if (self.operationType == ZJLockOperationTypeModify) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPassword:isSuccessful:)]) {
                [_delegate lockViewController:self modifyPassword:password isSuccessful:NO];
            }
            
        }
        else if (self.operationType == ZJLockOperationTypeValidate) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:validatePassword:isSuccessful:)]) {
                [_delegate lockViewController:self validatePassword:password isSuccessful:NO];
            }
        }
        else if (self.operationType == ZJLockOperationTypeRemove) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePassword:isSuccessful:)]) {
                [_delegate lockViewController:self removePassword:password isSuccessful:NO];
            }
            
        }
        self.statusLabel.text = @"绘制的密码错误";
        self.isMeetingError = YES;
        __weak typeof(self) weakSelf = self;
        [lockView showErrorPassword:password withTime:1.0f finishHandler:^(ZJLockView *lockView) {
            weakSelf.statusLabel.text = @"请绘制密码";
            weakSelf.isMeetingError = NO;
        }];
    }
    
}
- (void)dealloc {
    _lockView = nil;
//    NSLog(@"ZJLockViewController---销毁");
}

- (void)modifyPassword:(NSString *)password withLockView:(ZJLockView *)lockView {
    if (self.state == ZJLockViewControllerStateValidate) {
        // 验证旧密码
        [self validatePassword:password withLockView:lockView];
    }
    else {
        // 创建新密码
        [self createPassword:password withLockView:lockView];
    }
}

- (void)createPassword:(NSString *)password withLockView:(ZJLockView *)lockView {

    if (self.state == ZJLockViewControllerStateCreate) {
        if (password.length < self.mininumCount) {
            self.statusLabel.text = @"连接的密码数少于3个";
            self.isMeetingError = YES;
            __weak typeof(self) weakSelf = self;
            [lockView showErrorPassword:password withTime:1.0f finishHandler:^(ZJLockView *lockView){
                weakSelf.statusLabel.text = @"请绘制密码";
                weakSelf.isMeetingError = NO;
                
            }];
            
        }
        else {
            // 暂时的密码--未写入本地
            _currentPassword = password;
            // 清除绘制的密码图案
            [lockView resetDrawing];
            // 更改操作步骤为确认密码
            self.statusLabel.text = @"请再次绘制密码";
            self.state = ZJLockViewControllerStateCreateEnsure;
        }
    }
    else if (self.state == ZJLockViewControllerStateCreateEnsure) {
        if ([password isEqualToString:_currentPassword]) {// 正确
            [lockView resetDrawing];
            // 设置成功-- 保存密码
            [ZJLockViewController setCurrentPassword:password];
            if (self.operationType == ZJLockOperationTypeCreate) {
                self.statusLabel.text = @"密码创建成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:didSuccessFullyCreatePassword:)]) {
                    [_delegate lockViewController:self didSuccessFullyCreatePassword:_currentPassword];
                }
                
            }
            else if (self.operationType == ZJLockOperationTypeModify) {
                self.statusLabel.text = @"密码修改成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPassword:isSuccessful:)]) {
                    [_delegate lockViewController:self modifyPassword:password isSuccessful:YES];
                }
                
            }
        }
        else {//错误
            self.statusLabel.text = @"两次绘制的密码不匹配,创建失败";
            self.isMeetingError = YES;
            __weak typeof(self) weakSelf = self;
            [lockView showErrorPassword:password withTime:1.0f finishHandler:^(ZJLockView *lockView) {
                if (weakSelf.operationType == ZJLockOperationTypeModify) {
                    weakSelf.statusLabel.text = @"请重新绘制新密码";
                    
                }
                if (weakSelf.operationType == ZJLockOperationTypeCreate) {
                    weakSelf.statusLabel.text = @"请重新绘制密码";
                    
                }
                weakSelf.isMeetingError = NO;
            }];
            self.state = ZJLockViewControllerStateCreate;
        }
    }
}

#pragma mark - getter---- setter

- (void)setIsMeetingError:(BOOL)isMeetingError {
    _isMeetingError = isMeetingError;
    
    if (isMeetingError) {
        self.statusLabel.textColor = [UIColor redColor];
    }
    else {
        self.statusLabel.textColor = [UIColor blackColor];
    }
}

- (void)setOperationType:(ZJLockOperationType)operationType {
    _operationType = operationType;
    if (operationType == ZJLockOperationTypeModify) {
        self.statusLabel.text = @"输入旧密码";
        self.state = ZJLockViewControllerStateValidate;
    }
    else if (self.operationType == ZJLockOperationTypeValidate) {
        self.statusLabel.text = @"输入密码";
        self.state = ZJLockViewControllerStateValidate;
    }
    else if (self.operationType == ZJLockOperationTypeRemove) {
        self.statusLabel.text = @"输入旧密码";
        self.state = ZJLockViewControllerStateValidate;
    }
    else {
        self.statusLabel.text = @"输入初始密码";
        self.state = ZJLockViewControllerStateCreate;

    }
}


- (UILabel *)statusLabel {
    if (!_statusLabel) {
        UILabel *statusLabel = [UILabel new];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = @"请输入密码";
        statusLabel.textColor = [UIColor blackColor];
        _statusLabel = statusLabel;
        
    }
    return _statusLabel;
}

- (ZJLockView *)lockView {
    if (!_lockView) {
        _lockView = [[ZJLockView alloc] initWithDelegate:self];
        _lockView.backgroundColor = [UIColor purpleColor];
        
    }
    return _lockView;
}

@end
