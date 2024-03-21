//
//  UICustomSearchBar.h
//  wealth
//
//  Created by wangyingjie on 15/6/2.
//  Copyright (c) 2015年 普惠金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICustomSearchBarDelegate;

@interface UICustomSearchBar : UIView

//Wrappers around the Textfield subview
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *placeholder;

//The text field subview
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, getter = isCancelButtonHidden) BOOL cancelButtonHidden; //NO by Default

@property (nonatomic, weak) id<UICustomSearchBarDelegate> delegate;

@end

@protocol UICustomSearchBarDelegate <NSObject>

@optional
- (void)searchBarCancelButtonClicked:(UICustomSearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(UICustomSearchBar *)searchBar;

- (BOOL)searchBarShouldBeginEditing:(UICustomSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UICustomSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(UICustomSearchBar *)searchBar;

- (void)searchBar:(UICustomSearchBar *)searchBar textDidChange:(NSString *)searchText;
@end

//A rounded view that makes up the background of the search bar.
@interface UIRoundedView : UIView
@end
