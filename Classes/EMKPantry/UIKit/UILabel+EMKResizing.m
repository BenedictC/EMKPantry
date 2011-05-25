//
//  UILabel(EMKResizing).m
//  EMKPantry
//
//  Created by Benedict Cohen on 26/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UILabel(EMKResizing).h"


@implementation UILabel (EMKResizing)


-(void)EMK_resizeWidthToRevealAllContent:(BOOL)doShrink
{
    CGRect currentFrame = self.frame;
    CGSize expandedSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, currentFrame.size.height) lineBreakMode:self.lineBreakMode];
    
    if (!doShrink && currentFrame.size.width > expandedSize.width) return;
    
    self.frame = (CGRect){.origin = currentFrame.origin, .size = expandedSize};
}

@end
