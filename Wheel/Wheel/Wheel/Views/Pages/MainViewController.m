//
//  MainViewController.m
//  SchMuck
//
//  Created by Mac on 30/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController () {
    NSMutableArray *categories;
    NSInteger totalComponentsCount, totalCategoriesCount;
    
    CGRect mainFrame;
    float angleMargin, ratioRadiusMargin, radiusMargin;
    float ratioArcRadiusCategory, ratioArcRadiusComponent, ratioArcRadiusGraph, ratioArcRadiusGraphOuterMargin, ratioArcRadiusCenter;
    float radiusTotal, radiusCategory, radiusComponent, radiusGraph, radiusCenter;
    int maxRating;
    NSString *colorCenter, *colorGraphBackground, *colorGraph;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    NSLog(@"%@", categories);
}

- (void)viewDidLayoutSubviews {
    [self drawArcCategories];
    [self drawArcComponents];
    [self drawArcGraphBackground];
    [self drawArcCenter];
    [self drawArcGraph];
    [self drawArcCategoriesText];
    [self drawArcComponentsText];
}

#pragma init settings
- (void)initValue {
    
    categories = [[NSMutableArray alloc] init];
    categories = appController.categories;
    
    totalCategoriesCount = [categories count];
    totalComponentsCount = 0;
    for(NSMutableDictionary *dicCategory in categories) {
        NSInteger componentsCount = [[dicCategory objectForKey:@"components"] count];
        totalComponentsCount += componentsCount;
        [dicCategory setObject:[NSString stringWithFormat:@"%ld", (long)componentsCount] forKey:@"componentsCount"];
    }
    
    mainFrame = self.mainView.frame;
    
    // Ratio values for each circle radius compared to entire frame radius
    // You can customize these values
    
    maxRating = 5;
    
    angleMargin = 0.001;
    ratioRadiusMargin = 0.00001f;

    ratioArcRadiusCategory = 0.13;
    ratioArcRadiusComponent = 0.14;
    ratioArcRadiusCenter = 0.11;
    ratioArcRadiusGraphOuterMargin = 0.08;
    ratioArcRadiusGraph = ratioArcRadiusCenter * maxRating;
    //ratioArcRadiusGraph = 1.0 - ratioArcRadiusCategory - ratioArcRadiusComponent - ratioArcRadiusCenter - ratioArcRadiusGraphOuterMargin - (ratioRadiusMargin * 3);
    
    radiusTotal = mainFrame.size.width / 2.0f;
    radiusMargin = radiusTotal * ratioRadiusMargin;
    
    radiusCategory = radiusTotal * (1.0 - ratioRadiusMargin);
    radiusComponent = radiusTotal * (1.0 - ratioArcRadiusCategory - (ratioRadiusMargin * 2));
    //radiusGraph = radiusTotal * (1.0 - ratioArcRadiusCategory - ratioArcRadiusComponent - ratioArcRadiusGraphOuterMargin - (ratioRadiusMargin * 3));
    
    radiusCenter = (float)radiusTotal * ratioArcRadiusCenter;
    radiusGraph = radiusCenter * (float)maxRating;
    
    colorCenter = @"a87c4f";
    colorGraphBackground = @"F9F9F9";
    colorGraph = @"AAAAAA";
    
    
}

