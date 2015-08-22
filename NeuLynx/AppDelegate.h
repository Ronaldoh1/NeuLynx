//
//  AppDelegate.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Activity.h"
#import "ExclusiveInvite.h"
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property Activity *sharedActivity;
@property ExclusiveInvite *exclusiveInvite;
@property BOOL *hideDoneButtonForRequests;
@property BOOL *hideDoneButtonForMessages;
@property User *selectedUser;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

