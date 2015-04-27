//
//  CommonUtils.m
//


#import "CommonUtils.h"

@implementation CommonUtils

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (UIColor *) getUIColorFromHexString: (NSString *)hexStr {
    unsigned int rgbValue;
    [[NSScanner scannerWithString:hexStr] scanHexInt:&rgbValue];
    return [UIColor \
            colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

- (CGRect) getCGRectFromRadius: (float)radius withFormat: (CGRect) containerFrame {
    return CGRectMake(containerFrame.size.width / 2 - radius, containerFrame.size.height / 2 - radius, radius * 2, radius * 2);
}

- (NSString *) getFilteredString: (NSString *)str withLength: (int)length {
    if([str length] < length) {
        return str;
    } else {
        NSString *filteredStr = [str substringWithRange:NSMakeRange(0, length - 2)];
        filteredStr = [filteredStr stringByAppendingString:@"..."];
        return filteredStr;
    }
}
@end
