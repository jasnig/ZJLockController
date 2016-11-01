# ZJLockController
实现了, 一个常用的手势解锁的功能, 已经封装好创建密码, 验证密码 , 修改密码, 删除密码,. 同时简单实现了类似支付宝的支付密码的输入效果, 支付宝手势解锁


![lockView.gif](http://upload-images.jianshu.io/upload_images/1271831-9104de63e5ff17df.gif?imageMogr2/auto-orient/strip)


```
- (IBAction)deleteBtnOnClick:(id)sender {
    if (![ZJLockViewController isAllreadySetPassword]) {
        NSLog(@"未曾设置过密码或者密码已经被删除");
        return;
    }
    // 初始化
    ZJLockViewController *lock = [[ZJLockViewController alloc] initWithOperationType:ZJLockOperationTypeRemove delegate:self];
    // 宽度
    lock.lockView.pwdBtnSlideLength = 64.f;
    // 线宽
    lock.lockView.lineWidth = 8;
    // 设置不同状态的图片
    [lock.lockView setBtnImage:[UIImage imageNamed:@"normal"] forState:ZJLockButtonStateNormal];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"selected"] forState:ZJLockButtonStateSelected];
    [lock.lockView setBtnImage:[UIImage imageNamed:@"error"] forState:ZJLockButtonStateError];

    [self presentViewController:lock animated:YES completion:nil];
    

}
```