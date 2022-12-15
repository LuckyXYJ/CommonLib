//
//  NSString+RegulerExpression.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "NSString+RegulerExpression.h"

NSString *emptyString(id obj) {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj description];
    }
    if (!obj || [obj isKindOfClass:[NSNull class]] || ![obj isKindOfClass:[NSString class]]) {
        return @"";
    }
    return obj;
}

NSString *validString(NSString *string) {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@implementation NSString (RegulerExpression)

- (NSString *)trim {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)isValid {
    if (!self || self.length == 0 || [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)deptNumInputShouldNumber
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidatePhone {
    NSString *phoneRegex = @"^\\d{11}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phonePredicate evaluateWithObject:self];
}

- (BOOL)isValidateInvitedCode {
    NSString *inviteCodeRegex = @"^(?![0-9]+$)(?![A-Za-z]+$)[A-Za-z0-9]{1,11}$";
    NSPredicate *invitePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",inviteCodeRegex];
    return [invitePredicate evaluateWithObject:self];
}

- (BOOL)isValidatePassword {
    NSString *passwordRegex = @"^(?![0-9]+$)(?![A-Za-z]+$)[A-Za-z0-9]{8,18}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:self];
}

- (BOOL)isValidateNickname {
    NSString *passwordRegex = @"^[\u4E00-\u9FA5A-Za-z0-9_]{0,30}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:self];
}

- (BOOL)validateIdentityCard {
    BOOL flag;
    
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:self];
}

@end
