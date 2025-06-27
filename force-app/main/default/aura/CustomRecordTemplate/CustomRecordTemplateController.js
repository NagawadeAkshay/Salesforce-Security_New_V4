({	
    handleTemplateEvent: function (component, event) {
        var objCompB = component.find('childCmp');
        objCompB.sampleMethod("Param1");
    },
	toggleSection: function (component, event, helper) {
		console.log('buttonState ' + component.get('v.buttonstate'));
		let buttonstate = !component.get('v.buttonstate');
		var uniqueKey = window.location.pathname.split('/');
		for (let i = 0; i < uniqueKey.length; i++) {
			if (uniqueKey[i].includes('__c')) {
				localStorage.setItem(uniqueKey[i], buttonstate);
			}
		}
		component.set('v.buttonstate', buttonstate);
		component.set('v.isSidebarCollapsed', !component.get('v.isSidebarCollapsed'));
		var previousElementSibling = component.find("mainRegion").getElement();
		if (component.get('v.buttonstate') == true) {
			var nextElementSibling = component.find("rightSidebar").getElement();
			previousElementSibling.style.flex = "1 0";
		}
		else if (component.get('v.buttonstate') == false) {
			console.log('previousElementSibling.style.flex ' + previousElementSibling.style.flex);
			previousElementSibling.style.flex = component.get('v.firstDivFlex');
			console.log('firstDivFlex ' + component.get("v.firstDivFlex"));
		}
	},

	init: function (component, event, helper) {
		var uniqueKey = window.location.pathname.split('/');
		for (let i = 0; i < uniqueKey.length; i++) {
			if (uniqueKey[i].includes('__c')) {
				var uniqueValue = uniqueKey[i];
			}
		}
		if (localStorage.getItem(uniqueValue)) {
			component.set('v.buttonstate', localStorage.getItem(uniqueValue) === 'true');
		}

		component.set('v.isSidebarCollapsed', !component.get('v.buttonstate'));
	},

	toggleHeader: function (component, event, helper) {
		let headerButtonState = !component.get('v.headerButtonState');
		component.set('v.headerButtonState', headerButtonState);
		component.set('v.isHeaderCollapsed', !component.get('v.isHeaderCollapsed'));
	},

	handleChanged: function (component, message, helper) {
		// Read the message argument to get the values in the message payload
		if (message != null) {
			console.log('kk message received' + message);
		}
	},

	handleComponentEvent: function (component, event, helper) {
		var valueFromChild = event.getParam("message");
		console.log('kk inside parent buttonState' + component.get('v.buttonstate'));
		if (component.get('v.buttonstate') == true) {
			let buttonstate = !component.get('v.buttonstate');
			component.set('v.buttonstate', buttonstate);
			component.set('v.isSidebarCollapsed', !component.get('v.isSidebarCollapsed'));
		}
	},

	handleOnMouseDown: function (component, event, helper) {
		console.log("Inside handleOnMouseDown");
		if (event.stopPropagation) event.stopPropagation();
		if (event.preventDefault) event.preventDefault();
		event.cancelBubble = true;
		event.returnValue = false;
		var resizer = event.target;
		console.log("Inside handleOnMouseDown resizer " + JSON.stringify(event.target));
		delete resizer._clientX;
		component.set("v.resizer", resizer);
		console.log("Inside handleOnMouseDown resizer " + JSON.stringify(component.get("v.resizer")));
		component.set("v.canMove", true);
	},

	handleOnMouseMove: function (component, event, helper) {
		console.log("Inside handleOnMouseMove");
		if (component.get("v.canMove")) {
			console.log("Inside handleOnMouseMove canMove");
			const clientX = event.clientX;
			var resizer = component.get("v.resizer");
			console.log("clientX " + clientX);
			const deltaX = clientX - (resizer._clientX || clientX);
			resizer._clientX = clientX;
			component.set("v.resizer", resizer);
			console.log("Inside handleOnMouseDown resizer mouse " + JSON.stringify(component.get("v.resizer")));

			var previousElementSibling = component.find("mainRegion").getElement();
			console.log("previousElementSibling " + JSON.stringify(previousElementSibling));
			var nextElementSibling = component.find("rightSidebar").getElement();
			if (deltaX < 0) {
				console.log("Inside deltaX<");
				console.log("Inside deltaX< width1 " + window.getComputedStyle(previousElementSibling).width);
				const width = Math.round(parseInt(window.getComputedStyle(previousElementSibling).width) + deltaX);
				console.log("Inside deltaX< width " + width);
				console.log("Inside deltaX< value previous " + previousElementSibling.style.flex);
				previousElementSibling.style.flex = "0 " + (width < 10 ? 0 : width) + "px";
				component.set("v.firstDivFlex", previousElementSibling.style.flex);
				console.log("Inside deltaX< value " + previousElementSibling.style.flex);
				nextElementSibling.style.flex = "1 0";
				previousElementSibling.style.width = "225px";
				
			}
			// RIGHT
			else if (deltaX > 0) {
				console.log("Inside deltaX>");
				const width = Math.round(parseInt(window.getComputedStyle(nextElementSibling).width) - deltaX)
				nextElementSibling.style.flex = "0 " + (width < 10 ? 0 : width) + "px";
				previousElementSibling.style.flex = "1 0";
				nextElementSibling.style.width = "277px";
				component.set("v.firstDivFlex", previousElementSibling.style.flex);
			}
		}
	},
	handleOnMouseUp: function (component, event, helper) {
		if (event.stopPropagation) event.stopPropagation();
		if (event.preventDefault) event.preventDefault();
		event.cancelBubble = true;
		event.returnValue = false;
		console.log("Inside handleOnMouseUp");
		component.set("v.canMove", false);
	}
})