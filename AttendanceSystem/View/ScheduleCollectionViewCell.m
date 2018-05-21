//
//  ScheduleCollectionViewCell.m
//  AttendanceSystem
//
//  Created by TamTran on 5/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "ScheduleCollectionViewCell.h"
#import "LessionInfo.h"

@interface ScheduleCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;




@end


@implementation ScheduleCollectionViewCell


- (void)loadData:(NSMutableArray *)lessionArray {
    
    NSString* code = @"";
    for(LessionInfo* lession in lessionArray)
    {
        if(lession.isUnderLine){
            code = [code stringByAppendingString:[NSString stringWithFormat:@"<u>%@</u> ",lession.code]];
        }
        else
            code = [code stringByAppendingString:[NSString stringWithFormat:@"%@ ",lession.code]];
    }
    
    _lblTitle.text = code;
    
}

@end
