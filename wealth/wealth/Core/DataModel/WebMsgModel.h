//
//  WebMsgModel.h
//  wealth
//
//  Created by wangyingjie on 16/4/11.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "BaseModel.h"

@interface WebMsgModel : BaseModel

@property (nonatomic, copy) NSString *webTitle;         /**<web标题*/
@property (nonatomic, copy) NSString *webUrl;         /**<加载的url*/
@property (nonatomic, copy) NSString *webHtml;         /**<加载的html*/

@property (nonatomic, assign) WebViewLoadingType webLoadingType;         /**<web加载类型*/

@property (nonatomic, copy) NSString *shareUrl;         /**<分享链接*/
@property (nonatomic, copy) NSString *shareIconUrl;         /**<分享图标*/
@property (nonatomic, copy) NSString *shareContent;         /**<分享内容*/
@property (nonatomic, copy) NSString *shareTitle;         /**<分享标题*/


@property (nonatomic, assign) NSUInteger messageId;


@property (nonatomic, assign) BOOL isShare;         /**<*/

@end
