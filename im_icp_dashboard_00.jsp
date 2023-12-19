<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
<%
Connection con = null;
try {

Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "dashboard", "dash321");

/*Server Time for Reverse Timer*/
java.util.Date current_Server_Time2 = new java.util.Date();
DateFormat vDateFormat21 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
String vServerTime = vDateFormat21.format(current_Server_Time2);
PreparedStatement psMain = null;
PreparedStatement psTemp = null;
Statement st_icp = con.createStatement();
ResultSet rs_icp = null;
ResultSet rsMain = null;
ResultSet rsTemp = null;
String dashQuery = "";
String depQuery = "";
int today_Arrival_Count = 0;
int total_Arrival_Flights = 0;
int dep_Passenger_Flights = 0;
int daily_Dep_Count = 0;
int total_Dep_Flights = 0;
int total_Arrival_Count = 0;
int yesterday_Arrival_Count = 0;
int total_Dep_Count = 0;
int arr_Flight_Count = 0;
int yest_Flight_Count = 0;
String WeeklyPAXQuery = "";
String weekly_XAxis = "";
int weekelyArrPaxCount = 0;
int weekelyDepPaxCount = 0;

String WeeklyFlightsQuery = "";
String weeklyFlightXAxis = "";
int weekelyArrFlightCount = 0;
int weekelyDepFlightCount = 0;

String arrHourlyQuery = "";
String hourlyXAxis = "";
int hourlyArrFlightCount = 0;
int hourlyArrPaxCount = 0;
int hourlyArrActiveCounter = 0;

String depHourlyQuery = "";
String hourlyDepXAxis = "";
int hourlyDepFlightCount = 0;
int hourlyDepPaxCount = 0;
int hourlyDepActiveCounter = 0;
int displayHours = 12;
int t_Total = 0;
int t_Total_Arr = 0;

String dash = "";
////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

// DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
DateFormat vDateFormatYes = new SimpleDateFormat("dd MMM");
java.util.Date current_Server_Time = new java.util.Date();
String today_date = vDateFormatYes.format(current_Server_Time);	
java.util.Date yesterday_date_in_millis = new java.util.Date(System.currentTimeMillis()-1*24*60*60*1000);
String yesterday_date = vDateFormatYes.format(yesterday_date_in_millis);

String filter_icp = request.getParameter("icp") == null ? "004" : request.getParameter("icp");
String default_hrs = request.getParameter("default_hrs") == null ? "8" : request.getParameter("default_hrs");
displayHours = Integer.parseInt(default_hrs);
//out.println("kuhkihfayfdjhj" + filter_icp);
if(filter_icp.equals("")) filter_icp = "" + filter_icp + "";


	rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from imigration.IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
	
	while(rsTemp.next())
	{
%>
		<!--<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC")%></option>--><%
		if(filter_icp.equals(rsTemp.getString("ICP_SRNO")))
		{
				dash = rsTemp.getString("ICP_DESC");
				
		}
	}
	 rsTemp.close();  
	 int div_hgt = 200; 
	 if(filter_icp.equals("All")) {
		 div_hgt = 600;
	 }


%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="refresh" content="600"> <!-- auto refresh the page after 3600 seconds -->
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">   

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Immigration</title>
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style1.css" rel="stylesheet" type="text/css">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="css/all.min.css" media="all">
<link rel="stylesheet" href="css/style.css" media="all">
<script src="bar.js" type="text/javascript"></script>
<script src="js/Charts.js"></script>

<style>
	.fixTableHead { 
	overflow-y: auto; 
	overflow-x: auto; 
	height: 385px; 
	margin: auto;

	} 
	.fixTableHead thead {
	position: sticky; 
	top: 0; 
	} 
	.fixTableHead thead tr {
	position: sticky; 
	top: 0; 
	} 


