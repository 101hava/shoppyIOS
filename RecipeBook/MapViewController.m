//
//  MapViewController.m
//  RecipeBook
//
//  Created by Pavan Srinivas on 15/09/13.
//
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CLLocationDegrees lat = 12.917745600000000000;
    CLLocationDegrees longi = 77.623788300000000000;
    CLLocationCoordinate2D destination =  CLLocationCoordinate2DMake(lat,longi);
    
    CMMapPoint* mapPoint = [CMMapPoint mapPointWithCoordinate:destination];
    
    [CMMapLauncher launchMapApp:CMMapAppGoogleMaps forDirectionsFrom:[CMMapPoint currentLocation] to:mapPoint];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
