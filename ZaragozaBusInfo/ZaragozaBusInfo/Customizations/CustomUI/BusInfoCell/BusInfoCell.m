//
//  BusInfoCell.m
//  ZaragozaBusInfo
//
//  Created by rost on 29.03.16.
//  Copyright © 2016 Rost Gress. All rights reserved.
//

#import "BusInfoCell.h"

@implementation BusInfoCell


#pragma mark - Constructor
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.busInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.busInfoLabel.textColor        = [UIColor blackColor];
        self.busInfoLabel.font             = [UIFont fontWithName:@"Helvetica" size:16.0f];
        self.busInfoLabel.backgroundColor  = [UIColor clearColor];
        self.busInfoLabel.lineBreakMode    = NSLineBreakByWordWrapping;
        self.busInfoLabel.numberOfLines    = 3;
        self.busInfoLabel.textAlignment    = NSTextAlignmentLeft;
        
        self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.locationImageView.contentMode  = UIViewContentModeScaleAspectFit;
        
        NSDictionary *viewsValues = @{@"busInfoLabel"       : self.busInfoLabel,
                                      @"locationImageView"  : self.locationImageView};
        
        NSArray *subViewsFormats = @[@"H:|-(10)-[busInfoLabel]-[locationImageView(100)]-(10)-|",
                                     @"V:|-(10)-[busInfoLabel]-(5)-|",
                                     @"V:|-(5)-[locationImageView]-(5)-|"];
        
        [self addViews:viewsValues toSuperview:self withConstraints:subViewsFormats];
    }
    
    return self;
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
