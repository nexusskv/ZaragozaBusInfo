//
//  BusListViewController.m
//  ZaragozaBusInfo
//
//  Created by rost on 29.03.16.
//  Copyright © 2016 Rost Gress. All rights reserved.
//

#import "BusListViewController.h"
#import "ApiConnector.h"
#import "BusInfoCell.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"


#define BACKGROUND_COLOR     [UIColor colorWithRed:247.0f/255.0f green:241.0f/255.0f blue:226.0f/255.0f alpha:1.0f]
#define CUSTOM_ORANGE_COLOR  [UIColor colorWithRed:255.0f/255.0f green:192.0f/255.0f blue:94.0f/255.0f alpha:1.0f]
#define IMAGE_URL            @"https://maps.googleapis.com/maps/api/staticmap?zoom=17&size=200x120&sensor=true&center"


@interface BusListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITableView *busListTable;
@end


@implementation BusListViewController

#pragma mark - View life cycle
- (void)loadView {
    [super loadView];

    self.title = @"Zaragoza’s Bus Info";
    
    self.busListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.busListTable.delegate            = self;
    self.busListTable.dataSource          = self;
    self.busListTable.backgroundColor     = BACKGROUND_COLOR;
    self.busListTable.separatorStyle      = UITableViewCellSeparatorStyleSingleLine;
    self.busListTable.tableFooterView     = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.busListTable respondsToSelector:@selector(setSeparatorInset:)])
        [self.busListTable setSeparatorInset:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f)];
    
    NSDictionary *subViews = @{@"busListTable"    : self.busListTable};
    
    NSArray *subViewsFormats = @[@"H:|[busListTable]|",
                                 @"V:|[busListTable]|"];
    
    [self addViews:subViews toSuperview:self.view withConstraints:subViewsFormats];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [SVProgressHUD show];
    
    ApiConnector *apiConnector = [[ApiConnector alloc] initWithCallback:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count] > 0) {
                NSMutableArray *busSortValues = [NSMutableArray arrayWithArray:responseObject];
                [busSortValues sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
                
                self.dataArray = busSortValues;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.busListTable reloadData];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Bus info loading error!"
                                                                                         message:responseObject
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {}];
                
                [alertController addAction:defaultAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    
    [apiConnector loadBusesInfo];
}
#pragma mark -


#pragma mark - TableView dataSource & delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BusInfoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *busValues = self.dataArray[indexPath.row];    
    
    if (busValues[@"subtitle"]) {
        cell.busInfoLabel.text = [NSString stringWithFormat:@"%@ - %@ [%@]", busValues[@"id"], busValues[@"title"], busValues[@"subtitle"]];
    } else {
        cell.busInfoLabel.text = [NSString stringWithFormat:@"%@ - %@", busValues[@"id"], busValues[@"title"]];
    }

    NSString *imageUrl = [NSString stringWithFormat:@"%@=%@,%@", IMAGE_URL, busValues[@"lat"], busValues[@"lon"]];

    [cell.locationImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = (BusInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell     = [[BusInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.tag = indexPath.row;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor  = CUSTOM_ORANGE_COLOR;
        cell.backgroundView     = bgView;
        cell.backgroundColor    = CUSTOM_ORANGE_COLOR;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}
#pragma mark -


#pragma mark - addViews:toSuperview:withConstraints:
- (void)addViews:(NSDictionary *)views toSuperview:(UIView *)superview withConstraints:(NSArray *)formats {
    for (UIView *view in views.allValues) {
        [superview addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    for (NSString *formatString in formats) {
        [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
}
#pragma mark -

@end
