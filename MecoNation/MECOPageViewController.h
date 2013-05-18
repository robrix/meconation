//  MECOPageViewController.h
//  Created by Rob Rix on 2013-01-13.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MECOPageViewControllerDataSource, MECOPageViewControllerDelegate;

@interface MECOPageViewController : UIViewController

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UIScrollView *view;

@property (nonatomic, weak) id<MECOPageViewControllerDelegate> delegate;
@property (nonatomic, weak) id<MECOPageViewControllerDataSource> dataSource;

@end

@protocol MECOPageViewControllerDelegate <NSObject>

@optional

-(void)pageViewController:(MECOPageViewController *)pageViewController didShowViewController:(UIViewController *)controller;

@end

@protocol MECOPageViewControllerDataSource <NSObject>

-(UIViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;
-(UIViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

@end
