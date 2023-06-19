/********* brotherprinterplugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface brotherprinterplugin : CDVPlugin {
  // Member variables go here.
}

- (void)print:(CDVInvokedUrlCommand*)command;
@end

@implementation brotherprinterplugin

- (void)print:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
