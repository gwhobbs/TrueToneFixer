//
//  AppDelegate.m
//  TrueToneFixer
//
//  Created by Grant Hobbs on 3/19/22.
//

#import "AppDelegate.h"
#import "CBTrueToneClient.h"

@interface AppDelegate ()

@property (strong, nonatomic) CBTrueToneClient *client;
@property (weak, nonatomic) NSStatusItem *statusItem;
@property (weak, nonatomic) IBOutlet NSMenu *statusBarMenu;

@end

@implementation AppDelegate

- (void)toggleTrueTone {
    CBTrueToneClient* client = self.client;
    [client setEnabled:!client.enabled];
}

- (void)ensureTrueToneIsCorrectlyApplied {
    CBTrueToneClient* client = self.client;
    if (!client.supported) {
        return;
    }
    NSLog(@"Toggling True Tone...");
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(toggleTrueTone) userInfo:nil repeats:false];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(toggleTrueTone) userInfo:nil repeats:false];
}

- (void)receiveWakeNote: (NSNotification*) note {
    [self ensureTrueToneIsCorrectlyApplied];
}

- (IBAction)quit:(id)sender {
    [NSApplication.sharedApplication terminate:nil];
}

- (void)initializeStatusBarMenu {
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength: NSVariableStatusItemLength];
    self.statusItem.button.action = @selector(receiveWakeNote:);
    self.statusItem.menu = self.statusBarMenu;
    self.statusItem.button.image = [NSImage imageWithSystemSymbolName:@"display" accessibilityDescription:@"TrueToneFixer"];
}


- (void)subscribeToWakeFromSleepNotifications {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(receiveWakeNote:) name:NSWorkspaceDidWakeNotification object:NULL];
}


- (void)initializeTrueToneFixer {
    self.client = [[CBTrueToneClient alloc] init];
    [self ensureTrueToneIsCorrectlyApplied];
    [self subscribeToWakeFromSleepNotifications];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initializeStatusBarMenu];
    [self initializeTrueToneFixer];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
