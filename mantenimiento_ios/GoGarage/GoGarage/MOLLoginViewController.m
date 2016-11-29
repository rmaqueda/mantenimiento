//
//  MOLLoginViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 04/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//
#import "MOLAppDelegate.h"
#import "MOLLoginViewController.h"
#import "MOLNetworkManager.h"
#import <AFMInfoBanner/AFMInfoBanner.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MOLLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation MOLLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"Username"];
    if (username.length) {
        self.username.text = username;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)didPressLoginButton:(id)sender {
    if (!self.username.text.length || !self.password.text.length) {
        return;
    }
    
    self.loginButton.enabled = NO;
    self.registerButton.enabled = NO;
    
    @weakify(self);
    [SVProgressHUD show];
    [[MOLNetworkManager sharedInstance] loginWithUsername:self.username.text
                                                 password:self.password.text
                                          completionBlock:^(NSError *error)
     {
         @strongify(self);
         [SVProgressHUD dismiss];
         self.loginButton.enabled = YES;
         self.registerButton.enabled = YES;
         
         if (error) {
             NSLog(@"Error login: %@", error.localizedDescription);
             [AFMInfoBanner showWithText:@"Login Error" style:AFMInfoBannerStyleError andHideAfter:1.5];
         } else {
             MOLAppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
             appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
         }
     }];
}

@end
