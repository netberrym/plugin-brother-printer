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
        [_lib setup:@"75" height:@"100" speed:@"2" density:@"15" sensor:@"0" vertical:@"0" offset:@"0"];
        NSArray *images = object[@"base64"];
        for (int i = 0; i <= [images count]; i++){
            [_lib clearbuffer];
            NSDictionary *item = images[i];
            NSString *base64 = item[@"image"];
            
            NSNumber *height = @([item[@"height"] intValue]);
            int intheight = [height intValue];
            NSNumber *width = @([item[@"width"] intValue]);
            int intwidth = [width intValue];
            NSNumber *widthPaper = @([@"550" intValue]);
            int intwidthPaper = [widthPaper intValue];
            //NSNumber *heightPrint = (width/widthPaper)*height;
            
            int intValue = (intwidth/intwidthPaper)*intheight;
            
            // Bitmap bitmap = bmpFromBase64(base64);
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            _image = [[UIImage alloc] initWithData:imageData];
            [_lib sendImagebyFile:_image x:0 y:0 width:550 height:intValue threshold:128];
            // Imprime la imagen
            if(i != 0){
                [_lib sendcommand:@"BACKFEED 108\r\n"];
            }
            
            [_lib printlabel:@"1" copies:@"1"];
        }
       
        
        [_lib closeport:60];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
