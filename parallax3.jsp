<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style1.css" rel="stylesheet" type="text/css">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="css/all.min.css" media="all">
<link rel="stylesheet" href="css/parallaxs.css" media="all">
<link rel="stylesheet" href="css/style.css" media="all">
<script src="bar.js" type="text/javascript"></script>
<script src="js/Charts.js"></script>
    <!-- Bootstrap CSS -->

    <!-- CSS -->

    

    <title>Chart</title>
  </head>
<body>

	<div style="line-height: 70px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: center;color: white;">&nbsp;Immigration Dashboard Scrolling Demo</th>
</div>
		<div class="parallax1">
				<div class="container-fluid">
  <div class="row">
  <div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
Gender Statistics
<hr>

<canvas id="canvasPAX1" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ff9fbf 100%);
"></canvas>
</div>
</div>
</div>   
</div> 
</div>  
</div>

  
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],

  datasets: [
    {
      label: 'Male',
      data: [55,50,35,88,76,23,62],
      borderColor: "#377ff3",
	  //borderWidth: 1,
      backgroundColor: '#377ff3',
    },
    {
      label: 'Female',
      borderColor: "#e10076",
	  //borderWidth: 2,      
      data: [75,49,40,83,60,73,62],
      backgroundColor: '#FF4B91',
    },
    {
      label: 'Others',
      borderColor: "#00e0b2",
	  //borderWidth: 2,      
      data: [64,49,29,38,71,56,57],
      backgroundColor: '#00e0b2',


    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}]
},
		 title: {
		        fontSize: 14,		
		      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 14px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX1').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>
<div style="line-height: 60px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: left;color: white;">&nbsp;Arrival : PAX Clearance, Active Flights and Active Counters in last 7 hours</th>
</div>



<!--******************-->
		<div class="parallax2">
				<div class="container-fluid">
  <div class="row">
  <div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
Indian/Foreigner Statistics
<hr>
<canvas id="canvasPAX2" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #b3cffb 100%);"></canvas>
</div>
</div>
</div>   
</div>
 </div>
</div>
    
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],
  datasets: [
    {
      label: 'Indian',
      data: [55,50,35,75,49,40,83],
      borderColor: "#FF004D",
	  borderWidth: 2,
      backgroundColor: '#FF004D',
    },
    {
      label: 'Foreigner',
      borderColor: "#FFAC41",
	  borderWidth: 2,      
      data: [75,49,35,47,36,42,62],
      backgroundColor: '#FFAC41',
    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
			    responsive: true,
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}],

},
					 title: {
					        fontSize: 14,		
					      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 15px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX2').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>



<div style="line-height: 60px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: left;color: white;">&nbsp;Arrival : PAX Clearance, Active Flights and Active Counters in last 7 hours</th>
</div>




		<div class="parallax3">
				<div class="container-fluid">
  <div class="row">
  <div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
      	Gender Statistics
<hr>

<canvas id="canvasPAX3" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ff9fbf 100%);
"></canvas>
</div>
</div>
</div>   
</div> 
</div>  
</div>

  

    
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],

  datasets: [
    {
      label: 'Male',
      data: [55,50,35,88,76,23,62],
      borderColor: "#377ff3",
	  //borderWidth: 1,
      backgroundColor: '#377ff3',
    },
    {
      label: 'Female',
      borderColor: "#e10076",
	  //borderWidth: 2,      
      data: [75,49,40,83,60,73,62],
      backgroundColor: '#FF4B91',
    },
    {
      label: 'Others',
      borderColor: "#00e0b2",
	  //borderWidth: 2,      
      data: [64,49,29,38,71,56,57],
      backgroundColor: '#00e0b2',


    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}]
},
		 title: {
		        fontSize: 14,		
		      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 14px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX3').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>


<div style="line-height: 60px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: left;color: white;">&nbsp;Arrival : PAX Clearance, Active Flights and Active Counters in last 7 hours</th>
</div>

		<div class="parallax4">
				<div class="container-fluid">
  <div class="row">
  <div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
Gender Statistics
<hr>

<canvas id="canvasPAX4" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ff9fbf 100%);
"></canvas>
</div>
</div>
</div>   
 

  

    
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],

  datasets: [
    {
      label: 'Male',
      data: [55,50,35,88,76,23,62],
      borderColor: "#377ff3",
	  //borderWidth: 1,
      backgroundColor: '#377ff3',
    },
    {
      label: 'Female',
      borderColor: "#e10076",
	  //borderWidth: 2,      
      data: [75,49,40,83,60,73,62],
      backgroundColor: '#FF4B91',
    },
    {
      label: 'Others',
      borderColor: "#00e0b2",
	  //borderWidth: 2,      
      data: [64,49,29,38,71,56,57],
      backgroundColor: '#00e0b2',


    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}]
},
		 title: {
		        fontSize: 14,		
		      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 14px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX4').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>



<div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
Gender Statistics
<hr>

<canvas id="canvasPAX4.2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ff9fbf 100%);
"></canvas>
</div>
</div>
</div>   
</div> 
</div>  
</div>

  

    
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],

  datasets: [
    {
      label: 'Male',
      data: [55,50,35,88,76,23,62],
      borderColor: "#377ff3",
	  //borderWidth: 1,
      backgroundColor: '#377ff3',
    },
    {
      label: 'Female',
      borderColor: "#e10076",
	  //borderWidth: 2,      
      data: [75,49,40,83,60,73,62],
      backgroundColor: '#FF4B91',
    },
    {
      label: 'Others',
      borderColor: "#00e0b2",
	  //borderWidth: 2,      
      data: [64,49,29,38,71,56,57],
      backgroundColor: '#00e0b2',


    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}]
},
		 title: {
		        fontSize: 14,		
		      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 14px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX4.2').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>







<div style="line-height: 60px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: left;color: white;">&nbsp;Arrival : PAX Clearance, Active Flights and Active Counters in last 7 hours</th>
</div>


		<div class="parallax5">
				<div class="container-fluid">
  <div class="row">
  <div class="col">
   <div class="chartCard">
      <div class="chartBox" style="border-color: slateblue;border-width: 5px;">
Gender Statistics
<hr>

<canvas id="canvasPAX5" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #ff9fbf 100%);
"></canvas>
</div>
</div>
</div>   
</div> 
</div>  
</div>

  

    
	<script>
		// Data define for bar chart


var data = {
			labels: ["Oct 1", "Oct 2", "Oct 3", "Oct 4", "Oct 5", "Oct 6", "Oct 7"],

  datasets: [
    {
      label: 'Male',
      data: [55,50,35,88,76,23,62],
      borderColor: "#377ff3",
	  //borderWidth: 1,
      backgroundColor: '#377ff3',
    },
    {
      label: 'Female',
      borderColor: "#e10076",
	  //borderWidth: 2,      
      data: [75,49,40,83,60,73,62],
      backgroundColor: '#FF4B91',
    },
    {
      label: 'Others',
      borderColor: "#00e0b2",
	  //borderWidth: 2,      
      data: [64,49,29,38,71,56,57],
      backgroundColor: '#00e0b2',


    }
  ]
};
		// Options to display value on top of bars

		var myoptions = {
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: true
		}],
		xAxes: [{
		stacked: true,display: false
		}]
},
		 title: {
		        fontSize: 14,		
		      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstances = this.chart,
					ctx = chartInstances.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "#fff";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 14px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-14, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		
		//Code to drow Chart

var ctx = document.getElementById('canvasPAX5').getContext('2d');
	var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',
    data: data,
    options: myoptions
});

	</script>
<div style="line-height: 60px;font-family: Arial;background-color:#1192e8;font-size: 22px;text-align: left;color: white;">&nbsp;Arrival : PAX Clearance, Active Flights and Active Counters in last 7 hours</th>
</div>


</body>
</html>