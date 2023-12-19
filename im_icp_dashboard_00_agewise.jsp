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
PreparedStatement psTempV = null;
Statement st_icp = con.createStatement();
ResultSet rs_icp = null;
ResultSet rsMain = null;
ResultSet rsTemp = null;
ResultSet rsTempV = null;
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
<title>IndexForm</title>
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
	.fixTableHead thead th {
	position: sticky; 
	top: 0; 
	} 
	.fixTableHead thead tr:nth-child(1) {
	position: sticky; 
	top: 0; 
	} 
	.fixTableHead thead tr:nth-child(2) {
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
	/*	function compare_report()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_test.jsp?&icp="+document.entryfrm.compare_icp.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_test.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				document.entryfrm.submit();
				return true;
		}*/

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

<br>
	</div>
		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
		<div class="aboutsection">
		<section id="Home">
		<div class="pt-4" id="Home">
		
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
<%//////////////////////	Agewise Statistics in last 7 days - Start	/////////////////////////////////

	String WeeklyArrAgewise = "";
	String WeeklyArrAgewiseXAxis = "";
	int M0_M6_Arr = 0;
	int M6_Y1_Arr = 0;
	int Y1_Y5_Arr = 0;
	int Y5_Y10_Arr = 0;
	int Y10_Y20_Arr = 0;
	int Y20_Y30_Arr = 0;
	int Y30_Y40_Arr = 0;
	int Y40_Y50_Arr = 0;
	int Y50_Y60_Arr = 0;
	int Y60_Y70_Arr = 0;
	int Y70_Y80_Arr = 0;
	int Y80_Y90_Arr = 0;
	int Y90_Y100_Arr = 0;
	int Y100_Arr = 0;
	

	StringBuilder weekDaysAgewise = new StringBuilder();
	StringBuilder weekM0_M6_Arr = new StringBuilder();
	StringBuilder weekM6_Y1_Arr = new StringBuilder();
	StringBuilder weekY1_Y5_Arr = new StringBuilder();
	StringBuilder weekY5_Y10_Arr = new StringBuilder();
	StringBuilder weekY10_Y20_Arr = new StringBuilder();
	StringBuilder weekY20_Y30_Arr = new StringBuilder();
	StringBuilder weekY30_Y40_Arr = new StringBuilder();
	StringBuilder weekY40_Y50_Arr = new StringBuilder();
	StringBuilder weekY50_Y60_Arr = new StringBuilder();
	StringBuilder weekY60_Y70_Arr = new StringBuilder();
	StringBuilder weekY70_Y80_Arr = new StringBuilder();
	StringBuilder weekY80_Y90_Arr = new StringBuilder();
	StringBuilder weekY90_Y100_Arr = new StringBuilder();
	StringBuilder weekY100_Arr = new StringBuilder();

	 boolean flagFlightCountb = false;
	try {
		WeeklyArrAgewise = "select SUM(M0_M6) as M0_M6, SUM(M6_Y1) as M6_Y1,SUM(Y1_Y5) as Y1_Y5,SUM(Y5_Y10) as Y5_Y10,SUM(Y10_Y20) as Y10_Y20,SUM(Y20_Y30) as Y20_Y30,SUM(Y30_Y40) as Y30_Y40,SUM(Y40_Y50) as Y40_Y50,SUM(Y50_Y60) as Y50_Y60,SUM(Y60_Y70) as Y60_Y70,SUM(Y70_Y80) as Y70_Y80,  SUM(Y80_Y90) as Y80_Y90,  SUM(Y90_Y100) as Y90_Y100,  SUM(Y100) as Y100, icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from imigration.IM_DASHBOARD_COMBINED_PAX_BOARDING_DATE where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyArrAgewise);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			WeeklyArrAgewiseXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			M0_M6_Arr = rsTemp.getInt("M0_M6");
			M6_Y1_Arr = rsTemp.getInt("M6_Y1");
			Y1_Y5_Arr = rsTemp.getInt("Y1_Y5");
			Y5_Y10_Arr = rsTemp.getInt("Y5_Y10");
			Y10_Y20_Arr = rsTemp.getInt("Y10_Y20");
			Y20_Y30_Arr = rsTemp.getInt("Y20_Y30");
			Y30_Y40_Arr = rsTemp.getInt("Y30_Y40");
			Y40_Y50_Arr = rsTemp.getInt("Y40_Y50");
			Y50_Y60_Arr = rsTemp.getInt("Y50_Y60");
			Y60_Y70_Arr = rsTemp.getInt("Y60_Y70");
			Y70_Y80_Arr = rsTemp.getInt("Y70_Y80");
			Y80_Y90_Arr = rsTemp.getInt("Y80_Y90");
			Y90_Y100_Arr = rsTemp.getInt("Y90_Y100");
			Y100_Arr = rsTemp.getInt("Y100");
			//out.println(weeklyOCICount);

			if (flagFlightCountb == true) {
			  weekDaysAgewise.append(",");
			  weekM0_M6_Arr.append(",");
			  weekM6_Y1_Arr.append(",");
			  weekY1_Y5_Arr.append(",");
			  weekY5_Y10_Arr.append(",");
			  weekY10_Y20_Arr.append(",");
			  weekY20_Y30_Arr.append(",");
			  weekY30_Y40_Arr.append(",");
			  weekY40_Y50_Arr.append(",");
			  weekY50_Y60_Arr.append(",");
			  weekY60_Y70_Arr.append(",");
			  weekY70_Y80_Arr.append(",");
			  weekY80_Y90_Arr.append(",");
			  weekY90_Y100_Arr.append(",");
			  weekY100_Arr.append(",");

				} 
			else
				flagFlightCountb = true;

			weekDaysAgewise.append("\"");
			weekDaysAgewise.append(WeeklyArrAgewiseXAxis);
			weekDaysAgewise.append("\"");
			
			weekM0_M6_Arr.append(M0_M6_Arr);
			weekM6_Y1_Arr.append(M6_Y1_Arr);
			weekY1_Y5_Arr.append(Y1_Y5_Arr);
			  weekY5_Y10_Arr.append(Y5_Y10_Arr);
			  weekY10_Y20_Arr.append(Y10_Y20_Arr);
			  weekY20_Y30_Arr.append(Y20_Y30_Arr);
			  weekY30_Y40_Arr.append(Y30_Y40_Arr);
			  weekY40_Y50_Arr.append(Y40_Y50_Arr);
			  weekY50_Y60_Arr.append(Y50_Y60_Arr);
			  weekY60_Y70_Arr.append(Y60_Y70_Arr);
			  weekY70_Y80_Arr.append(Y70_Y80_Arr);
			  weekY80_Y90_Arr.append(Y80_Y90_Arr);
			  weekY90_Y100_Arr.append(Y90_Y100_Arr);
			  weekY100_Arr.append(Y100_Arr);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysAgewise = weekDaysAgewise.toString();
	String strweekM0_M6_Arr = weekM0_M6_Arr.toString();
	String strweekM6_Y1_Arr = weekM6_Y1_Arr.toString();
	String strweekY1_Y5_Arr = weekY1_Y5_Arr.toString();
	String strweekY5_Y10_Arr = weekY5_Y10_Arr.toString();
	String  strweekY10_Y20_Arr = weekY10_Y20_Arr.toString();
	String  strweekY20_Y30_Arr = weekY20_Y30_Arr.toString();
	 String strweekY30_Y40_Arr = weekY30_Y40_Arr.toString();
	 String strweekY40_Y50_Arr = weekY40_Y50_Arr.toString();
	String  strweekY50_Y60_Arr = weekY50_Y60_Arr.toString();
	 String strweekY60_Y70_Arr = weekY60_Y70_Arr.toString();
	 String strweekY70_Y80_Arr = weekY70_Y80_Arr.toString();
	 String strweekY80_Y90_Arr = weekY80_Y90_Arr.toString();
	 String strweekY90_Y100_Arr = weekY90_Y100_Arr.toString();
	 String strweekY100_Arr = weekY100_Arr.toString();
	
	
	//out.println(strHourlyOCI);
	
	////////////////	Table -  Indian/Foreigner Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-12">

		<table class="tableDesign" height="100">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">Below&nbsp;06&nbsp;Months&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">06&nbsp;Months&nbsp;to&nbsp;01&nbsp;Yr&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">01&nbsp;to&nbsp;05&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">05&nbsp;to&nbsp;10&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">10&nbsp;to&nbsp;20&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">20&nbsp;to&nbsp;30&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">30&nbsp;to&nbsp;40&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">40&nbsp;to&nbsp;50&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">50&nbsp;to&nbsp;60&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">60&nbsp;to&nbsp;70&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">70&nbsp;to&nbsp;80&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">80&nbsp;to&nbsp;90&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">90&nbsp;to&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#e33740;border-color: #bf1a23;width:20%; text-align: right;">Above&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysNationality.toString();
			String strWeekBioEnrolled = weekIndian.toString();
			String strWeekBioVerified = weekForeigner.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weeklyDaysAgewise = strWeekDaysAgewise.toString().replace("\"", "").split(",");
			String[] weeklyM0_M6_Arr = strweekM0_M6_Arr.split(",");
			String[] weeklyM6_Y1_Arr = strweekM6_Y1_Arr.split(",");
			String[] weeklyY1_Y5_Arr = strweekY1_Y5_Arr.split(",");
			String[] weeklyY5_Y10_Arr = strweekY5_Y10_Arr.split(",");
			String[] weeklyY10_Y20_Arr = strweekY10_Y20_Arr.split(",");
			String[] weeklyY20_Y30_Arr = strweekY20_Y30_Arr.split(",");
			String[] weeklyY30_Y40_Arr = strweekY30_Y40_Arr.split(",");
			String[] weeklyY40_Y50_Arr = strweekY40_Y50_Arr.split(",");
			String[] weeklyY50_Y60_Arr = strweekY50_Y60_Arr.split(",");
			String[] weeklyY60_Y70_Arr = strweekY60_Y70_Arr.split(",");
			String[] weeklyY70_Y80_Arr = strweekY70_Y80_Arr.split(",");
			String[] weeklyY80_Y90_Arr = strweekY80_Y90_Arr.split(",");
			String[] weeklyY90_Y100_Arr = strweekY90_Y100_Arr.split(",");
			String[] weeklyY100_Arr = strweekY100_Arr.split(",");

			for (int i = 0; i < weeklyDaysAgewise.length; i++) {
			%>
	<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:20px; hover">
		<td style="background-color:#ffc4c8;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weeklyDaysAgewise[i].replace("-","&#8209;")%></td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM0_M6_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyM0_M6_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM6_Y1_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyM6_Y1_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY1_Y5_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY1_Y5_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY5_Y10_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY5_Y10_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY10_Y20_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY10_Y20_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY20_Y30_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY20_Y30_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY30_Y40_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY30_Y40_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY40_Y50_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY40_Y50_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY50_Y60_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY50_Y60_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY60_Y70_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY60_Y70_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY70_Y80_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY70_Y80_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY80_Y90_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY80_Y90_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffe6e7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY90_Y100_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY90_Y100_Arr[i]))%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffd4d7;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY100_Arr[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(weeklyY100_Arr[i]))%>&nbsp;&nbsp;</td>
	</tr>
<%
			}
			%>
		</table>
		</div>
		</div>
	</div>
	<%///////////////////////	Table - Indian/Foreigner Count in last 7 days - End	////////////////////////%>

<br><br>
<br><br>
<div class="container-fluid">
<div class="row">
<div class="col-sm-12">

<div class="card" style="border: solid 3px #da1e28; border-radius: 20px; height:550px;">

<div class="card-body" style=" height:550px; ">

<canvas id="canvasWeeklyAgewise2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #fbcadd 100%);border-radius: 20px;height:550px; "></canvas>
	</div>
	</div>	
	</div>
	</div>
	
	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysAgewise%>],
			datasets: [{ 
				  label: "6 Months",
			      backgroundColor: "#377ff3",
			      borderColor: "#377ff3",
			      borderWidth: 1,
			     
			      data: [<%=strweekM0_M6_Arr%>]
			},{ 
				  label: "6 Months to 1 Year",
			      backgroundColor: "#FF4B91",
			      borderColor: "#FF4B91",
			      borderWidth: 1,
			     
			      data: [<%=strweekM6_Y1_Arr%>]
			},{ 
				  label: "1-5 Years",
			      backgroundColor: "brown",
			      borderColor: "brown",
			      borderWidth: 1,
			     
			      data: [<%=strweekY1_Y5_Arr%>]
			},{ 
				  label: "5-10 Years",
			      backgroundColor: "cadetblue",
			      borderColor: "cadetblue",
			      borderWidth: 1,
			     
			      data: [<%=strweekY5_Y10_Arr%>]
			},{ 
				  label: "10-20 Years",
			      backgroundColor: "chartreuse",
			      borderColor: "chartreuse",
			      borderWidth: 1,
			     
			      data: [<%=strweekY10_Y20_Arr%>]
			},{ 
				  label: "20-30 Years",
			      backgroundColor: "coral",
			      borderColor: "coral",
			      borderWidth: 1,
			     
			      data: [<%=strweekY20_Y30_Arr%>]
			},{ 
				  label: "30-40 Years",
			      backgroundColor: "cornflowerBlue",
			      borderColor: "cornflowerBlue",
			      borderWidth: 1,
			     
			      data: [<%=strweekY30_Y40_Arr%>]
			},{ 
				  label: "40-50 Years",
			      backgroundColor: "darkCyan",
			      borderColor: "darkCyan",
			      borderWidth: 1,
			     
			      data: [<%=strweekY40_Y50_Arr%>]
			},{ 
				  label: "50-60 Years",
			      backgroundColor: "red",
			      borderColor: "levender",
			      borderWidth: 1,
			     
			      data: [<%=strweekY50_Y60_Arr%>]
			},{ 
				  label: "60-70 Years",
			      backgroundColor: "goldenrod",
			      borderColor: "goldenrod",
			      borderWidth: 1,
			     
			      data: [<%=strweekY60_Y70_Arr%>]
			},{ 
				  label: "70-80 Years",
			      backgroundColor: "fuchsia",
			      borderColor: "fuchsia",
			      borderWidth: 1,
			     
			      data: [<%=strweekY70_Y80_Arr%>]
			},{ 
				  label: "80-90 Years",
			      backgroundColor: "gold",
			      borderColor: "gold",
			      borderWidth: 1,
			     
			      data: [<%=strweekY80_Y90_Arr%>]
			},{ 
				  label: "90-100 Years",
			      backgroundColor: "grey",
			      borderColor: "grey",
			      borderWidth: 1,
			     
			      data: [<%=strweekY90_Y100_Arr%>]
			},{ 
				  label: "100 Years",
			      backgroundColor: "khaki",
			      borderColor: "khaki",
			      borderWidth: 1,
			     
			      data: [<%=strweekY100_Arr%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
		responsive:true,
		maintainAspectRatio: false,				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		//stacked: true
		display: false,
		}],
		xAxes: [{
		//stacked: true,
		gridLines: {
			color:"grey",
		}
		
		}]
		},
		 title: {
				display: true,
					text:'Age-wise Statistics in last 7 days',
				fontSize: 25,		
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 8px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x-1, bar._model.y );

							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyAgewise2').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

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





























