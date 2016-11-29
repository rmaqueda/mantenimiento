//
//  MOLBaseViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 07/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLPagginationViewController.h"
#import "MOLPaginationManager.h"
#import "MOLNetworkManager.h"
#import "MOLAppDelegate.h"
#import <AFMInfoBanner/AFMInfoBanner.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MOLPagginationViewController () <MOLDataHelperDelegate>

@end

@implementation MOLPagginationViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.dataSource = self;
    self.table.delegate = self;
//    self.table.tableFooterView = [self.paginationObject activityIndicatorView:self.view];
    self.table.allowsMultipleSelectionDuringEditing = NO;
    self.table.separatorColor = [UIColor clearColor];
    self.dataHelper = [[MOLDataHelper alloc] init];
    self.dataHelper.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO Asertion debe ser implementado por las subclases
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.objects == 0) {
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.table.bounds.size.width, self.table.bounds.size.height)];
        messageLbl.text = self.emptyTextLabel;
        messageLbl.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
        messageLbl.numberOfLines = 2;
        messageLbl.textAlignment = NSTextAlignmentCenter;
        [messageLbl sizeToFit];
        self.table.backgroundView = messageLbl;
    } else {
        self.table.backgroundView = nil;
    }
    
    return self.objects.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataHelper deleteObject:self.objects[indexPath.row] completionBlock:^(NSError *error) {
            if (!error) {
                [self.objects removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [AFMInfoBanner showWithText:@"Deleting Error, cannot delete, is in use" style:AFMInfoBannerStyleError andHideAfter:1.5];
                [tableView reloadData];
            }
        }];
    }
}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height)) {
//        if (self.paginationObject.results.count < self.paginationObject.totalObjects) {
//            [self nextPage];
//        } else {
//            self.table.tableFooterView = nil;
//        }
//    }
//}

//- (void)nextPage {
//    @weakify(self);
//    [self.paginationObject nextPageWithBlock:^(NSError *error) {
//        if (!error) {
//            @strongify(self);
//            [self.table reloadData];
//        } else {
//            NSLog(@"Error download object: %@", error.localizedDescription);
//        }
//    }];
//}

#pragma mark - Actions

- (IBAction)didPressLogoutButton:(id)sender {
    [SVProgressHUD show];
    [[MOLNetworkManager sharedInstance] logoutWithCompletionBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"Error in logout: %@", error.localizedDescription);
        } else {
            UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            MOLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = rootController;
        }
    }];
}

#pragma mark - MOLDataHelper Delegate

- (void)dataHelpeDidReciveObjectsOfClass:(Class<APIDrawableObject>)objectClass objects:(NSArray *)objects {
    self.objects = objects.mutableCopy;
    [self.table reloadData];
}

@end