#pragma draw Arc
// Category Arc
- (void)drawArcCategories {
    SHPieChartView *chart = [[SHPieChartView alloc] initWithFrame:[commonUtils getCGRectFromRadius:radiusCategory withFormat:mainFrame]];
    chart.chartBackgroundColor = [UIColor whiteColor];
    chart.isConcentric = YES;
    chart.concentricRadius = radiusComponent + radiusMargin;
    chart.concentricColor = [UIColor whiteColor];
    for(NSMutableDictionary *dicCategory in categories) {
        [chart addAngleValue:(([[dicCategory objectForKey:@"componentsCount"] intValue] / (float)totalComponentsCount) - angleMargin) andColor:[commonUtils getUIColorFromHexString:[dicCategory objectForKey:@"color"]]];
        [chart addAngleValue:angleMargin andColor:[UIColor whiteColor]];
        
    }
    [self.mainView addSubview:chart];
}
// Components Arc
- (void)drawArcComponents {
    SHPieChartView *chart = [[SHPieChartView alloc] initWithFrame:[commonUtils getCGRectFromRadius:radiusComponent withFormat:mainFrame]];
    chart.chartBackgroundColor = [UIColor whiteColor];
    chart.isConcentric = YES;
    chart.concentricRadius = radiusGraph + ratioArcRadiusGraphOuterMargin * radiusTotal;
    chart.concentricColor = [UIColor whiteColor];
    for(NSMutableDictionary *dicCategory in categories) {
        NSMutableArray *arrComponents = [[NSMutableArray alloc] init];
        arrComponents = [dicCategory objectForKey:@"components"];
        for(NSMutableDictionary *dicComponent in arrComponents) {
            [chart addAngleValue:((1.0 / (float)totalComponentsCount) - angleMargin) andColor:[commonUtils getUIColorFromHexString:[dicComponent objectForKey:@"color"]]];
            [chart addAngleValue:angleMargin andColor:[UIColor whiteColor]];
        }
    }
    [self.mainView addSubview:chart];
}
// Graph Arc Background
- (void)drawArcGraphBackground {
    int i = 0;
    for(; i < maxRating - 1; i++) {
        float radius = radiusGraph - ((float)i * ((radiusGraph - radiusCenter) / (float)(maxRating - 1)));
        SHPieChartView *chart = [[SHPieChartView alloc] initWithFrame:[commonUtils getCGRectFromRadius:radius + 3.5f withFormat:mainFrame]];
        chart.isConcentric = YES;
        chart.concentricRadius = radius - 3.5f;
        chart.concentricColor = [UIColor whiteColor];
        [chart addAngleValue:1.0 andColor:[commonUtils getUIColorFromHexString:colorGraphBackground]];
        [self.mainView addSubview:chart];
    }
}
// Graph
- (void)drawArcGraph {
    SHPieChartView *chart = [[SHPieChartView alloc] initWithFrame:[commonUtils getCGRectFromRadius:radiusCategory withFormat:mainFrame]];
    chart.isGraph = YES;
    chart.graphColor = [commonUtils getUIColorFromHexString:colorGraph];
    chart.graphCount = (int)totalComponentsCount;
    chart.graphPointRadius = 3.0f;
    chart.graphRadius = radiusCenter - 1.8f;
    chart.graphData = categories;
    [self.mainView addSubview:chart];
}
// Center Circle Arc
- (void)drawArcCenter {
    SHPieChartView *chart = [[SHPieChartView alloc] initWithFrame:[commonUtils getCGRectFromRadius:radiusCenter withFormat:mainFrame]];
    [chart addAngleValue:1.0 andColor:[commonUtils getUIColorFromHexString:colorCenter]];
    [self.mainView addSubview:chart];
}

