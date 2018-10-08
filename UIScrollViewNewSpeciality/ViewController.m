//
//  ViewController.m
//  UIScrollViewNewSpeciality
//
//  Created by YYH on 2018/10/8.
//  Copyright © 2018 YUEAPP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController {
    __weak UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.delegate = self;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [NSLayoutConstraint activateConstraints:@[
                                              [scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
                                              [backgroundView.leadingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.leadingAnchor],
                                              [backgroundView.topAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.topAnchor],
                                              [backgroundView.trailingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.trailingAnchor],
                                              [backgroundView.bottomAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.bottomAnchor]
                                              ]];
    
    UILabel *container = [UILabel new];
    container.textColor = UIColor.whiteColor;
    container.font = [UIFont systemFontOfSize:14];
    container.textAlignment = NSTextAlignmentCenter;
    container.numberOfLines = 0;
    NSMutableString *text = [NSMutableString string];
    for (NSInteger i = 0; i < 200; i ++) {
        [text appendString:@"test container text\n"];
    }
    container.text = text;
    container.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:container];
    [NSLayoutConstraint activateConstraints:@[
                                              [container.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
                                              [container.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
                                              [container.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
                                              [container.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
                                              [container.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor]
                                              ]];
    
    UIView *contentLayoutGuideView = [UIView new];
    contentLayoutGuideView.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.5];
    contentLayoutGuideView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentLayoutGuideView];
    NSLayoutConstraint *contentLCenterY = [contentLayoutGuideView.centerYAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:-20];
    contentLCenterY.priority = UILayoutPriorityDefaultLow;
    [NSLayoutConstraint activateConstraints:@[
                                              [contentLayoutGuideView.centerXAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.centerXAnchor],
                                              contentLCenterY,
                                              [contentLayoutGuideView.topAnchor constraintGreaterThanOrEqualToAnchor:scrollView.frameLayoutGuide.topAnchor],
                                              [contentLayoutGuideView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor multiplier:1],
                                              [contentLayoutGuideView.heightAnchor constraintEqualToConstant:40]
                                              ]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.bounds.size.height, 0, 0, 0);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat y = targetContentOffset->y + scrollView.contentInset.top;
    //0-0.25 bottom 0.25-0.75 center 0.75-1 top
    CGFloat vlimit = 0.2;
    CGFloat height = scrollView.bounds.size.height;
    CGFloat offsety = y;
    CGFloat currenty = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (velocity.y > 0) { //向上滑动
        if (y > 0) {
            if (currenty < height * 0.25) {
                if (velocity.y > vlimit) {
                    offsety = height * 0.5;
                } else {
                    offsety = 0;
                }
            } else if (currenty < height * 0.5) {
                offsety = height * 0.5;
            } else if (currenty < height * 0.75) {
                if (velocity.y > vlimit && y > height * 0.5) {
                    offsety = height - 40;
                } else {
                    offsety = height * 0.5;
                }
            } else if (currenty < height) {
                if (y < height) {
                    offsety = height - 40;
                }
            }
        }
    } else if (velocity.y < 0) { //向下滑动
        if (y < height) {
            if (currenty > height * 0.75) {
                if (velocity.y < -vlimit && y > height * 0.5) {
                    offsety = height * 0.5;
                } else {
                    offsety = height - 40;
                }
            } else if (currenty > height * 0.5) {
                offsety = height * 0.5;
            } else if (currenty > height * 0.25) {
                if (velocity.y < -vlimit) {
                    offsety = 0;
                } else {
                    offsety = height * 0.5;
                }
            } else {
                offsety = 0;
            }
        }
    } else {
        if (currenty > height * 0.75) {
            offsety = height - 40;
        } else if (currenty > height * 0.5) {
            offsety = height * 0.5;
        } else if (currenty > height * 0.25) {
            offsety = height * 0.5;
        } else {
            offsety = 0;
        }
    }
    
    *targetContentOffset = CGPointMake(0, offsety - scrollView.contentInset.top);

    NSLog(@"%f  %f  ** %@", currenty, y, NSStringFromCGPoint(velocity));
    
}


@end
