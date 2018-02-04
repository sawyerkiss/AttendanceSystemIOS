//
//  AboutViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 2/1/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTouchContactUs:(id)sender {
//    NSString* title = @"Content Title";
    NSString* email = [NSString stringWithFormat:@"mailto:%@",@"trungtruc1094@gmail.com"];
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    email = [email stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL* emailURL = [NSURL URLWithString:email];
//    NSArray* dataToShare = @[to];
//
//    UIActivityViewController* activityViewController =
//    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
//                                      applicationActivities:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentViewController:activityViewController
//                           animated:YES
//                         completion:^{}];
        [[UIApplication sharedApplication] openURL:emailURL options:@{} completionHandler:nil];
    });
    
}
- (IBAction)didTouchLikeUs:(id)sender {
    
    NSURL* fbAppUrl = [NSURL URLWithString:@"fb://profile/100003879126656"];
    NSURL* fbWebUrl = [NSURL URLWithString:@"https://www.facebook.com/100003879126656"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([[UIApplication sharedApplication] canOpenURL:fbAppUrl]){
            // FB installed
            [[UIApplication sharedApplication] openURL:fbAppUrl options:@{} completionHandler:nil];
        } else {
            // FB is not installed, open in safari
            [[UIApplication sharedApplication] openURL:fbWebUrl options:@{} completionHandler:nil];
        }
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
