//
//  GHDatePickerView.m
//  BRPickerViewDemo
//
//  Created by yin tian on 2018/11/19.
//  Copyright © 2018 91renb. All rights reserved.
//

#import "GHDatePickerView.h"
#import "BRPickerViewMacro.h"
#import "BRPickerView.h"



@interface GHDatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;
/** 当前选择的展示类型 */
@property (nonatomic,assign) GHDatePickerMode showType;

@property (nonatomic,strong) NSArray *allArray;
@property (nonatomic,strong) NSArray *defaultArray;
/** 选择结果回调 */
@property (nonatomic,copy) GHDateResultBlock resultBlock;

/** 选中的日期如：2018年12月12日 */
@property (nonatomic,copy) NSString *selectDateValue;
/** 选中的是上午还是下午 */
@property (nonatomic,copy) NSString *selectAMPM;


@end


@implementation GHDatePickerView

+ (void)showPickerViewWithTitle:(NSString *)title defaultValue:(NSString *)defaultValue dataType:(GHDatePickerMode)type currentDate:(NSDate *)currentDate minDate:(NSDate *)mindate maxDate:(NSDate *)maxDate resultBlock:(GHDateResultBlock)resultBlock
{
    GHDatePickerView *pickView = [[GHDatePickerView alloc]initWithTitle:title dataType:type defaultValue:defaultValue currentDate:currentDate minDate:mindate maxDate:maxDate resultBlock:resultBlock];
    pickView.resultBlock = resultBlock;
    [pickView showWithAnimation:YES];
    
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title dataType:(GHDatePickerMode)type defaultValue:(NSString *)defaultValue currentDate:(NSDate *)currentDate minDate:(NSDate *)mindate maxDate:(NSDate *)maxDate resultBlock:(GHDateResultBlock)resultBlock
{
    if (self = [super init]) {

        self.titleLabel.text = title;
        _showType = type;
        _resultBlock = resultBlock;
        _minLimitDate = mindate;
        _maxLimitDate = maxDate;
        _selectDate = currentDate;
        _defaultArray = [NSArray arrayWithObjects:@"上午",@"下午", nil];
        _selectAMPM = @"上午";
        [self calculateArray];
        
        [self initUI];
    }
    return self;
}
#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    [self.alertView addSubview:self.pickerView];
}
#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}
#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    
}
#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

- (void)cleanCache
{
    NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subpaths) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
   
}

#pragma mark - 滚动到当前日期
- (void)scrollToCurrentDateRow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *str = [NSString stringWithFormat:@"%zi年%zi月%zi日",self.selectDate.br_year,self.selectDate.br_month,self.selectDate.br_day];
        for (NSInteger i = 0; i < self.allArray.count; i++) {
            
            if ([str isEqualToString:self.allArray[i]]) {
                self.selectDateValue = str;
                [self.pickerView selectRow:i inComponent:0 animated:NO];
                [self.pickerView reloadAllComponents];
            }
            
        }
        
    });
    
}

- (void)calculateArray
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = array.lastObject;
    NSLog(@"cachePath---%@",cachePath);
    NSString *filePathName = [cachePath stringByAppendingPathComponent:@"dateStrPlist.plist"];
    NSLog(@"filePathName---%@",filePathName);
    
    if ([self isFileExist:@"dateStrPlist.plist"]) {
        
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePathName];
        NSLog(@"dataArray---%@",dataArray);
        self.allArray = [dataArray copy];
        
        if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
            
            [self scrollToCurrentDateRow];
        }
        
    }else{
        
        dispatch_queue_t queue = dispatch_queue_create("wendingding", NULL);
        dispatch_async(queue, ^{
            
            NSInteger yearNum = 0;
            NSInteger monthNum = 0;
            NSInteger dayNum = 0;
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSInteger i = self.minLimitDate.br_year; i <= self.maxLimitDate.br_year; i++) {
                
                double start  = CFAbsoluteTimeGetCurrent();
                yearNum = i;
                NSInteger startMonth = 1;
                
                NSInteger endMonth = 12;
                if (yearNum == self.selectDate.br_year - 1) {
                    startMonth = 12;
                }
                
                for (NSInteger i = startMonth; i <= endMonth; i++) {
                    
                    monthNum = i;
                    
                    NSInteger startDay = 1;
                    NSInteger endDay = [NSDate br_getDaysInYear:yearNum month:monthNum];
                    
                    for (NSInteger i = startDay; i <= endDay; i++) {
                        
                        dayNum = i;
                        [tempArr addObject:[NSString stringWithFormat:@"%zi年%zi月%zi日",yearNum,monthNum,dayNum]];
                    }
                    double end  = CFAbsoluteTimeGetCurrent();
                    NSLog(@"%lf",(end - start) * 1000);
                }
                
                self.allArray = [tempArr copy];
                //            NSLog(@"%@",self.allArray);
                
                //本地缓存一份
                
                NSString *homePath = NSHomeDirectory();
                NSLog(@"homeDir = %@",homePath);
                NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSLog(@"array--%@",array);
                NSString *cachePath = array.lastObject;
                //拼接路径
                NSString *filePath = [cachePath stringByAppendingPathComponent:@"dateStrPlist.plist"];
                [self.allArray writeToFile:filePath atomically:YES];
                
            }
            
            [self scrollToCurrentDateRow];
            
        });
        
    }

}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_showType == GHDatePickerModeDate) {
        return 1;
    }else if (_showType == GHDatePickerModeDateAMPM) {
        return 2;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowsArr = [NSArray array];
    if (_showType == GHDatePickerModeDate) {
        rowsArr = @[@(self.allArray.count)];
    }else if (_showType == GHDatePickerModeDateAMPM){
        rowsArr = @[@(self.allArray.count), @(self.defaultArray.count)];
    }
    return [rowsArr[component] integerValue];
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];

    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.0f * kScaleFit];
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    // 给选择器上的label赋值
    [self setDateLabelText:label component:component row:row];
    return label;


}
- (void)setDateLabelText:(UILabel *)label component:(NSInteger)component row:(NSInteger)row
{
    if (_showType == GHDatePickerModeDate) {
        label.text = [NSString stringWithFormat:@"%@", self.allArray[row]];
    }else if (_showType == GHDatePickerModeDateAMPM){
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@", self.allArray[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@", self.defaultArray[row]];
        }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_showType == GHDatePickerModeDate) {
        self.selectDateValue = _allArray[row];
    }else if (_showType == GHDatePickerModeDateAMPM){
        if (component == 0) {
            self.selectDateValue = _allArray[row];
        }else if (component == 1){
            self.selectAMPM = _defaultArray[row];
        }
    }
    if (self.resultBlock) {
        self.resultBlock(self.selectDateValue, self.selectAMPM);
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    // 点击确定按钮后，执行block回调
    [self dismissWithAnimation:YES];
     __weak typeof(self)weakself = self;
    if (weakself.resultBlock) {

        weakself.resultBlock(self.selectDateValue, self.selectAMPM);

    }
}

#pragma mark - 时间选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

@end
