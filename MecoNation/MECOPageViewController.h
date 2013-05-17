//  MECOPageViewController.h
//  Created by Rob Rix on 2013-01-13.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MECOPageViewControllerDataSource;

@interface MECOPageViewController : UIViewController

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UIScrollView *view;

@property (nonatomic, weak) id<MECOPageViewControllerDataSource> dataSource;

@end

@protocol MECOPageViewControllerDataSource <NSObject>

-(UIViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;
-(UIViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

@end
