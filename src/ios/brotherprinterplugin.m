/********* brotherprinterplugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
@import BrotherObjCFramework;

BROTHERSDK *_lib;

@interface brotherprinterplugin : CDVPlugin {
  // Member variables go here.
}

- (void)print:(CDVInvokedUrlCommand*)command;
@end

@implementation brotherprinterplugin {
	UIImage *_image;
}

- (void)pluginInitialize {
    [super pluginInitialize];
    _lib = [BROTHERSDK new];
}

- (void)print:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
   /*  NSString* echo = [command.arguments objectAtIndex:0]; */

    /* if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
 */

	// Obtiene los valores 
    NSDictionary *object = command.arguments[0];
    
    // Conecta con la impresora
    NSInteger IsOpen = [_lib openportMFI:@"com.issc.datapath"];
    
    if(IsOpen == 1)
    {
        // Configuración de la impresora
        [_lib setup:@"75" height:@([item[@"heightPapper"] intValue]) speed:@"2" density:@"15" sensor:@"0" vertical:@"0" offset:@"0"];
        [_lib clearbuffer];
		
		// Recoge los datos de la image en base 64
		NSString *base64 = object[@"base64"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _image = [[UIImage alloc] initWithData:imageData];
		[_lib sendImagebyFile:_image x:0 y:0 width:550 height:intValue threshold:128];

		// Imprime de la imagen
        [_lib printlabel:@"1" copies:@"1"];
		
		// Desconecta
        [_lib closeport:30000];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