canvas {
   
    background: linear-gradient(to bottom, #ffffff 40%, #fff9b0 100%);
}


.canvasArrPAXFltActCount 
{
    background: linear-gradient(to bottom, #ffffff 40%, #99ccff 100%);
}

.tableDesign {
	border-collapse: separate;
	border-spacing: 0;	
}
.tableDesign tr th, .tableDesign tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tableDesign tr th:first-child, .tableDesign tr td:first-child {
	border-left: 1px solid #bbb;
}

.tableDesign tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}

/* top-left border-radius */
.tableDesign tr:first-child th:first-child {
	border-top-left-radius: 10px;
}

/* top-right border-radius */
.tableDesign tr:first-child th:last-child {
	border-top-right-radius: 10px;
}

/* bottom-left border-radius */
.tableDesign tr:last-child td:first-child {
	border-bottom-left-radius: 10px;
}

/* bottom-right border-radius */
.tableDesign tr:last-child td:last-child {
	border-bottom-right-radius: 10px;
}

.right{
	text-align :right;
	}

</style>

</style>
<style>
body{font-family:Arial, Helvetica, sans-serif;}

.wrapper1{margin:0 auto; width:60%;}
.outer_table td{vertical-align:bottom;}
.main_table {
 border-spacing: 0;
 border-collapse: separate;
 border-radius: 10px 10px 0 0;
 width:100%;
 color:#333;
}
.main_table th:not(:last-child),
.main_table td:not(:last-child) {
 border-right: 1px solid #fff;
}
.main_table>tbody>tr:not(:last-child)>th,
.main_table>tbody>tr:not(:last-child)>td,
.main_table>tr:not(:last-child)>td,
.main_table>tr:not(:last-child)>th,
.main_table>tbody:not(:last-child) {
 border-bottom: 1px solid #fff;
}
.main_table th{padding:3px; color:#fff;}
.main_table td{text-align:center; padding:3px;}
.red_table{background: linear-gradient(#ffd2d4, #fff3f4); border: 2px solid #e11a25;}
.red_table th{background: linear-gradient(to left, #ee515a, #e11a25);}
.green_table{background: linear-gradient(#bdf1f4, #e6f9fa); border: 2px solid #317a83;}
.green_table th{background:linear-gradient(to left, #52bac7, #317a83);}
.purple_table{background: linear-gradient(#ebccf9, #f2e7f7); border: 2px solid #7f3f9f;}
.purple_table th{background:linear-gradient(to left, #bf83dd, #7f3f9f);}
.blue_table{background: linear-gradient(#d6d6d6, #ffffff); border: 2px solid #555e61;}
.blue_table th{background:linear-gradient(to left, #b8c3c7, #606263);}

.gold_table {
    background: linear-gradient(#fbd363, #def3fb);
    border: 2px solid #e2a909;
}

.green_table tr{font-size:11px;}
.red_table tr{font-size:11px;}
.purple_table tr{font-size:11px;}
.blue_table tr{font-size:11px;}
</style>


<%!
		// Function to Print numbers in Indian Format
		// Class for ICP
		class ICP
		{
			String ip;
			String db_link;
			String icp_no;
			public ICP(String icp_no,  String db_link, String ip) {
				this.ip = ip;
				this.db_link = db_link;
				this.icp_no = icp_no;
			}
			public String get_db_link() {
				return db_link;
			}
			public String get_ip() {
				return ip;
			}
			public String get_icp_no() {
				return icp_no;
			}
		}
		// Function to covert AM and PM
		public String convertToAmPm(String timeStr)
		{
			try
			{
				SimpleDateFormat inputFormat = new SimpleDateFormat("HH");
				SimpleDateFormat outputFormat = new SimpleDateFormat("hh a");
				
				java.util.Date date = inputFormat.parse(timeStr);
				String amPmTime = outputFormat.format(date);

				return amPmTime;
			}
			catch(ParseException e)
			{
				e.printStackTrace();
				return null;
			}
		}
%>
<%!
//Capitalising first Charcter of each word in a string,
		public static String capitalizeFirstChar(String IcpNamePrev)	
		{	
			String icpName = IcpNamePrev.toLowerCase();
			String[] arr = icpName.split(" ");
			StringBuffer sb = new StringBuffer();
			for(int j=0 ; j< arr.length ;j++){
				sb.append(Character.toUpperCase(arr[j].charAt(0))).append(arr[j].substring(1)).append(" ");
			}

			return sb.toString().trim();
		}	
%>
<script>
function letternumber(e, str)
		{
			var key;
			var keychar;
			if (window.event)
			   key = window.event.keyCode;
			else if (e)
			   key = e.which;
			else
			   return true;
			keychar = String.fromCharCode(key);
			keychar = keychar.toLowerCase();
			// control keys
			if ((key==null) || (key==0) || (key==8) || 
				(key==9) || (key==13) || (key==27) )
			   return true;
			// alphas and numbers
			else if ((str.indexOf(keychar) > -1))
			   return true;
			else
			   return false;
		}

		function filtery(pattern, list){
         
		  /*

		  if the dropdown list passed in hasn't

		  already been backed up, we'll do that now

		  */

		  if (!list.bak){

			/*

			We're going to attach an array to the select object

			where we'll keep a backup of the original dropdown list

			*/

			list.bak = new Array();

			for (n=0;n<list.length;n++){

			  list.bak[list.bak.length] = new Array(list[n].value, list[n].text);

			}

		  }

		  /*

		  We're going to iterate through the backed up dropdown

		  list. If an item matches, it is added to the list of

		  matches. If not, then it is added to the list of non matches.

		  */

		  match = new Array();

		  nomatch = new Array();

		  for (n=0;n<list.bak.length;n++){

			if(list.bak[n][1].toLowerCase().indexOf(pattern.toLowerCase())!=-1){

			  match[match.length] = new Array(list.bak[n][0], list.bak[n][1]);//value found

			}else{

			  nomatch[nomatch.length] = new Array(list.bak[n][0], list.bak[n][1]);

			}

		  }

		  /*

		  Now we completely rewrite the dropdown list.

		  First we write in the matches, then we write

		  in the non matches

		  */

		  for (n=0;n<match.length;n++){

			list[n].value = match[n][0];

			list[n].text = match[n][1];

		  }

		  for (n=0;n<nomatch.length;n++){

			list[n+match.length].value = nomatch[n][0];

			list[n+match.length].text = nomatch[n][1];

		  }

		  /*

		  Finally, we make the 1st item selected - this

		  makes sure that the matching options are

		  immediately apparent

		  */

		  list.selectedIndex=0;

		}
		function compare_report()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				document.entryfrm.submit();
				return true;
		}

</script>

<!--  Reverse Timer Functions -->
<form name="FormServerTime">
	<input type="hidden" name="ServerTime" value='<%=vServerTime%>'>
</form>

<SCRIPT language="JavaScript" type="text/javascript">
	var CounterTimerID = 0;
	var tStartTimer  = null;
	function UpdateTimer() 
	{
		if(CounterTimerID) 
		{
			clearTimeout(CounterTimerID);
			CounterTimerID  = 0;
		}
		tStartTimer = tStartTimer - 1;
	
		document.entryfrm.ReverseCounterID.value = tStartTimer;
		CounterTimerID = setTimeout("UpdateTimer()", 1000);

		if(tStartTimer == 0) 
		{
			if(CounterTimerID) 
			{
				clearTimeout(CounterTimerID);
				CounterTimerID  = 0;
			}
			tStartTimer = null;
			
			compare_report();
				/*document.entryfrm.target = "_self";
				document.entryfrm.action = "im_icp_epassport_dashboard_vishwa.jsp";
				document.entryfrm.submit();*/
			    return true;
		}
	}
	function StartTimer() 
	{
		tStartTimer = 600;   //10 minutes delay
		CounterTimerID = setTimeout("UpdateTimer()", 1000);
	}
	</script>

<script LANGUAGE="JAVASCRIPT">
	//var dayarray=new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
	var dayarray=new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
	//var montharray=new Array("January","February","March","April","May","June","July","August","September","October","November","December")
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

	var timevar = document.FormServerTime.ServerTime.value;
	var y1=timevar.substring(0,4);
	var m1t=timevar.substring(5,7);
	var m2t=Number(m1t)-1;
	var m1=m2t;
	if (m1==-1){ m1=11; y1=Number(y1)-1 }
	var d1=timevar.substring(8,10);
	var h1=timevar.substring(11,13);
	var mm1=timevar.substring(14,16);
	var s1=timevar.substring(17,19);
	var serverdate=new Date(y1,m1,d1,h1,mm1,s1);
	var serverdate1 = serverdate.getTime();
	var time_counter = 1;

function DigitalTime()
{
	//if (!document.layers && !document.all)	return;
	var DigitalClock = new Date(serverdate1 + (1000 * time_counter++) ); 
	//var DigitalClock = new Date();
	var date = DigitalClock.getDate();
	var month = DigitalClock.getMonth() + 1;
	var hours = DigitalClock.getHours();
	var minutes = DigitalClock.getMinutes();
	var seconds = DigitalClock.getSeconds();
	var dn = "AM";
	if (date < 10)
		date = "0" + date;
	if (month < 10)
		month = "0" + month;

	if (hours >= 12)
	{
		dn = "PM";
		hours = hours - 12;
	}
	if (hours == 0)
		hours = 12;

	if (minutes <= 9)
		minutes = "0" + minutes;
	if (seconds <= 9)
		seconds = "0" + seconds;

	//var digclock = "<font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + DigitalClock.getYear()  + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font>";
	var digclock = "<a href='#' onclick='compare_report();'><font size='1' face='Verdana' color='darkgreen'>" + "<font size='1'>&nbsp;Date : </font>" +  dayarray[DigitalClock.getDay()] + ", " + montharray[DigitalClock.getMonth()] + " " + date + ", " + y1 + "<BR>" + "<font size='1'>&nbsp;Time : </font>" + hours + ":" + minutes + ":" + seconds + " " + dn +  "<BR><font size='1' color='red'>&nbsp;(auto refresh in " + document.entryfrm.ReverseCounterID.value + " seconds)</font></font></a>";
	Clock.innerHTML = digclock;
	setTimeout("DigitalTime()",1000);
 }
</script>
<!-- End :  Reverse Timer Functions -->
<%//////////////////////// New Table ////////////////////////////////%>
<style>
			 #loading {
				 position: fixed;
				 display: block;
				 width: 100%;
				 height: 100%;
				 }
				  /*  Required for date selector */
	div.ui-datepicker {
				font-size:10px;
			}
	/*  Required for date selector */
		</style>
<script>
/////////////// Below are the list of the Function requred to enable the loading division and the timer/////////////////////////////////////////////////

	function enableTimer()
	{
			document.getElementById("loading").style.display='none';
			document.clkfrm.stop_timer.value = "0";
			SetCursor();
	}
			
	var TotalSeconds;
	function CreateTimer(Time) 
	{
		TotalSeconds = Time;
		UpdateTimer();
		window.setTimeout("Tick()", 1000);
	}

	function Tick() 
	{
		if(document.clkfrm.stop_timer.value == "0") return;
		TotalSeconds += 1;
		UpdateTimer();
		window.setTimeout("Tick()", 1000);
	}

	function LeadingZero(Time) 
	{
		return (Time < 10) ? "0" + Time : + Time;
	}

	function UpdateTimer() 
	{
		var Seconds = TotalSeconds;
		var Days = Math.floor(Seconds / 86400);
		Seconds -= Days * 86400;

		var Hours = Math.floor(Seconds / 3600);
		Seconds -= Hours * (3600);

		var Minutes = Math.floor(Seconds / 60);
		Seconds -= Minutes * (60);

		var TimeStr = ((Days > 0) ? Days + " days " : "") + LeadingZero(Hours) + ":" + LeadingZero(Minutes) + ":" + LeadingZero(Seconds)

		digclock = "<font face='Verdana' size='2' color='#FF0000'><b>Timer :- " + TimeStr + "</b></font>";
			
		if (document.layers)
		{
				
			document.layers.Clock.document.write(digclock);
			document.layers.Clock.document.close();
		}
		else if (document.all) {
				
			Clock.innerHTML = digclock;
		}
	}
///////////////////////////////////////////////////////////////////////////////////////////////////
</script>
<%@ page language = "java" import = "java.sql.*, java.io.*, java.awt.*, java.util.*, java.text.*, javax.naming.*, javax.sql.*"%>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%
	DateFormat vDateFormat_N = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDate = new SimpleDateFormat("dd/MM/yyyy");
	DateFormat vHours = new SimpleDateFormat("HH");
	DateFormat vMinut = new SimpleDateFormat("mm");
	DateFormat vDay = new SimpleDateFormat("dd");
	//java.util.Date current_Server_Time = new java.util.Date();
    String vFileName = vDateFormat_N.format(current_Server_Time);
	String sch_time = "";
	String repstring = "";
	int calTime = 0;
	if(Integer.parseInt(vHours.format(current_Server_Time)) > 1)
	{
		sch_time = Integer.parseInt(vHours.format(current_Server_Time))-1+""+vMinut.format(current_Server_Time);
		if(sch_time.length() == 3) sch_time = "0"+sch_time;
	}
	String filter_time = request.getParameter("filter_time") == null ? "1" : request.getParameter("filter_time"); 
	String filter_date = request.getParameter("filter_date") == null ? vDate.format(current_Server_Time) : request.getParameter("filter_date");
	String select_time = filter_time;
	if(filter_time.trim().length() > 0)
	{

		calTime = Integer.parseInt(vHours.format(current_Server_Time)) - Integer.parseInt(filter_time);

		if(calTime > 0)
		{
			
			filter_time = calTime+""+vMinut.format(current_Server_Time);
			if(filter_time.length() == 3) filter_time = "0"+filter_time;
		}
		else
		{
			
			int repint = Integer.parseInt(vDate.format(current_Server_Time).substring(0,2))-1;
			if(repint < 10) repstring = "0"+repint;
			else repstring = ""+repint;
			filter_date = vDate.format(current_Server_Time).replace(vDate.format(current_Server_Time).substring(0,2),repstring);

			filter_time = 24+calTime+""+vMinut.format(current_Server_Time);
			
			if(filter_time.length() == 3) filter_time = "0"+filter_time;

		}
			
	}
	else
	{
		filter_time = sch_time;
		if(filter_date.trim().length() == 0)
			filter_date = vDate.format(current_Server_Time);
	}
	
	//String filter_icp = request.getParameter("filter_icp") == null ? "" : request.getParameter("filter_icp");

%>
<%!
public String getRecTime(String file_name,String boarding_date,Connection con)
{
	String rectime = "";
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		ps = con.prepareStatement("select to_char(APIS_FILE_REC_TIME,'dd/mm/yyyy hh24:mi:ss') as APIS_FILE_REC_TIME from imigration.im_apis_flight@ICSSP_TO_DMRC66 where FLIGHT_SCH_ARR_DATE = to_date('"+boarding_date+"','dd/mm/yyyy') and APIS_FILENAME = '"+file_name+"'");
		rs = ps.executeQuery();
		if(rs.next())
			rectime = rs.getString("APIS_FILE_REC_TIME");
		rs.close();
		ps.close();
		

	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	return rectime;
}
public String getDiffTime(String str_sch_arr_time,String str_apis_rec_time)
{
	long hours_new = 0;
	long minuets_new = 0;
	String color = "";
	String str_time_difference_new = "";
	try
	{
		
		if(!str_sch_arr_time.equals("") && !str_apis_rec_time.equals(""))
		{
			long time_diff_new = (new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str_sch_arr_time).getTime() - new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str_apis_rec_time).getTime())/1000;
			hours_new = time_diff_new/3600;
			minuets_new = (time_diff_new%3600)/60;
			if(hours_new == 0)
				str_time_difference_new = minuets_new+" Minutes";
			else
				str_time_difference_new = hours_new+" Hour "+minuets_new+" Minutes";

			if((hours_new == 0 && minuets_new < 1) || (hours_new < 0))
			 color = "R";
			else if((hours_new == 0 && minuets_new > 1) || (hours_new == 0 && minuets_new == 0))
			  color = "G";
			else if(hours_new >= 1)
			  color = "Y";
			else
			 color = "G";
			
		}
		else
			str_time_difference_new = "";
		}
	catch(Exception e)
	{
	  e.printStackTrace();
	}
	return color+""+str_time_difference_new;
}

%>
</head>
<%//////////////////////// New Table //////////////////////////enableTimer()//////%>
<body onload="DigitalTime(); StartTimer();" style="background-color: #ffffff;">
	<div class="wrapper">
	<div class="flag-strip"></div>
	<header class="bg-white py-1">
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					<a href="#Home"><h1><span>IVFRT (I)</span><br/>National Informatics Centre</h1></a>
				</div>
				<div class="col-sm-4">
			  <img src="Immigration_Logo.png" width="100%" height="90%" alt="Immigration Dashboard" align="center;">
				</div>
				<div class="col-sm-4 text-end">
					<p id="Clock"></p>
				</div>
			</div> 
		</div>
</header>
<div class="menu">
  <nav class="navbar navbar-expand-sm">
	<div class="container"> 
	  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#collapsibleNavbar"> <span class="navbar-toggler-icon"></span> </button>
	  <div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav">
		  <li class="nav-item"><a href="#Home" class="scrollLink nav-link">Home</a></li>
		  <li class="nav-item dropdown"><a href="#Home" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Immigration Clearance</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#ICS_1">Arrival and Departure Immigration Clearance in last 7 days</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_2">Arrival and Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_4">Hourly Clearance of Arrival and Departure Flights in last <%=displayHours%> hours</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Gender">Gender Based Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Indian_Foreigner">Indian/Foreigner Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Flight_Running_Status">Currently Running Flight Status in last 30 minutes</a></li>
 		  <li> <a class="scrollLink dropdown-item" href="#ICS_Agewise">Age-wise Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#Arr_Sch_Flts">Arrival, Departure and Expected Flights</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_PAX">Arrival : Hourly Flight Clearance and Expected Flights</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ICS_Dep_PAX">Departure : Hourly Flight Clearance and Expected Flights</a></ul></li>


		  <li class="nav-item dropdown"><a href="#biometric_1" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Biometrics</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#biometric_1">Arrival : Biometric Enrollment/Verification/Exemption Statistics</a></ul></li>

		  <li class="nav-item dropdown"><a href="#visa_1" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Visa</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#visa_1">Arrival : Visa Clearance in last 7 days</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="#visa_2">Arrival : Visa Clearance in last <%=displayHours%> hours</a></ul></li>

		  <li class="nav-item dropdown"><a href="#ucf_Indian" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">UCF</a>
		  <ul class="dropdown-menu">
		  <li> <a class="scrollLink dropdown-item" href="#ucf_Indian">Indian UCF Matched/Not Matched Statistics in last 7 days</a></li>
		  <li> <a class="scrollLink dropdown-item" href="#ucf_Foreigner">Foreigner UCF Matched/Not Matched Statistics in last 7 days</a></ul></li>
		  

		  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Other Dashboards</a>
		   <ul class="dropdown-menu">
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_evisa_dashboard.jsp" target="_blank" class="scrollLink nav-link">e-Visa</a></li>
			<li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_voa_dashboard.jsp" target="_blank" class="scrollLink nav-link">Visa-on-Arrival</a></li>
			<li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_epassport_dashboard.jsp" target="_blank" class="scrollLink nav-link">e-Passport</a></li>
		  <li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_images_dashboard.jsp" target="_blank" class="scrollLink nav-link">Images</a></li>
		  <li><a class="scrollLink dropdown-item" href="http://10.248.168.222:8888/Imm/icp_dashboard/im_cruise_dashboard.jsp" target="_blank" class="scrollLink nav-link">Cruise Clearance (e-LC)</a></ul></li>

		  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
		   <ul class="dropdown-menu">
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_pax.jsp" target="_blank">Immigration Control System</a> </li>
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
			<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
		  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>
	   </ul>			   
	  </div>			  
	</div>
	<span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;<%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%>&nbsp;</font></span>
  </nav>

</div>

<form name="entryfrm" method="post">
  <input class="input" type="hidden" name="ReverseCounterID" size="55" maxlength="55" value="600">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td style="text-align: center;">
			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b>

			<input height="40" type="text" style="color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="10" name="source_port1" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')">
			<!--filtery function-->
			<!--letternumber function-->
			<select class="form-select-sm" name="compare_icp" onKeyDown="if(event.keyCode==13) event.keyCode=9;">

<!-- 			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>
 --><%
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from imigration.IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
			while(rsTemp.next())
			{
%>
				<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC")%></option>
<%
			}
			 rsTemp.close();  
			  div_hgt = 200; 
			 if(filter_icp.equals("All")) {
				 div_hgt = 600;
			 }
%> 
			</select>&nbsp;&nbsp;
			<!--&nbsp;&nbsp;<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			&nbsp;&nbsp;<button class="btn btn-primary btn-sm" type="button" onClick="compare_report();"> Generate </button>



			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;Select Hours&nbsp;&nbsp;</b>
			<select class="form-select-sm"  name="default_hrs">
			<option value="6" <%if(default_hrs.equals("6")){%> selected<%}%>>6</option>
			<option value="7" <%if(default_hrs.equals("7")){%> selected<%}%>>7</option>
			<option value="8" <%if(default_hrs.equals("8")){%> selected<%}%>>8</option>
			<option value="9" <%if(default_hrs.equals("9")){%> selected<%}%>>9</option>
			<option value="10" <%if(default_hrs.equals("10")){%> selected<%}%>>10</option>
			<option value="11" <%if(default_hrs.equals("11")){%> selected<%}%>>11</option>
			<option value="12" <%if(default_hrs.equals("12")){%> selected<%}%>>12</option>
			</select>&nbsp;&nbsp;
			<!--&nbsp;&nbsp;<input type="button" class="Button" value="Go" onclick=" compare_hrs();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			&nbsp;&nbsp;<button class="btn btn-primary btn-sm" type="button" onClick="compare_hrs();"> Go </button>
			</td>
		</tr>
	</table>
</form>
<br>
	</div>
		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
		<div class="aboutsection">
		<section id="Home">
		<div class="pt-4" id="Home">
		<table id = "auto-index" class="table table-sm table-striped">
		   <thead>
			<tr id='head1'>
					<th colspan=9 bgcolor="green">HOME</th>
				</tr>
				<tr id='head' name='home'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th colspan=6>Description</th>
				</tr>
			</thead>
</table><br>
		<%!
		// Function to Print numbers in Indian Format

		public String getIndianFormat(int num){

			String convertedNumber = "";
			int digitCount = 1;
			
			do{
				int currentDigit = num%10;
				num = num /10;
				if( digitCount%2 ==0 && digitCount!=2)
					convertedNumber = currentDigit + "," + convertedNumber;
				else
					convertedNumber = currentDigit + convertedNumber;
				digitCount++;
			
			}while(num>0);
			
			return convertedNumber;
		}
%>

<%!
		// Function to reverse time attributes in graph

		    public static String reverseOnComma(String input){

			String parts[] = input.split(",");
			StringBuilder reversed = new StringBuilder();

			for(int i = parts.length - 1; i >= 0; i--){
			reversed.append(parts[i]);
			if(i>0){
				reversed.append(",");
			}
		}
		return reversed.toString();
	}
	%>
<%//////////////////////////	Arrival PAX Count	Tabs	//////////////////////////////////
	try {
		dashQuery = "select distinct GRAND_TOTAL_PAX_ARR as arr_Passenger_Count from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	total_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	yesterday_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
	try {
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	today_Arrival_Count = rsTemp.getInt("arr_Passenger_Count");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	//String test_no = getIndianFormat(total_Arrival_Count);
%>
<%/////////////////////////////////	Departure PAX Count	Tabs	///////////////////////////////////////////////////
int today_Dep_Count = 0;
int yest_Dep_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;;

try {
	dashQuery = "select distinct GRAND_TOTAL_PAX_DEP as dep_Passenger from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		total_Dep_Count = rsTemp.getInt("dep_Passenger");

		total_PAX_Count = total_Arrival_Count + total_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		yest_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		total_Yest_Count = yest_Dep_Count + yesterday_Arrival_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		today_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		total_Today_PAX_Count = today_Arrival_Count + today_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}



////////////////////	Arrival Flights Count	Tabs	/////////////////////////


try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_ARR as total_Arrival_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			total_Arrival_Flights = rsTemp.getInt("total_Arrival_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			arr_Flight_Count = rsTemp.getInt("arr_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			yest_Flight_Count = rsTemp.getInt("arr_Flights");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	/////////////////////////////////////////	Departure Flights Count	Tabs	////////////////////////////////////////////////////

	int yest_Dep_Flights = 0;
	int today_Dep_Flights = 0;
	int total_Flights_Count = 0;
	int total_Flights_Count_Yest = 0;
	int total_Flights_Count_Today = 0;
	
	try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_DEP as total_Dep_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			total_Dep_Flights = rsTemp.getInt("total_Dep_Flights");
			total_Flights_Count =  total_Dep_Flights + total_Arrival_Flights;

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			yest_Dep_Flights = rsTemp.getInt("dep_Flights");
			total_Flights_Count_Yest = yest_Flight_Count + yest_Dep_Flights;
			
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	try {
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from imigration.im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

			today_Dep_Flights = rsTemp.getInt("dep_Flights");
			total_Flights_Count_Today = arr_Flight_Count + today_Dep_Flights;
		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
	%>

</section>



<%////////////////	Arrival PAX Count Tabs - Start	///////////////////////%>
<br><br><br><br><br><br><br>
<div class="container">
<div class="row">
<div class="col-sm-4" style="flex:3;">
		<table class="tableDesign">
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;">Arrival</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;"><%=getIndianFormat(today_Arrival_Count)%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;Footfall</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3"><%=getIndianFormat(yesterday_Arrival_Count)%></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;Footfall</td>
		</tr>		
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td id="countArr" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #44a9ff;"></td>
			<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Overall&nbsp;Footfall</td>
		</tr>
	</table>
</div>
<%////////////////	Arrival Flights Count Tabs - Start	///////////////////////%>

<div class="col-sm-2" style="flex:2;"><br><br><br><br><br>
<table class="tableDesign">	
			<tr style="font-size: 20px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;text-align: center;">Arrival&nbsp;Flights</th>
			</tr>
			<tr style="font-size: 15px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #004076;font-size: 20px;"><%=getIndianFormat(arr_Flight_Count)%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #004076;font-size: 12px;">&nbsp;Today&nbsp;Flights</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color :#0072d3;font-size: 20px;"><%=getIndianFormat(yest_Flight_Count)%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color :#0072d3;font-size: 12px;">&nbsp;Yesterday&nbsp;Flights</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArrFlt" style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #44a9ff;font-size: 20px;"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #44a9ff;font-size: 12px;">&nbsp;Overall&nbsp;Flights</td>
			</tr>
		</table>
	</div>
<%////////////////	Departure PAX Count Tabs - Start	///////////////////////%>


	<div class="col-sm-4" style="flex:3;">
	<table class="tableDesign">		
		<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;">Departure</th>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;"><%=getIndianFormat(today_Dep_Count)%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;">&nbsp;Today's&nbsp;Footfall</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">		
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;"><%=getIndianFormat(yest_Dep_Count)%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;Footfall</td>
		</tr>		
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">		
			<td id="count_total_Dep_Count" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #a376e2;"></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Overall&nbsp;Footfall</td>
		</tr>
	</table>
</div>
<%////////////////	Departure Flights Count Tabs - Start	///////////////////////%>

<div class="col-sm-2" style="flex:2;"><br><br><br><br><br>
<table class="tableDesign">
		<tr style="font-size: 20px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
			<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0; text-align: center;">Departure&nbsp;Flights</th>
		</tr>
		<tr style="font-size: 15px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">				
			<td style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #5521a0;font-size: 20px;"><%=today_Dep_Flights%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #5521a0;font-size: 12px;">&nbsp;Today&nbsp;Flights</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
			<td style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #864cd9;font-size: 20px;"><%=yest_Dep_Flights%></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #864cd9;font-size: 12px;">&nbsp;Yesterday&nbsp;Flights</td>
		</tr>
		<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">			
			<td id="count_total_Dep_Flights" style="background-color:#e8daff;border-color: #e8daff;width:40%; font-weight: bold; text-align: right;color: #a376e2;font-size: 20px;"></td>
			<td style="background-color:#e8daff;border-color: #e8daff;width:60%; font-weight: bold; text-align: left;color: #a376e2;font-size: 12px;">&nbsp;Overall&nbsp;Flights</td>
		</tr>
	</table>
</div>
</div>
</div>
<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>
<section id="ICS_1"><br><br><br><br><br><br><br>	
<div class="pt-4" id="ICS_1">
	<table id = "auto-index1" class="table table-sm table-striped" >
		<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival and Departure Immigration Clearance in last 7 days</th>
			</tr>				
		</thead>
	</table>
</div>
<jsp:include page="im_icp_dashboard_00_arr_dep_immigration_clearance.jsp"/>
</section>

<section id="ICS_2" ><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_2">
<table id = "auto-index2" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival and Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_arr_dep_pax_flts_counters.jsp"/>
</section>

<section id="ICS_4"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_4"> 
<table id = "auto-index4" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Hourly Clearance of Arrival and Departure Flights in last <%=displayHours%> hours</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_hourly_clearance.jsp"/>
</div>
</section>

<section class="aboutsection" id="ICS_Arr_Indian_Foreigner"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Arr_Indian_Foreigner">
<table id = "auto-index8" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Indian/Foreigner Statistics in last 7 days</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_indian_foreigner.jsp"/>
</section>

<%///////////Gender///////////////////////////////////////////%>
<section class="aboutsection" id="ICS_Arr_Gender"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Arr_Gender">    
<table id = "auto-index8" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Gender Based Statistics in last 7 days</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_gender.jsp"/>
</section>
<%///////////Gender///////////////////////////////////////////%>

<%////////////Indian UCF//////////////////////////////////////////%>
<section id="ucf_Indian"><br><br><br><br><br><br><br>
<div class="pt-4" id="ucf_Indian">    
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
			<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Indian UCF Matched/Not Matched Statistics in last 7 days</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_indian_ucf.jsp"/>
</section>
<%////////////Indian UCF//////////////////////////////////////////%>


<%/////////////Foreigner UCF////////////////////////////////////////////////%>
<section id="ucf_Foreigner"><br><br><br><br><br><br><br>
<div class="pt-4" id="ucf_Foreigner">    
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Foreigner UCF Matched/Not Matched Statistics in last 7 days</th>
	</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_foreigner_ucf.jsp"/>
</div>
</section>
<%/////////////Foreigner UCF////////////////////////////////////////////////%>

<section id="visa_1"><br><br><br><br><br><br><br>
<div class="pt-4" id="visa_1">    
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last 7 days</th>
		</tr>

	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_arr_visa_days.jsp"/>
</section>
	
<section id="visa_2"><br><br><br><br><br><br><br>
<div class="pt-4" id="visa_2">    
<table id = "auto-index7" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last <%=displayHours%> hours</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_arr_visa_hrs.jsp"/>
</section>

<section class="aboutsection" id="biometric_1"><br><br><br><br><br><br><br>
	<div class="pt-4" id="biometric_1">    
	<table id = "auto-index8" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Biometric Enrollment/Verification/Exemption Statistics</th>
			</tr>
		</thead>
	</table>
<jsp:include page="im_icp_dashboard_00_arr_bio_enroll.jsp"/>
</section>	

<section id="ICS_Flight_Running_Status" ><br><br><br><br><br><br><br>
	<div class="pt-4" id="ICS_Flight_Running_Status">
	<table id = "auto-index2" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Currently Running Flight Status in last 30 minutes</th>
			</tr>
		</thead>
	</table><br>
	</div>
<jsp:include page="im_icp_dashboard_00_currently.jsp"/>
</section>

<%///////////////////////////	Start - Arrived, Departed and Expected Flights	/////////////////////////////%>
<section id="Arr_Sch_Flts"><br><br><br><br><br><br><br>
<div class="pt-4" id="Arr_Sch_Flts">
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
			<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival, Departure and Expected Flights</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_arr_dep_expected.jsp"/>
</section>

<!--   ************************Arrival : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->

<section id="ICS_Arr_PAX"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Arr_PAX">    
<table id = "auto-index5" class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
			<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Hourly Flight Clearance and Expected Flights</th>
		</tr>
	</thead>
</table>
<jsp:include page="im_icp_dashboard_00_arr_hourly.jsp"/>
</section>

<!--   ************************Departure : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->
<section id="ICS_Dep_PAX"><br><br><br><br><br><br><br>
	<div class="pt-4" id="ICS_Dep_PAX">    
	<table id = "auto-index5" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
				<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : Hourly Flight Clearance and Expected Flights</th>
			</tr>
		</thead>
	</table>
	</div>
<jsp:include page="im_icp_dashboard_00_dep_hourly.jsp"/>
</section>
	

<section id="ICS_Agewise"><br><br><br><br><br><br><br>
<div class="pt-4" id="ICS_Agewise">
	<table id = "auto-index2" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Age-wise Statistics in last 7 days</th>
			</tr>
		</thead>
	</table><br>
</div>
<jsp:include page="im_icp_dashboard_00_agewise.jsp"/>
</section>
<%/////////////////////////////////////////////AGE-WISE////////REMOVED DUE TO CODE TOO LARGE ERROR/////////
 //Used Include tag for im_icp_dashboard_agewise.jsp Table      
 %>

<%////////////////////////////////////////////AGE-WISE////////////%>
<section id="biometric_2">
	<div class="pt-4" id="biometric_2">
	<table id = "auto-index9" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: red; color: white; font-size: 22px;text-align: center;"></th>
			</tr>
		</thead>	
	</table>
	</div>
</section>
<script>
/////////////////// Total Arrival Footfall /////////////////////
let counts_arr_total_pax = setInterval(updated_arr_total_pax);
        let upto_arr_total_pax = <%=(total_Arrival_Count)-400%>;
        function updated_arr_total_pax() {
            upto_arr_total_pax = ++upto_arr_total_pax;
            document.getElementById('countArr').innerHTML = upto_arr_total_pax.toLocaleString('en-IN');
            if (upto_arr_total_pax == <%=total_Arrival_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }
/////////////////////////////////Total Departure Footfall ///////////////////////////////////////
let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Dep_Count)-400%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Dep_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Dep_Count%>) {
                clearInterval(counts_dep_pax);
            }
        }

///////////////////////////// Total Arrival Flights //////////////////////////////////////
let counts_arr_flights = setInterval(updated_arr_flights);
        let upto_arr_flights = <%=(total_Arrival_Flights)-400%>;
        function updated_arr_flights() {
            upto_arr_flights = ++upto_arr_flights;
            document.getElementById('countArrFlt').innerHTML = upto_arr_flights.toLocaleString('en-IN');
            if (upto_arr_flights === <%=total_Arrival_Flights%>) {
                clearInterval(counts_arr_flights);
            }
        }
//////////////////////////////////////// Total Departure Flights ////////////////////////////////////////
let counts_dep_flights = setInterval(updated_dep_flights);
        let upto_dep_flights = <%=(total_Dep_Flights)-400%>;
        function updated_dep_flights() {
            upto_dep_flights = ++upto_dep_flights;
            document.getElementById('count_total_Dep_Flights').innerHTML = upto_dep_flights.toLocaleString('en-IN');
            if (upto_dep_flights === <%=total_Dep_Flights%>) {
                clearInterval(counts_dep_flights);
            }
        }
////////////////////////////////////////////////////////////////////////////////////////////////////////
</script>
<%
} catch (Exception e) {
e.printStackTrace();
} 

finally 
	{
		try
		{
			if (con != null)
					{
					con.close();
					}
			/*if (ctx != null)
					{
					ctx.close();
					}*/
		}
	catch(Exception e)
	{
		//out.println(e.getMessage());
	}
}
%>
		</body>
		</html>
