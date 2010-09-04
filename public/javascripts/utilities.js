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