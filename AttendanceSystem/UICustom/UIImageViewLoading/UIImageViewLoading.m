//
//  UIImageViewLoading.m
//  Envoy_App
//
//  Created by Nguyen Xuan Tho on 3/10/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import "UIImageViewLoading.h"
#import "UIImageView+AFNetworking.h"
#import "DGActivityIndicatorView.h"
#import "UIColor+Categories.h"

@import Photos;

static CGFloat const kSizeOfIndicator = 37.0f;
static NSInteger const kMaxAmountRequestImage = 3;

@interface UIImageViewLoading ()

@property (strong, nonatomic) DGActivityIndicatorView *indicatorView;
@property (nonatomic) NSInteger amoutRequestImage;

@end

@implementation UIImageViewLoading

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    self.indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor whiteColor] size:kSizeOfIndicator];
    self.indicatorView.tintColor = [UIColor colorWithHexString:@"#ff5548"];
    [self addSubview:self.indicatorView];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:kSizeOfIndicator];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:kSizeOfIndicator];
    
    [self addConstraints:@[constraintX,
                           constraintY,
                           constraintWidth,
                           constraintHeight]];
    [self.indicatorView startAnimating];
    self.amoutRequestImage = 0;
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest placeholderImage:(UIImage *)placeholderImage {
    self.amoutRequestImage ++;
    __weak typeof(self) weakSelf = self;
    [self setImageWithURLRequest:urlRequest
                placeholderImage:placeholderImage
                         success:
     ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf setImage:image];
         [strongSelf.indicatorView stopAnimating];
         strongSelf.amoutRequestImage = 0;
     }
                         failure:
     ^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (error.code == kCFURLErrorTimedOut &&
             self.amoutRequestImage <= kMaxAmountRequestImage) {
             [strongSelf setImageWithURLRequest:urlRequest placeholderImage:placeholderImage];
         } else {
             [strongSelf setImage:placeholderImage];
             [strongSelf.indicatorView stopAnimating];
             strongSelf.amoutRequestImage = 0;
         }
     }];
}

- (void)setImageWithImageLink:(NSString *)imageLink andPlaceholderImageName:(NSString *)imageName {
    if (![self.indicatorView animating]) {
        [self.indicatorView startAnimating];
    }
    NSURL *url = [NSURL URLWithString:imageLink];
    UIImage *placeHolderImage = nil;
    if (imageName.length > 0) {
        placeHolderImage = [UIImage imageNamed:imageName];
    }
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self setImageWithURLRequest:request placeholderImage:placeHolderImage];
    } else {
        [self setImage:placeHolderImage];
        [self.indicatorView stopAnimating];
    }
}

- (void)setImageWithName:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName]];
    [self.indicatorView stopAnimating];
}

- (void)setImageWithImage:(UIImage *)image andPlaceholderImageName:(NSString *)imageName {
    if (![self.indicatorView animating]) {
        [self.indicatorView startAnimating];
    }
   
    UIImage *placeHolderImage = nil;
    if (imageName.length > 0) {
        placeHolderImage = [UIImage imageNamed:imageName];
    }
    
    if (image) {
        placeHolderImage = image;
    }
    
        [self setImage:placeHolderImage];
        [self.indicatorView stopAnimating];
}

@end
