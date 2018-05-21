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

//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (weak, nonatomic) IBOutlet UITextView *textView;


@end


@implementation ScheduleCollectionViewCell


- (void)loadData:(NSMutableArray *)lessionArray inCell:(NSInteger)index{
    
    if(index == 2)
    {
        LessionInfo* lesssion = [lessionArray objectAtIndex:0];
//        self.textView.text = lesssion.code;
        self.textView.backgroundColor = [UIColor greenColor];
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [lesssion.code dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        self.textView.attributedText = attributedString;
    }
    else {
         self.textView.backgroundColor = [UIColor whiteColor];
        NSString* code = @"";
        
        if(lessionArray && lessionArray.count > 0)
        {
            for(LessionInfo* lession in lessionArray)
            {
                if(lession.isUnderLine){
                    code = [code stringByAppendingString:[NSString stringWithFormat:@"<u>%@</u>",lession.code]];
                    if(![lession isEqual:[lessionArray lastObject]])
                        code = [code stringByAppendingString:@"<br>"];
                }
                else {
                    code = [code stringByAppendingString:[NSString stringWithFormat:@"%@",lession.code]];
                    if(![lession isEqual:[lessionArray lastObject]])
                        code = [code stringByAppendingString:@"<br>"];
                }
            }
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithData: [code dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil
                                                    ];
            self.textView.attributedText = attributedString;
            //    _lblTitle.text = code;
        }
        else
        {
            self.textView.text = @"";
            self.textView.attributedText = nil;
        }
    }
    
}

- (void)setUnderlineForLabel:(UILabel*)label withText:(NSString*)text {
    NSMutableAttributedString *textAttr = [label.attributedText mutableCopy];
    
    //    [textAttr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, text.length)];
    
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Regular" size:12],
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName: @(-3)};
    textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    
    label.attributedText = textAttr;
}

@end
