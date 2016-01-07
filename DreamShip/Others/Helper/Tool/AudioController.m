//
//  AudioController.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/7.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "AudioController.h"

static AVAudioPlayer *player = nil;

@implementation AudioController

+(void)playMusic{
    if (player == nil) {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"dreamer" ofType:@"mp3"];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileName] error:nil];
        player.delegate = self;
        [player prepareToPlay];
    }
    
    [player play];
}

+(void)stopMusic{
    [player stop];
}
@end
