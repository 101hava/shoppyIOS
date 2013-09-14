//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "RecipeBookViewController.h"
#import "RecipeDetailViewController.h"

#define AMPERSAND @"&"

@interface RecipeBookViewController ()

@property(nonatomic, strong)   CLLocationManager *locationManager;
@property(nonatomic, strong)    CLLocation *bestEffortAtLocation;

@end

@implementation RecipeBookViewController {
    NSMutableArray *recipes;
    NSArray *searchResults;
    
}

@synthesize tableView = _tableView;
@synthesize locationManager;
@synthesize bestEffortAtLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    bestEffortAtLocation = nil;
    
    [self buildRequest];
    recipes = [[NSMutableArray alloc] initWithCapacity:0];
    // recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}



-(NSString*) addFKParams:(NSDictionary*)paramsDict ToUrl:(NSString*)uriStr
{
    NSMutableString* returnUrl = [NSMutableString stringWithString:uriStr];
    if(uriStr)
    {
        if(paramsDict)
        {
            if([uriStr rangeOfString:@"?"].location == NSNotFound)
            {
                [returnUrl appendString:@"?"];
            }
            else
            {
                [returnUrl appendString:AMPERSAND];
            }
            NSMutableArray* parametersArray = [[NSMutableArray alloc] init];
            [paramsDict enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
                if(key && ![key isEqualToString:@""])
                    [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
                else
                    [parametersArray addObject:[NSString stringWithFormat:@"%@", obj]];
            }];
            [returnUrl appendString:[parametersArray componentsJoinedByString:AMPERSAND]];
        }
    }
    return returnUrl;
}

-(void) buildRequest
{
    NSString* apiUrl = @"http://pavansri.apiary.io/shopping-cart";
    if(bestEffortAtLocation)
    {
        NSString *currentLatitude = [[NSString alloc]
                                     initWithFormat:@"%g",
                                     bestEffortAtLocation.coordinate.latitude];
        //latitude.text = currentLatitude;
        
        NSString *currentLongitude = [[NSString alloc]
                                      initWithFormat:@"%g",
                                      bestEffortAtLocation.coordinate.longitude];
        NSDictionary* latLongDict = [[NSDictionary alloc] initWithObjectsAndKeys:currentLatitude, @"lat", currentLongitude, @"long", nil];
        
        [self addFKParams:latLongDict ToUrl:apiUrl];
        
    }
    
    NSLog(@"Request Url = %@", apiUrl);
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        
        NSLog(@"Connection establisted successfully");
        
    } else {
        
        NSLog(@"Connection failed.");
        
    }
    
    NSURLResponse* response = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@", res);
    
    // show all values
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"items"];
    
    for (NSDictionary *result in results) {
        NSString *nameStr = [result objectForKey:@"name"];
        [recipes addObject:nameStr];
    }
    
    [self.tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%g",
                                 newLocation.coordinate.latitude];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%g",
                                  newLocation.coordinate.longitude];
    
    //If the location changes update or else no.
    if(bestEffortAtLocation
       && bestEffortAtLocation.coordinate.longitude == newLocation.coordinate.longitude
       && bestEffortAtLocation.coordinate.latitude == newLocation.coordinate.latitude)
    {
        //Do nothing.
    }
    else{
        bestEffortAtLocation = newLocation;
        [self buildRequest];
    }
    
    //NSLog(@"lat = %@ long = %@", currentLatitude, currentLongitude);
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [recipes count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        RecipeDetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destViewController.recipeName = [searchResults objectAtIndex:indexPath.row];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        }
    }
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

/*
 - (BOOL)searchDisplayController:(UISearchDisplayController *)controller
 shouldReloadTableForSearchScope:(NSInteger)searchOption
 {
 [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
 objectAtIndex:searchOption]];
 
 return YES;
 }
 
 */
@end
