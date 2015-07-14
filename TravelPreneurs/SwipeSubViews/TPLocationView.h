//
//  TPLocationView.h
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "calloutBezier.h"
#import "User.h"

@interface TPLocationView : UIView<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mMapView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;
@property (strong, nonatomic) NSMutableArray* annotations;
@property (strong, nonatomic) calloutBezier* calloutView;
@property User* user;

@property int lastLoadedCount;
@property int lastLoadedPage;
@property int page;


-(void)initialize:(User*)user;
@end
