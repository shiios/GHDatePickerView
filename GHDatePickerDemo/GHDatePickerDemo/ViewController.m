//
//  ViewController.m
//  GHDatePickerDemo
//
//  Created by yin tian on 2018/11/22.
//  Copyright © 2018 yin tian. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDate *minDate = [NSDate br_setYear:2017 month:1 day:1];
    NSDate *maxDate = [NSDate br_setYear:2037 month:1 day:1];
    [GHDatePickerView showPickerViewWithTitle:@"休假" defaultValue:@"" dataType:GHDatePickerModeDate currentDate:[NSDate date] minDate:minDate maxDate:maxDate resultBlock:^(NSString *selectDateStr, NSString *ampmStr) {
        
        NSLog(@"%@%@",selectDateStr,ampmStr);
    }];
}


@end
