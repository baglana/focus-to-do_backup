'use strict';

function createWindow(left, top, width, height) {
	chrome.windows.create(
		{
			url: chrome.runtime.getURL("WebContent/index.html"),
			type: "popup",
			left, top,
			width, height
		}, 
		function(window) {
			// 保存：通过变更保存窗口信息会被释放
			chrome.storage.local.set({'wid': window.id});
		}
	);
}

async function getWidnow() {
	let result = await chrome.storage.local.get(["wid"]);
	let wid = parseInt(result.wid);
	// console.log(`${result.wid} ${wid}`);
	if (wid) {
		// 不能使用windows.get，当id对应窗口不存在时会报错
		let windows = await chrome.windows.getAll({windowTypes: ['popup']});
		for (let w of windows) {
			if (w.id === wid) {
				return w;
			}
		}
	}
	return null;
}

chrome.windows.onRemoved.addListener(async (wid) => {
	let window = await getWidnow();
	if (!window) {	// 窗口不存在，则说明关闭的是本窗口；否则关闭的是其他窗口
		chrome.storage.local.set({'wid': ""});
		chrome.action.setBadgeText({text: ""});
	}
});

chrome.notifications.onClicked.addListener(async (notificationId) => {
	// console.log("click the notification");
	let window = await getWidnow();
	if (window && notificationId.startsWith(`net.focustodo`)) {
		let info = { focused: true };
		chrome.windows.update(window.id, info);
		chrome.notifications.clear(notificationId);
	}
});

chrome.action.onClicked.addListener(async () => {
	// console.log(`action.onClicked`);
	let window = await getWidnow();
	if (window) {
		// console.log("Active the old window!");
		let info = { focused: true };
		chrome.windows.update(window.id, info);
	} else {
		// console.log("Create a new window!");
		// 以小（mac）为准：mac用户如果调整为一个较小值后，重启能恢复
		let left = 100;
		let top = 100;
		let width = 1000;
		let height = 598;
		let result = await chrome.storage.sync.get(['windowSize']);
		if (result.windowSize) {
			width = parseInt(result.windowSize.width);
			height = parseInt(result.windowSize.height);
		}
		width = Math.max(width, 1000);
		height = Math.max(height, 598);
		if (chrome.system && chrome.system.display) {
			let displays = await chrome.system.display.getInfo();
			if (displays.length > 0) {
				let display = displays[0];
				let bounds = display.bounds;
				width = Math.min(bounds.width, width);
				height = Math.min(bounds.height, height);
				left = parseInt((bounds.width - width) / 2);
				top = parseInt((bounds.height - height) / 2);
				createWindow(left, top, width, height);
			} else {
				createWindow(left, top, width, height);
			}
		} else {
			createWindow(left, top, width, height);
		}
	}
});

// chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
// 	console.log(sender.tab ? "from a content script:" + sender.tab.url : "from the extension");
//     if (request.greeting === "hello") {
//       	sendResponse({farewell: "goodbye"});
//     }
// });

console.log(`background.js loaded`);