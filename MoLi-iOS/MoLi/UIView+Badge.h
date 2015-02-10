//
//  UIView+Badge.h
//  MLTBadgedView
//
//  Created by Robert Rasmussen on 10/2/10.
//  Copyright 2010 Moonlight Tower. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kBadgePlacementUpperLeft,
  kBadgePlacementUpperRight,
  kBadgePlacementUpperBest
} MLTBadgePlacement;


@interface MLTBadgeView : UIView {
  
}
// Determines where badge is placed
@property MLTBadgePlacement placement;
// The numeric value to display on the badge
@property (nonatomic, assign) NSInteger badgeValue;
// The font for the badge number
@property(nonatomic, strong) UIFont *font;
// The interior color of the badge
@property(nonatomic, strong) UIColor *badgeColor;
// The color for badge text
@property(nonatomic, strong) UIColor *textColor;
// The outline color for the badge
@property(nonatomic, strong) UIColor *outlineColor;
// The width of the outline around the badge
@property (nonatomic, assign) float outlineWidth;
// Force the badge to a minimum size
@property (nonatomic, assign) float minimumDiameter;
// Show the badge no matter what
@property BOOL displayWhenZero;
@end

// Addition to UIView which allows any UIView to display
// a badge in the upper left or upper right corner of
// the view.
@interface UIView(Badged)
@property(nonatomic, readonly) MLTBadgeView *badge;
@end