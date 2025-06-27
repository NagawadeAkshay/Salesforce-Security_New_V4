({
	toggleSection : function(component, event, helper) {
	
		let buttonstate = !component.get('v.buttonstate');
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		localStorage.setItem(userId,buttonstate);
        component.set('v.buttonstate', buttonstate);
		component.set('v.isSidebarCollapsed', !component.get('v.isSidebarCollapsed'));
		
	},
	init : function(component, event, helper) {
	
		var userId = $A.get("$SObjectType.CurrentUser.Id");
			if(localStorage.getItem(userId))
            component.set('v.buttonstate', localStorage.getItem(userId)==='true');
			component.set('v.isSidebarCollapsed', !component.get('v.buttonstate'));
		
    }
})