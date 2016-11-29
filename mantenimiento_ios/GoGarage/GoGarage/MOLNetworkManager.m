//
//  MOLNetworkManager.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 30/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLNetworkManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "MOLImage.h"

@interface MOLNetworkManager ()

@property (nonatomic ,copy) NSString *token;

@end


@implementation MOLNetworkManager

//static NSString * const API_URL = @"http://localhost:8000/api/1.0/";
//static NSString * const LOGIN_URL = @"http://localhost:8000/rest-auth/login/";
//static NSString * const LOGOUT_URL = @"http://localhost:8000/rest-auth/logout/";
//static NSString * const REGISTER_URL = @"http://localhost:8000/rest-auth/registration/";
//static NSString * const USER_URL = @"http://localhost:8000/rest-auth/user/";

static NSString * const API_URL = @"https://molestudio.es:8075/api/1.0/";
static NSString * const LOGIN_URL = @"https://molestudio.es:8075/rest-auth/login/";
static NSString * const LOGOUT_URL = @"https://molestudio.es:8075/rest-auth/logout/";
static NSString * const REGISTER_URL = @"https://molestudio.es:8075/rest-auth/registration/";
static NSString * const USER_URL = @"https://molestudio.es:8075/rest-auth/user/";

+ (instancetype)sharedInstance {
    static MOLNetworkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        sessionConfiguration.URLCache = cache;
        sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        _sharedInstance = [[MOLNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:API_URL] sessionConfiguration:nil];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    return self;
}

