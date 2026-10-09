#ifndef EWThemePrefs_h
#define EWThemePrefs_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// All theme prefs live in one NSUserDefaults dict so the web editor,
// the settings page and the tweak agree on one schema.
static inline NSDictionary *EWThemeDict(void) {
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EasyWalletTheme"];
    return d ?: @{};
}

static inline BOOL EWThemeEnabled(void) {
    NSDictionary *d = EWThemeDict();
    // On when unset: fresh install shows the theme immediately.
    if (d[@"enabled"] == nil) return YES;
    return [d[@"enabled"] boolValue];
}

static inline UIColor *EWColorFromHex(id hex, UIColor *fallback) {
    if (![hex isKindOfClass:[NSString class]]) return fallback;
    NSString *s = [(NSString *)hex stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([s hasPrefix:@"#"]) s = [s substringFromIndex:1];
    if (s.length != 6 && s.length != 8) return fallback;
    unsigned v = 0;
    if (![[NSScanner scannerWithString:s] scanHexInt:&v]) return fallback;
    CGFloat a = 1.0, r, g, b;
    if (s.length == 6) {
        r = ((v >> 16) & 0xFF) / 255.0; g = ((v >> 8) & 0xFF) / 255.0; b = (v & 0xFF) / 255.0;
    } else {
        a = ((v >> 24) & 0xFF) / 255.0; r = ((v >> 16) & 0xFF) / 255.0; g = ((v >> 8) & 0xFF) / 255.0; b = (v & 0xFF) / 255.0;
    }
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

static inline UIColor *EWAccentColor(void) {
    return EWColorFromHex(EWThemeDict()[@"accentHex"], [UIColor systemGreenColor]);
}

static inline UIColor *EWNavBarColor(void) {
    return EWColorFromHex(EWThemeDict()[@"navBarHex"], nil);
}

static inline UIColor *EWTabBarColor(void) {
    return EWColorFromHex(EWThemeDict()[@"tabBarHex"], nil);
}

// Custom background image shipped by the web editor.
// The editor exports a PNG; the sideload step (or Filza) drops it at
// Documents/EWTheme/bg.png inside the app container. Nil when absent.
static inline UIImage *EWCustomBackgroundImage(void) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *p = [[paths.firstObject stringByAppendingPathComponent:@"EWTheme"] stringByAppendingPathComponent:@"bg.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:p]) return nil;
    return [UIImage imageWithContentsOfFile:p];
}

#endif
