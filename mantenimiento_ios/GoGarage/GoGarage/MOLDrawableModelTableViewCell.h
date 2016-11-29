//
//  MOLDrawableTableViewCell.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 15/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


typedef NS_ENUM(NSInteger, MOLTableViewCellType) {
    MOLTableViewCellTypeNone,
    MOLTableViewCellTypeEnterText,
    MOLTableViewCellTypeEnterDescription,
    MOLTableViewCellTypeEnterValue,
    MOLTableViewCellTypeSelectDate,
    MOLTableViewCellTypeDatePicker,
    MOLTableViewCellTypeNewVC
};


@protocol DrawableCell <NSObject>

@property (nonatomic, strong) NSObject<APIDrawableObject> *object;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *placeholder;

+ (void)registerNibForTableview:(UITableView *)table;
- (void)drawCell;

@end


@interface MOLDrawableModelTableViewCell : UITableViewCell

@property (nonatomic, strong) NSObject<APIDrawableObject> *object;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *suffix;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (void)registerNibForTableview:(UITableView *)table;

- (void)drawCell;
- (UITableView *)myTableview;

@end
