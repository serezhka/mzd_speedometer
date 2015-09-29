// ==UserScript==
// @name Speedometer
// @description Speedometer
// @author Serezhka
// @version 0.1
// ==/UserScript==

var speedValue = 0;

function speedometer() {
	$('head').prepend($('<link rel="stylesheet" type="text/css" />').attr('href', 'speedometer/speedometer.css'));
	$('<div />', {id: 'btnDiv'}).appendTo('body');
	$('<img />', {id: 'btnImg', src: 'speedometer/speedometer_btn.png'}).appendTo($('#btnDiv'));
	$('<div />', {id: 'fullscreenDiv'}).appendTo('body');
	$('<img />', {src: '', alt: ''}).appendTo($('#fullscreenDiv'));
	$('#btnDiv').click(function () {
		$('#fullscreenDiv img').attr('src', 'speedometer/speedometer_background.jpg');
		$(this).fadeOut();
		$('#fullscreenDiv').fadeIn();
	});
	$('#fullscreenDiv').click(function () {
		$(this).fadeOut();
		$('#btnDiv').fadeIn();
	});
	$('<text />', {id: 'spdVal'}).appendTo($('#fullscreenDiv'));
	$('#spdVal').text('0');

	setInterval(function () {
		if (framework.getCurrentApp() == 'system' && framework.getCurrCtxtId() == 'Applications') {
			$('#btnDiv').fadeIn();
			updateSpeed();
		} else {
			$('#btnDiv').fadeOut();
			$('#fullscreenDiv').fadeOut();
		}
	}, 1000);

	Cufon.replace('#spdVal');
}

function updateSpeed() {
	$.get('vehSpd.txt', function (data) {
		data = $.trim(data);
		if ($.isNumeric(data) && data != speedValue) {
			speedValue = data;
			$('#spdVal').each(function () {
				var $this = $(this);
				$({Counter: $this.text()}).animate({Counter: speedValue}, {
					duration: 950,
					easing: 'linear',
					step: function (now) {
						$this.text(Math.ceil(now));
						Cufon.replace('#spdVal');
					},
					complete: function () {
						Cufon.replace('#spdVal');
					}
				});
			});
		}
	});
}

function loadFonts() {
	$.ajax({
		url: 'speedometer/cufon-yui.js',
		dataType: 'script',
		success: function () {
			$.ajax({
				url: 'speedometer/7-Segment_italic_500.font.js',
				dataType: 'script',
				success: function () {
					speedometer();
				},
				async: false
			});
		},
		async: false
	});
}

(function () {
	window.opera.addEventListener("AfterEvent.load", function (e) {
		if (!document.getElementById("jquery-script")) {
			var docBody = document.getElementsByTagName("body")[0];
			if (docBody) {
				var script = document.createElement("script");
				script.setAttribute("id", "jquery-script");
				script.setAttribute("src", "speedometer/jquery.min.js");
				script.addEventListener('load', function () {
					var script = document.createElement("script");
					script.textContent = "(" + loadFonts.toString() + ")();";
					docBody.appendChild(script);
				}, false);
				docBody.appendChild(script);
			}
		}
	});
})();