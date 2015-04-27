//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Sample Value for Category / Components / Rating
        NSMutableDictionary *cat1 = [@{
                                       @"title" : @"Category1",
                                       @"color" : @"c3986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Comp1",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"2"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp2",
                                                             @"color" : @"f87c4f",
                                                             @"rating" : @"1"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp3",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"5"
                                                             } mutableCopy]
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        NSMutableDictionary *cat2 = [@{
                                       @"title" : @"Benleyaasdfsdafsdafpwafasdfsadhfl",
                                       @"color" : @"c3986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Layer",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"3"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Visual",
                                                             @"color" : @"d87c4f",
                                                             @"rating" : @"5"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp3",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"2"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp4",
                                                             @"color" : @"e87c4f",
                                                             @"rating" : @"4"
                                                             } mutableCopy],
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        NSMutableDictionary *cat3 = [@{
                                       @"title" : @"Category3",
                                       @"color" : @"43986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Comp1",
                                                             @"color" : @"a87cff",
                                                             @"rating" : @"4"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Good",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"5"
                                                             } mutableCopy]
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        NSMutableDictionary *cat4 = [@{
                                       @"title" : @"Category4Category4Category4",
                                       @"color" : @"c3986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Comp1",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"3"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp2",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"3"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Good",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"1"
                                                             } mutableCopy]
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        NSMutableDictionary *cat5 = [@{
                                       @"title" : @"Category5",
                                       @"color" : @"f3986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Comp1Comp1Comp1",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"5"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp2",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"2"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp3",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"3"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp4",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"1"
                                                             } mutableCopy]
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        NSMutableDictionary *cat6 = [@{
                                       @"title" : @"Category6Category6Category6",
                                       @"color" : @"c3986b",
                                       @"components" : [
                                                        @[
                                                          [@{
                                                             @"title" : @"Comp1",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"5"
                                                             } mutableCopy],
                                                          [@{
                                                             @"title" : @"Comp2Comp2Comp2",
                                                             @"color" : @"a87c4f",
                                                             @"rating" : @"4"
                                                             } mutableCopy]
                                                          ] mutableCopy
                                                        ]
                                       } mutableCopy];
        
        _categories = [[NSMutableArray alloc] init];
        _categories = [@[cat1, cat2, cat3, cat4, cat5, cat6] mutableCopy];
    }
    return self;
}

@end
