//
//  GHDatePickerView.h
//  BRPickerViewDemo
//
//  Created by yin tian on 2018/11/19.
//  Copyright © 2018 91renb. All rights reserved.
//

#import "BRBaseView.h"

typedef NS_ENUM(NSInteger,GHDatePickerMode){
    
    GHDatePickerModeDate,//2018年12月12号
    GHDatePickerModeDateAMPM,//2018年12月12号 上午
    
};



typedef void(^GHDateResultBlock)(NSString *selectDateStr,NSString *ampmStr);

NS_ASSUME_NONNULL_BEGIN

@interface GHDatePickerView : BRBaseView

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

//清理缓存
- (void)cleanCache;
 
//判断数据是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
