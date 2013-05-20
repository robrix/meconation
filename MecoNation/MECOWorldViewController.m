//
//  MECOWorldController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIslandViewController.h"
#import "MECOWorldViewController.h"
#import "MECOPageViewController.h"
#import "MECOIsland.h"
#import "MECOJob.h"
#import "MECOPerson.h"

@interface MECOWorldViewController () <MECOPageViewControllerDataSource, MECOPageViewControllerDelegate>

@property (copy) NSArray *islands;

@property (strong) IBOutlet UIButton *boatButton;
@property (strong) IBOutlet UILabel *warningLabel;
@property (strong) IBOutlet UIToolbar *toolbar;
@property (strong) IBOutlet UILabel *islandIdentifier;
@property (strong) IBOutlet UILabel *IQCount;
@property (nonatomic, strong) MECOPageViewController *pageViewController;

@property (copy) NSArray *islandViewControllers;

@property (strong) IBOutlet UILabel *mecoPopulationLabel;
@property (readonly) NSUInteger mecoPopulation;


@end

@implementation MECOWorldViewController

@synthesize islands = _islands;
@synthesize pageViewController = _pageViewController;

// Labels the current Island
-(NSUInteger)currentIslandNumber {
	return self.currentIslandViewController.islandIndex + 1;
}
-(NSString *)currentIslandLabel {
	return [NSString stringWithFormat: @"Island %u", self.currentIslandNumber];
}
-(void)updateIslandLabel {
	self.islandIdentifier.text = self.currentIslandLabel;
	[self.islandIdentifier sizeToFit];
}


//warning messages
-(NSString *) boatWarningLabel {
	return [NSString stringWithFormat: @"Sorry the boat is unavailable right now..." ];
}
-(NSString *) sheepWarningLabel {
	return [NSString stringWithFormat: @"Sorry Sheep are unavailable right now..."];
}
//Warning Label updates
-(void) updateWarningLabelForBoat {
	self.warningLabel.text = self.boatWarningLabel;
	[self.warningLabel sizeToFit];
}
-(void) updateWarningLabelForSheep {
	self.warningLabel.text = self.sheepWarningLabel;
	[self.warningLabel sizeToFit];
}

-(IBAction)showBoatWarning:(id)sender{
	[self updateWarningLabelForBoat];
}


-(NSSet *)allMecos {
	NSMutableSet *mecos = [NSMutableSet new];
	for (MECOIsland *island in self.islands) {
		[mecos unionSet:island.mecos];
	}
	return mecos;
}

-(NSUInteger)mecoPopulation {
	return self.allMecos.count;
}


//Population Label stuff
-(NSString *)populationLabel {
	return [NSString stringWithFormat: @"Population %u / %u / ∞", self.currentIslandPopulation, self.mecoPopulation];
}
-(void)updatePopulationLabel {
	self.mecoPopulationLabel.text = self.populationLabel;
	[self.mecoPopulationLabel sizeToFit];
}
-(NSUInteger) currentIslandPopulation {
	return self.currentIsland.mecos.count;
}


//IQ
-(NSUInteger) IQRate {
	int mecoScientistCount = 0;
	for (MECOPerson *person in self.allMecos)
	{
		if ([person.job.title isEqual:MECOScientistJobTitle])
			mecoScientistCount += 1;
	}
	return mecoScientistCount * 10;
}
-(NSString *)IQLabel{
	return [NSString stringWithFormat:@"IQ %u", self.IQRate ];
}
-(void) updateIQLabel{
	//Right now this posts the rate of IQ per minute
	//Instead it should show the amount of IQ the user has...
	self.IQCount.text = self.IQLabel;
	[self.IQCount sizeToFit];
}


-(void)viewDidLoad {
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	
	[self performSegueWithIdentifier:@"pageViewController" sender:self];
	
	NSMutableArray *islandViewControllers = [NSMutableArray new];
	NSUInteger islandIndex = 0;
	self.islands = [MECOIsland allIslands];
	for (MECOIsland *island in self.islands) {
		MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
		controller.view.frame = self.pageViewController.view.bounds;
		controller.island = island;
		if (islandIndex == 0) {
			[controller addMecoWithJob:[MECOJob jobTitled:MECOScientistJobTitle]];
			[controller addMecoWithJob:[MECOJob jobTitled:MECOFarmerJobTitle]];
			[controller addMecoWithJob:[MECOJob jobTitled:MECOTailorJobTitle]];
            [self updatePopulationLabel];
			[self updateIQLabel];
		}
		controller.mecoWorld = self;
		controller.islandIndex = islandIndex++;
		[islandViewControllers addObject:controller];
	}
	self.islandViewControllers = islandViewControllers;
	
	self.pageViewController.currentViewController = [self.islandViewControllers objectAtIndex:0];
}


-(MECOIsland *)currentIsland {
	return self.currentIslandViewController.island;
}

-(MECOIslandViewController *)currentIslandViewController {
	return (MECOIslandViewController *)self.pageViewController.currentViewController;
}


-(IBAction)showSpawnMenu:(id)sender {
	[self.currentIslandViewController showSpawnMenu:sender];
}

-(IBAction)showJobsMenu:(id)sender {
	[self.currentIslandViewController showJobsMenu:sender];
}


-(void)setPageViewController:(MECOPageViewController *)pageViewController {
	_pageViewController = pageViewController;
	
	pageViewController.delegate = self;
	pageViewController.dataSource = self;
	
	[self addChildViewController:pageViewController];
	
	const CGFloat kToolbarHeight = CGRectGetHeight(self.toolbar.bounds);
	pageViewController.view.frame = (CGRect){
		{0, kToolbarHeight},
		{CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kToolbarHeight}
	};
	[self.view insertSubview:pageViewController.view atIndex:1];
	
	[pageViewController didMoveToParentViewController:self];
}


-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerAfterViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex < (self.islandViewControllers.count - 1)?
		[self.islandViewControllers objectAtIndex:viewController.islandIndex + 1]
	:	nil;
}

-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerBeforeViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex > 0?
		[self.islandViewControllers objectAtIndex:viewController.islandIndex - 1]
	:	nil;
}


-(void)pageViewController:(MECOPageViewController *)pageViewController didShowViewController:(UIViewController *)controller {
	[self updateIslandLabel];
	[self updatePopulationLabel];
}

@end
