//
//  ImagePickerViewModel.h
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "BaseViewModel.h"

@interface ImagePickerViewModel : BaseViewModel

@property (nonatomic, copy) NSString *customPictureName;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSUInteger imageLength;

@property (nonatomic, assign) CGFloat compressRatio;

// ImagePicker Config
@property (nonatomic, copy) NSArray *mediaTypes;

@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@property (nonatomic, assign) UIImagePickerControllerQualityType qualityType;

@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

@property (nonatomic, assign) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;

@property (nonatomic, assign) UIImagePickerControllerCameraDevice cameraDevice;

@property (nonatomic, assign) UIImagePickerControllerCameraFlashMode cameraFlashMode;

- (void)presentImagePickerViewController:(UIViewController *)viewController
                              completion:(void (^)(void))completion;

@end
