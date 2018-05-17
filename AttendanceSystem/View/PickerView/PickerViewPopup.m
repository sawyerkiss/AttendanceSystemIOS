//
//  PickerViewPopup.m
//  Envoy_App
//
//  Created by KaneNguyen on 3/17/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import "PickerViewPopup.h"
#import "StudentModel.h"

static NSString *const kPickerViewPopup = @"PickerViewPopup";

@interface PickerViewPopup()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *donePressed;
@property (weak, nonatomic) IBOutlet UIButton *cancelPressed;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic) NSInteger selectionIndex;
@property (nonatomic) NSArray *datas;
@property (nonatomic, copy) PickerViewInputCompletion completion;

@end

@implementation PickerViewPopup

+ (void)showPickerViewInputInView:(UIView *)view
                          andData:(NSArray *)datas
                andSelectionIndex:(NSInteger)selectionIndex
                    andCompletion:(PickerViewInputCompletion)completion {
    PickerViewPopup *pickerView = [[PickerViewPopup alloc] initWithFrame:view.frame];
    pickerView.datas = datas;
    pickerView.selectionIndex = selectionIndex;
    if (completion) {
        pickerView.completion = completion;
    }
    [view addSubview:pickerView];
    
    [pickerView.pickView selectRow:selectionIndex inComponent:0 animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:kPickerViewPopup
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    if (view) {
        [self addSubview:view];
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
       // [self.cancelPressed setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
       // [self.donePressed setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    }
}

#pragma mark - PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.datas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    StudentModel* student = [self.datas objectAtIndex:row];
    
    NSString* title = [NSString stringWithFormat:@"%@ - %@",student.code,student.name];
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectionIndex = row;
}

- (IBAction)cancelPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)donePressed:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(self.selectionIndex);
    }
}

@end
