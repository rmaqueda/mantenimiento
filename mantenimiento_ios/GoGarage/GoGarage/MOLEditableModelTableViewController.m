//
//  EditableModelTableViewController.m
//  Table Editable Model
//
//  Created by Ricardo Maqueda Martinez on 14/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLEditableModelTableViewController.h"
#import "MOLSelectOptionViewController.h"

#import "MOLRuntimeHelper.h"
#import "MOLDataHelper.h"

#import "MOLDrawableModelTableViewCell.h"
#import "MOLEnterTextTableViewCell.h"
#import "MOLEnterValueTableViewCell.h"
#import "MOLEnterDescriptionTableViewCell.h"
#import "MOLNewVCTableViewCell.h"
#import "MOLSelectDateTableViewCell.h"
#import "MOLSelectImageTableViewCell.h"
#import <AFMInfoBanner/AFMInfoBanner.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MOLEditableModelTableViewController () <MOLSelectOptionViewControllerDelegate>

@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation MOLEditableModelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    
    NSArray *validClasses = @[
                              @"UIImage",
                              @"NSString",
                              @"NSDate",
                              @"NSNumber",
                              @"MOLVehicle",
                              @"MOLLocal",
                              @"MOLService"
                              ];
    self.properties = [MOLRuntimeHelper dictionaryPropertiesNameTypeForClass:[self.modelObject class] classTypes:validClasses];
    
    [self registerCells];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(didPressSaveButton:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)registerCells {
    [MOLSelectImageTableViewCell registerNibForTableview:self.tableView];
    [MOLEnterTextTableViewCell registerNibForTableview:self.tableView];
    [MOLEnterValueTableViewCell registerNibForTableview:self.tableView];
    [MOLEnterDescriptionTableViewCell registerNibForTableview:self.tableView];
    [MOLNewVCTableViewCell registerNibForTableview:self.tableView];
    [MOLSelectDateTableViewCell registerNibForTableview:self.tableView];
}

- (void)reloadData {
    NSArray *validClasses = @[
                              @"UIImage",
                              @"NSString",
                              @"NSDate",
                              @"NSNumber",
                              @"MOLVehicle",
                              @"MOLLocal",
                              @"MOLService"
                              ];
    self.properties = [MOLRuntimeHelper dictionaryPropertiesNameTypeForClass:[self.modelObject class] classTypes:validClasses];
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.properties.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *property = self.properties[indexPath.row];
    
    if ([indexPath isEqual:[tableView indexPathForSelectedRow]]) {
        if ([property[@"class"] isEqualToString:@"NSDate"]) {
            return 256;
        }
        
        if ([property[@"class"] isEqualToString:@"UIImage"]) {
            MOLSelectImageTableViewCell *cell = (MOLSelectImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.hasImage) {
                return 256;
            }
        }
    }

    return 67.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *property = self.properties[indexPath.row];
    NSString *placeholder = [NSString stringWithFormat:@"placeholder_%@", property[@"name"]];
    NSString *localizadPlaceholder = NSLocalizedString(placeholder, nil);
    
    MOLDrawableModelTableViewCell *cell;
    
    if ([property[@"class"] isEqualToString:@"UIImage"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectImage"];
    }
    
    if ([property[@"class"] isEqualToString:@"NSString"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EnterText"];
    }
    
    if ([property[@"class"] isEqualToString:@"NSNumber"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EnterValue"];
        
        if ([property[@"name"] isEqualToString:@"price"]) {
            cell.suffix = @"EUR";
        } else if ([property[@"name"] isEqualToString:@"kilometers"]) {
            cell.suffix = @"KM";
        }
    }
    
    if ([property[@"class"] isEqualToString:@"NSDate"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectOption"];
    }
    
    if ([property[@"class"] isEqualToString:@"MOLVehicle"] ||
        [property[@"class"] isEqualToString:@"MOLLocal"] ||
        [property[@"class"] isEqualToString:@"MOLService"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewVC"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.placeholder = localizadPlaceholder;
    cell.object = self.modelObject;
    cell.property = property[@"name"];
    [cell drawCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - Actions

- (IBAction)didPressSaveButton:(id)sender {
    if ([self.modelObject isKindOfClass:[MOLMaintenanceBookDetails class]]) {
        MOLMaintenanceBookDetails *maintenanceDetails = (MOLMaintenanceBookDetails*)self.modelObject;
        MOLMaintenanceBook *maintenanceToSave = [[MOLMaintenanceBook alloc] init];
        maintenanceToSave.vehicleId = maintenanceDetails.vehicle.objectId;
        maintenanceToSave.localId = maintenanceDetails.local.objectId;
        maintenanceToSave.serviceId = maintenanceDetails.service.objectId;
        maintenanceToSave.date = maintenanceDetails.date;
        maintenanceToSave.price = maintenanceDetails.price;
        maintenanceToSave.kilometers = maintenanceDetails.kilometers;
        maintenanceToSave.objectId = maintenanceDetails.objectId;
        self.modelObject = maintenanceToSave;
    }

    MOLDataHelper *dataHelper = [[MOLDataHelper alloc] init];
    [SVProgressHUD show];
    if (self.modelObject.objectId) {
        [dataHelper updateObject:self.modelObject completionBlock:^(NSError *error, id<APIDrawableObject> object) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"Error Updating: %@", error.localizedDescription);
                [AFMInfoBanner showWithText:@"Updating Error" style:AFMInfoBannerStyleError andHideAfter:1.5];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [dataHelper saveObject:self.modelObject completionBlock:^(NSError *error, id<APIDrawableObject> object) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"Error Creating: %@", error.localizedDescription);
                [AFMInfoBanner showWithText:@"Creating Error" style:AFMInfoBannerStyleError andHideAfter:1.5];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - Select Option View Controller

- (void)selectOptionViewController:(MOLSelectOptionViewController *)viewController didSelect:(id)object {
    if ([object isKindOfClass:MOLVehicle.class]) {
        [self.modelObject setValue:object forKey:@"vehicle"];
    }
    
    if ([object isKindOfClass:MOLService.class]) {
        [self.modelObject setValue:object forKey:@"service"];
    }
    
    if ([object isKindOfClass:MOLLocal.class]) {
        [self.modelObject setValue:object forKey:@"local"];
    }
    [self.tableView reloadData];
}

#pragma  mark - Cell Delegates

- (void)newVCCellDidTap:(MOLNewVCTableViewCell *)cell {
    [self performSegueWithIdentifier:@"selectOption" sender:cell];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectOption"]) {
        MOLNewVCTableViewCell *cell = sender;
        id<APIDrawableObject> selectedObject = [cell.object valueForKey:cell.property];
        
        MOLSelectOptionViewController *selectOptionVC = [segue destinationViewController];
        selectOptionVC.delegate = self;
        selectOptionVC.selectedObject = selectedObject;
    }
}

@end
