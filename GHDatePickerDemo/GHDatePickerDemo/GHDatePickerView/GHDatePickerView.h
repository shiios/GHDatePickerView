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



+ (void)showPickerViewWithTitle:(NSString *)title defaultValue:(NSString *)defaultValue dataType:(GHDatePickerMode)type currentDate:(NSDate *)currentDate minDate:(NSDate *)mindate maxDate:(NSDate *)maxDate resultBlock:(GHDateResultBlock)resultBlock;
//清理缓存
- (void)cleanCache;
//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName;


@end

NS_ASSUME_NONNULL_END
