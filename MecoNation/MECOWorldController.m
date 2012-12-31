//
//  MECOWorldController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOViewController.h"
#import "MECOWorldController.h"
#import "MECOIsland.h"

@interface MECOWorldController () <UIPageViewControllerDataSource>

@property (strong) IBOutlet UIPageViewController *pageViewController;

//@property (strong) IBOutletCollection(UIViewController) NSArray *islandControllers;

@property (copy) NSArray *islands;

@end

@implementation MECOWorldController

-(MECOViewController *)createViewControllerForIslandAtIndex:(NSUInteger)index {
	MECOViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"island"];
	controller.islandIndex = index;
	return controller;
}

-(void)awakeFromNib {
	self.islands = [NSArray arrayWithObjects:[MECOIsland firstIsland], [MECOIsland firstIsland], nil];
	
	[self.pageViewController setViewControllers:[NSArray arrayWithObject:[self createViewControllerForIslandAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}


-(MECOViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(MECOViewController *)viewController {
	return viewController.islandIndex < (self.islands.count - 1)?
		[self createViewControllerForIslandAtIndex:viewController.islandIndex + 1]
	:	nil;
}

-(MECOViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MECOViewController *)viewController {
	return viewController.islandIndex > 0?
		[self createViewControllerForIslandAtIndex:viewController.islandIndex - 1]
	:	nil;
}

@end