#pragma draw Arc Texts
- (void)drawArcCategoriesText {

    UIFont *font = [UIFont systemFontOfSize:18.0f];
    UIColor *color = [UIColor whiteColor];
    float letterWidth = 2.6f;
    
    CGPoint centerPoint = CGPointMake(mainFrame.size.width / 2.0, mainFrame.size.height / 2.0);
    float radius = radiusCategory, filterCharLength = 12.0;
    float angle = 0, itemAngle, centerItemAngle, itemRadian;
    float x, y, centerX, centerY, w, h = radiusCategory, arcRadiusHeight = radiusTotal * (1 - ratioArcRadiusCategory);
    CGRect itemRect;
    NSString *itemText;
    
    for(NSMutableDictionary *dicCategory in categories) {
        
        
        itemAngle = (([[dicCategory objectForKey:@"componentsCount"] intValue] / (float)totalComponentsCount) - angleMargin) * 360.0f;
        centerItemAngle = angle + (itemAngle / 2.0f);
        
        centerX = centerPoint.x + (sin(DEGREES_RADIANS(centerItemAngle)) * radius / 2.13);
        centerY = centerPoint.y - (cos(DEGREES_RADIANS(centerItemAngle)) * radius / 2.13);
        w = radius * 2 * M_PI * (float)[[dicCategory objectForKey:@"componentsCount"] intValue] / (float)totalComponentsCount;
        x = centerX - (w / 2.0f);
        y = centerY - (h / 2.0f);
        
        itemRect = CGRectMake(x, y, w, h);
        
        itemText = [commonUtils getFilteredString:[dicCategory objectForKey:@"title"] withLength:(int)(w / filterCharLength)];
        
        
        CoreTextArcView *textLabel = [[CoreTextArcView alloc] initWithFrame:itemRect
                                                                        font:font
                                                                        text:itemText
                                                                      radius:arcRadiusHeight
                                                                     arcSize:[itemText length] * letterWidth
//                                                                    arcSize:w / 5.2f
                                                                       color:color];
        textLabel.backgroundColor = [UIColor clearColor];
    
        itemRadian = DEGREES_RADIANS(centerItemAngle);
        textLabel.layer.transform = CATransform3DMakeRotation(itemRadian, 0, 0, 1);
        [self.mainView addSubview:textLabel];
        
        angle += itemAngle + (angleMargin * 360.0f);
    }

}

- (void)drawArcComponentsText {
    
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    UIColor *color = [UIColor whiteColor];
    float letterWidth = 2.4f;
    
    CGPoint centerPoint = CGPointMake(mainFrame.size.width / 2.0, mainFrame.size.height / 2.0);
    float radius = radiusComponent, filterCharLength = 10.0;
    float angle = 0, itemAngle, centerItemAngle, itemRadian;
    float x, y, centerX, centerY, w, h = radiusComponent, arcRadiusHeight = radiusTotal * (1 - ratioArcRadiusCategory - ratioRadiusMargin - ratioArcRadiusComponent);
    CGRect itemRect;
    NSString *itemText;
    
    for(NSMutableDictionary *dicCategory in categories) {
        
        NSMutableArray *arrComponents = [[NSMutableArray alloc] init];
        arrComponents = [dicCategory objectForKey:@"components"];
        for(NSMutableDictionary *dicComponent in arrComponents) {
            
            itemAngle = ((1 / (float)totalComponentsCount) - angleMargin) * 360.0f;
            centerItemAngle = angle + (itemAngle / 2.0f);
            
            centerX = centerPoint.x + (sin(DEGREES_RADIANS(centerItemAngle)) * radius / 2.4);
            centerY = centerPoint.y - (cos(DEGREES_RADIANS(centerItemAngle)) * radius / 2.4);
            w = radius * 2 * M_PI / (float)totalComponentsCount;
            x = centerX - (w / 2.0f);
            y = centerY - (h / 2.0f);
            
            itemRect = CGRectMake(x, y, w, h);
            
            itemText = [commonUtils getFilteredString:[dicComponent objectForKey:@"title"] withLength:(int)(w / filterCharLength)];
            
            CoreTextArcView *textLabel = [[CoreTextArcView alloc] initWithFrame:itemRect
                                                                           font:font
                                                                           text:itemText
                                                                         radius:arcRadiusHeight
                                                                        arcSize:([itemText length]) * letterWidth
//                                                                                                              arcSize:w / 4.4f
                                                                          color:color];
            textLabel.backgroundColor = [UIColor clearColor];
            
            itemRadian = DEGREES_RADIANS(centerItemAngle);
            textLabel.layer.transform = CATransform3DMakeRotation(itemRadian, 0, 0, 1);
            [self.mainView addSubview:textLabel];
            
            angle += itemAngle + (angleMargin * 360.0f);
        }
    }
    

}

@end