- (void)registerUsername:(NSString *)username email:(NSString *)email password:(NSString *)password
         completionBlock:(void (^) (NSError *error, MOLUser *user))block
{
    NSDictionary *bodyObject = @{
                                 @"username": [username lowercaseString],
                                 @"password1": password,
                                 @"email": email
                                 };
    NSLog(@"POST Request path: %@ Parameters: %@", REGISTER_URL, bodyObject);
    
    @weakify(self);
    [self POST:REGISTER_URL parameters:bodyObject progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *token = [NSString stringWithFormat:@"Token %@", responseObject[@"key"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[username lowercaseString] forKey:@"Username"];
        [defaults setObject:token forKey:@"Token"];
        [defaults synchronize];
        
        @strongify(self);
        self.token = token;
        
        MOLUser *user = [[MOLUser alloc] init];
        user.username = username;
        user.email = email;
        
        !block ?: block(nil, user);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block (error, nil);
    }];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
          completionBlock:(void (^) (NSError *error))block
{
    NSDictionary *parameters = @{@"username":[username lowercaseString], @"password":password};
    NSLog(@"POST Request path: %@", LOGIN_URL);
    
    @weakify(self);
    [self POST:LOGIN_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *token = [NSString stringWithFormat:@"Token %@", responseObject[@"key"]];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:[username lowercaseString] forKey:@"Username"];
         [defaults setObject:token forKey:@"Token"];
         [defaults synchronize];
         
         @strongify(self);
         self.token = token;
         [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
         
         !block ?: block(nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         !block ?: block(error);
     }];
}

- (void)loginWithLastUserNameWithCompletionBlock:(void (^) (NSError *error))block {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Token"];
    
    if (token.length) {
        self.token = token;
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
        [self fetchCurrentUserWithCompletionBlock:^(NSError *error, MOLUser *user) {
            if (!error) {
                !block ?: block(nil);
            } else {
                self.token = nil;
                [self.requestSerializer clearAuthorizationHeader];
                !block ?: block(error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"Login" code:403 userInfo:nil];
        !block ?: block(error);
    }
}

- (void)logoutWithCompletionBlock:(void (^) (NSError *error))block {
    NSLog(@"POST Request path: %@", LOGOUT_URL);
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    [self POST:LOGOUT_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !block ?: block(nil);
        self.token = nil;
        [self.requestSerializer clearAuthorizationHeader];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(error);
    }];
}

- (void)objectOfClass:(Class<APIDrawableObject>)classObject withId:(NSNumber *)objectId
           completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    NSString *path = [NSString stringWithFormat:@"%@%@/", [(Class)classObject endpoint], objectId];
    NSLog(@"GET Request path: %@", path);
    
    [self GET:path parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSError *error;
          id<APIDrawableObject> response = [MTLJSONAdapter modelOfClass:classObject fromJSONDictionary:responseObject error:&error];
          if (error) {
              !block ?: block(error, nil);
          } else {
              !block ?: block(nil, response);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          !block ?: block (error, nil);
      }];

}

- (void)fetchCurrentUserWithCompletionBlock:(void (^) (NSError *error, MOLUser *user))block {
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    NSLog(@"GET Request path: %@", USER_URL);
    
    [self GET:USER_URL parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSError *error;
          MOLUser *response = [MTLJSONAdapter modelOfClass:[MOLUser class] fromJSONDictionary:responseObject error:&error];
          if (error) {
              !block ?: block(error, nil);
          } else {
              !block ?: block(nil, response);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          !block ?: block (error, nil);
      }];
}

- (void)objectsOfClass:(Class<APIDrawableObject>)classObject
            completionBlock:(void (^) (NSError *error, MOLResponse *response))completionBlock
{
    NSLog(@"GET Request path: %@", [(Class)classObject endpoint]);
    
    [self GET:[(Class)classObject endpoint] parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSError *error;
          MOLResponse *response = [MTLJSONAdapter modelOfClass:[MOLResponse class] fromJSONDictionary:responseObject error:&error];
          if (error) {
              completionBlock(error, nil);
          } else {
              completionBlock(nil, response);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          completionBlock(error, nil);
      }];
}

- (void)objects:(Class<APIDrawableObject>)classObject
            pageSize:(NSUInteger)pageSize
                page:(NSUInteger)page
             filters:(NSArray *)filters
     completionBlock:(void (^) (NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects))block
{
    NSString *path = [NSString stringWithFormat:@"%@?page=%lu&page_size=%lu", [classObject endpoint], (unsigned long)page, (unsigned long)pageSize];
    NSLog(@"GET Request path: %@", path);
    
    if (filters) {
        NSString *one = filters[0];
        NSString *pathWithFilter = [path stringByAppendingString:[NSString stringWithFormat:@"&%@", one]];
        path = pathWithFilter;
    }
    
    [self GET:path parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSError *error;
          MOLResponse *response = [MTLJSONAdapter modelOfClass:[MOLResponse class] fromJSONDictionary:responseObject error:&error];
          
          if (error) {
              !block ?: block(error, nil, 0, 0);
          } else {
              NSUInteger next = 0;
              response.next ? next = page + 1 : next == 0;
              !block ?: block(nil, response.results, next, [response.count integerValue]);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          !block ?: block(error, nil, 0, 0);
      }];
}

- (void)saveObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    NSError *error;
    NSMutableDictionary *JSONObject = [MTLJSONAdapter JSONDictionaryFromModel:object error:&error].mutableCopy;
    if (error) {
        !block ?: block(error, nil);
        return;
    }
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    NSLog(@"POST Request path: %@", [object.class endpoint]);
    
    [self POST:[object.class endpoint] parameters:JSONObject constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        NSError *error;
        id<APIDrawableObject>modelObject = [MTLJSONAdapter modelOfClass:object.class fromJSONDictionary:responseObject1 error:&error];
        if (error) {
            !block ?: block(error, nil);
        } else {

            if (object.image) {
                NSData *imageData = UIImageJPEGRepresentation(object.image, 0.5);
                [self POST:@"vehicleimage/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%@", modelObject.objectId] mimeType:@"image/jpeg"];
                    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", modelObject.objectId] dataUsingEncoding:NSUTF8StringEncoding] name:@"vehicle"];
                } progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject2) {

                       NSError *error2;
                       MOLImage *image = [MTLJSONAdapter modelOfClass:MOLImage.class fromJSONDictionary:responseObject2 error:&error2];
                       
                       if (!error2) {
                           modelObject.images = @[image];
                           !block ?: block(nil, modelObject);
                       } else {
                           !block ?: block(error2, nil);
                       }
                       
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       !block ?: block(error, nil);
                   }];
            } else {
                !block ?: block(nil, modelObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(error, nil);
    }];
}

- (void)updateObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    NSString *path = [NSString stringWithFormat:@"%@%@/", [object.class endpoint], object.objectId];
    NSError *error;
    NSDictionary *JSONObject = [MTLJSONAdapter JSONDictionaryFromModel:object error:&error];
    if (error) {
        !block ?: block(error, nil);
        return;
    }
    
    NSLog(@"PUT Request path: %@", path);
    
    [self PUT:path parameters:JSONObject success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id<APIDrawableObject>modelObject = [MTLJSONAdapter modelOfClass:object.class fromJSONDictionary:responseObject error:&error];
        if (error) {
            !block ?: block(error, nil);
        } else {
            !block ?: block(nil, modelObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(error, nil);
    }];
}

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", self.token] forHTTPHeaderField:@"Authorization"];
    NSString *path = [NSString stringWithFormat:@"%@%@/", [object.class endpoint], object.objectId];
    NSLog(@"DELETE Request path: %@", path);
          
    [self DELETE:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !block ?: block(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(error);
    }];
}

@end
