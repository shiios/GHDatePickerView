# GHDatePickerView
/**
 *  1.显示时间选择器
 *
 *  @param title            标题
 *  @param defaultValue     默认值
 *  @param type         日期显示类型
 *  @param currentDate  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param mindate      设置日期滚动上限
 *  @param maxDate      设置日期滚动下限
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showPickerViewWithTitle:(NSString *)title defaultValue:(NSString *)defaultValue dataType:(GHDatePickerMode)type currentDate:(NSDate *)currentDate minDate:(NSDate *)mindate maxDate:(NSDate *)maxDate resultBlock:(GHDateResultBlock)resultBlock;

/**
*  模式选择为 GHDatePickerModeDate  yyyyMMdd 
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDate *minDate = [NSDate br_setYear:2017 month:1 day:1];
    NSDate *maxDate = [NSDate br_setYear:2037 month:1 day:1];
    [GHDatePickerView showPickerViewWithTitle:@"休假" defaultValue:@"" dataType:GHDatePickerModeDate currentDate:[NSDate date] minDate:minDate maxDate:maxDate resultBlock:^(NSString *selectDateStr, NSString *ampmStr) {
        
        NSLog(@"%@%@",selectDateStr,ampmStr);
    }];
}
/**
效果展示-：
*/
https://github.com/shiios/GHDatePickerView/Simulator Screen Shot - iPhone XR - 2018-11-22 at 14.22.09.png

/**
*  模式选择为 GHDatePickerModeDateAMPM  yyyyMMdd AM/PM
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDate *minDate = [NSDate br_setYear:2017 month:1 day:1];
    NSDate *maxDate = [NSDate br_setYear:2037 month:1 day:1];
    [GHDatePickerView showPickerViewWithTitle:@"休假" defaultValue:@"" dataType:GHDatePickerModeDateAMPM currentDate:[NSDate date] minDate:minDate maxDate:maxDate resultBlock:^(NSString *selectDateStr, NSString *ampmStr) {
        
        NSLog(@"%@%@",selectDateStr,ampmStr);
    }];
}
/**
效果展示二：
*/
https://github.com/shiios/GHDatePickerView/Simulator Screen Shot - iPhone XR - 2018-11-22 at 14.22.52.png

/**
* 清理缓存
*/
- (void)cleanCache;
 
/**
* 判断数据是否已经在沙盒中已经存在？
*/
- (BOOL) isFileExist:(NSString *)fileName;
