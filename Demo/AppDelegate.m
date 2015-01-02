#import "AppDelegate.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"
#import "MASShortcut+Monitoring.h"

NSString *const MASPreferenceKeyShortcut = @"MASDemoShortcut";
NSString *const MASPreferenceKeyShortcutEnabled = @"MASDemoShortcutEnabled";
NSString *const MASPreferenceKeyConstantShortcutEnabled = @"MASDemoConstantShortcutEnabled";

@implementation AppDelegate {
    __weak id _constantShortcutMonitor;
    __weak id _constantShortcutMonitor1;
    __weak id _constantShortcutMonitor2;
}

@synthesize window = _window;
@synthesize shortcutView = _shortcutView;

#pragma mark -

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Checkbox will enable and disable the shortcut view
    [self.shortcutView bind:@"enabled" toObject:self withKeyPath:@"shortcutEnabled" options:nil];
}

- (void)dealloc
{
    // Cleanup
    [self.shortcutView unbind:@"enabled"];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Uncomment the following lines to make Command-Shift-D the default shortcut
//    MASShortcut *defaultShortcut = [MASShortcut shortcutWithKeyCode:0x2 modifierFlags:NSCommandKeyMask|NSShiftKeyMask];
//    [MASShortcut setGlobalShortcut:defaultShortcut forUserDefaultsKey:MASPreferenceKeyShortcut];

    // Shortcut view will follow and modify user preferences automatically
    self.shortcutView.associatedUserDefaultsKey = MASPreferenceKeyShortcut;

    // Activate the global keyboard shortcut if it was enabled last time
    [self resetShortcutRegistration];

    // Activate the shortcut Command-F1 if it was enabled
    [self resetConstantShortcutRegistration];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark - Custom shortcut

- (BOOL)isShortcutEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:MASPreferenceKeyShortcutEnabled];
}

- (void)setShortcutEnabled:(BOOL)enabled
{
    if (self.shortcutEnabled != enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:MASPreferenceKeyShortcutEnabled];
        [self resetShortcutRegistration];
    }
}

- (void)resetShortcutRegistration
{
    if (self.shortcutEnabled) {
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MASPreferenceKeyShortcut handler:^{
            [[NSAlert alertWithMessageText:NSLocalizedString(@"Global hotkey has been pressed cestil.", @"Alert message for custom shortcut")
                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on custom shortcut")
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }];
    }
    else {
        [MASShortcut unregisterGlobalShortcutWithUserDefaultsKey:MASPreferenceKeyShortcut];
    }
}

#pragma mark - Constant shortcut

- (BOOL)isConstantShortcutEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:MASPreferenceKeyConstantShortcutEnabled];
}

- (void)setConstantShortcutEnabled:(BOOL)enabled
{
    if (self.constantShortcutEnabled != enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:MASPreferenceKeyConstantShortcutEnabled];
        [self resetConstantShortcutRegistration];
    }
}

- (void)resetConstantShortcutRegistration
{
    if (self.constantShortcutEnabled) {
        MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_DownArrow modifierFlags:NSCommandKeyMask|NSAlternateKeyMask|NSControlKeyMask];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"MoveFull" ofType:@"scpt"];
        NSURL* url = [NSURL fileURLWithPath:path];NSDictionary* errors = [NSDictionary dictionary];
        NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
        _constantShortcutMonitor = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut handler:^{
            [appleScript executeAndReturnError:nil];
        }];
        
        MASShortcut *shortcut1 = [MASShortcut shortcutWithKeyCode:kVK_LeftArrow modifierFlags:NSCommandKeyMask|NSAlternateKeyMask|NSControlKeyMask];
        NSString* path1 = [[NSBundle mainBundle] pathForResource:@"MoveLeft" ofType:@"scpt"];
        NSURL* url1 = [NSURL fileURLWithPath:path1];NSDictionary* errors1 = [NSDictionary dictionary];
        NSAppleScript* appleScript1 = [[NSAppleScript alloc] initWithContentsOfURL:url1 error:&errors1];
        _constantShortcutMonitor1 = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut1 handler:^{
            [appleScript1 executeAndReturnError:nil];
        }];
        
        MASShortcut *shortcut2 = [MASShortcut shortcutWithKeyCode:kVK_RightArrow modifierFlags:NSCommandKeyMask|NSAlternateKeyMask|NSControlKeyMask];
        NSString* path2 = [[NSBundle mainBundle] pathForResource:@"MoveRight" ofType:@"scpt"];
        NSURL* url2 = [NSURL fileURLWithPath:path2];NSDictionary* errors2 = [NSDictionary dictionary];
        NSAppleScript* appleScript2 = [[NSAppleScript alloc] initWithContentsOfURL:url2 error:&errors2];
        _constantShortcutMonitor2 = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut2 handler:^{
            [appleScript2 executeAndReturnError:nil];
        }];
        
    }
    //[appleScript release];
    
//    if (self.constantShortcutEnabled) {
//        MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_F2 modifierFlags:NSCommandKeyMask];
//        _constantShortcutMonitor = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut handler:^{
//            [[NSAlert alertWithMessageText:NSLocalizedString(@"⌘F2 has been pressed cestil marmule.", @"Alert message for constant shortcut")
//                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on constant shortcut")
//                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
//        }];
//    }
//    else {
//        [MASShortcut removeGlobalHotkeyMonitor:_constantShortcutMonitor];
//    }
}

@end
