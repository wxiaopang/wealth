//
//  UIButton+count.m
//  wealth
//
//  Created by wangyingjie on 15/12/24.
//  Copyright © 2015年 普惠金融. All rights reserved.
//

#import "UIButton+count.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kButtonClickCountPlist   @"ButtonClickCount.plist"

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

static void *const kbtnClickedCountKey = (void *)&kbtnClickedCountKey;
static void *const kbtnFunctionIdKey = (void *)&kbtnFunctionIdKey;
static void *const btnCurrentActionBlockKey = (void *)&btnCurrentActionBlockKey;

@implementation UIButton (count)

/** 拦截了UIButton 所有的
 - (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
 方法*/
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if ( self.btnFunctionId ) {
        __weak typeof(target) weakTarget = target;

        __weak typeof(self) weakSelf = self;

        //利用 关联对象 给UIButton 增加了一个 block
        [self setCustomBtnOnClick:^{
            //运行时 发送 消息 执行方法
            ((void (*)(void *, SEL, UIButton *))objc_msgSend)((__bridge void *)(weakTarget), action , weakSelf);

        }];

        //拦截了本身要执行的action 先执行，写下来的 xw_clicked:方法
        [super addTarget:self action:@selector(custom_clicked:) forControlEvents:controlEvents];
    } else {
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

//拦截了按钮点击后要执行的代码
- (void)custom_clicked:(UIButton *)sender {
    //统计 在这个方法中执行想要操作的
    self.btnClickedCount++;

    //执行原来要执行的方法
    sender.customBtnOnClick();
}

//在分类中增加了 btnClickedCount的 (setter 和 getter）方法，使用关联对象增加了相关的成员空间
- (NSInteger)btnClickedCount {
    return [objc_getAssociatedObject(self, &kbtnClickedCountKey) integerValue];
}

- (void)setBtnClickedCount:(NSInteger)btnClickedCount {
    objc_setAssociatedObject(self, &kbtnClickedCountKey, @(btnClickedCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)btnFunctionId {
    return [objc_getAssociatedObject(self, &kbtnFunctionIdKey) integerValue];
}

- (void)setBtnFunctionId:(NSInteger)btnFunctionId {
    objc_setAssociatedObject(self, &kbtnFunctionIdKey, @(btnFunctionId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//增加一个 block 关联UIButton
- (void)setCustomBtnOnClick:(void (^)())customBtnOnClick {
    objc_setAssociatedObject(self, &btnCurrentActionBlockKey, customBtnOnClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())customBtnOnClick {
    return objc_getAssociatedObject(self, &btnCurrentActionBlockKey);
}

@end
