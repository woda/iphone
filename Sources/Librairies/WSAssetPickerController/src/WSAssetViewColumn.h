//
//  WSAssetView.h
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>

@interface WSAssetViewColumn : UIView

@property (nonatomic, weak) UIImageView *selectedView;
@property (nonatomic) NSUInteger column;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (WSAssetViewColumn *)assetViewWithImage:(UIImage *)thumbnail;

- (id)initWithImage:(UIImage *)thumbnail;

- (void)setShouldSelectItemBlock:(BOOL(^)(NSInteger column))shouldSelectItemBlock;

@end