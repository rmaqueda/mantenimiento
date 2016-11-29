//
//  MOLRegisterViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 04/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLAppDelegate.h"
#import "MOLRegisterViewController.h"
#import "MOLNetworkManager.h"
#import <AFMInfoBanner/AFMInfoBanner.h>

@interface MOLRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end

@implementation MOLRegisterViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)isValidData {
    if (!self.username.text.length) {
        
        return NO;
    }
    
    if (!self.email.text.length) {
        
        return NO;
    }
    
    if (!self.password1.text.length || !self.password2.text.length) {
        
        return NO;
    }
    
    if (![self.password1.text isEqualToString:self.password2.text]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions

- (IBAction)didPressRegisterButton:(id)sender {
    [self.view endEditing:YES];
    if (![self isValidData]) {
        return;
    }
   
    @weakify(self);
    [[MOLNetworkManager sharedInstance] registerUsername:self.username.text email:self.email.text password:self.password1.text completionBlock:^(NSError *error, MOLUser *user) {
        if (error) {
            NSLog(@"Error registering user: %@", error.localizedDescription);
            [AFMInfoBanner showWithText:@"Login Error" style:AFMInfoBannerStyleError andHideAfter:1.5];
            @strongify(self);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Register problems!"
                                                                           message:@"Sorry, try again later..."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                self.username.text = nil;
                self.email.text = nil;
                self.password1.text = nil;
                self.password2.text = nil;
                [self.username becomeFirstResponder];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            MOLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
    }];
}

@end
