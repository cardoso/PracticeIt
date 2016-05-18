//
//  MDTimeIntervalPickerView.h
//  
//
//  Created by bepid on 5/18/16.
//
//

#import <UIKit/UIKit.h>

@interface MDTimeIntervalPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSTimeInterval defaultTimeInterval;

-(instancetype)init;

-(instancetype)initWithFrame:(CGRect)frame;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;

-(NSTimeInterval)timeInterval;

-(BOOL)setTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;

-(BOOL)setSeconds:(NSInteger)seconds animated:(BOOL)animated;

-(BOOL)setMinutes:(NSInteger)minutes animated:(BOOL)animated;

-(NSInteger)secondsComponent;

-(NSInteger)minutesComponent;

-(NSInteger)seconds;

-(NSInteger)minutes;

@end
