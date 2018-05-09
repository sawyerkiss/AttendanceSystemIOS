//
//  AppDelegate.h
//  AttendanceSystem
//
//  Created by TrungTruc on 1/24/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString *const ProjectOxfordFaceSubscriptionKey = @"18db52d47bc5483f92d687a957c40c98";
static NSString *const ProjectOxfordFaceEndpoint = @"https://westcentralus.api.cognitive.microsoft.com/face/v1.0/";
//@"https://westus.api.cognitive.microsoft.com/face/v1.0/";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain, nonatomic) NSData * mdl;
@property (retain, nonatomic) NSData * recomdl;
@property (assign, nonatomic) intptr_t jdaDetector;
@property (assign, nonatomic) intptr_t recognizer;

@property (retain, nonatomic) NSMutableArray * groups;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

