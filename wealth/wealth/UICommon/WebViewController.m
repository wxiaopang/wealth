//
//  WebViewController.m
//  wealth
//
//  Created by wangyingjie on 16/4/11.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) UIButton *closeBtn;    /**<关闭窗口按钮*/

@property (nonatomic, copy) NSString *shareIconUrl;     /**<*/
@property (nonatomic, strong) UIImage *shareImage;     /**<*/
@property (nonatomic, copy) NSString *webTitle; /**<*/
@property (nonatomic, copy) NSString *webUrl; /**<*/
@property (nonatomic, copy) NSString *webHtml; /**<*/
@property (nonatomic, assign) BOOL isShare;     /**<*/
@property (nonatomic, assign) WebViewLoadingType webLoadingType; /**<*/

@property (nonatomic, assign) BOOL isDisplayActionSheet;     /**<*/
@property (nonatomic, assign) BOOL isGetToken;     /**<*/
@property (nonatomic, assign) BOOL isFrist;     /**<*/
@property (nonatomic, strong) NSDictionary *content;  /**<链接活动的分享*/
@property (nonatomic, copy) NSString *referrerUrl;    /**<判断是否需要跳转*/


@property (nonatomic, strong) UIView *loadingBGView;     /**<*/
@property (nonatomic, strong) UIImageView *loadingView;     /**<*/
@property (nonatomic, strong) NSTimer *loadingTimer;     /**<*/

@end

@implementation WebViewController

#pragma mark- UIViewControllerLifeCycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isFrist = YES;
        self.isNeedChangeUserAgent = YES; //会调取点语法
        
        [self setUpViews];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButtomItemWithNormalName:@"back_white" highName:@"back_white" selector:@selector(back) target:self];
//    self.closeBtn = [self leftCloseBarButtomItemWithNormalName:@"title_icon_close" highName:@"title_icon_close" selector:@selector(close) target:self];
    _closeBtn.hidden = YES;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isGetToken = YES;
    _webMainWebView.delegate = self;
    
    
    
    [self startTheTimer];
    
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self clearAllTheBlock];
    _webMainWebView.delegate = nil;
    [self stopTheLoadView];
    self.isGetToken = NO;
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark- InitSubViews
- (void)setUpViews {
    self.loadingBGView = [[UIView alloc] initViewWithFrame:CGRectMake(0, kNavigationBarHeight-3.0f, ScreenWidth, 3.0f) backgroundColor:[UIColor get_6_Color]];
    [self.view addSubview:_loadingBGView];
    //    _loadingBGView.hidden = YES;
    
    self.webMainWebView = [[UIWebView alloc] initViewWithFrame:CGRectMake(0.0f, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavigationBarHeight) backgroundColor:[UIColor whiteColor]];
    _webMainWebView.delegate = self;
    _webMainWebView.dataDetectorTypes = UIDataDetectorTypeNone;//不响应界面的电话和链接
//    _webMainWebView.scalesPageToFit = YES;
    _webMainWebView.opaque = NO;
    [self.view addSubview:_webMainWebView];
    
}

#pragma mark- NetWorking
- (void)netGetData {
    
}

- (void)showNoNetWorkViewAndStopTimer{
    [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-kNavigationBarHeight)];
    [self stopTheLoadView];
}

- (void)reloadButtonClick{
    self.nonetWorkView.hidden = YES;
    _loadingView.frame = CGRectMake(-50.0f, _loadingView.top, 30.0f, _loadingView.height);
    _loadingView.alpha = 1.0f;
    [self startTheTimer];
    self.webMessageModel = _webMessageModel;
}

- (void)clearAllTheBlock{

    
}

#pragma mark 过滤判断是否是需要过滤的url
- (BOOL)isBadUrlWithUrl:(NSString *)url {
    __block BOOL isBadBool = YES;
    NSArray *goodUrlArray = @[@".iqianjin.com",@"hm.baidu.com",@"cpro.baidu.com",@"www.google-analytics.com​",@"qiao.baidu.com",@"172.16.3.",@"172.16",@"youku"];
    NSMutableString *mUrl = [NSMutableString stringWithString:url];
    //截取域名
    if ([mUrl rangeOfString:@"?"].location != NSNotFound) {
        [mUrl deleteCharactersInRange:NSMakeRange([mUrl rangeOfString:@"?"].location, mUrl.length - [mUrl rangeOfString:@"?"].location)];
    }
    [goodUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *aGoodUrl = (NSString *)obj;
        if ([mUrl rangeOfString:aGoodUrl].location != NSNotFound) {
            isBadBool = NO;
        }
    }];
    return isBadBool;
}

