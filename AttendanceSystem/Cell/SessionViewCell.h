//
//  SessionViewCell.h
//  AttendanceSystem
//
//  Created by TrungTruc on 3/1/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewCell : UICollectionViewCell

-(void)loadDataForCell:(NSString*)title value:(NSString*)value;

@end
