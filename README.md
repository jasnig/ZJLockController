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

> 这是我写的<iOS自定义控件剖析>这本书籍中的一个demo, 如果你希望知道具体的实现过程和其他的一些常用效果的实现, 那么你应该能轻易在网上下载到免费的盗版书籍. 

> 当然作为本书的写作者, 还是希望有人能支持正版书籍. 如果你有意购买书籍, 在[这篇文章中](http://www.jianshu.com/p/510500f3aebd), 介绍了书籍中所有的内容和书籍适合阅读的人群, 和一些试读章节, 以及购买链接. 在你准备[购买](http://www.qingdan.us/product/13)之前, 请一定读一读里面的说明. 否则, 如果不适合你阅读, 虽然书籍售价35不是很贵, 但是也是一笔损失.


> 如果你希望联系到我, 可以通过[简书](http://www.jianshu.com/users/fb31a3d1ec30/latest_articles)联系到我
