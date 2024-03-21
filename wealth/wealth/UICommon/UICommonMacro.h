//
//  UICommonMacro.h
//  wealth
//
//  Created by wangyingjie on 15/7/30.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//



#pragma once

/**
 *    替换主Windows的rootViewController
 *
 *    @param x 首页
 *
 *    @return 无
 */
#define kTrurnToRootViewController(x) do { \
    CustomNavigationViewController *navigateController = [[CustomNavigationViewController alloc] initWithRootViewController:[[(x) alloc] init]]; \
    CATransition *animation = [CATransition animation]; \
    [animation setDuration:0.2]; \
    [animation setType:kCATransitionMoveIn]; \
    [animation setSubtype:kCATransitionFromTop]; \
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]]; \
    [navigateController.view.layer addAnimation:animation forKey:nil]; \
    ROOT_NAVIGATECONTROLLER = navigateController; \
} while(0)

/**
 *    手动重登录
 *
 *    @return 无
 */
#define kManualRelogon   do { \
                            [GET_CLIENT_MANAGER manualRelogon:^{ \
                                CustomNavigationViewController *navigateController = [[CustomNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]]; \
                                CATransition *animation = [CATransition animation]; \
                                [animation setDuration:0.2]; \
                                [animation setType:kCATransitionMoveIn]; \
                                [animation setSubtype:kCATransitionFromTop]; \
                                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]]; \
                                [navigateController.view.layer addAnimation:animation forKey:nil]; \
                                ROOT_NAVIGATECONTROLLER = navigateController; \
                            }]; \
                        } while(0)


#define kManualRelogonWith(type)   do { \
    [GET_CLIENT_MANAGER manualRelogon:^{ \
        LoginViewController *loginRootVC = [[LoginViewController alloc] init];\
        loginRootVC.fromType = type;\
        CustomNavigationViewController *navigateController = [[CustomNavigationViewController alloc] initWithRootViewController:loginRootVC]; \
        CATransition *animation = [CATransition animation]; \
        [animation setDuration:0.2]; \
        [animation setType:kCATransitionMoveIn]; \
        [animation setSubtype:kCATransitionFromTop]; \
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]]; \
        [navigateController.view.layer addAnimation:animation forKey:nil]; \
        ROOT_NAVIGATECONTROLLER = navigateController; \
    }]; \
} while(0);

//根据参数创建label
//#define GreateLabel(obj, textcolor, fontSize, alignment, superView) \
//do{\
//    if (obj == nil){\
//        obj = [[UILabel alloc] init];\
//    }\
//    obj.userInteractionEnabled = YES;\
//    obj.backgroundColor = [UIColor clearColor];\
//    obj.textColor = textcolor;\
//    obj.numberOfLines = 0;\
//    if (fontSize > 0) {\
//        obj.font = [UIFont systemFontOfSize:fontSize];\
//    }\
//    obj.textAlignment = alignment;\
//    [superView addSubview:obj];\
//} while (0)
//
////仅初始化label
//#define GreateEmptyLabel(obj, bgColor, superView) \
//do{\
//    if (obj == nil){\
//        obj = [[UILabel alloc] init];\
//    }\
//    obj.backgroundColor = bgColor;\
//    [superView addSubview:obj];\
//} while (0)
//
////仅初始化UIView
//#define GreateUIView(obj, bgColor, superView) \
//do{\
//    if (obj == nil){\
//        obj = [[UIView alloc] init];\
//    }\
//    obj.backgroundColor = bgColor;\
//    [superView addSubview:obj];\
//} while (0)
//
////根据参数创建UIImaneView
//#define GreateImageView(obj, imageName, highlightedImageName, superView) \
//do {\
//    if (obj == nil){\
//        obj = [[UIImageView alloc] init];\
//    }\
//    obj.userInteractionEnabled = YES;\
//    obj.backgroundColor = [UIColor clearColor];\
//    obj.image = [UIImage imageNamed:imageName];\
//    obj.contentMode = UIViewContentModeCenter;\
//    if (highlightedImageName.length > 0) {\
//        obj.highlightedImage = [UIImage imageNamed:highlightedImageName];\
//    }\
//    [superView addSubview:obj];\
//} while (0)
//
//
////获取图片
//#define GetImage(imageName) [UIImage imageNamed:(imageName)]

#pragma mark - 拉伸图片
#define GetImageStretchable(imageName,x,y) [GetImage(imageName) stretchableImageWithLeftCapWidth:x topCapHeight:y]



