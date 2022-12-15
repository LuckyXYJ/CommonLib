//
//  NSString+RegulerExpression.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *emptyString(id obj);
FOUNDATION_EXTERN NSString *validString(NSString *string);

@interface NSString (RegulerExpression)


- (NSString *)trim;
- (BOOL)deptNumInputShouldNumber;
- (BOOL)isValid;
- (BOOL)isValidatePhone;
- (BOOL)isValidateInvitedCode;
- (BOOL)isValidatePassword;
- (BOOL)isValidateNickname;
- (BOOL)validateIdentityCard;

@end

NS_ASSUME_NONNULL_END
