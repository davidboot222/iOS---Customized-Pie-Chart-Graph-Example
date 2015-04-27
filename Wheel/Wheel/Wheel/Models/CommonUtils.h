//  CommonUtils.h
//  Created by BE

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject {
    UIActivityIndicatorView *activityIndicator;
}
+ (instancetype)shared;

- (UIColor *) getUIColorFromHexString: (NSString *)hexStr; // Convert Hexa value in NSString format (e.g. @"F03D8E") into UIColor
- (CGRect) getCGRectFromRadius: (float)radius withFormat: (CGRect) containerFrame; // Get Rectangle Frame by Radius within the Container Frame
- (NSString *) getFilteredString: (NSString *)str withLength: (int)length;

@end