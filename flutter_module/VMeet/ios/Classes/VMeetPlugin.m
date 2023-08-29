#import "VMeetPlugin.h"
#if __has_include(<VMeet/VMeet-Swift.h>)
#import <VMeet/VMeet-Swift.h>
#else
#import "VMeet-Swift.h"
#endif

@implementation VMeetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVMeetPlugin registerWithRegistrar:registrar];
}
@end
