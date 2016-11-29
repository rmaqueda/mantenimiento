//
//  MOLDrawableTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 15/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLDrawableModelTableViewCell.h"

@implementation MOLDrawableModelTableViewCell

+ (void)registerNibForTableview:(UITableView *)table {
    [table registerNib:[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] forCellReuseIdentifier:[self reuseIndentifier]];
}

+ (NSString *)reuseIndentifier {
    //TODO: Implementar macro de: "Debe ser implementado en subclases
    return nil;
}

- (void)drawCell {
    //TODO: Implementar macro de: "Debe ser implementado en subclases
}

- (UITableView *)myTableview {
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    return (UITableView *)view;
}

@end
