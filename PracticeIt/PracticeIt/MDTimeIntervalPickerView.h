//
//  MDTimeIntervalPickerView.h
//  
//
//  Created by bepid on 5/18/16.
//
//

#import <UIKit/UIKit.h>

@interface MDTimeIntervalPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

-(NSTimeInterval)timeInterval;

@end
