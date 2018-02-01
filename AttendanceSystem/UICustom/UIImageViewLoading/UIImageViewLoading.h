//
//  UIImageViewLoading.h
//  Envoy_App
//
//  Created by Nguyen Xuan Tho on 3/10/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadImageCompletion)(BOOL isSuccess);

@interface UIImageViewLoading : UIImageView

- (void)setImageWithImageLink:(NSString *)imageLink andPlaceholderImageName:(NSString *)imageName;
- (void)setImageWithImage:(UIImage *)image andPlaceholderImageName:(NSString *)imageName;
- (void)setImageWithName:(NSString *)imageName;

@end
