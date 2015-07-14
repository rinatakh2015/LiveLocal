//
//  TPLocationView.m
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPLocationView.h"
#import "TPMapAnnotation.h"
#import "AsyncImageView.h"
#import "MyUtils.h"
#import <CoreLocation/CoreLocation.h>
#import "APIClient.h"
#import "defs.h"
#import "global_functions.h"
#import "AppDelegate.h"
@implementation TPLocationView
{
    double oldZoomScale;
}
-(void)initialize:(User*)user{
    
    oldZoomScale = 0;
    
    self.user = user;
    self.lineSeparatorHeightConstraint.constant = 0.5;
    self.mMapView.delegate = self;
    self.annotations = [[NSMutableArray alloc] init];
    
    //[self sampleData];
    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;

    [[MyUtils shared] applyTranslation:self];
    
    [self.mMapView removeAnnotations:self.mMapView.annotations];
    
    TPMapAnnotation* myAnnotation = [[TPMapAnnotation alloc] initWithUser:self.user];
    [self.mMapView addAnnotation:myAnnotation];

    if([self isForMe])
    {
        /*CLLocationCoordinate2D mapCenter;
        mapCenter.latitude =  myAnnotation.coordinate.latitude;
        mapCenter.longitude = myAnnotation.coordinate.longitude;
        MKCoordinateSpan mapSpan;
        mapSpan.latitudeDelta = 0.01;
        mapSpan.longitudeDelta = 0.01;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapCenter;
        mapRegion.span = mapSpan;
        
        [self.mMapView setRegion:mapRegion];*/
        
        dispatch_queue_t queue = dispatch_queue_create("nearby_user_search", 0);
        dispatch_async(queue, ^{
            [self loadData];
        });
        
    }
    else{
        TPMapAnnotation* myAnnotation1 = [[TPMapAnnotation alloc] initWithUser:[MyUtils shared].user];
        [self.mMapView addAnnotation:myAnnotation1];
        [self fitMapToAnnotations];
    }
    
}

- (BOOL) isForMe
{
    return [MyUtils shared].user.identifier == self.user.identifier;
}
-(void)loadData
{
    [APIClient getFavouriteUsers:COUNTS_PER_PAGE Page:_page completionHandler:^(NSMutableArray *passedResponse, NSError *error) {
        if (!error) {
            
            //If it is already loaded data, ignore it
            if (_page <= _lastLoadedPage) {
                return;
            }
            
            if(_page == 0)
            {
                [self.annotations removeAllObjects];
            }
            
            _lastLoadedCount = [passedResponse count];
            _lastLoadedPage = _page;
            
            if (_lastLoadedCount > 0) {
                for (User* user in passedResponse) {
                    TPMapAnnotation* annotation = [[TPMapAnnotation alloc] initWithUser:user];
                    [self.annotations addObject:annotation];
                    [self.mMapView addAnnotation:annotation];
                }
            }
            
            [self fitMapToAnnotations];
            
            if ( _lastLoadedCount == COUNTS_PER_PAGE ) {
                _page++;
                [self loadData];
            }
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];
    
}

-(void) fitMapToAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mMapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    if(self.mMapView.annotations.count > 1)
    {
        zoomRect.origin.y -= 1500;
    }
    else {
        zoomRect.origin.y -= 1000;
    }
    zoomRect.origin.x -= 1000;
    zoomRect.size.width += 2000;
    zoomRect.size.height += 1500;

    [self.mMapView setVisibleMapRect:zoomRect animated:NO];

}

-(void) addAnotationWithCoordinate:(CLLocationCoordinate2D*) coordinate
{

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    MKAnnotationView *annotationView = (MKAnnotationView *) [self.mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ([annotation isKindOfClass:[TPMapAnnotation class]]) {
        
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        TPMapAnnotation *myFamily = [[TPMapAnnotation alloc] init];
        myFamily = annotation;
        
        AsyncImageView *profilePic = [[AsyncImageView alloc] initWithFrame:CGRectMake(3.5, 3.5, 41, 41)];
        if (myFamily.imageURL ) {
            [profilePic loadImageFromURL:[NSURL URLWithString:myFamily.imageURL]];
        }
        else
            [profilePic setImage:[UIImage imageNamed:@"icon_defaultavatar.png"]];

        profilePic.layer.cornerRadius = 20;
        profilePic.clipsToBounds = YES;
        [annotationView addSubview:profilePic];
        annotationView.image = [UIImage imageNamed:@"marker.png"];
        annotationView.enabled = YES;
        [annotationView setCanShowCallout:NO];
        annotationView.centerOffset = CGPointMake(0, - annotationView.frame.size.height/2);
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
        
    }
    
    return nil;
}




- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *view in views) {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]]) {
            view.canShowCallout = NO;
        }
    }
}





- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

    TPMapAnnotation *annotation = [[TPMapAnnotation alloc] init];
    annotation = view.annotation;
    
    BOOL isUser = NO;
    if (annotation.userID == [MyUtils shared].user.identifier) {
        isUser = YES;
    }
    
    
    CGSize  calloutSize = CGSizeMake(200.0, 81.0);
    _calloutView = [[calloutBezier alloc] initWithFrame:CGRectMake(-calloutSize.width/2.75, -calloutSize.height, calloutSize.width, calloutSize.height)];
    _calloutView.backgroundColor = [UIColor clearColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, calloutSize.width - 10, 20)];
    if (isUser) {
        titleLabel.text = @"Me";
    } else {
        titleLabel.text = annotation.title;
    }
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    titleLabel.textColor = [UIColor blackColor];
    [_calloutView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, calloutSize.width - 10, 20)];
    subTitleLabel.text = annotation.subtitle;
    subTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    subTitleLabel.textColor = [UIColor blackColor];
    [_calloutView addSubview:subTitleLabel];
    
    [view addSubview:_calloutView];
    
    [self.mMapView setCenterCoordinate:annotation.coordinate animated:YES];
    
 
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [_calloutView removeFromSuperview];
    NSLog(@"Deslected");
}

/*-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    MKZoomScale currentZoomScale = (CGFloat)(mapView.bounds.size.width / mapView.visibleMapRect.size.width);

    
    if (oldZoomScale < currentZoomScale) {
        CGPoint nePoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
        CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
        
        //Then transform those point into lat,lng values
        CLLocationCoordinate2D neCoord;
        neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
        
        CLLocationCoordinate2D swCoord;
        swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
        
        double radius = sqrt( (neCoord.latitude - swCoord.latitude) * (neCoord.latitude - swCoord.latitude) + (neCoord.longitude - swCoord.longitude) * (neCoord.longitude - swCoord.longitude)) / 2.0;

    }
    
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
