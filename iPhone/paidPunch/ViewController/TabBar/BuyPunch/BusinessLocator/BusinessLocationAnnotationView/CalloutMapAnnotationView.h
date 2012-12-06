#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CalloutMapAnnotationView : MKAnnotationView {
	MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
}

@property (nonatomic, strong) MKAnnotationView *parentAnnotationView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;

- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;

@end
