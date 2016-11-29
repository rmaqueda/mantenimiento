//
//  MOLSelectOptionViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 13/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLSelectOptionViewController.h"
#import "MOLEditableModelTableViewController.h"
#import "MOLNetworkManager.h"
#import "MOLLocal.h"
#import "MOLService.h"
#import "MOLVehicle.h"
#import <AFMInfoBanner/AFMInfoBanner.h>

@implementation MOLSelectOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    self.title = [[[self.selectedObject.class endpoint] capitalizedString] substringToIndex:[[self.selectedObject.class endpoint] length] - 1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    @weakify(self);
    [[MOLNetworkManager sharedInstance] objectsOfClass:self.selectedObject.class completionBlock:^(NSError *error, MOLResponse *response) {
        @strongify(self);
        self.options = response.results;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.options.count == 0) {
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        //TODO: Poner el tipo en el mensaje
        messageLbl.text = @"No created yet.\n Please, tap on the plus button above.";
        messageLbl.numberOfLines = 2;
        messageLbl.textAlignment = NSTextAlignmentCenter;
        [messageLbl sizeToFit];
        self.tableView.backgroundView = messageLbl;
    } else {
        self.tableView.backgroundView = nil;
    }
    
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<APIDrawableObject> object = self.options[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    
    cell.textLabel.text = object.title;
    
    if ([object isEqual:self.selectedObject]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedObject = self.options[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(selectOptionViewController:didSelect:)]) {
        [self.delegate selectOptionViewController:self didSelect:self.options[indexPath.row]];
    }
    
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        id<APIDrawableObject> selectedObject = self.options[indexPath.row];
        if ([selectedObject isEqual:self.selectedObject]) {
            [AFMInfoBanner showWithText:@"Cannot delete, change it before" style:AFMInfoBannerStyleError andHideAfter:1.5];
            return;
        }
        
        [[MOLNetworkManager sharedInstance] deleteObject:self.options[indexPath.row] completionBlock:^(NSError *error) {
            if (!error) {
                NSMutableArray *mutableCopy = self.options.mutableCopy;
                [mutableCopy removeObjectAtIndex:indexPath.row];
                self.options = mutableCopy.copy;
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [AFMInfoBanner showWithText:@"Deleting Error, cannot delete, is in use" style:AFMInfoBannerStyleError andHideAfter:1.5];
                [tableView reloadData];
            }
        }];
    }
}

#pragma mark - Segues

- (IBAction)didPressNewButton:(id)sender {
    if ([self.selectedObject isKindOfClass:MOLLocal.class]) {
        [self performSegueWithIdentifier:@"newLocal" sender:[[MOLLocal alloc] init]];
    } else {
        [self performSegueWithIdentifier:@"newService" sender:[[MOLService alloc] init]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MOLEditableModelTableViewController *newMaintenanceVC = [segue destinationViewController];
    newMaintenanceVC.modelObject = sender;
}

@end
