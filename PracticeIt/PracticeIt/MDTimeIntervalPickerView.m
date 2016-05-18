//
//  MDTimeIntervalPickerView.m
//  
//
//  Created by bepid on 5/18/16.
//
//

#import "MDTimeIntervalPickerView.h"

@implementation MDTimeIntervalPickerView

-(instancetype)init {
    self = [super init];
    
    if(self) {
        super.delegate = self;
        super.dataSource = self;
        [self setTimeInterval:self.defaultTimeInterval animated:NO];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        super.delegate = self;
        super.dataSource = self;
        [self setTimeInterval:self.defaultTimeInterval animated:NO];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        super.delegate = self;
        super.dataSource = self;
        [self setTimeInterval:self.defaultTimeInterval animated:NO];
    }
    
    return self;
}

-(NSTimeInterval)timeInterval {
    NSLog(@"%ld", [self seconds] + [self minutes]*60);
    return [self seconds] + [self minutes]*60;
}

-(BOOL)setTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated {
    if(timeInterval > 59*61 || timeInterval < 0)
        return NO;
    
    [self setMinutes:(timeInterval/60) animated:animated];
    [self setSeconds:(fmod(timeInterval, 60)) animated:animated];
    
    return YES;
}

-(BOOL)setSeconds:(NSInteger)seconds animated:(BOOL)animated {
    if(seconds > 59 || seconds < 0)
        return NO;
    
    [self selectRow:seconds inComponent:[self secondsComponent] animated:animated];
    return YES;
}

-(BOOL)setMinutes:(NSInteger)minutes animated:(BOOL)animated {
    if(minutes > 59 || minutes < 0)
        return NO;
    
    [self selectRow:minutes inComponent:[self minutesComponent] animated:animated];
    return YES;
}

-(NSInteger)secondsComponent {
    return 1;
}

-(NSInteger)minutesComponent {
    return 0;
}

-(NSInteger)seconds {
    return [self selectedRowInComponent:[self secondsComponent]];
}

-(NSInteger)minutes {
    return [self selectedRowInComponent:[self minutesComponent]];
}


#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch(component) {
        case 0:
            return 60;
        case 1:
            return 60;
        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(component == [self secondsComponent]) {
        return [NSString stringWithFormat:@"%ld sec", row];
    } else if(component == [self minutesComponent]) {
        return [NSString stringWithFormat:@"%ld min", row];
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([self timeInterval] <= 0)
        [self setTimeInterval:1 animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
