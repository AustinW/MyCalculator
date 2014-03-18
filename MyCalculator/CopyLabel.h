// From: https://github.com/zhbrass/UILabel-Clipboard

@interface CopyLabel : UILabel {
    SEL copyAction;
    id copyTarget;
}
- (void)setTarget:(id)target forCopyAction:(SEL)action;
@end