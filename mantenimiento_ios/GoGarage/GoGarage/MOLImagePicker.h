//
//  MOLImagePicker.h
//  noDJ
//
//  Created by Ricardo Maqueda Martinez on 28/11/15.
//  Copyright © 2015 Ricardo Maqueda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOLImagePicker;

@protocol MOLImagePickerDelegate <NSObject>

- (void)imagePikerDelegate:(MOLImagePicker *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void)imagePickerControllerDidCancel:(MOLImagePicker *)picker;

@end

@interface MOLImagePicker : UIViewController

@property (nonatomic, weak) id<MOLImagePickerDelegate>delegate;

@end
