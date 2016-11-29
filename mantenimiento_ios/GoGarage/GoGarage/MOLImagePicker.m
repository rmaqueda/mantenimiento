//
//  MOLImagePicker.m
//  noDJ
//
//  Created by Ricardo Maqueda Martinez on 28/11/15.
//  Copyright © 2015 Ricardo Maqueda. All rights reserved.
//

#import "MOLImagePicker.h"

@interface MOLImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation MOLImagePicker

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *library = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo library", nil) style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        [self showPhotolibrary];
                                                    }];
    [actionSheet addAction:library];
    

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil) style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self showCamera];
                                                       }];
        [actionSheet addAction:camera];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
                                                            [self.delegate imagePickerControllerDidCancel:self];
                                                        }
                                                    }];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (void)showCamera {
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (void)showPhotolibrary {
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(MOLImagePicker *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(imagePikerDelegate:didFinishPickingMediaWithInfo:)]) {
        [self.delegate imagePikerDelegate:self didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(MOLImagePicker *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

@end
