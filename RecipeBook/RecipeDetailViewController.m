//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()

@property(nonatomic, strong) CMMapLauncher* mapLauncher;
@end

@implementation RecipeDetailViewController

@synthesize mapLauncher;

@synthesize recipeLabel;
@synthesize recipeName;


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
    mapLauncher = [[CMMapLauncher alloc] init];
    CLLocationDegrees lat = 12.917745600000000000;
    CLLocationDegrees longi = 77.623788300000000000;
    CLLocationCoordinate2D destination =  CLLocationCoordinate2DMake(lat,longi);
    
    CMMapPoint* mapPoint = [CMMapPoint mapPointWithCoordinate:destination];
    
    [CMMapLauncher launchMapApp:CMMapAppGoogleMaps forDirectionsFrom:[CMMapPoint currentLocation] to:mapPoint];
    
	// Set the Label text with the selected recipe
    //recipeLabel.text = recipeName;
    
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    CLLocation* currentLocation = newLocation;
    NSLog(@"%@", currentLocation);
    if(currentLocation)
    {
        // this uses an address for the destination.  can use lat/long, too with %f,%f format
        NSString* address = @"Silk Board bangalore";
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                         currentLocation.coordinate.latitude, currentLocation.coordinate.longitude,
                         [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
