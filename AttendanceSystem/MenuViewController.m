//
//  MenuViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 1/24/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemModel.h"
#import "REFrostedViewController.h"
#import "UIColor+Categories.h"
#import "ConnectionManager.h"
#import "LoadingManager.h"
#import "LoginViewController.h"
#import "UIImageViewLoading.h"
#import "ProfileViewController.h"
#import "AboutViewController.h"
#import "CourseListViewController.h"
#import "AttendanceViewController.h"
#import "SendAbsenceViewController.h"
#import "SendFeedbackViewController.h"
#import "MPOPersonFacesController.h"
#import "StudentScheduleViewController.h"

static CGFloat const kCellHeightRatio = 60.0f/667.0f;
static CGFloat kCellHeight;

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (weak, nonatomic) IBOutlet UIImageViewLoading *imgProfile;

@property (nonatomic) NSArray *items;
@property (nonatomic) NSInteger itemIndexSelected;
@property (nonatomic) REFrostedViewController* homeController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kCellHeight;
}

- (void)initUserInterface {
    
    kCellHeight = SCREEN_HEIGHT * kCellHeightRatio;
    
    self.lblProfileName.text = [[UserManager userCenter] getProfileName];
    
    self.imgProfile.layer.masksToBounds = YES;
    self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.width/2;
    
    UserModel* user = [[UserManager userCenter] getCurrentUser];
    [self.imgProfile setImageWithImageLink:user.avatar andPlaceholderImageName:@"icon_user"];
    
    self.tableMenu.rowHeight = UITableViewAutomaticDimension;
    self.tableMenu.estimatedRowHeight = 100;
    self.tableMenu.backgroundColor = [UIColor colorWithHexString:MAIN_BLUE_COLOR];
    self.tableMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMenu.delegate = self;
    self.tableMenu.dataSource = self;
    
    MenuItemModel *courselist = [[MenuItemModel alloc] initWithName:@"Course List"
                                                               type:MenuItemType_CourseList
                                                  imageNameSelected:@"icon_nav_menu"
                                                imageNameUnselected:@"icon_nav_menu"];
    MenuItemModel *sendFeeback = [[MenuItemModel alloc] initWithName:@"Send Feedback"
                                                                type:MenuItemType_SendFeedback
                                                   imageNameSelected:@"icon_nav_menu"
                                                 imageNameUnselected:@"icon_nav_menu"];
    MenuItemModel *schedules = [[MenuItemModel alloc] initWithName:@"Schedules"
                                                              type:MenuItemType_Schedules
                                                 imageNameSelected:@"icon_nav_menu"
                                               imageNameUnselected:@"icon_nav_menu"];
    MenuItemModel *account = [[MenuItemModel alloc] initWithName:@"Account"
                                                            type:MenuItemType_Account
                                               imageNameSelected:@"icon_nav_menu"
                                             imageNameUnselected:@"icon_nav_menu"];
    MenuItemModel *about = [[MenuItemModel alloc] initWithName:@"About"
                                                          type:MenuItemType_About
                                             imageNameSelected:@"icon_nav_menu"
                                           imageNameUnselected:@"icon_nav_menu"];
    MenuItemModel *logout = [[MenuItemModel alloc] initWithName:@"Logout"
                                                           type:MenuItemType_Logout
                                              imageNameSelected:@"icon_nav_menu"
                                            imageNameUnselected:@"icon_nav_menu"];
    
    MenuItemModel *attendance = [[MenuItemModel alloc] initWithName:@"Attendance"
                                                               type:MenuItemType_Attendance
                                                  imageNameSelected:@"icon_nav_menu"
                                                imageNameUnselected:@"icon_nav_menu"];
    
    MenuItemModel *sendAbsenceRequest = [[MenuItemModel alloc] initWithName:@"Send Absence Request"
                                                                       type:MenuItemType_SendAbsenceRequest
                                                          imageNameSelected:@"icon_nav_menu"
                                                        imageNameUnselected:@"icon_nav_menu"];
    
    MenuItemModel *uploadFaces = [[MenuItemModel alloc] initWithName:@"Upload Faces"
                                                                       type:MenuItemType_UploadFaces
                                                          imageNameSelected:@"icon_nav_menu"
                                                        imageNameUnselected:@"icon_nav_menu"];
    
    if([[[UserManager userCenter] getCurrentUser].role_id integerValue] == STUDENT) {
        self.items = @[attendance,
                       sendFeeback,
                       sendAbsenceRequest,
                       schedules,
                       account,
                       uploadFaces,
                       about,
                       logout];
    }
    else {
        self.items = @[courselist,
                       sendFeeback,
                       schedules,
                       account,
                       about,
                       logout];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchProfileIcon:(id)sender {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"menuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.backgroundColor = [UIColor clearColor];
    }
    MenuItemModel *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    if (indexPath.row == self.itemIndexSelected) {
        cell.textLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithHexString:MAIN_BLUE_COLOR];
        [cell.imageView setImage:[UIImage imageNamed:item.imageNameSelected]];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.imageView setImage:[UIImage imageNamed:item.imageNameUnselected]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.frostedViewController hideMenuViewController];
    self.homeController = self.frostedViewController;
    self.itemIndexSelected = indexPath.row;
    [tableView reloadData];
    MenuItemModel *item = [self.items objectAtIndex:indexPath.row];
    switch (item.type) {
        case MenuItemType_Attendance :{
            AttendanceViewController* attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:attendance animated:TRUE];
            break;
        }
        case MenuItemType_SendAbsenceRequest: {
            SendAbsenceViewController* absence = [self.storyboard instantiateViewControllerWithIdentifier:@"SendAbsenceViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:absence animated:TRUE];
        }
            break ;
        case MenuItemType_CourseList:{
            CourseListViewController* courseList = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseListViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:courseList animated:TRUE];
            break;
        }
        case MenuItemType_SendFeedback: {
            SendFeedbackViewController* absence = [self.storyboard instantiateViewControllerWithIdentifier:@"SendFeedbackViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:absence animated:TRUE];
        }

            break;
            
        case MenuItemType_Schedules:
        {
            StudentScheduleViewController* absence = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentScheduleViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:absence animated:TRUE];
        }
            
            break;
            
        case MenuItemType_Account: {
            ProfileViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:profile animated:TRUE];
        }
            break;
        case MenuItemType_About:
        {
            AboutViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:profile animated:TRUE];
        }
            break ;
        case MenuItemType_Logout:
            [self showLogoutAlert];
            break;
        
        case MenuItemType_UploadFaces:
            {
            GroupPerson* person = [[GroupPerson alloc] init];
            person.personId = [[UserManager userCenter] getCurrentUser].person_id;
            
            PersonGroup* group = [[PersonGroup alloc] init];
            group.groupId = GROUP;
            
            MPOPersonFacesController * controller = [[MPOPersonFacesController alloc] initWithGroup:group andPerson:person];
            //        controller.needTraining = * NO ;
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:controller animated:YES];
            }
            
            break;
        default:
            break;
    }
    self.itemIndexSelected = 0;
}

-(void)showLogoutAlert {
    [self showAlertQuestionWithMessage:@"Would you like to logout of your account?"
                            completion:
     ^(NSInteger buttonIndex) {
         if (buttonIndex == 1) {
             //             [self showLoadingView];
             [[ConnectionManager connectionDefault] logout:
              ^(id  _Nonnull responseObject) {
                  //                  [self hideLoadingView];
                  [[UserManager userCenter] setCurrentUserToken:@""];
                  [self gotoSignInScreen];
                  
              }
                                                andFailure:
              ^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
                  [self hideLoadingView];
                  [[UserManager userCenter] setCurrentUserToken:@""];
                  [self gotoSignInScreen];
                  [self showAlertNoticeWithMessage:errorMessage completion:nil];
                  
              }];
         }
     }];
}

- (void)gotoSignInScreen {
    [self.homeController hideMenuViewController];
    [(UINavigationController*)self.homeController.contentViewController dismissViewControllerAnimated:FALSE completion:nil];
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

@end
