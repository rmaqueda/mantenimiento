////
////  MOLPerformanceAPI.m
////  GoGarage
////
////  Created by Ricardo Maqueda Martinez on 05/01/16.
////  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "MOLNetworkManager.h"
//#import "MOLVehicle.h"
//
//
//@interface MOLPerformanceTest : XCTestCase
//
//@property (nonatomic, strong) MOLNetworkManager *networkManager;
//@property (nonatomic) int i;
//
//@end
//
//
//@implementation MOLPerformanceTest
//
//- (void)setUp {
//    [super setUp];
//    self.networkManager = [MOLNetworkManager sharedInstance];
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Network Expectation"];
//    [self.networkManager loginWithUsername:@"testperformance" password:@"a12345678" completionBlock:^(NSError *error) {
//        if (error) {
//            XCTAssert(@"Login failed");
//        }
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"Timeout Error: %@", error);
//        }
//    }];
//    
//}
//
//- (void)tearDown {
//    [self deleteAllVehicles];
//    self.networkManager = nil;
//    [super tearDown];
//}
//
//- (void)testCreateVehicle {
//    MOLVehicle *vehicle = [[MOLVehicle alloc] init];
//    vehicle.nick = [NSString stringWithFormat:@"%i", self.i];
//    vehicle.brand = @"Citroen";
//    vehicle.model = @"Xsara Picasso";
//    vehicle.color = @"Gris";
//    vehicle.chassisNumber = @"A123123";
//    vehicle.manufacturedDate = [NSDate date];
//    vehicle.registrationNumber = @"1234-CTL";
//    vehicle.vehicleDescription = @"Lorem fistrum a wan apetecan ese que llega a peich se calle ustée qué dise usteer fistro. Caballo blanco caballo negroorl papaar papaar la caidita va usté muy cargadoo al ataquerl te voy a borrar el cerito papaar papaar.";
//    
//
//    [self measureBlock:^{
//        MOLVehicle *vehicle = [[MOLVehicle alloc] init];
//        vehicle.nick = [NSString stringWithFormat:@"%i", self.i];
//        vehicle.brand = @"Citroen";
//        vehicle.model = @"Xsara Picasso";
//        vehicle.color = @"Gris";
//        vehicle.chassisNumber = @"A123123";
//        vehicle.manufacturedDate = [NSDate date];
//        vehicle.registrationNumber = @"1234-CTL";
//        vehicle.vehicleDescription = @"Lorem fistrum a wan apetecan ese que llega a peich se calle ustée qué dise usteer fistro";
//        self.i++;
//        
//        XCTestExpectation *expectation = [self expectationWithDescription:@"Network Expectation"];
//        
//        [self.networkManager createObject:vehicle completionBlock:^(NSError *error, id<APIDrawableObject> object) {
//            NSLog(@"Create vehicle %@", vehicle.nick);
//            [expectation fulfill];
//        }];
//        
//        [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
//            if (error) {
//                NSLog(@"Timeout Error: %@", error);
//            }
//        }];
//    }];
//}
//
////- (void)testListAndDeleteVehicle {
////    [self measureBlock:^{
////        
////        MOLVehicle *vehicle = [[MOLVehicle alloc] init];
////        vehicle.nick = @"test vehicle";
////        vehicle.brand = @"Citroen";
////        vehicle.model = @"Xsara Picasso";
////        vehicle.color = @"Gris";
////        vehicle.chassisNumber = @"A123123";
////        vehicle.manufacturedDate = [NSDate date];
////        vehicle.registrationNumber = @"1234-CTL";
////        vehicle.vehicleDescription = @"Lorem fistrum a wan apetecan ese que llega a peich se calle ustée qué dise usteer fistro";
////        
////        XCTestExpectation *expectation = [self expectationWithDescription:@"Network Expectation"];
////
////        [self.networkManager createObject:vehicle completionBlock:^(NSError *error, id<APIDrawableObject> object) {
////            if (error) {
////                XCTAssert(@"Error creating vehicle");
////            } else {
////
////                [self.networkManager fetchObjects:MOLVehicle.class pageSize:100 page:1 completionBlock:^(NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects) {
////                    NSLog(@"%lu entries", objects.count);
////                    
////                    for (MOLVehicle *vehicle in objects) {
////                        [self.networkManager deleteObject:vehicle completionBlock:^(NSError *error) {
////                            NSLog(@"Delete vehicle %@", vehicle.objectId);
////                        }];
////                    }
////                    [expectation fulfill];
////                }];
////            }
////        }];
////
////        [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
////            if (error) {
////                NSLog(@"Timeout Error: %@", error);
////            }
////        }];
////    }];
////}
//
//
////- (void)deleteAllVehicles {
////    [self.networkManager loginWithUsername:@"testperformance" password:@"a12345678" completionBlock:^(NSError *error) {
////        [self.networkManager fetchObjects:MOLVehicle.class pageSize:100 page:1 completionBlock:^(NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects) {
////            for (MOLVehicle *vehicle in objects) {
////                [self.networkManager deleteObject:vehicle completionBlock:nil];
////            }
////        }];
////    }];
////}
//
//@end
