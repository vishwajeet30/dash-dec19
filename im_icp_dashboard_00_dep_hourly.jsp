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
	<%////////////////////////////////////////////////////////////// Start : Combined APIS and DEPARTURE Statistics ////////////////////////////////////////////////////////////////////////
			

//------------------------------------- List for Map --------------------------------------------//
	Map<String, ICP> icp_srno_dba_link = new LinkedHashMap<String,ICP>(); // For storing ICP_SRNO and DBA_LINKS.
	if(filter_icp.equals("All"))
	{
		icp_srno_dba_link.put("022",new ICP("022","DBL_IVFRT022","10.52.131.131"));    // AMD2
		icp_srno_dba_link.put("010",new ICP("010","DBL_IVFRT010","10.52.141.3"));	// CAL2
		icp_srno_dba_link.put("162",new ICP("162","DBL_IVFRT162","10.52.143.3"));	// HAR2
		icp_srno_dba_link.put("006",new ICP("006","DBL_IVFRT006","10.52.134.3"));	// JAI2
		icp_srno_dba_link.put("033",new ICP("033","DBL_IVFRT033","10.52.138.3"));	// GOA2
		icp_srno_dba_link.put("023",new ICP("023","DBL_IVFRT023","10.52.129.3"));	// TVM2
		icp_srno_dba_link.put("007",new ICP("007","DBL_IVFRT007","10.52.142.195"));	// VAR2
		icp_srno_dba_link.put("094",new ICP("094","DBL_IVFRT094","10.52.145.131"));	// CBE2
		icp_srno_dba_link.put("012",new ICP("012","DBL_IVFRT012","10.52.134.67"));	// GAY2
		icp_srno_dba_link.put("019",new ICP("019","DBL_IVFRT019","10.52.134.131"));	// GUW2
		icp_srno_dba_link.put("021",new ICP("021","DBL_IVFRT021","10.52.142.131"));  // LUC2 
		icp_srno_dba_link.put("092",new ICP("092","DBL_IVFRT092","10.52.146.3"));  // MNG2 
		icp_srno_dba_link.put("026",new ICP("026","DBL_IVFRT026","10.52.132.3"));  // PNE2 
		icp_srno_dba_link.put("003",new ICP("003","DBL_IVFRT003","10.52.145.67"));  // TRY2 
		icp_srno_dba_link.put("016",new ICP("016","DBL_IVFRT016","10.52.131.195"));  // NAG2 
		icp_srno_dba_link.put("364",new ICP("364","DBL_IVFRT164","10.52.147.3"));  // GED2 
		icp_srno_dba_link.put("032",new ICP("032","DBL_IVFRT032","10.52.140.66"));  // AMR2 
		icp_srno_dba_link.put("002",new ICP("002","DBL_IVFRT002","10.52.139.3"));  // KOL2 
		icp_srno_dba_link.put("309",new ICP("309","DBL_IVFRT309","10.52.145.3"));  // MUN2 
		icp_srno_dba_link.put("305",new ICP("305","DBL_IVFRT305","10.52.140.130"));  // ATT2 
		icp_srno_dba_link.put("105",new ICP("105","DBL_IVFRT105","10.52.142.3")) ;// WAG2
		icp_srno_dba_link.put("008",new ICP("008","DBL_IVFRT008","10.52.135.3")) ;// CHN2
		icp_srno_dba_link.put("004",new ICP("004","DBL_IVFRT004","10.52.144.3")) ;// IGI2
		icp_srno_dba_link.put("001",new ICP("001","DBL_IVFRT001","10.52.137.3")) ;// BOM2
		icp_srno_dba_link.put("041",new ICP("041","DBL_IVFRT041","10.52.148.3")) ;// NHYD
		icp_srno_dba_link.put("085",new ICP("085","DBL_IVFRT085","10.52.130.3")) ;// BNG2
		icp_srno_dba_link.put("024",new ICP("024","DBL_IVFRT024","10.52.136.3")) ;// COH2
		icp_srno_dba_link.put("077",new ICP("077","DBL_IVFRT077","10.52.141.131")) ;// AND2
		icp_srno_dba_link.put("095",new ICP("095","DBL_IVFRT095","10.52.128.3")) ;// SRI2
		icp_srno_dba_link.put("025",new ICP("025","DBL_IVFRT025","10.52.129.67")) ;// VTZ2
		icp_srno_dba_link.put("015",new ICP("015","DBL_IVFRT015","10.52.132.131")) ;// MDU2
		icp_srno_dba_link.put("096",new ICP("096","DBL_IVFRT096","10.52.149.3")) ;// BAG2
		icp_srno_dba_link.put("084",new ICP("084","DBL_IVFRT084","10.52.149.66")) ;// BHU2
		icp_srno_dba_link.put("005",new ICP("005","DBL_IVFRT005","10.52.133.212")) ;// CHA2
		icp_srno_dba_link.put("030",new ICP("030","DBL_IVFRT030","10.52.161.131")) ;// KAN2
		icp_srno_dba_link.put("029",new ICP("029","DBL_IVFRT029","10.52.146.131")) ;// SUR2
		icp_srno_dba_link.put("397",new ICP("397","DBL_IVFRT397","10.52.161.197")) ;// CHIT
		icp_srno_dba_link.put("107",new ICP("107","DBL_IVFRT107","10.52.147.132")) ;// KAR2
		icp_srno_dba_link.put("017",new ICP("017","DBL_IVFRT017","10.52.132.66")) ;// IDR2
		icp_srno_dba_link.put("224",new ICP("224","DBL_IVFRT224","10.52.136.8")) ;// COHSEAPORT
		icp_srno_dba_link.put("888",new ICP("888","DBL_IVFRT888","172.16.1.51")) ;// CICS  
	}
	else if(filter_icp.equals("022"))
		icp_srno_dba_link.put("022",new ICP("022","DBL_IVFRT022","10.52.131.131"));    // AMD2
	else if(filter_icp.equals("010"))
		icp_srno_dba_link.put("010",new ICP("010","DBL_IVFRT010","10.52.141.3"));	// CAL2
	else if(filter_icp.equals("162"))
		icp_srno_dba_link.put("162",new ICP("162","DBL_IVFRT162","10.52.143.3"));	// HAR2
	else if(filter_icp.equals("006"))
		icp_srno_dba_link.put("006",new ICP("006","DBL_IVFRT006","10.52.134.3"));	// JAI2
	else if(filter_icp.equals("033"))
		icp_srno_dba_link.put("033",new ICP("033","DBL_IVFRT033","10.52.138.3"));	// GOA2
	else if(filter_icp.equals("023"))
		icp_srno_dba_link.put("023",new ICP("023","DBL_IVFRT023","10.52.129.3"));	// TVM2
	else if(filter_icp.equals("007"))
		icp_srno_dba_link.put("007",new ICP("007","DBL_IVFRT007","10.52.142.195"));	// VAR2
	else if(filter_icp.equals("094"))
		icp_srno_dba_link.put("094",new ICP("094","DBL_IVFRT094","10.52.145.131"));	// CBE2
	else if(filter_icp.equals("012"))
		icp_srno_dba_link.put("012",new ICP("012","DBL_IVFRT012","10.52.134.67"));	// GAY2
	else if(filter_icp.equals("019"))
		icp_srno_dba_link.put("019",new ICP("019","DBL_IVFRT019","10.52.134.131"));	// GUW2
	else if(filter_icp.equals("364"))
		icp_srno_dba_link.put("364",new ICP("364","DBL_IVFRT164","10.52.147.3"));  // GED2 
	else if(filter_icp.equals("021"))
		icp_srno_dba_link.put("021",new ICP("021","DBL_IVFRT021","10.52.142.131"));  // LUC2 
	else if(filter_icp.equals("092"))
		icp_srno_dba_link.put("092",new ICP("092","DBL_IVFRT092","10.52.146.3"));  // MNG2 
	else if(filter_icp.equals("026"))
		icp_srno_dba_link.put("026",new ICP("026","DBL_IVFRT026","10.52.132.3"));  // PNE2 
	else if(filter_icp.equals("003"))
		icp_srno_dba_link.put("003",new ICP("003","DBL_IVFRT003","10.52.145.67"));  // TRY2 
	else if(filter_icp.equals("016"))
		icp_srno_dba_link.put("016",new ICP("016","DBL_IVFRT016","10.52.131.195"));  // NAG2 
	else if(filter_icp.equals("032"))
		icp_srno_dba_link.put("032",new ICP("032","DBL_IVFRT032","10.52.140.66"));  // AMR2 
	else if(filter_icp.equals("002"))
		icp_srno_dba_link.put("002",new ICP("002","DBL_IVFRT002","10.52.139.3"));  // KOL2 
	else if(filter_icp.equals("309"))
		icp_srno_dba_link.put("309",new ICP("309","DBL_IVFRT309","10.52.145.3"));  // MUN2 
	else if(filter_icp.equals("305"))
		icp_srno_dba_link.put("305",new ICP("305","DBL_IVFRT305","10.52.140.130"));  // ATT2 
	else if(filter_icp.equals("105"))
		icp_srno_dba_link.put("105",new ICP("105","DBL_IVFRT105","10.52.142.3")) ;// WAG2
	else if(filter_icp.equals("008"))
		icp_srno_dba_link.put("008",new ICP("008","DBL_IVFRT008","10.52.135.3")) ;// CHN2
	else if(filter_icp.equals("004"))
		icp_srno_dba_link.put("004",new ICP("004","DBL_IVFRT004","10.52.144.3")) ;// IGI2
	else if(filter_icp.equals("001"))
		icp_srno_dba_link.put("001",new ICP("001","DBL_IVFRT001","10.52.137.3")) ;// BOM2
	else if(filter_icp.equals("041"))
		icp_srno_dba_link.put("041",new ICP("041","DBL_IVFRT041","10.52.148.3")) ;// NHYD
	else if(filter_icp.equals("085"))
		icp_srno_dba_link.put("085",new ICP("085","DBL_IVFRT085","10.52.130.3")) ;// BNG2
	else if(filter_icp.equals("024"))
		icp_srno_dba_link.put("024",new ICP("024","DBL_IVFRT024","10.52.136.3")) ;// COH2
	else if(filter_icp.equals("077"))
		icp_srno_dba_link.put("077",new ICP("077","DBL_IVFRT077","10.52.141.131")) ;// AND2
	else if(filter_icp.equals("095"))
		icp_srno_dba_link.put("095",new ICP("095","DBL_IVFRT095","10.52.128.3")) ;// SRI2
	else if(filter_icp.equals("025"))
		icp_srno_dba_link.put("025",new ICP("025","DBL_IVFRT025","10.52.129.67")) ;// VTZ2
	else if(filter_icp.equals("015"))
		icp_srno_dba_link.put("015",new ICP("015","DBL_IVFRT015","10.52.132.131")) ;// MDU2
	else if(filter_icp.equals("096"))
		icp_srno_dba_link.put("096",new ICP("096","DBL_IVFRT096","10.52.149.3")) ;// BAG2
	else if(filter_icp.equals("084"))
		icp_srno_dba_link.put("084",new ICP("084","DBL_IVFRT084","10.52.149.66")) ;// BHU2
	else if(filter_icp.equals("005"))
		icp_srno_dba_link.put("005",new ICP("005","DBL_IVFRT005","10.52.133.212")) ;// CHA2
	else if(filter_icp.equals("030"))
		icp_srno_dba_link.put("030",new ICP("030","DBL_IVFRT030","10.52.161.131")) ;// KAN2
	else if(filter_icp.equals("029"))
		icp_srno_dba_link.put("029",new ICP("029","DBL_IVFRT029","10.52.146.131")) ;// SUR2
	else if(filter_icp.equals("397"))
		icp_srno_dba_link.put("397",new ICP("397","DBL_IVFRT397","10.52.161.197")) ;// CHIT
	else if(filter_icp.equals("107"))
		icp_srno_dba_link.put("107",new ICP("107","DBL_IVFRT107","10.52.147.132")) ;// KAR2
	else if(filter_icp.equals("017"))
		icp_srno_dba_link.put("017",new ICP("017","DBL_IVFRT017","10.52.132.66")) ;// IDR2
	else if(filter_icp.equals("224"))
		icp_srno_dba_link.put("224",new ICP("224","DBL_IVFRT224","10.52.136.8")) ;// COHSEAPORT
	else if(filter_icp.equals("888"))
		icp_srno_dba_link.put("888",new ICP("888","DBL_IVFRT888","172.16.1.51")) ;// CICS  
	//----------------------------------  List for Map -------------------------------------//
	
	

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	


			DateFormat flightDateFormat = new SimpleDateFormat("dd MMM");

	DateFormat vDateFormat2 = new SimpleDateFormat("HH");
		//java.util.Date current_Server_Time = new java.util.Date();
		String current_hour = vDateFormat2.format(current_Server_Time);
		//out.println(current_hour);


	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from imigration.im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join imigration.im_trans_dep_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from imigration.im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  imigration.im_apis_pax_dep@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		//out.println(strSqlFlightDetails);

		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from imigration.im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join imigration.im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1 ,3 ,passenger_count desc ";

		//out.println(strSqlFlightDetails);

		Statement stFlightDetails = con.createStatement();
		ResultSet rsFlightDetails = null;
		
		LinkedHashMap<String, String> borDateHoursFlightnameCountPair = new LinkedHashMap<String,String>();
		
		try
		{
			rsFlightDetails = stFlightDetails.executeQuery(strSqlFlightDetails);
			
			if(rsFlightDetails.next()){
				do{			
					
					String boarding_date = rsFlightDetails.getDate("boarding_date") == null ? "" : flightDateFormat.format(rsFlightDetails.getDate("boarding_date")); 
					String boarding_time = rsFlightDetails.getString("boarding_time") == null ? "" : rsFlightDetails.getString("boarding_time"); 
					String hours = rsFlightDetails.getString("hours") == null ? "" : rsFlightDetails.getString("hours"); 
					String flight_no = rsFlightDetails.getString("flight_no") == null ? "" : rsFlightDetails.getString("flight_no"); 
					
					String passenger_count = rsFlightDetails.getInt("passenger_count") == 0 ? "0" : rsFlightDetails.getString("passenger_count"); 

					if( borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) == null)
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, flight_no + "##" + passenger_count);
					else
						borDateHoursFlightnameCountPair.put(boarding_date + "#####" + hours, borDateHoursFlightnameCountPair.get(boarding_date + "#####" + hours) + "####" + flight_no + "##" + passenger_count);
					
					
						
				}while(rsFlightDetails.next());
			}

			if(rsFlightDetails!=null)
			{
				rsFlightDetails.close();
				stFlightDetails.close();
			}

		}
		catch(SQLException e)
		{
			out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + strSqlFlightDetails + "<BR><BR></b></font>");
		}

				
		
				int serial_no = 0;
				int maxFlightInHour = - 1;

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{
					if(borDateHoursFlightnameCountPair.get(keyValue).split("####").length > maxFlightInHour)
						maxFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					serial_no++;		
				}

		/////////////////////////////////////////////////////////// Strat : New Table for Flight Count ////////////////////////////////////////////////////////////////////////////////////
				
				%>			
							<BR><BR>
							<table class="outer_table" width="100%"> 
							
								
								<tr>
				<%

				serial_no = 0;
				boolean future_flag = false;			
				boolean future_past_divison = false;
				int current_hour_in_int = Integer.parseInt(current_hour);

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;
					
					int current_row_hour_in_int = Integer.parseInt(keyValue.split("#####")[1]);
					
					if(current_row_hour_in_int > current_hour_in_int)
						future_flag = true;

					if(current_row_hour_in_int > current_hour_in_int)
					{
						future_flag = true;
						
						if(future_past_divison==false)
						{
							%><td style="vertical-align:bottom">
												<table  style="border-collapse: collapse;background-color:black;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="0%" cellpadding="0" cellspacing="0" >
													<%	
														while(maxFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "1">&nbsp;</td>
																</tr>
															<%
															maxFlightInHour--;
														}
													
													%>	
														
														</table></td><%
						}
						future_past_divison = true;
					}

					//////////////////////////////////////////// Start : Curent Hour Sum Calculation //////////////////////////////////////////

					int current_hour_pax_sum = 0;

					for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
					{
						current_hour_pax_sum = current_hour_pax_sum + Integer.parseInt((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);

						//out.println((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);
					}

					//////////////////////////////////////////// End : Curent Hour Sum Calculation //////////////////////////////////////////

					%>
										
								
											<td style="vertical-align:bottom">
												<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="100%" cellpadding="0" cellspacing="0">
													<%	
														while(differenceInFlightInHour > 0)
														{
															%>
																<tr>
																	<td colspan = "2">&nbsp;</td>
																</tr>
															<%
															differenceInFlightInHour--;
														}
													
													%>
														<tr>
															<td colspan = "2" style="font-weight: bold;text-align: center;"><%=current_hour_pax_sum%></td>
														</tr>
														</table>
														<%if( future_flag == false && serial_no%2==0){%>
															<table class="main_table red_table" width="100%">
														<%}else if( future_flag == false && serial_no%2!=0) {%>
															<table class="main_table green_table" width="100%">
														<%}
														else if( future_flag != false && serial_no%2==0){%>
															<table class="main_table blue_table" width="100%">
														<%}else if( future_flag != false && serial_no%2!=0) {%>
															<table class="main_table blue_table" width="100%">
														<%}
													
													
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(future_flag == false)
															{
																if(serial_no%2==0)
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
															else
															{
																if(serial_no%2==0)
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
														}
													%>
													<tr>
														<th style="font-weight: bold;text-align: center; font-size:15px" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%>&nbsp;</th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

							
					</table><BR><BR><%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and DEP Statistics ////////////////////////////////////////////////////////////////////////	%>	

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





























