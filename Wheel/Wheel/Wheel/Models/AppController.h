//  AppController.h
//  Created by BE

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableArray *categories;

+ (AppController *)sharedInstance;

@end