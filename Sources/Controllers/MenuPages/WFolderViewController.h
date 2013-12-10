//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WListViewController.h"
#import "WUploadManager+Picker.h"

@interface WFolderViewController : WListViewController <WUploadManagerPickerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) NSString      *path;
@property (nonatomic, retain) NSNumber      *folderId;

- (id)initWithId:(NSNumber *)folderId andData:(NSDictionary *)data;

@end
