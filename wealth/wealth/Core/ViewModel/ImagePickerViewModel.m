//
//  ImagePickerViewModel.m
//  wealth
//
//  Created by wangyingjie on 15/1/23.
//  Copyright (c) 2015年 puhui. All rights reserved.
//

#import "ImagePickerViewModel.h"
@interface ImagePickerViewModel () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *parentController;
@property (nonatomic, strong) UIImagePickerController *imagePick;

@end

@implementation ImagePickerViewModel

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _sourceType = UIImagePickerControllerSourceTypeCamera;
        _qualityType = UIImagePickerControllerQualityTypeHigh;
        _presentationStyle = UIModalPresentationFullScreen;
        _cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        _mediaTypes = @[ @"public.image" ];
        _compressRatio = 0.0f;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dadasda");
}

- (void)presentImagePickerViewController:(UIViewController *)viewController
                              completion:(void (^)(void))completion
{
    self.parentController = viewController;
    
    _imagePick = [[UIImagePickerController alloc] init];
    _imagePick.delegate = self;
    if ( _mediaTypes ) {
        _imagePick.mediaTypes = _mediaTypes;
    }
    _imagePick.sourceType = _sourceType;
    _imagePick.videoQuality = _qualityType;
    _imagePick.modalPresentationStyle = _presentationStyle;
    _imagePick.cameraCaptureMode = _cameraCaptureMode;
    _imagePick.cameraDevice = _cameraDevice;
    _imagePick.allowsEditing = YES;
    _imagePick.cameraFlashMode = _cameraFlashMode;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 80)/2, 10, 80, 25);
//    button.backgroundColor = [UIColor clearColor];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [button setTitle:@"相册" forState:UIControlStateNormal];
//    [button setTitle:@"相册" forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(chosePictureAlume) forControlEvents:UIControlEventTouchUpInside];
//    _imagePick.cameraOverlayView = button;
    [self.parentController presentViewController:_imagePick animated:YES completion:completion];
}

- (void)chosePictureAlume {
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePick.sourceType = self.sourceType;
}

#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
//    image = [image scaledImageWidth:[UIScreen mainScreen].bounds.size.width
//                             height:[UIScreen mainScreen].bounds.size.height];
    

    
    
    [self.parentController dismissViewControllerAnimated:YES completion:^{
        // 缓存图片
        self.image = image;
        
        // 缓存至本地文件
        [self saveImageToDocument];
    }];
    
    
//    [self.parentController dismissViewControllerAnimated:YES completion:^{
//        @weakify(self);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            @strongify(self);
//            __block UIImage *compressImage = image;
//            if ( _compressRatio ) { // 压缩图片大小
//                [Utility testFunctionTimes:[NSString stringWithUTF8String:__FUNCTION__] tast:^{
//                    compressImage = [UIImage compressImage:image compressRatio:_compressRatio];
//                }];
//            }
//            
//            // 缓存图片
//            self.image = compressImage;
//            
//            // 缓存至本地文件
//            [self saveImageToDocument];
//        });
//    }];
}

- (void)saveImageToDocument {
    NSString *filePath = kPhotoPicturePath;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
//    NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@/%@.jpg", filePath, @(GET_CLIENT_MANAGER.loginManager.accountInformation.appLendRequestId), (self.customPictureName ? self.customPictureName : [Utility getUUID])];
//    NSData *jpgImage = UIImageJPEGRepresentation(self.image, 1.0f);
//    self.imageLength = jpgImage.length;
//    if ( [PathEngine writeToFile:jpgImage fullName:fileFullPath] ) {
//        self.imagePath = fileFullPath;
//    };
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSLog(@"info = %@", info);
////    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
////    void(^completion)(void)  = ^(void){
////        
////        [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
////            if (asset){
////                [self launchEditorWithAsset:asset];
////            }
////        } failureBlock:^(NSError *error) {
////            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
////        }];
////        
////        UIImage * editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
////        if(editedImage){
////            [self launchPhotoEditorWithImage:editedImage highResolutionImage:editedImage];
////        }
////        
////    };
////    
////    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
////        [self dismissViewControllerAnimated:YES completion:completion];
////    }else{
////        [self dismissPopoverWithCompletion:completion];
////    }
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ( self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePick.sourceType = self.sourceType;
    } else {
        [self.parentController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
