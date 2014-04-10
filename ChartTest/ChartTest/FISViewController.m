//
//  FISViewController.m
//  ChartTest
//
//  Created by Andrea McClave on 4/10/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "FISViewController.h"
#import <TEAClockChart.h>
#import <TEABarChart.h>

// Link to cocoapod: https://github.com/xhacker/TEAChart

@interface FISViewController ()

//@property (weak, nonatomic) IBOutlet TEAClockChart *clockChart;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TEABarChart *barChart = [[TEABarChart alloc] initWithFrame:CGRectMake(20, 20, 280, 100)];
    barChart.barColor = [UIColor orangeColor];
    barChart.backgroundColor = [UIColor blueColor];
    //@[[UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]];
    barChart.data = @[@0, @7, @10, @8, @2, @8];
    [self.view addSubview:barChart];
    
    UILabel *chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 200, 40)];
    chartLabel.text = @"CHART LABEL TEST";
    chartLabel.textColor = [UIColor blueColor];
    
    [self.view addSubview:chartLabel];
    
//    self.clockChart.data = @[[TEATimeRange timeRangeWithStart:[NSDate date] end:[NSDate dateWithTimeIntervalSinceNow:3600]]
//                             // ...
//                             ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
