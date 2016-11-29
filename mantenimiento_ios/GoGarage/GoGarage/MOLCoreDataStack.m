//
//  MOLCoreDataStack.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 23/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLCoreDataStack.h"
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>

@interface MOLCoreDataStack ()

@property (strong, nonatomic) NSManagedObjectContext *mainMOC;
//@property (strong, nonatomic) NSManagedObjectContext *backgroundMOC;
@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSURL *modelURL;

@end

@implementation MOLCoreDataStack

@synthesize mainMOC = _mainMOC;
@synthesize model = _model;
@synthesize storeCoordinator = _storeCoordinator;

+ (instancetype)sharedInstance {
    static MOLCoreDataStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MOLCoreDataStack alloc] initWithModelName:@"Model"];
    });
    
    return _sharedInstance;
}

- (id)initWithModelName:(NSString *)aModelName {
    if (self = [super init]) {
        _modelURL = [[NSBundle mainBundle] URLForResource:aModelName withExtension:@"momd"];
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMOC.persistentStoreCoordinator = self.storeCoordinator;
//        _backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        _backgroundMOC.parentContext = self.mainMOC;
    }
    
    return self;
}

#pragma mark - Others

- (void)deleteAllData {
    NSLog(@"Delete All Data!");
    NSError *err = nil;
    for (NSPersistentStore *store in self.storeCoordinator.persistentStores) {
        if (![self.storeCoordinator removePersistentStore:store error:&err]) {
            NSLog(@"Error while removing store %@ from store coordinator %@", store, self.storeCoordinator);
        }
    }
    
    NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [documents URLByAppendingPathComponent:@"Model"];
    
    if (![[NSFileManager defaultManager] removeItemAtURL:url error:&err]) {
        NSLog(@"Error removing %@: %@", self.modelURL, err);
    }
    
    _mainMOC = nil;
    _storeCoordinator = nil;
    _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainMOC.persistentStoreCoordinator = self.storeCoordinator;
}


#pragma mark - NSPersistentStoreCoordinator

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (_storeCoordinator == nil) {
        NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documents URLByAppendingPathComponent:@"model.sqlite"];
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:storeURL
                                                   options:nil
                                                     error:nil]) {
            return nil;
        }
    }
    
    return _storeCoordinator;
}

#pragma mark - NSManagedObjectModel

- (NSManagedObjectModel *)model {
    if (_model == nil) {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    
    return _model;
}

#pragma mark - Instance Methods

- (NSArray *)objectsForClass:(Class<APIDrawableObject>)objectClass {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[objectClass managedObjectEntityName]];
    NSArray *results = [self.mainMOC executeFetchRequest:request error:nil];

    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:results.count];
    for (NSManagedObject *managedObjed in results) {
        id realObject = [MTLManagedObjectAdapter modelOfClass:objectClass fromManagedObject:managedObjed error:nil];
        [mutableArray addObject:realObject];
    }
    
    return mutableArray.copy;
}

- (id)objectForClass:(Class<APIDrawableObject>)objectClass withId:(NSNumber *)objectId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", objectId];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[objectClass managedObjectEntityName]];
    [request setPredicate:predicate];
    
    NSArray *results = [self.mainMOC executeFetchRequest:request error:nil];
    
    if (results.count) {
        return [results objectAtIndex:0];
    } else {
        return nil;
    }
}

- (void)saveObject:(id)object
   completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    NSError *insertError;
    id objectTosave = [MTLManagedObjectAdapter managedObjectFromModel:object
                                                 insertingIntoContext:self.mainMOC
                                                                error:&insertError];
    if (insertError) {
        !block ?: block(insertError, nil);
    } else {
        
        NSError *saveError;
        if ([self.mainMOC save:&saveError]) {
            NSLog(@"Saved object in DB");
        } else {
            NSLog(@"Fail saving object in DB");
        }
        
        id objectToReturn = [MTLManagedObjectAdapter modelOfClass:[object class] fromManagedObject:objectTosave error:nil];
        
        !block ?: block(saveError, objectToReturn);
    }
}

- (void)updateObject:(id)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block {
    
    MOLBaseModel *basemodel = (MOLBaseModel *)object;
    id objectToUpdate = [self objectForClass:[object class] withId:basemodel.objectId];
    [self.mainMOC delete:objectToUpdate];
    
    NSError *insertError;
    id objectToSave = [MTLManagedObjectAdapter managedObjectFromModel:object
                                                 insertingIntoContext:self.mainMOC
                                                                error:&insertError];
    if (insertError) {
        !block ?: block(insertError, nil);
    }
    
    NSError *saveError;
    [self.mainMOC save:&saveError];
    
    if (saveError) {
        !block ?: block(saveError, nil);
    } else {
        !block ?: block(nil, objectToSave);
    }
}

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block {
    
    MOLBaseModel *basemodel = (MOLBaseModel *)object;
    id objectToUpdate = [self objectForClass:[object class] withId:basemodel.objectId];
    [self.mainMOC deleteObject:objectToUpdate];
    
    NSError *saveError;
    [self.mainMOC save:&saveError];
    
    if (saveError) {
        NSLog(@"Error deleting data on DB");
    } else {
        NSLog(@"Deleted data in DB");
    }
    
    !block ?: block(saveError);
}


@end
