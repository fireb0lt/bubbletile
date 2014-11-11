//
//  LabelsAndFx.m
//  BubbleTile
//
//  Created by Isaac on 6/20/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "LabelsAndFx.h"

@implementation LabelsAndFx
- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        SKLabelNode *addLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        addLabel.fontColor = [SKColor blackColor];
        addLabel.fontSize = 48;
        addLabel.text = @"";
        //addLabel.alpha = 0.2;
        addLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        addLabel.position=CGPointMake(self.size.width/2,self.size.height-65);
        
        
        [self addChild:addLabel];
    }
    
    return self;
}
@end
