$(function() {
	$("div.user_track_statistics a.order").live("click", function(event) {
		$(this).parents("table").load($(this).attr('href'));
		
		event.preventDefault();
	});
});

var chart = new Object();

chart.render_track_statistics = function(categories, times, hr_max, hr_avg, options) {
	new Highcharts.Chart({
		chart: {renderTo: "user_track_statistics_chart",
				marginLeft: 60,
				marginRight: 80},
		title: {text: null},
		xAxis: [{categories: categories,
				 labels: {rotation : 90, align : "left"}}],
		yAxis: [{title: {text: options.yAxisTitleFirst, style : {color: '#e0a421'}}}, 
				{title: {text: options.yAxisTitleSecond, style : {color: '#e0a421'}, margin : 50},
				type : "datetime",
				opposite: true}],
		series: [{name : options.timeSerie, yAxis: 1, data: times},
				 {name : options.hrMaxSerie, data: hr_max},
				 { name : options.hrAvgSerie, data: hr_avg}],
		colors : ["#f10879", "#c98a3b", "#444444"],
		tooltip : {formatter : function() {
			if (this.series.name == options.timeSerie)
				return this.x + "<br/>" + Highcharts.dateFormat("%H:%M:%S", this.y)
			else
				return this.x + "<br/>" + this.y;
		}},
		legend: {enabled: true, verticalAlign : "top", y : 20}
	});
}
