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
#import "MECOViewUtilities.h"

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

@synthesize IQ = _IQ;
@synthesize jobs = _jobs;
@synthesize jobsByTitle = _jobsByTitle;

@synthesize islands = _islands;
@synthesize pageViewController = _pageViewController;

// Labels the current Island
-(NSUInteger)currentIslandNumber {
	return self.currentIslandViewController.islandIndex + 1;
}
-(NSString *)currentIslandLabel {
	return [NSString stringWithFormat: @"%u", self.currentIslandNumber];
}
-(void)updateIslandLabel {
	self.islandIdentifier.text = self.currentIslandLabel;
	[self.islandIdentifier sizeToFit];
}


//Warning Label updates
-(void) updateWarningLabelForBoat {
	[self updateWarningLabelWithText:@"Sorry the boat is unavailable right now..."];
}
-(void) updateWarningLabelForSheep {
	[self updateWarningLabelWithText:@"Sorry Sheep are unavailable right now..."];
}
-(void) updateWarningLabelForPopulation{
	[self updateWarningLabelWithText:@"You will need another house for that..."];
}

-(void)updateWarningLabelWithText:(NSString *)text {
	self.warningLabel.text = text;
	MECOFadeInView(self.warningLabel, self.view);
	MECOFadeOutView(self.warningLabel, 3);
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
-(NSSet *)allHouses {
	NSMutableSet *houses = [NSMutableSet new];
	for (MECOIsland *island in self.islands) {
		[houses unionSet:island.houses];
	}
	return houses;
}

-(NSUInteger)mecoPopulation {
	return self.allMecos.count;
}


//Population Label stuff
-(NSUInteger)maximumPopulation{
	return self.allHouses.count * 4 - 1;
}
-(NSString *)populationLabel {
	return [NSString stringWithFormat: @"%u / %u / %u", self.currentIslandPopulation, self.mecoPopulation, self.maximumPopulation];
}
-(void)updatePopulationLabel {
	self.mecoPopulationLabel.text = self.populationLabel;
	[self.mecoPopulationLabel sizeToFit];
}
-(NSUInteger) currentIslandPopulation {
	return self.currentIsland.mecos.count;
}


//IQ
-(void)setIQ:(NSUInteger)IQ {
	_IQ = IQ;
	[self updateIQLabel];
}

-(NSUInteger) IQRate {
	int mecoScientistCount = 0;
	for (MECOPerson *person in self.allMecos)
	{
		if ([person.job isEqual:self.jobsByTitle[MECOScientistJobTitle]])
			mecoScientistCount += 1;
	}
	return mecoScientistCount * 10;
}
-(NSString *)IQLabel{
	return [NSString stringWithFormat:@"%u - %u/min", self.IQ, self.IQRate];
}
-(void) updateIQLabel{
	self.IQCount.text = self.IQLabel;
	[self.IQCount sizeToFit];
}
-(NSUInteger) IQSubtract{
	//IQ = IQ - costOfItem
	return self.IQ;
}


-(void)viewDidLoad {
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	
	self.jobs = [MECOJob jobsWithWorld:self];
	self.jobsByTitle = [NSDictionary dictionaryWithObjects:self.jobs forKeys:[self.jobs valueForKey:@"title"]];
	
	[self performSegueWithIdentifier:@"pageViewController" sender:self];
	
	NSMutableArray *islandViewControllers = [NSMutableArray new];
	NSUInteger islandIndex = 0;
	self.islands = [MECOIsland allIslands];
	for (MECOIsland *island in self.islands) {
		MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
		controller.view.frame = self.pageViewController.view.bounds;
		controller.island = island;
		if (islandIndex == 0) {
			[controller addMecoWithJob:self.jobsByTitle[MECOScientistJobTitle]];
			[controller addMecoWithJob:self.jobsByTitle[MECOFarmerJobTitle]];
			[controller addMecoWithJob:self.jobsByTitle[MECOTailorJobTitle]];
            [self updatePopulationLabel];
			[self updateIQLabel];
		}
		controller.worldViewController = self;
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


-(IBAction)showBuildMenu:(id)sender {
	[self.currentIslandViewController showBuildMenu:sender];
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
