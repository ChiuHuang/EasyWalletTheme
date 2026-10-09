#import <UIKit/UIKit.h>
#import "EWThemePrefs.h"

// v1 theming without an app class-dump: only generic UIKit hooks.
// Everything is gated by EWThemeEnabled() so disabling one key
// restores stock. App-specific view hooks get added after a
// class-dump of Easy Wallet 3.1.36 names the real header/tab classes.

// -- Accent: tint controls that opt into tintColor ---------------------------
%hook UIButton
- (void)didMoveToWindow {
    %orig;
    if (EWThemeEnabled() && self.tintColor) self.tintColor = EWAccentColor();
}
%end

%hook UISwitch
- (void)didMoveToWindow {
    %orig;
    if (EWThemeEnabled()) self.onTintColor = EWAccentColor();
}
%end

%hook UIProgressView
- (void)didMoveToWindow {
    %orig;
    if (EWThemeEnabled()) self.progressTintColor = EWAccentColor();
}
%end

// -- NavBar / TabBar ----------------------------------------------------------
%hook UINavigationBar
- (void)didMoveToWindow {
    %orig;
    if (!EWThemeEnabled()) return;
    UIColor *c = EWNavBarColor();
    if (c) {
        UINavigationBarAppearance *a = [[UINavigationBarAppearance alloc] init];
        [a configureWithOpaqueBackground];
        a.backgroundColor = c;
        self.standardAppearance = a;
        self.scrollEdgeAppearance = a;
    }
    self.tintColor = EWAccentColor();
}
%end

%hook UITabBar
- (void)didMoveToWindow {
    %orig;
    if (!EWThemeEnabled()) return;
    UIColor *c = EWTabBarColor();
    if (c) {
        UITabBarAppearance *a = [[UITabBarAppearance alloc] init];
        [a configureWithOpaqueBackground];
        a.backgroundColor = c;
        self.standardAppearance = a;
        if (@available(iOS 15.0, *)) self.scrollEdgeAppearance = a;
    }
    self.tintColor = EWAccentColor();
}
%end

// -- Custom background image ---------------------------------------------------
// Paints Documents/EWTheme/bg.png behind the root view of every full-screen
// controller. Tag 7741 marks the hosted image view so layout passes reuse it.
%hook UIViewController
- (void)viewDidLayoutSubviews {
    %orig;
    if (!EWThemeEnabled()) return;
    UIImage *bg = EWCustomBackgroundImage();
    if (!bg) return;
    if (CGRectGetWidth(self.view.bounds) < 300) return;
    UIImageView *iv = [self.view viewWithTag:7741];
    if (!iv) {
        iv = [[UIImageView alloc] initWithImage:bg];
        iv.tag = 7741;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.userInteractionEnabled = NO;
        [self.view insertSubview:iv atIndex:0];
    }
    iv.frame = self.view.bounds;
    iv.image = bg;
}
%end
