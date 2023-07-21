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
	
    // Obtiene los valores 
    NSDictionary *object = command.arguments[0];
	
    // Conecta con la impresora
    NSInteger IsOpen = [_lib openportMFI:@"com.issc.datapath"];

    if(IsOpen == 1)    {
		// Configuración de la impresora
        NSNumber *height = @([object[@"height"] intValue]);
        int intheight = [height intValue];
        int intheightpaper = (intheight * 25.4 / 203);
        NSString *heightPapper = [@(intheightpaper) stringValue];
        [_lib setup:@"75" height:heightPapper speed:@"2" density:@"15" sensor:@"0" vertical:@"0" offset:@"0"];
        [_lib clearbuffer];

        // Recoge los datos de la image en base 64
        NSString *base64 = object[@"base64"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _image = [[UIImage alloc] initWithData:imageData];
        [_lib sendImagebyFile:_image x:0 y:0 width:550 height:intheight threshold:128];

        // Imprime de la imagen
        [_lib printlabel:@"1" copies:@"1"];

          // Desplazamiento al final de la impresión
        [_lib sendcommand:@"FEED 60\r\n"];

        // Desconecta
        [_lib closeport:20];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
