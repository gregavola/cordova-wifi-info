//
//  WifiInfoPlugin.m
//  WifiInfoPlugin
//
//  Created by Greg Avola 9/14/18
//
//

#import "WifiInfoPlugin.h"
#include <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation WifiInfoPlugin


- (id)fetchSSIDInfo {
    // see http://stackoverflow.com/a/5198968/907720
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (void)getConnectedSSID:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    NSDictionary *r = [self fetchSSIDInfo];

    NSString *ssid = [r objectForKey:(id)kCNNetworkInfoKeySSID]; //@"SSID"

    if (ssid && [ssid length]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ssid];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not available"];
    }

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

@end
