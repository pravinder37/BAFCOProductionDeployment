({
    invoke: function(component) {
        
        var formFactor = $A.get("$Browser.formFactor");
        var Android = $A.get("$Browser.isAndroid");
        var iOS = $A.get("$Browser.isIOS");
        var iPad = $A.get("$Browser.isIPad");
        var iPhone = $A.get("$Browser.isIPhone");
        var Phone = $A.get("$Browser.isPhone");
        var Tablet = $A.get("$Browser.isTablet");
        var WindowsPhone = $A.get("$Browser.isWindowsPhone");

        
        component.set('v.formFactor',formFactor);
        component.set('v.Android',Android);
        component.set('v.iOS',iOS);
        component.set('v.iPad',iPad);
        component.set('v.iPhone',iPhone);
        component.set('v.Phone',Phone);
        component.set('v.Tablet',Tablet);
        component.set('v.WindowsPhone',WindowsPhone);
        
    }
})