#pragma mark- PublibMethod


#pragma mark- PrivateMethod
-(void)refresh {
    
}


- (void)back {
    if ([_webMainWebView canGoBack]) {
        if (_webMainWebView.loading) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [_webMainWebView goBack];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getTitleForPushActivity {
    if (_webTitle && _webTitle.length > 0) {
        return [self getFormatWithTitle:_webTitle];
    }
    NSString *titleText = [_webMainWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (titleText && titleText.length > 0) {
        titleText = [self getFormatWithTitle:titleText];
    }
    else if (_webTitle && _webTitle.length > 0) {
        titleText = [self getFormatWithTitle:_webTitle];
    }
    else {
        titleText = @"活动";
    }
    return titleText;
}

//title过长则截取9位
- (NSString *)getFormatWithTitle:(NSString *)title {
    if (title && title.length > 9) {
        NSString *formatTitle = [title substringToIndex:9];
        title = [NSString stringWithFormat:@"%@...",formatTitle];
    }
    return title;
}


- (void)goToControllerWithUrl:(NSURL *)url {
    NSString *decodedUrl = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)url.absoluteString, CFSTR(""), kCFStringEncodingUTF8);
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    NSArray *queryArray = [url.query componentsSeparatedByString:@"?"];
    if (queryArray && queryArray.count > 0) {
        for (NSString *subString in queryArray) {
            NSArray *subArray = [subString componentsSeparatedByString:@"="];
            if (subArray && subArray.count > 1) {
                [queryDic setObject:subArray[1] forKey:subArray[0]];
            }
        }
    }
    self.referrerUrl = queryDic[@"referrer"];
    if (![NSString isAvailableString:self.referrerUrl]) {
        self.referrerUrl = [self getOriginalReferrerUrl];
    }
    
    [self gotoControllerWithIdentifier:decodedUrl];
}

- (void)stopTheTimer{
    if (_loadingTimer != nil) {
        [_loadingTimer invalidate];
        _loadingTimer = nil;
    }
}

- (void)startTheTimer{
    [self stopTheTimer];
    [self refreshTheLoadView];
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTheLoadView) userInfo:nil repeats:YES];
}

