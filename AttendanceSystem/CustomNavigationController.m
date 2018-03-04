//
//  CustomNavigationController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 1/25/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "CustomNavigationController.h"
#import "REFrostedViewController.h"
#import "CourseListViewController.h"
#import "AttendanceViewController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(panGestureRecognized:)];
    [pan setEdges:UIRectEdgeLeft];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    NSInteger role = [[[UserManager userCenter] getCurrentUser].role_id integerValue];
    
    if(role == TEACHER) {
         CourseListViewController* courseList = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseListViewController"];
        self.viewControllers = @[courseList];
    }
    else {
        AttendanceViewController* attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceViewController"];
        self.viewControllers = @[attendance];
    }
}

#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIScreenEdgePanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end
