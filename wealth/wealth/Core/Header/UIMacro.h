//
//  UIMacro.h
//  wealth
//
//  Created by wangyingjie on 16/3/16.
//  Copyright © 2016年 puhui. All rights reserved.
//

#ifndef Wealth_UIMacro_h
#define Wealth_UIMacro_h

//根据参数创建label
#define GreateLabel(obj, textcolor, fontSize, alignment, superView) \
do{\
if (obj == nil){\
obj = [[UILabel alloc] init];\
}\
obj.userInteractionEnabled = YES;\
obj.backgroundColor = [UIColor clearColor];\
obj.textColor = textcolor;\
obj.numberOfLines = 0;\
if (fontSize > 0) {\
obj.font = [UIFont systemFontOfSize:fontSize];\
}\
obj.textAlignment = alignment;\
[superView addSubview:obj];\
} while (0)

//根据参数创建label
#define GreateLabelf(obj, textcolor, fonts, alignment, superView) \
do{\
if (obj == nil){\
obj = [[UILabel alloc] init];\
}\
obj.userInteractionEnabled = YES;\
obj.backgroundColor = [UIColor clearColor];\
obj.textColor = textcolor;\
obj.numberOfLines = 0;\
if (fonts) {\
obj.font = fonts;\
}\
obj.textAlignment = alignment;\
[superView addSubview:obj];\
} while (0)

//仅初始化label
#define GreateEmptyLabel(obj, bgColor, superView) \
do{\
if (obj == nil){\
obj = [[UILabel alloc] init];\
}\
obj.backgroundColor = bgColor;\
[superView addSubview:obj];\
} while (0)

//仅初始化UIView
#define GreateUIView(obj, bgColor, superView) \
do{\
if (obj == nil){\
obj = [[UIView alloc] init];\
}\
obj.backgroundColor = bgColor;\
[superView addSubview:obj];\
} while (0)

//根据参数创建UIImaneView
#define GreateImageView(obj, imageName, highlightedImageName, superView) \
do {\
if (obj == nil){\
obj = [[UIImageView alloc] init];\
}\
obj.userInteractionEnabled = YES;\
obj.backgroundColor = [UIColor clearColor];\
obj.image = [UIImage imageNamed:imageName];\
obj.contentMode = UIViewContentModeCenter;\
if (highlightedImageName.length > 0) {\
obj.highlightedImage = [UIImage imageNamed:highlightedImageName];\
}\
[superView addSubview:obj];\
} while (0)

//创建UITextField
#define GreateTextField(obj, fontSize, superView) \
do {\
if (obj == nil){\
obj = [[UITextField alloc] init];\
}\
obj.userInteractionEnabled = YES;\
obj.backgroundColor = [UIColor clearColor];\
obj.borderStyle = UITextBorderStyleNone;\
obj.clearButtonMode = UITextFieldViewModeWhileEditing;\
if (fontSize > 0) {\
obj.font = [UIFont systemFontOfSize:fontSize];\
}\
obj.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
obj.returnKeyType = UIReturnKeyDone;\
[superView addSubview:obj];\
} while (0)



#define GreateButtonWriteTitle(obj, frame, title, normal, highlight, superView)\
do{\
if (obj == nil){\
obj = [[UIButton alloc] initButtonWithFrame:frame backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor whiteColor] title:title];\
}\
UIImage *normalImage = [normal stretchableImageWithLeftCapWidth:10 topCapHeight:15];\
UIImage *highlightedImage = [highlight stretchableImageWithLeftCapWidth:10 topCapHeight:15];\
[obj setBackgroundImage:normalImage forState:UIControlStateNormal];\
[obj setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[superView addSubview:obj];\
}while (0)

