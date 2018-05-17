//
//  PickerViewPopup.h
//  Envoy_App
//
//  Created by KaneNguyen on 3/17/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerViewInputCompletion)(NSInteger selectionIndex);

@interface PickerViewPopup : UIView

+ (void)showPickerViewInputInView:(UIView *)view
                          andData:(NSArray *)datas
                andSelectionIndex:(NSInteger)selectionIndex
                    andCompletion:(PickerViewInputCompletion)completion;

@end
