

#import "LocationSearchViewController.h"
#import "AppDelegate.h"
#import "LocationSearchCell.h"
#import "LocationSearchCommonCell.h"

static NSString *commonIdentifier = @"LocationSearchCommon";
static NSString *CellIdentifier = @"LocationSearchCell";

@interface LocationSearchViewController ()<UISearchBarDelegate,UITextFieldDelegate>{
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
    BOOL isSearching;
    NSArray *locationList;
    IBOutlet LocationSearchCell *locationCell;
    BOOL isFirstLaunch;
    BOOL isSearchTextCleared;
    BOOL isBottomSearchClicked;
    NSInteger numberOfCellsToDisplay;
}

@property (strong, nonatomic) IBOutlet UITableView *tblContentList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation LocationSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstLaunch = YES;

    
    self.locationNotFoundView.hidden = YES;
    [self.searchBar setDelegate:self];
    [self.searchBar setImage:[UIImage imageNamed: @"LocationIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar sizeToFit];
    _searchBar.text = self.searchText;
    
    self.navigationController.navigationBarHidden = YES;
    contentList = [[NSMutableArray alloc]init];
    filteredContentList = [[NSMutableArray alloc] init];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UINib *nib = [UINib nibWithNibName:@"LocationSearchCommonCell" bundle:nil];
    [_tblContentList registerNib:nib forCellReuseIdentifier:commonIdentifier];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTblContentList:nil];
    [self setSearchBar:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [_searchBar becomeFirstResponder];
    for(UIView *subView in _searchBar.subviews){
        for(UIView *subSecondView in subView.subviews){
            
            if([subSecondView isKindOfClass:UITextField.class]){
                
                [(UITextField*)subSecondView setDelegate:self];
                NSDictionary* d = [(UITextField*)subSecondView typingAttributes];
                
                NSMutableDictionary* md = [NSMutableDictionary dictionaryWithDictionary:d];
                
                md[NSBackgroundColorAttributeName] = [UIColor colorWithRed:227.0/255.0 green:241.0/255.0 blue:249.0/255.0 alpha:1.0];
                [(UITextField*)subSecondView setTypingAttributes:md];
                _searchBar.text = self.searchText;
            }
        }
    }
}


- (void)performSearch
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchBar.text;
   // request.region = self.region;
    
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(self.searchCoordinate, 1, 1);
    request.region = rgn;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    //request.naturalLanguageQuery = _searchBar.text;
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        [contentList removeAllObjects];
        for(MKMapItem *item in response.mapItems) {
            //if(contentList.count<numberOfCellsToDisplay)
                [contentList addObject:item];
            //else
               // break;

        }
        [self reloadContents];
    }];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (filteredContentList.count >0 || contentList.count > 0) {
        if (isBottomSearchClicked) {
            return 1;
        }
        return 2;
    }else{
        if(isFirstLaunch || [self.searchBar.text  isEqual: @""])
            return 0;
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (filteredContentList.count >0 || contentList.count > 0) {
        if (section == 0) {
            if (isSearching) {
                return [filteredContentList count];
            } else {
                return [contentList count];
            }
        }else{
            return 1;
        }
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    isBottomSearchClicked = NO;
    
    if (filteredContentList.count >0 || contentList.count > 0) {
        if (indexPath.section == 0) {
            LocationSearchCell *cell = (LocationSearchCell*)[self.tblContentList dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            if(cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"LocationSearchCell" owner:self options:nil];
                cell = (LocationSearchCell*)locationCell;
            }
            if (isSearching) {
                MKMapItem *item = [filteredContentList objectAtIndex:indexPath.row];
                cell.locationTitleLabel.text = item.name;
                cell.locationDetailLabel.text = item.placemark.title;
                
                if (indexPath.row == (filteredContentList.count - 1)) {
                    cell.locationBottomLabel.hidden = YES;
                }
                
            } else {
                MKMapItem *item = [contentList objectAtIndex:indexPath.row];
                cell.locationTitleLabel.text = item.name;
                cell.locationDetailLabel.text = item.placemark.title;
                
                if (indexPath.row == (contentList.count - 1)) {
                    cell.locationBottomLabel.hidden = YES;
                }
                
            }
            return cell;
            
            
        }else{
            LocationSearchCommonCell *cell = (LocationSearchCommonCell*)[self.tblContentList dequeueReusableCellWithIdentifier:commonIdentifier forIndexPath:indexPath];
            cell.searchLabel.text = [NSString stringWithFormat:@"Search for \"%@\"",self.searchBar.text];
            cell.imageView.image = [self getUpdatedImage];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        LocationSearchCommonCell *cell = (LocationSearchCommonCell*)[self.tblContentList dequeueReusableCellWithIdentifier:commonIdentifier  forIndexPath:indexPath];
        cell.imageView.image = [self getUpdatedImage];
        
        cell.searchLabel.text = [NSString stringWithFormat:@"Search for \"%@\"",self.searchBar.text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (filteredContentList.count >0 || contentList.count > 0) {
        
        if (indexPath.section == 0) {
            [self.view endEditing:YES];
            if (isSearching) {
                MKMapItem *item = filteredContentList[indexPath.row];
                CLLocationCoordinate2D coord = item.placemark.location.coordinate;
                NSString *lat = [NSString stringWithFormat:@"%f",coord.latitude];
                NSString *lon = [NSString stringWithFormat:@"%f",coord.longitude];
                NSDictionary* userInfo = @{@"lat": lat, @"lon": lon, @"location":item.placemark.name,@"mapItem":item};
                [self dismissViewControllerAnimated:YES completion:nil];
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"loadSearchLocation" object:self userInfo:userInfo];
            } else {
                MKMapItem *item = contentList[indexPath.row];
                CLLocationCoordinate2D coord = item.placemark.location.coordinate;
                NSString *lat = [NSString stringWithFormat:@"%f",coord.latitude];
                NSString *lon = [NSString stringWithFormat:@"%f",coord.longitude];
                NSDictionary* userInfo = @{@"lat": lat, @"lon": lon, @"location":item.placemark.name,@"mapItem":item};
                [self dismissViewControllerAnimated:YES completion:nil];
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"loadSearchLocation" object:self userInfo:userInfo];
            }
        }else{
            
            MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
            request.naturalLanguageQuery = self.searchBar.text;
            request.region = _region;
            MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
            [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                if (contentList.count>0 ) {
                    [contentList removeAllObjects];
                }
                
                if (filteredContentList.count>0 ) {
                    [filteredContentList removeAllObjects];
                }
                
                for(MKMapItem *item in response.mapItems) {
                   // if(contentList.count<numberOfCellsToDisplay)
                        [contentList addObject:item];
                   // else
                      //  break;

                }
                if (contentList.count>0) {
                    isBottomSearchClicked = YES;
                    [self reloadContents];
                }else{
                    NSLog(@"No Location Found");
                    self.locationNotFoundView.hidden = NO;
                }
            }];
        }
    }else{
        //[self.view endEditing:YES];

        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = self.searchBar.text;
        request.region = _region;
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (contentList.count>0 ) {
                [contentList removeAllObjects];
            }
            
            if (filteredContentList.count>0 ) {
                [filteredContentList removeAllObjects];
            }
            
            for(MKMapItem *item in response.mapItems) {
                
              [contentList addObject:item];
            }
            
            if (contentList.count>0) {
                [self reloadContents];
            }else{
                self.locationNotFoundView.hidden = NO;
            }
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sampleView = [[UIView alloc] init];
    sampleView.frame = CGRectMake(0, 0 , self.view.frame.size.width, 44);
    sampleView.backgroundColor = [UIColor clearColor];
    return sampleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (void)searchTableList
{
    for (MKMapItem *tempItem in contentList) {
      //  if(filteredContentList.count<numberOfCellsToDisplay)
       [filteredContentList addObject:tempItem];
        [self.tblContentList reloadData];
        self.locationNotFoundView.hidden = YES;
    }
}


-(void)reloadContents
{
    if([self.searchBar.text length] != 0) {
        isSearching = YES;
        [self searchTableList];
    } else {
        isSearching = NO;
    }
}

#pragma mark - Search Bar Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (isFirstLaunch) {
        isFirstLaunch = NO;
        for(UIView *subView in _searchBar.subviews){
            for(UIView *subSecondView in subView.subviews){
                
                if([subSecondView isKindOfClass:UITextField.class]){
                    
                    NSDictionary* d = [(UITextField*)subSecondView typingAttributes];
                    NSMutableDictionary* md = [NSMutableDictionary dictionaryWithDictionary:d];
                    md[NSBackgroundColorAttributeName] = [UIColor colorWithRed:227.0/255.0 green:241.0/255.0 blue:249.0/255.0 alpha:1.0];
                    [(UITextField*)subSecondView setTypingAttributes:md];
                    
                }
            }
        }
    }
    
    
    [self performSearch];
    //Remove all objects first.
    [contentList removeAllObjects];
    [filteredContentList removeAllObjects];
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    } else {
        isSearching = NO;
    }
    [self.tblContentList reloadData];
    self.locationNotFoundView.hidden = YES;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSDictionary* userInfo = @{@"lat": @"", @"lon": @"", @"location":@"NoSearch",@"mapItem":@""};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"loadSearchLocation" object:self userInfo:userInfo];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (isSearchTextCleared && [searchBar.text  isEqual: @""]) {
        searchBar.text = self.searchText;
        isSearchTextCleared = NO;
    }
       // [searchBar resignFirstResponder];
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = searchBar.text;
        request.region = _region;
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            [contentList removeAllObjects];
            [filteredContentList removeAllObjects];
            for(MKMapItem *item in response.mapItems) {
                [contentList addObject:item];
            }
            [self reloadContents];
        }];

}

#pragma mark UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (isFirstLaunch) {
        textField.text = @"";
        isFirstLaunch = NO;
        isSearchTextCleared = YES;
        NSDictionary* d = [textField typingAttributes];
        
        NSMutableDictionary* md = [NSMutableDictionary dictionaryWithDictionary:d];
        
        md[NSBackgroundColorAttributeName] = [UIColor colorWithRed:227.0/255.0 green:241.0/255.0 blue:249.0/255.0 alpha:1.0];
        [textField setTypingAttributes:md];
    }
    return YES;
}


-(UIImage*)getUpdatedImage{
    UIImage *image = [UIImage imageNamed:@"SearchIcon.png"];
    
    CGRect rect = CGRectMake(0, 0,10, 14);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context,[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);// [[UIColor grayColor] CGColor]
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    return flippedImage;
}



@end