#define GreateButtonType(obj, butframe, titleString, type, superView)\
do{\
if (obj == nil){\
obj = [[UIButton alloc] initButtonWithFrame:butframe backgroundColor:[UIColor clearColor] font:FONT_CN_NORMAL(34) titleColor:[UIColor whiteColor] title:titleString];\
}\
if(type){\
UIImage *normalImage = [[UIImage imageNamed:@"big_button"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];\
UIImage *highlightedImage = [[UIImage imageNamed:@"big_button_click"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];\
[obj setBackgroundImage:normalImage forState:UIControlStateNormal];\
[obj setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
}else{\
UIImage *normalImage = [[UIImage imageNamed:@"big_ghost_button"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];\
UIImage *highlightedImage = [[UIImage imageNamed:@"big_ghost_button_click"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];\
[obj setBackgroundImage:normalImage forState:UIControlStateNormal];\
[obj setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];\
[obj setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor get_9_Color] forState:UIControlStateNormal];\
}\
[superView addSubview:obj];\
}while (0)


/*
 *  创建常用类型button  type为BOOL类型 YES为使用纯色按钮图片 NO为使用线框按钮图片
 */
#define GreateButton(obj, title, type, superView) \
do {\
if (obj == nil){\
obj = [UIButton buttonWithType:UIButtonTypeCustom];\
}\
obj.backgroundColor = [UIColor clearColor];\
[obj setTitle:title forState:UIControlStateNormal];\
obj.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;\
obj.layer.allowsEdgeAntialiasing = YES;\
NSString * normal;\
NSString * highlighted;\
if (type) {\
normal = @"btn_normal_0.png";\
highlighted = @"btn_selected_0.png";\
[obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor colorWithRed:69.0/255.0 green:192.0/255.0 blue:205.0/255.0 alpha:1] forState:UIControlStateDisabled];\
[obj setBackgroundImage:[[UIImage imageNamed:@"btn_normal_0.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];\
} else {\
normal = @"btn_normal_1.png";\
highlighted = @"btn_selected_1.png";\
[obj setTitleColor:[UIColor getGreenColor] forState:UIControlStateNormal];\
}\
[obj setBackgroundImage:[[UIImage imageNamed:normal] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];\
[obj setBackgroundImage:[[UIImage imageNamed:highlighted] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];\
[superView addSubview:obj];\
} while (0)

//创建一个只显示文字标题的按钮
#define GreateButtonOnlyTitle(obj, title, fontSize, superView) \
do {\
if (obj == nil){\
obj = [UIButton buttonWithType:UIButtonTypeCustom];\
}\
obj.backgroundColor = [UIColor clearColor];\
[obj setTitle:title forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor getNavicationBarColor] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];\
[obj.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];\
[superView addSubview:obj];\
} while (0)
//[obj.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];\

//创建一个有边框且只显示文字标题的按钮
#define GreateButtonOnlyTitleWithBorder(obj, title, fontSize, superView) \
do {\
if (obj == nil){\
obj = [UIButton buttonWithType:UIButtonTypeCustom];\
}\
obj.backgroundColor = [UIColor clearColor];\
[obj setTitle:title forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor colorWithRed:150/255.0 green:160/255.0 blue:163/255.0 alpha:1.0] forState:UIControlStateNormal];\
[obj setTitleColor:[UIColor colorWithRed:33/255.0 green:163/255.0 blue:177/255.0 alpha:1.0] forState:UIControlStateHighlighted];\
[obj setTitleColor:[UIColor colorWithRed:33/255.0 green:163/255.0 blue:177/255.0 alpha:1.0] forState:UIControlStateSelected];\
obj.layer.borderWidth = 1.0;\
obj.layer.borderColor = [UIColor colorWithRed:150/255.0 green:160/255.0 blue:163/255.0 alpha:1.0].CGColor;\
btn.layer.cornerRadius = 4.0;\
[obj.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];\
[superView addSubview:obj];\
} while (0)


//获取图片
#define GetImage(imageName) [UIImage imageNamed:imageName]

#pragma mark - 拉伸图片
#define GetImageStretchable(imageName,x,y) [GetImage(imageName) stretchableImageWithLeftCapWidth:x topCapHeight:y]


#pragma mark - 重置RootViewController
#define ResetRootViewController(contrl) do {\
AppDelegate * appDelegate = GET_APP_DELEGATE;\
appDelegate.mainMenu.rootControl = [[CustomNavigationViewController alloc] initWithRootViewController:[[(contrl) alloc] init]];\
CATransition * animation = [CATransition animation];\
[animation setDuration:0.2];\
[animation setType:kCATransitionMoveIn];\
[animation setSubtype:kCATransitionFromTop];\
[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];\
[appDelegate.mainMenu.rootControl.view.layer addAnimation:animation forKey:nil];\
appDelegate.window.rootViewController = appDelegate.mainMenu;\
}while (0)

#pragma mark - 设置主架构控制器
#define SetMainViewController(contrl) do {\
AppDelegate * appDelegate = GET_APP_DELEGATE;\
appDelegate.mainMenu = [[SlideMenuViewController alloc] init];\
appDelegate.mainMenu.rootControl = [[CustomNavigationViewController alloc] initWithRootViewController:[[(contrl) alloc] init]];\
appDelegate.mainMenu.leftControl = [[SideViewController alloc] init];\
CATransition * animation = [CATransition animation];\
[animation setDuration:0.2];\
[animation setType:kCATransitionMoveIn];\
[animation setSubtype:kCATransitionFromTop];\
[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];\
[appDelegate.mainMenu.rootControl.view.layer addAnimation:animation forKey:nil];\
appDelegate.window.rootViewController = appDelegate.mainMenu;\
}while (0)

#pragma mark - 根据用户信息进入对应的首页
#define SetHomeViewTypeOfUserInfo do{\
HomeTypeManager * homeManager = [[HomeTypeManager alloc] init];\
[homeManager homeViewTpye];\
}while (0)

//#pragma mark - 设置tabBar为根控制器
//#define SetRootViewController do{\
//    AppDelegate * appDelegate = GET_APP_DELEGATE;\
//    TabBarViewController * controller = [[TabBarViewController alloc] init];\
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];\
//    appDelegate.window.rootViewController = nav;\
//}while (0)

//#pragma mark - 设置tabBar为根控制器
//#define SetRootViewController do{\
//AppDelegate * appDelegate = GET_APP_DELEGATE;\
//appDelegate.window.rootViewController = GetViewControllerWithStoryboardNameIndentifier(@"Launch", @"TabBarVC");\
//}while (0)

#pragma mark - 设置tabBar为根控制器
#define SetRootViewController do{\
AppDelegate * appDelegate = GET_APP_DELEGATE;\
UINavigationController * nav= GetViewControllerWithStoryboardNameIndentifier(@"Launch", @"TabBarNAVI");\
appDelegate.window.rootViewController = nav;\
}while (0)



#define   SET_CONTENT_BACKGROUND_IMAGE(imageName,top,left,bottom,right)  [[UIImage imageNamed:(imageName)] resizableImageWithCapInsets:UIEdgeInsetsMake((top),(left),(bottom),(right)) resizingMode:UIImageResizingModeStretch] //拉伸图片



#pragma mark - 获取storyboard中指定的视图控制器
#define GetViewControllerWithStoryboardName(storyboardName) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController]
#define GetViewControllerWithStoryboardNameIndentifier(storyboardName, identifier) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier]

#endif /* UIMacro_h */
