//
//  WebViewController.h
//  wealth
//
//  Created by wangyingjie on 16/4/11.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "UIBaseViewController.h"

@interface WebViewController : UIBaseViewController

@property (nonatomic, strong) WebMsgModel *webMessageModel; /**<*/

@property (nonatomic, strong) UIWebView *webMainWebView; /**<*/

@property (nonatomic, assign) BOOL gotoAppCancel;   /**<进入app后点击取消（如登录页）*/
@property (nonatomic, assign) BOOL isFromPopWeb;    /**<是否是来自所弹的蒙层*/

@property (nonatomic, assign) BOOL isNeedChangeUserAgent; /**<*/


@end
