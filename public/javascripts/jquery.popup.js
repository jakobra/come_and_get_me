function ModalPopup(link) {
    $("#popup a[rel=popup]").attr("href", link).trigger("click");
}

$.fn.popup = function (options) {
    var options = $.extend({
        duration: 250,
        closeContent: null
    }, options);

    if ($("#overlay").size() < 1) {
        $("<div></div>").attr("id", "overlay").appendTo("body")
    }
    var tags = $(this);
    if ($("#popup").size() < 1) {
        $("<div id=\"popup\" class=\"popup\"><div class=\"popup-close\">" + (options.closeContent != null ? options.closeContent : "") + "</div><a href=\"\" style=\"display: none;\" rel=\"popup\"></a><div id=\"popup-container\"></div></div>").appendTo("body");
        tags = tags.add($("#popup a[rel=popup]"));
    }

	var closePopup = function() {
		$('#popup').fadeOut(options.duration, function () {
            $('#overlay').eq(0).fadeOut(options.duration, function () {
                $('#popup > div').eq(1).css("width", "").css("height", "").css("display", "").empty();
                $("#popup").css("width", "").css("height", "").css("position", "").css("left", "").css("top", "");
            });
        });
	} 

    $('#popup > div.popup-close, #overlay').bind('click', function () {
        closePopup();
    });

    var popup = $('#popup');
    var container = $("#popup > div").eq(1);
    var overlay = $('#overlay');

    return tags.each(function () {
        $(this).click(function (event) {
            var anchor = $(this);
            var alreadyVisible = popup.is(":visible");

            var callback = function () {
                if (!alreadyVisible) {
                    overlay.css({ 'opacity': 0, 'display': 'block' }).fadeTo(options.duration, 0.8);
                }

                var href = anchor.attr('href');
                var url = href.split('#')[0];
                var cls = anchor.attr('rev');
                var reset = anchor.hasClass("reset-popup-container");
				
                $.get(url, function (content) {
                    container.data("href", href);
                    popup.attr("class", cls).addClass("popup");
				
                    if (reset) {
                        container.data("initialized", false);
                    }

                    var reposition = function (e) {
                        container.html(content);

						$(".popup-close", container).click(function (event) {
					        closePopup();
							event.preventDefault();
					    });
					
                        var head = $("head");
                        $("style", container).each(function () {
                            head.append($(this).clone());
                            $(this).remove();
                        });

                        Utilities.positionPopup();

                        popup.css("opacity", "0.0000001").show();
                        popup.css("opacity", "").hide();

                        popup.fadeIn(options.duration);
                    }

                    sReg = /\b(src)\s*=\s*"([^"]*)"/g;
                    matchArr = content.match(sReg);

                    var imageCount = 0;
                    if (matchArr != null) {
                        var imagesToLoad = new Array();
                        for (i = 0; i < matchArr.length; i++) {
                            imagesToLoad.push(matchArr[i].replace(/src\s*=\s*"/g, "").replace(/"$/, ""));
                        }
						
                        Utilities.preFetch(imagesToLoad, reposition);
                    } else {
                        reposition();
                    }
                });
            }

            event.preventDefault();
            alreadyVisible ? popup.fadeOut(options.duration, callback) : callback();
        });
    });
}