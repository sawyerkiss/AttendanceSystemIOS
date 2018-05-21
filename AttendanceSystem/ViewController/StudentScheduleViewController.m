//
//  StudentScheduleViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 5/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentScheduleViewController.h"
#import "ScheduleCollectionViewCell.h"
#import "LessionInfo.h"
#import "LessionTableViewCell.h"

static const NSArray* DAY_OF_WEEK ;
static const NSArray* MATRIX_OF_INDEX;
static int INDEX_ARRAY[] = {2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

static CGFloat const kCellHeightRatio = 70.0f/667.0f;
static CGFloat kCellHeight;

@interface StudentScheduleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *scheduleCollection;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@property (weak, nonatomic) IBOutlet UITableView *lessionTable;
@property (nonatomic) NSMutableArray *schedulesData;

@property (nonatomic)   NSInteger _selectedIndex;

@property (nonatomic) NSInteger userRole;

@property (nonatomic) NSMutableArray *lessonArray;

@end

@implementation StudentScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    kCellHeight = SCREEN_HEIGHT * kCellHeightRatio;
    
    self.title = @"SCHEDULES";
    
    self.timeLabel.text = @"";
    self.freeLabel.text = @"";
    
    DAY_OF_WEEK = @[@"MON",@"TUE", @"WED",@"THU",@"FRI",@"SAT"];
    MATRIX_OF_INDEX = @[@6,@12,@18,@24,@7,@13,@19,@25,@8,@14,@20,@26,@9,@15,@21,@27,@10,@16,@22,@28,@11,@17,@23,@29];
    //   INDEX_ARRAY = {2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    
    //@[@2,@2,@2,@2,@2,@2,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    
    
    _scheduleCollection.dataSource = self;
    _scheduleCollection.delegate = self;
    [_scheduleCollection registerNib:[UINib nibWithNibName:@"ScheduleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"scheduleCell"];
    
    //    [_scheduleCollection registerClass:[ScheduleCollectionViewCell class] forCellWithReuseIdentifier:@"scheduleCell"];
    //
    [_scheduleCollection setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _schedulesData = [[NSMutableArray alloc] init];
    _lessonArray = [[NSMutableArray alloc] init];
    
    self.lessionTable.hidden = YES;
    
    for(int i = 0 ; i < 30 ; i++)
    {
        NSMutableArray* lessionArray = [[NSMutableArray alloc] init];
        [self.schedulesData addObject:lessionArray];
    }
    
    [[self.schedulesData objectAtIndex:0] addObject:[[LessionInfo alloc] init:@"MON"]];
    [[self.schedulesData objectAtIndex:1] addObject:[[LessionInfo alloc] init:@"TUE"]];
    [[self.schedulesData objectAtIndex:2] addObject:[[LessionInfo alloc] init:@"WED"]];
    [[self.schedulesData objectAtIndex:3] addObject:[[LessionInfo alloc] init:@"THU"]];
    [[self.schedulesData objectAtIndex:4] addObject:[[LessionInfo alloc] init:@"FRI"]];
    [[self.schedulesData objectAtIndex:5] addObject:[[LessionInfo alloc] init:@"SAT"]];
    
    [self.scheduleCollection reloadData];
    
    /////////////////////////////////////////
    self.lessionTable.estimatedSectionHeaderHeight = 0 ;
    self.lessionTable.dataSource = self;
    self.lessionTable.delegate = self;
    self.lessionTable.rowHeight = UITableViewAutomaticDimension;
    self.lessionTable.estimatedRowHeight = 110;
    [self.lessionTable setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    //////////////////////////////////////////
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self showLoadingView];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self callGetScheduleAPI];
        });
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.schedulesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scheduleCell" forIndexPath:indexPath];
    cell.layer.borderWidth = 0;
    
    if(indexPath.row >= 0 && indexPath.row <= 5)
    {
        cell.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.layer.borderWidth = 2;
        
        cell.layer.backgroundColor = [[UIColor greenColor] CGColor];
        
        [cell loadData:[self.schedulesData objectAtIndex:indexPath.row] inCell:2];
        
        
    }
    else {
        
        [cell loadData:[self.schedulesData objectAtIndex:indexPath.row] inCell:INDEX_ARRAY[indexPath.row]];
        
        cell.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        if (indexPath.row == __selectedIndex) {
            cell.layer.borderColor = [[UIColor redColor] CGColor];
            cell.layer.borderWidth = 2;
        }
        else {
            cell.layer.borderColor = [[UIColor grayColor] CGColor];
            cell.layer.borderWidth = 2;
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_scheduleCollection.frame.size.width / 6 , _scheduleCollection.frame.size.height / 5 );
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if(indexPath.row >= 0 && indexPath.row <= 5)
        return;
    else {
        __selectedIndex = indexPath.row;
        
        NSString* time = [self getTime:indexPath.row];
        
        [collectionView reloadData];
        
        self.timeLabel.text = time;
        
        self.lessionTable.hidden = YES;
        
        if(INDEX_ARRAY[indexPath.row] == 1)
        {
            self.lessionTable.hidden = NO;
            self.freeLabel.text = @"";
            
            self.lessonArray = [self.schedulesData objectAtIndex:indexPath.row];
            [self.lessionTable reloadData];
        }
        else {
            self.freeLabel.text = @"No schedule";
            self.lessionTable.hidden = YES;
            
            //        [self.lessonArray removeAllObjects];
            //        [self.lessionTable reloadData];
        }
        
       
    }
    
}

- (NSString*) getTime:(NSInteger) pos {
    switch (pos){
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
            return @"7:30 - 9:00";
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
            return @"9:30 - 11:30";
        case 18:
        case 19:
        case 20:
        case 21:
        case 22:
        case 23:
            return @"13:30 - 15:00";
        case 24:
        case 25:
        case 26:
        case 27:
        case 28:
        case 29:
            return @"15:30 - 17:30";
    }
    return @"";
}

//'1-I23-LT;5-I23-LT;12-I11C-TH;12-I44-LT'

- (void)fillCourseListToScheduleData:(NSArray*)courseList {
    
    
    for(CourseModel* course in courseList) {
        
        if(!course.schedules)
            continue;
        
        NSString* scheduleString = course.schedules;
        
        NSArray* scheduleStringArray = [scheduleString componentsSeparatedByString:@";"];
        
        for(NSString* lession in scheduleStringArray)
        {
            NSArray* lessionStringArray = [lession componentsSeparatedByString:@"-"];
            
            NSString* indexText = [lessionStringArray objectAtIndex:0];
            
            NSUInteger index = [indexText integerValue];
            
            int newIndex = [MATRIX_OF_INDEX[index] intValue];
            
            NSLog(@"new index : %d",newIndex);
            
            if(newIndex >=0 && newIndex <= sizeof(INDEX_ARRAY)/sizeof(int))
                INDEX_ARRAY[newIndex] = 1;
            
            LessionInfo *lession = [[LessionInfo alloc] init];
            
            lession.code = course.code;
            lession.class_name = course.class_name;
            lession.name = course.name;
            lession.office_hour = course.office_hour && ![course.office_hour isEqualToString:@""] ? [NSString stringWithFormat:@"Office hour: %@", course.office_hour] : @"";
            lession.note = course.note && ![course.note isEqualToString:@""] ? [NSString stringWithFormat:@"Note: %@", course.note] : @"";
            
            NSString* typeClass = [lessionStringArray objectAtIndex:2] ;
            
            if([typeClass isEqualToString:@"LT"])
            {
                typeClass = @"Ly Thuyet";
                lession.isUnderLine = FALSE;
            }
            else{
                typeClass = @"Thuc Hanh";
                lession.isUnderLine = TRUE;
            }
            
            lession.content = [lessionStringArray objectAtIndex:1] ? [NSString stringWithFormat:@"Room: %@ - %@", [lessionStringArray objectAtIndex:1],typeClass] :@"";
            
            
            if(newIndex < [self.schedulesData count])
                [[self.schedulesData objectAtIndex:newIndex] addObject:lession];
        }
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lessonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LessionCell";
    LessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadLessionData:[self.lessonArray objectAtIndex:indexPath.row]];
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return kCellHeight;
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSInteger)integerFromString:(NSString *)string
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:string];
    return [numberObj integerValue];
}

- (void)callGetScheduleAPI {
    
    NSString* studentId = [[UserManager userCenter] getCurrentUser].userId;
    
    self.userRole = [[[UserManager userCenter] getCurrentUser].role_id integerValue];
    
    if(self.userRole == TEACHER) {
        
        [[ConnectionManager connectionDefault] getTeacherScheduleWithId:studentId success:^(id  _Nonnull responseObject) {
            
            [self hideLoadingView];
            
            NSArray* courseList = [CourseModel arrayOfModelsFromDictionaries:responseObject[@"courses"] error:nil];
            
            [self fillCourseListToScheduleData:courseList];
            
            [self.scheduleCollection reloadData];
            
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            
            [self hideLoadingView];
            
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
        
    }
    else
    {
        
        [[ConnectionManager connectionDefault] getStudentScheduleWithId:studentId success:^(id  _Nonnull responseObject) {
            
            [self hideLoadingView];
            
            NSArray* courseList = [CourseModel arrayOfModelsFromDictionaries:responseObject[@"courses"] error:nil];
            
            [self fillCourseListToScheduleData:courseList];
            
            [self.scheduleCollection reloadData];
            
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            
            [self hideLoadingView];
            
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
    }
    
}

@end
