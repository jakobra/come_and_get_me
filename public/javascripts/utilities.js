var Utilities = new Object();

Utilities.preFetch = function(imageArray, callback) {
    var downloaded = 0;
    var isArray = imageArray instanceof Array;
    var loadedArray = new Array();
	console.log(imageArray.length);
    var loaded = function() {
        if (isArray) {
            if (++downloaded == imageArray.length) {
                callback(loadedArray);
            }
        } else {
            callback(loadedArray[0]);
        }
    }

    var load = function(src) {
        var img = new Image();
        loadedArray.push(img);
        img.onload = loaded;
        img.onerror = loaded;
        img.onabort = loaded;
        img.src = src;
    }

    if (isArray) {
        for (i = 0; i < imageArray.length; i++) {
            if (imageArray[i] == null || imageArray[i] == "") {
                loaded();
            } else {
                load(imageArray[i]);
            }
        }
    } else {
        load(imageArray);
    }
}

Utilities.positionPopup = function(callback, width, height) {
    var popup = $("#popup");
    var container = $("#popup-container", popup);

    var offset = document.body.scrollTop || document.documentElement.scrollTop;
    if (width == undefined)
        width = popup.outerWidth();

    if (height == undefined)
        height = popup.outerHeight();

    var position = { left: ($("body").width() / 2 - width / 2) + 'px' };
    if (popup.hasClass("center-vertical") && height < $(window).height()) {
        position.top = (offset + $(window).height() / 2 - height / 2) + 'px';
    } else {
        position.top = offset + 30 + 'px';
    }

    if ($.browser.msie && typeof document.body.style.maxHeight === "undefined") {
        position.left = parseInt(position.left) - (parseInt(position.left) / 2);
    }

    if (callback != null) {
        position.width = width;
        position.height = height;
        popup.animate(position, 250, callback);
    } else {
        popup.css(position);
    }
}

Utilities.popupLoaded = function(callback) {
    var popup = $("#popup");
    var container = $("#popup-container", popup);

    container.css("position", "absolute").css("opacity", "0.0000001").show();
    var width = container.outerWidth();
    var height = container.outerHeight();
    container.removeData("initialized");
    Initialize(container);
    container.css("position", "").css("opacity", "").hide();

    Utilities.positionPopup(
        function() {
            container.fadeIn(250, callback);
        },
        width,
        height
    );
}

Utilities.randomId = function(prefix) {
    return prefix + "_" + Math.ceil(Math.random() * 1000000);
}

Utilities.cookies = {
    getCookie: function(cookieId) {
        var start = document.cookie.indexOf(cookieId + "=");
        if (start > -1) {
            var end = document.cookie.indexOf(";", start);
            if (end == -1)
                end = document.cookie.length;
            return document.cookie.substring(start + cookieId.length + 1, end);
        }
        else
            return null;
    },
    setCookie: function(cookieId, value) {
        document.cookie = cookieId + "=" + value + ";Path=/";
    }
};

Utilities.friendlyDate = function(date) {
    if (typeof date == "string") {
        date = new Date(date);
    }
    var now = new Date();
    var seconds = Math.ceil((now - date) / 1000);

    var text = null;
    var value = 0;

    if (seconds < 60) {
        value = seconds;
        text = (value == 1 ? Texts.FriendyDate.Second1 : Texts.FriendyDate.SecondN);
    } else if (seconds < 60 * 60) {
        value = Math.floor(seconds / 60);
        text = (value == 1 ? Texts.FriendyDate.Minute1 : Texts.FriendyDate.MinuteN);
    } else if (seconds < 60 * 60 * 24) {
        value = Math.floor(seconds / 60 / 60);
        text = (value == 1 ? Texts.FriendyDate.Hour1 : Texts.FriendyDate.HourN);
    } else if (seconds < 60 * 60 * 24 * 7) {
        value = Math.floor(seconds / 60 / 60 / 24);
        text = (value == 1 ? Texts.FriendyDate.Day1 : Texts.FriendyDate.DayN);
    } else if (seconds < 60 * 60 * 24 * 30) {
        value = Math.floor(seconds / 60 / 60 / 24 / 7);
        text = (value == 1 ? Texts.FriendyDate.Week1 : Texts.FriendyDate.WeekN);
    } else if (seconds < 60 * 60 * 24 * 365) {
        value = Math.floor(seconds / 60 / 60 / 24 / 30);
        text = (value == 1 ? Texts.FriendyDate.Month1 : Texts.FriendyDate.MonthN);
    } else {
        value = Math.floor(seconds / 60 / 60 / 24 / 365);
        text = (value == 1 ? Texts.FriendyDate.Year1 : Texts.FriendyDate.YearN);
    }

    return text.replace("{0}", value);
}

Utilities.copy = function(s) {
	if(window.clipboardData && clipboardData.setData) {
		clipboardData.setData("Text", s);
	} else {
		// You have to sign the code to enable this or allow the action in about:config by changing
		user_pref("signed.applets.codebase_principal_support", true);
		netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');

		var clip = Components.classes['@mozilla.org/widget/clipboard;[[[[1]]]]'].createInstance(Components.interfaces.nsIClipboard);
		if (!clip) return;

		// create a transferable
		var trans = Components.classes['@mozilla.org/widget/transferable;[[[[1]]]]'].createInstance(Components.interfaces.nsITransferable);
		if (!trans) return;

		// specify the data we wish to handle. Plaintext in this case.
		trans.addDataFlavor('text/unicode');

		// To get the data from the transferable we need two new objects
		var str = new Object();
		var len = new Object();

		var str = Components.classes["@mozilla.org/supports-string;[[[[1]]]]"].createInstance(Components.interfaces.nsISupportsString);
		var copytext=meintext;
		str.data=copytext;
		trans.setTransferData("text/unicode",str,copytext.length*[[[[2]]]]);
		var clipid=Components.interfaces.nsIClipboard;
		if (!clip) return false;
		clip.setData(trans,null,clipid.kGlobalClipboard);	   
	}
}

function flashContainer(source, width, height) {
    this.source = source;
    this.width = width;
    this.height = height;
    this.params = new Array();

    this.render = function() {
        document.write('<object type="application/x-shockwave-flash" data="');
        document.write(this.source);
        if (this.title) {
            document.write('" title="');
            document.write(this.title);
        }
        document.write('" height="');
        document.write(this.height);
        document.write('" width="');
        document.write(this.width);
        document.write('"><param name="movie" value="');
        document.write(this.source);
        document.writeln('" />');
        for (var param in this.params) {
            document.write('<param name="');
            document.write(param);
            document.write('" value="');
            document.write(this.params[param]);
            document.writeln('" />');
        }
        document.writeln('<param name="wmode" value="transparent" />');
    }
}