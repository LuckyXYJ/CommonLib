//
//  XZConverseUIUtils.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "XZConverseUIUtils.h"
#import "CommonFont.h"
#import "BaseColor.h"

@implementation XZConverseUIUtils

UIView * drawLine(UIColor *color) {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    return line;
}

UILabel * createLabelWithText(NSString *text, CGFloat fontSize, UIColor *textColor) {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize == 0 ? 15 : fontSize weight:UIFontWeightRegular];
    label.textColor = textColor ? textColor : ColorHex(0x333333);
    return label;
}

UITextField * createTextFieldWithPlaceholder(NSString *placeholder, UIColor *textColor, BOOL enable) {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:Font(15), NSForegroundColorAttributeName:ColorHex(0x333333)}];
    textField.font = Font(15);
    textField.textColor = textColor ? textColor : ColorHex(0x333333);
    //    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentRight;
    textField.borderStyle = UITextBorderStyleNone;
    textField.enabled = enable;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

UIButton * createBtnWithTitle(NSString *title, UIColor *titleColor, NSString *backgroundImage, NSString *disableImage, BOOL enable) {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (backgroundImage) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    }
    if (disableImage) {
        [button setBackgroundImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    }
    button.titleLabel.font = Font(18);
    button.enabled = enable;
    
    return button;
}

@end
