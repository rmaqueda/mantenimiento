//
//  MOLPaginationManager.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 03/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLPaginationManager.h"
#import "MOLNetworkManager.h"


typedef enum {
    RequestStatusNone,
    RequestStatusInProgress,
    RequestStatusDone
} RequestStatus;

@interface MOLPaginationManager ()

@property (assign, readwrite) NSInteger totalObjects;
@property (assign, readwrite) NSInteger pageSize;
@property (nonatomic, strong) Class classObject;
@property (assign) NSUInteger nextPage;
@property (assign) RequestStatus requestStatus;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSArray *filters;

@end

@implementation MOLPaginationManager

- (instancetype)initWithClass:(Class<APIDrawableObject>)classObject
                     pageSize:(NSInteger)pageSize
                      filters:(NSArray *)filers
{
    if (self = [super init]) {
        _pageSize = pageSize;
        _nextPage = 1;
        _results = [[NSMutableArray alloc] init];
        _requestStatus = RequestStatusNone;
        _classObject = classObject;
        _filters = filers;
        pageSize ? _pageSize = pageSize : _pageSize == 20;
    }
    
    return self;
}

- (UIView *)activityIndicatorView:(UIView *)view {
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 60.0f)];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGFloat XCenter = (CGRectGetWidth(loadingView.frame) / 2) - (CGRectGetWidth(activityIndicatorView.frame) / 2);
    CGFloat YCenter = (CGRectGetHeight(loadingView.frame) / 2) - (CGRectGetHeight(activityIndicatorView.frame) / 2);
    
    activityIndicatorView.center = CGPointMake(XCenter, YCenter);
    activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicatorView;
    [loadingView addSubview:activityIndicatorView];
    
    return loadingView;
}

- (void)nextPageWithBlock:(void (^) (NSError *error))block {
    if (self.requestStatus == RequestStatusInProgress || self.nextPage == 0)
        return;
    
    self.requestStatus = RequestStatusInProgress;
    [self.activityIndicator startAnimating];
    @weakify(self);
    [[MOLNetworkManager sharedInstance] objects:self.classObject
                                            pageSize:self.pageSize
                                                page:self.nextPage
                                             filters:self.filters
                                     completionBlock:^(NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects)
    {
        
        if (!error) {
            @strongify(self);
            self.nextPage = nextPage;
            self.totalObjects = totalObjects;
            [self.results addObjectsFromArray:objects];
        }
        
        self.requestStatus = RequestStatusDone;
        [self.activityIndicator stopAnimating];
        block ? block(error) : nil;
    }];
}

@end