- (void)refreshTheLoadView{
    _loadingBGView.hidden = NO;
    if (!_loadingView) {
        self.loadingView = [[UIImageView alloc] initImageViewWithFrame:CGRectMake(-50.0f, kNavigationBarHeight-3.0f, 50.0f, 3.0f) image:[UIImage imageNamed:@""] backgroundColor:[UIColor get_9_Color]];
        _loadingView.layer.masksToBounds = YES;
        _loadingView.layer.cornerRadius = 1.5f;
        [self.view addSubview:_loadingView];
    }
    [UIView animateWithDuration:1 animations:^{
        
        if (_loadingView.width > ScreenWidth-10.0f) {
            _loadingView.frame = CGRectMake(0.0f, kNavigationBarHeight-3.0f, _loadingView.width += 0.1f, 3.0f);
        }else if (_loadingView.width > (ScreenWidth*9.0f)/10.0f) {
            _loadingView.frame = CGRectMake(0.0f, kNavigationBarHeight-3.0f, _loadingView.width += 1.0f, 3.0f);
        }else if (_loadingView.width > (ScreenWidth*3.0f)/4.0f){
            _loadingView.frame = CGRectMake(0.0f, kNavigationBarHeight-3.0f, _loadingView.width += 5.0f, 3.0f);
        }else{
            _loadingView.frame = CGRectMake(0.0f, kNavigationBarHeight-3.0f, _loadingView.width += 50.0f, 3.0f);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopTheLoadView{
    [self stopTheTimer];
    [UIView animateWithDuration:0.3 animations:^{
        _loadingView.frame = CGRectMake(-5.0f, kNavigationBarHeight-3.0f, ScreenWidth+10.0f, 3.0f);
    } completion:^(BOOL finished) {
        _loadingBGView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _loadingView.frame = CGRectMake(ScreenWidth+5.0f, kNavigationBarHeight-3.0f, ScreenWidth+10.0f, 3.0f);
            _loadingView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}


#pragma mark- setMethod

- (void)setWebMessageModel:(WebMsgModel *)webMessageModel{
    if (_webMessageModel != webMessageModel) {
        _webMessageModel = webMessageModel;
    }
    if (_webMessageModel) {
        if (_webMessageModel.webTitle && _webMessageModel.webTitle.length > 0) {
            self.webTitle = _webMessageModel.webTitle;
        }
        self.webLoadingType = _webMessageModel.webLoadingType;
        if (_webMessageModel.shareIconUrl && _webMessageModel.shareIconUrl.length > 0) {
            self.shareIconUrl = _webMessageModel.shareIconUrl;
        }
        if (_webMessageModel.isShare) {
            self.isShare = _webMessageModel.isShare;
        }
    }
}

- (void)setWebTitle:(NSString *)webTitle{
    if (_webTitle != webTitle) {
        _webTitle = [webTitle copy];
    }
    if (_webTitle && _webTitle.length > 0) {
        self.navigationBarView.title = [self getFormatWithTitle:_webTitle];
    }
}

- (void)setWebUrl:(NSString *)webUrl{
    NSLog(@"*********^^^^^^^::::   %@",webUrl);
    if (_webUrl != webUrl) {
        _webUrl = [webUrl copy];
    }
    if (_webUrl && _webUrl.length > 0) {
        NSURL *appCenterURL = [NSURL URLWithString:[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:appCenterURL];
        [_webMainWebView loadRequest:requestObj];
    }
}

- (void)setWebHtml:(NSString *)webHtml{
    if (_webHtml != webHtml) {
        _webHtml = [webHtml copy];
    }
    if (_webHtml && _webHtml.length > 0) {
        [_webMainWebView loadHTMLString:_webHtml baseURL:nil];
    }
}

- (void)setWebLoadingType:(WebViewLoadingType)webLoadingType{
    if (_webLoadingType != webLoadingType) {
        _webLoadingType = webLoadingType;
    }
    if (_webLoadingType != WebViewType_Url_Token ) {
        [self deleteCookies];
    }
    if (_webLoadingType != WebViewType_Url_Token_tab ) {
        [self deleteCookies];
    }
    switch (_webLoadingType) {
        case WebViewType_Url_Treaty:{

        }break;
        case WebViewType_Url_Problem:{

        }break;
        case WebViewType_Url_Token_tab:
        case WebViewType_Url_Token:{

        }break;
        case WebViewType_Url_AITreaty:{

        }break;
        case WebViewType_Html:
        case WebViewType_Html_Several:{
            self.webHtml = _webMessageModel.webHtml;
        }break;
        case WebViewType_Html_CTAgreement:{

        }break;
        case WebViewType_Html_TCAgreement:{

        }break;
        case WebViewType_Html_SCAgreement:{

        }break;
        case WebViewType_Html_DPAgreement:{

        }break;
        case WebViewType_Html_ATAgreement:{

        }break;
        case WebViewType_Url_Baidu:{

        }break;
        case WebViewType_Html_NoTitle:{
            [self getMessageDetail];
        }break;
        case WebViewType_Url:
        case WebViewType_Url_Several:
        default:{
            self.webUrl = _webMessageModel.webUrl;
        }break;
    }
}

- (void)setIsShare:(BOOL)isShare{
    _isShare = isShare;
    if (_isShare) {
//        [self rightBarButtomItemWithNormalName:@"title_icon_share" highName:@"title_icon_share" selector:@selector(shareClick) target:self];
    }
}

- (void)getMessageDetail{
    @weakify(self);
    [GET_CLIENT_MANAGER.messageManager getMessageDetailWithMessageId:self.webMessageModel.messageId Complete:^(NSString *errMsg) {
        @strongify(self);
        [self.navigationBarView.activityIndicatorView stopAnimating];
        [self hideBlankView];
        [self hideNoNetWorkView];
        if (errMsg) {
            [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
            [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-(kNavigationBarHeight))];
            _webMainWebView.hidden = YES;
        }
        else {
            if (GET_CLIENT_MANAGER.messageManager.code == ResponseErrorCode_OK) {
                _webMainWebView.hidden = NO;
                if (GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgType == 2) {
                    self.webUrl = GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgDetail;
                }else{
                    self.webHtml = [self addHeaderWithHtml];
                }
            }
            else if (1){
                [ROOT_NAVIGATECONTROLLER showLoadView:UILoadFail message:errMsg complete:^{ }];
                [self showNoNetWorkView:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight-(kNavigationBarHeight))];
                _webMainWebView.hidden = YES;
            }
        }
    }];
}



#pragma mark- 修改UserAgent H5需要判断版本
- (void)setIsNeedChangeUserAgent:(BOOL)isNeedChangeUserAgent {
    _isNeedChangeUserAgent = isNeedChangeUserAgent;
    if (_isNeedChangeUserAgent) {//需要修改
        [[ClientManager sharedClientManager] setIQianJinUserAgent];
    }
    else {//不需要修改
        [[ClientManager sharedClientManager] setOriginalUserAgent];
    }
}

#pragma mark- 每次进来先清空cookies否则会影响登录/未登录状态
- (void)deleteCookies {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

//#pragma mark- 分享
//#pragma mark ShareAction
//- (void)shareClick {
//    if (!self.isDisplayActionSheet) {
//        self.isDisplayActionSheet = YES;
//        self.shareActionSheet = [[UIFlatActionSheet alloc] initWithTitle:nil delegate:self flatActionSheetStyle:UIFlatActionSheetStyleCustom displayStyle:UIFlatActionSheetDisplayFromButtomStyle cancelButtonTitle:nil otherButtonTitles:@"", nil];
//        [_shareActionSheet showInView:self.view withComplete:^(BOOL finished) {
//        }];
//    } else {
//        if (_shareActionSheet) {
//            [_shareActionSheet dismiss];
//        }
//    }
//}
//
//- (void)shareLinkClick:(NSDictionary *)content {
//    if (!self.isDisplayActionSheet) {
//        self.content = content;
//        self.isDisplayActionSheet = YES;
//        self.shareActionSheet = [[UIFlatActionSheet alloc] initWithTitle:nil delegate:self flatActionSheetStyle:UIFlatActionSheetStyleCustom displayStyle:UIFlatActionSheetDisplayFromButtomStyle cancelButtonTitle:nil otherButtonTitles:@"", nil];
//        [_shareActionSheet showInView:self.view withComplete:^(BOOL finished) {
//        }];
//    } else {
//        if (_shareActionSheet) {
//            [_shareActionSheet dismiss];
//        }
//    }
//}
//
//#pragma mark 微信好友分享 必须有content
//- (void)weChatBtnAction {
//    if ( self.content && [self.content isKindOfClass:[NSDictionary class]]) {
//        NSString *url = self.content[@"link"];
//        NSString *title = self.content[@"title"];
//        if (url.length > 1 || title.length > 1) {
//            _webMessageModel.shareTitle = self.content[@"title"];
//            _webMessageModel.shareContent = self.content[@"desc"];
//            _webMessageModel.shareUrl = self.content[@"link"];
//            self.shareImage = self.content[@"image"];
//        }
//    }
//    [_shareActionSheet dismiss];
//    
//    __block typeof(self) bself = self;
//    [[ShareManager sharedShareManager] sendWeChatMessageTitle:_webMessageModel.shareTitle description:_webMessageModel.shareContent WithUrl:_webMessageModel.shareUrl image:_shareImage WithScene:WXSceneSession withCompletion:^(BOOL result, NSString *msg) {
//        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//            if (!result) {
//                [bself showTextToastWithTitle:msg];
//            }
//        }];
//    }];
//}
//#pragma mark 微信朋友圈要求有必须有title
//- (void)timeLineBtnAction {
//    if ( self.content && [self.content isKindOfClass:[NSDictionary class]]) {
//        NSString *url = self.content[@"link"];
//        NSString *title = self.content[@"title"];
//        if (url.length > 1 || title.length > 1) {
//            _webMessageModel.shareTitle = self.content[@"title"];
//            _webMessageModel.shareContent = self.content[@"desc"];
//            _webMessageModel.shareUrl = self.content[@"link"];
//            self.shareImage = self.content[@"image"];
//        }
//    }
//    [_shareActionSheet dismiss];
//    
//    __block typeof(self) bself = self;
//    [[ShareManager sharedShareManager] sendWeChatMessageTitle:_webMessageModel.shareTitle description:_webMessageModel.shareContent WithUrl:_webMessageModel.shareUrl image:_shareImage WithScene:WXSceneTimeline withCompletion:^(BOOL result, NSString *msg) {
//        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//            if (!result) {
//                [bself showTextToastWithTitle:msg];
//            }
//        }];
//    }];
//}
//
//#pragma mark QQ
//- (void)qqBtnAction {
//    if ( self.content && [self.content isKindOfClass:[NSDictionary class]]) {
//        NSString *url = self.content[@"link"];
//        NSString *title = self.content[@"title"];
//        if (url.length > 1 || title.length > 1) {
//            _webMessageModel.shareTitle = self.content[@"title"];
//            _webMessageModel.shareContent = self.content[@"desc"];
//            _webMessageModel.shareUrl = self.content[@"link"];
//            self.shareImage = self.content[@"image"];
//        }
//    }
//    NSString *theShareTitle =_webMessageModel.shareTitle.length < 1 ? @"我在用爱钱进提供的高收益理财产品，推荐给你试一试" : _webMessageModel.shareTitle;
//    NSString *theShareContent =_webMessageModel.shareContent.length < 1 ?  @"现在注册可享受50元新手奖励！还可享受年化收益率12%-14%的高收益理财产品。" : _webMessageModel.shareContent;
//    NSString *theShareUrl = _webMessageModel.shareUrl;
//    UIImage *theShareImage = _shareImage;
//    [_shareActionSheet dismiss];
//    __block typeof(self) bself = self;
//    [[ShareManager sharedShareManager] sendQQMessageTitle:theShareTitle description:theShareContent WithUrl:theShareUrl image:theShareImage withCompletion:^(BOOL result, NSString *msg) {
//        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//            if (!result) {
//                [bself showTextToastWithTitle:msg];
//            }
//        }];
//    }];
//}
//
//#pragma mark QQ空间
//- (void)qZoneBtnAction {
//    if ( self.content && [self.content isKindOfClass:[NSDictionary class]]) {
//        NSString *url = self.content[@"link"];
//        NSString *title = self.content[@"title"];
//        if (url.length > 1 || title.length > 1) {
//            _webMessageModel.shareTitle = self.content[@"title"];
//            _webMessageModel.shareContent = self.content[@"desc"];
//            _webMessageModel.shareUrl = self.content[@"link"];
//            self.shareImage = self.content[@"image"];
//        }
//    }
//    NSString *theShareTitle =_webMessageModel.shareTitle.length < 1 ? @"我在用爱钱进提供的高收益理财产品，推荐给你试一试" : _webMessageModel.shareTitle;
//    NSString *theShareContent =_webMessageModel.shareContent.length < 1 ?  @"现在注册可享受50元新手奖励！还可享受年化收益率12%-14%的高收益理财产品。" : _webMessageModel.shareContent;
//    NSString *theShareUrl = _webMessageModel.shareUrl;
//    UIImage *theShareImage = _shareImage;
//    [_shareActionSheet dismiss];
//    __block typeof(self) bself = self;
//    [[ShareManager sharedShareManager] sendQZoneMessageTitle:theShareTitle description:theShareContent WithUrl:theShareUrl image:theShareImage withCompletion:^(BOOL result, NSString *msg) {
//        [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//            if (!result) {
//                [bself showTextToastWithTitle:msg];
//            }
//        }];
//    }];
//}
//
//- (void)cancelBtnAction {
//    [_shareActionSheet dismiss];
//}
//
//- (void)flatActionSheetDidDismiss:(UIFlatActionSheet *)flatActionSheet {
//    self.content = nil;
//    self.isDisplayActionSheet = NO;
//}
//
//#pragma mark- ShareManagerDelegate
//- (void)sendStatusWithMessage:(NSString *)message {
//    __block typeof(self) bself = self;
//    [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//        [bself showTextToastWithTitle:message];
//    }];
//}
//
//#pragma mark- UIFlatActionSheetDelegate
//- (UIView *)buttonViewForflatActionSheet:(UIFlatActionSheet *)flatActionSheet atButtonIndex:(NSInteger)buttonIndex {
//    ShareSheetView *shareSheetView = [[ShareSheetView alloc] initWithFrame:CGRectMake(0, 0, _webMainWebView.frame.size.width, 207) isHaveQQ:YES];
//    [shareSheetView.weChatBtn addTarget:self action:@selector(weChatBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [shareSheetView.timeLineBtn addTarget:self action:@selector(timeLineBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [shareSheetView.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    //    if (_isShare) {
//    //        return [shareSheetView autorelease];
//    //    }
//    [shareSheetView.qqBtn addTarget:self action:@selector(qqBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [shareSheetView.qZoneBtn addTarget:self action:@selector(qZoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    return shareSheetView;
//}

#pragma mark 如果H5没有返回referrerUrl就自己截取
- (NSString *)getOriginalReferrerUrl {
    NSMutableString *oUrl = [NSMutableString stringWithString:_webUrl];
    NSRange rang = NSMakeRange(oUrl.length, 0);
    if ([oUrl rangeOfString:@"?token"].location != NSNotFound) {
        rang = NSMakeRange([oUrl rangeOfString:@"?token"].location, oUrl.length - [oUrl rangeOfString:@"?token"].location);
    } else if ([oUrl rangeOfString:@"&token"].location != NSNotFound) {
        rang = NSMakeRange([oUrl rangeOfString:@"&token"].location, oUrl.length - [oUrl rangeOfString:@"&token"].location);
    } else if ([oUrl rangeOfString:@"?from=app"].location != NSNotFound) {
        rang = NSMakeRange([oUrl rangeOfString:@"?from=app"].location, oUrl.length - [oUrl rangeOfString:@"?from=app"].location);
    } else if ([oUrl rangeOfString:@"&from=app"].location != NSNotFound) {
        rang = NSMakeRange([oUrl rangeOfString:@"&from=app"].location, oUrl.length - [oUrl rangeOfString:@"&from=app"].location);
    }
    [oUrl deleteCharactersInRange:rang];
    return oUrl;
}

#pragma mark- WebViewDelegate
#pragma mark- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^shouldStartLoadWithRequest:%@",webView.request.URL);
    self.isFrist = NO;
    self.nonetWorkView.hidden = YES;
    if (_loadingView.width > ScreenWidth  && !_isFromPopWeb) {
        _loadingView.frame = CGRectMake(-50.0f, _loadingView.top, 30.0f, _loadingView.height);
        _loadingView.alpha = 1.0f;
        [self performSelector:@selector(startTheTimer) withObject:self afterDelay:0.2];
    }
    
//    if ( [request.URL.scheme isEqualToString:@"iqianjin"] ) {
//        NSString *encoded = [NSString stringWithFormat:@"%@", request.URL];
//        NSString *decoded = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)encoded, CFSTR(""), kCFStringEncodingUTF8);
//        NSDictionary *dic = [IQianJinCommonManager toArrayOrNSDictionary:[[decoded substringFromIndex:[@"iqianjin://" length]] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        if ( dic ) {
//            __block typeof(self) bself = self;
//            if ( dic[@"imgUrl"] ) {
//                [FileDownLoadManager fileDownLoadWithURl:dic[@"imgUrl"] completion:^(NSString *filePath, BOOL islocal, int code) {
//                    UIImage *image = [UIImage imageWithContentsOfFile:filePath]
//                    ? [UIImage imageWithContentsOfFile:filePath]
//                    : [UIImage imageNamed:@"share_act.png"];
//                    [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//                        [bself shareLinkClick:@{ @"title":(dic[@"title"]?dic[@"title"]:@""),
//                                                 @"desc":(dic[@"desc"]?dic[@"desc"]:@""),
//                                                 @"link":(dic[@"link"]?dic[@"link"]:@""),
//                                                 @"image":image }];
//                    }];
//                }];
//            } else {
//                [[GCDManager sharedGCDManager] doWorkInMainQueue:^{
//                    [bself shareLinkClick:@{ @"title":(dic[@"title"]?dic[@"title"]:@""),
//                                             @"desc":(dic[@"desc"]?dic[@"desc"]:@""),
//                                             @"link":(dic[@"link"]?dic[@"link"]:@""),
//                                             @"image":[UIImage imageNamed:@"share_act.png"] }];
//                }];
//            }
//        }
//        [self stopTheLoadView];
//        return NO;
//    }
//    else if ( [request.URL.scheme isEqualToString:@"iqianjindrc"] ) {
//        [self goToControllerWithUrl:request.URL];
//        [self stopTheLoadView];
//        return NO;
//    }
//    else if ([request.URL.scheme rangeOfString:@"http"].location != NSNotFound) {
//        self.webMessageModel.webUrl =  request.URL.absoluteString;
//        if ([self isBadUrlWithUrl:request.URL.absoluteString]) {
//            [self stopTheLoadView];
//            return NO;
//        }
//    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^DidStartLoad:%@",webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^DidFinishLoad:%@",webView.request.URL);
    _webMessageModel.webUrl = [NSString stringWithFormat:@"%@",webView.request.URL];
    
    self.nonetWorkView.hidden = YES;
    [self stopTheLoadView];
    
    self.webTitle = [self getTitleForPushActivity];
    
    __block typeof(self) bself = self;
    [UIView animateWithDuration:0.25 animations:^{
        if ([_webMainWebView canGoBack]) {
            bself.closeBtn.hidden = NO;
        } else {
            bself.closeBtn.hidden = YES;
        }
    }];
    
    //自适应宽度（但是要注意高度）
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    [self modifyImageToFitScreen:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^FailLoad:%@",webView.request.URL);
//    if (_webMessageModel.TreatyType == WebViewType_Url_Token_tab) {
//        [self.view removeFromSuperview];
//    }
    NSString *url = [NSString stringWithFormat:@"%@",webView.request.URL];
    if (url.length > 2) {
        self.webMessageModel.webUrl = [NSString stringWithFormat:@"%@",webView.request.URL];
    }
    //    [self showNoNetWorkViewAndStopTimer];
    [self stopTheLoadView];
    
    //如果本页加载的是弹出的半透明蒙层,则蒙层加载失败直接关闭页面
    if (self.isModalViewController) {
        [self stopTheLoadView];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }else{
        [self showNoNetWorkViewAndStopTimer];
    }
}

#pragma mark 拦截并修改图片大小
- (void)modifyImageToFitScreen:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth= document.body.offsetWidth;"
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}

- (NSString *)addHeaderWithHtml{
    NSString *header = [NSString stringWithFormat:
                        @"<style type=\"text/css\">\
                        p.text1 { margin-top:12px; margin-left:4px; color:#192E54;}\
                        p.text2 { margin-top:-15px; margin-left:4px; color:#717FA5;}\
                        p.text3 { margin-top:-10px; margin-left:4px; margin-bottom:-5px; color:#717FA5;}\
                        </style>\
                        <p class=\"text1\" style=font-size:21px>%@</p>\
                        <p class=\"text2\" style=font-size:18px>%@</p>\
                        <p class=\"text3\" style=font-size:14px>%@</p>\
                        <hr noshade size=0.5px color=#717FA5 >",GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgTitle,GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgPaper,GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgTime];
    return [NSString stringWithFormat:@"%@%@",header,GET_CLIENT_MANAGER.messageManager.msgDetailModel.msgDetail];
}



#pragma mark- H5跳转APP指定页面规则
- (void)gotoControllerWithIdentifier:(NSString *)identifier {
//    if ([identifier rangeOfString:kH5GotoLogin].location != NSNotFound) {//需要跳登录
//        if ([[ClientManager sharedClientManager] getUserId] > 0) {
//            self.webMessageModel = _webMessageModel;
//        }
//        else {
//            [self jemptoLoginViewWithIsFromH5:YES isFromAssets:NO isFromLoginConflict:NO];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoRegister].location != NSNotFound) {//需要跳注册
//        if ([[ClientManager sharedClientManager] getUserId] > 0) {
//            self.webMessageModel = _webMessageModel;
//        }
//        else {
//            [self jemptoRegisterViewFromH5];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoProductionDP].location != NSNotFound) {//需要跳理财产品-整存宝
//        UIViewController *rootViewController=(UIViewController *)[((UINavigationController *)ROOT_NAVIGATECONTROLLER).viewControllers objectAtIndex:0];
//        if ([rootViewController isKindOfClass:[RootViewController class]]) {
//            RootViewController *rootVC = (RootViewController *)rootViewController;
//            rootVC.productionViewController.productionTab = ProductionTab_DP;
//            [rootVC selectTabWithIndex:1];//选择tab1
//            if (self.isFromPopWeb) {//如果来自弹出蒙层,则需要将蒙层消失
//                if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                    [self.view removeFromSuperview];
//                }else{
//                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                        
//                    }];
//                }
//            }
//            [self popToRootViewController];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoProductionAT].location != NSNotFound) {//需要跳理财产品-爱月投
//        UIViewController *rootViewController=(UIViewController *)[((UINavigationController *)ROOT_NAVIGATECONTROLLER).viewControllers objectAtIndex:0];
//        if ([rootViewController isKindOfClass:[RootViewController class]]) {
//            RootViewController *rootVC = (RootViewController *)rootViewController;
//            rootVC.productionViewController.productionTab = ProductionTab_AT;
//            [rootVC selectTabWithIndex:1];//选择tab1
//            if (self.isFromPopWeb) {//如果来自弹出蒙层,则需要将蒙层消失
//                if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                    [self.view removeFromSuperview];
//                }else{
//                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                        
//                    }];
//                }
//            }
//            [self popToRootViewController];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoProductionCR].location != NSNotFound) {//需要跳理财产品-爱活宝
//        UIViewController *rootViewController=(UIViewController *)[((UINavigationController *)ROOT_NAVIGATECONTROLLER).viewControllers objectAtIndex:0];
//        if ([rootViewController isKindOfClass:[RootViewController class]]) {
//            RootViewController *rootVC = (RootViewController *)rootViewController;
//            rootVC.productionViewController.productionTab = ProductionTab_CT;
//            [rootVC selectTabWithIndex:1];//选择tab1
//            if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                [self.view removeFromSuperview];
//            }else{
//                [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                    
//                }];
//            }
//            [self popToRootViewController];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoMoreMain].location != NSNotFound) {//需要跳互动页
//        UIViewController *rootViewController=(UIViewController *)[((UINavigationController *)ROOT_NAVIGATECONTROLLER).viewControllers objectAtIndex:0];
//        if ([rootViewController isKindOfClass:[RootViewController class]]) {
//            RootViewController *rootVC = (RootViewController *)rootViewController;
//            [rootVC selectTabWithIndex:3];//选择tab3
//            if (self.isFromPopWeb) {//如果来自弹出蒙层,则需要将蒙层消失
//                if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                    [self.view removeFromSuperview];
//                }else{
//                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                        
//                    }];
//                }
//            }
//            [self popToRootViewController];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoAssets].location != NSNotFound) {//需要跳资产页
//        if ([[ClientManager sharedClientManager] getUserId] > 0) {
//            UIViewController *rootViewController=(UIViewController *)[((UINavigationController *)ROOT_NAVIGATECONTROLLER).viewControllers objectAtIndex:0];
//            if ([rootViewController isKindOfClass:[RootViewController class]]) {
//                RootViewController *rootVC = (RootViewController *)rootViewController;
//                [rootVC selectTabWithIndex:2];
//                if (self.isFromPopWeb) {//如果来自弹出蒙层,则需要将蒙层消失
//                    if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                        [self.view removeFromSuperview];
//                    }else{
//                        [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                            
//                        }];
//                    }
//                }
//                [self popToRootViewController];
//            }
//        } else {
//            [self jemptoLoginViewWithIsFromH5:YES isFromAssets:NO isFromLoginConflict:NO];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoCertificate].location != NSNotFound) {//需要跳身份证验证页
//        if ([[ClientManager sharedClientManager] getUserId] > 0) {
//            UserModel *userModel = [[UserConfigDAO sharedUserConfigDAO] getUserModelWithUserId:[[ClientManager sharedClientManager] getUserId]];
//            if (!userModel.isIdVerified) {
//                MoreRealNameViewController *viewController = [[MoreRealNameViewController alloc] init];
//                viewController.FromType = RealNameFrom_H5;
//                CATransition *animation = [CATransition animation];
//                [animation setDuration:kPushAnimationTime];
//                [animation setType: kCATransitionMoveIn];
//                [animation setSubtype: kCATransitionFromTop];
//                viewController.isPushFromBottom = YES;
//                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//                if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//                    UINavigationController *navigationController = (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
//                    [navigationController pushViewController:viewController animated:NO];
//                    [navigationController.view.layer addAnimation:animation forKey:nil];
//                }else{
//                    [self.navigationController pushViewController:viewController animated:NO];
//                    [self.navigationController.view.layer addAnimation:animation forKey:nil];
//                }
//            } else {
//                if (!_webMainWebView.loading) {
//                    [_webMainWebView reload];
//                }
//            }
//        } else {
//            [self jemptoLoginViewWithIsFromH5:YES isFromAssets:NO isFromLoginConflict:NO];
//        }
//    }
//    else if ([identifier rangeOfString:kH5GotoNewWeb].location != NSNotFound) {
//        WebMsgModel *webModel = [[WebMsgModel alloc] init];
//        webModel.webUrl = _referrerUrl;
//        webModel.webLoadingType = WebViewType_Url_Token;
//        WebViewController *webVC = [[WebViewController alloc] init];
//        webVC.isFromPopWeb = _isFromPopWeb;
//        if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//            UINavigationController *navigationController = (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
//            [navigationController pushViewController:webVC animated:YES];
//        }else{
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//        webVC.webMessageModel = webModel;
//    }
//    else if ([identifier rangeOfString:kH5CloseWeb].location != NSNotFound) {
//        if (_webMessageModel.webLoadingType == WebViewType_Url_Token_tab) {
//            [self.view removeFromSuperview];
//        }
//        [super back];
//    }
}

@end
