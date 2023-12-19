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
Statement stmtTemp = null;
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
String ip_Address = "";
String icp_Number = "";
String print_Requesters_Name = "";
String print_Requesters_Location = "";

String dash = "";
String table_icp_ip = "";
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
	height: 500px; 
	margin: auto;

	} 
	.fixTableHead thead {
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
		
public String getIcpDesc(String icp,Connection con)
{
	String desc = "";
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		ps = con.prepareStatement("select ICP_DESC from imigration.IM_ICP_LIST where icp_srno = '"+icp+"'");
		rs = ps.executeQuery();
		if(rs.next())
			desc = rs.getString("ICP_DESC");
		rs.close();
		ps.close();
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	return desc;
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
				document.entryfrm.action="im_icp_dashboard_00_test_ip_main2.jsp?&icp="+document.entryfrm.compare_icp.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}
		function compare_report_ip()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_test_ip_main2.jsp?&icp="+document.entryfrm.compare_ip.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_test_ip_main.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
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

%>
</head>
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

<!-- 	<table>
		<thead>
			<tr>
				<th  style="font-family: Arial;background-color: #1780c4; color: white;"></th>
			</tr>				
		</thead>
	</table> -->
	<table id = "auto-index8" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 30px;text-align: center;padding: 0px;">Hash</th>
			</tr>
		</thead>
	</table>
</div>
</div>


<%////////////////////////////////////////////////////////////////////////////////%>

<%////////////////////////////////////////////////////////////////////////////////%>

<div class="container-fluid">
<div class="row" style="margin-top: 155px;">
<div class="col-sm-12">
<table style="background-color:#e8ecf1;border-radius: 5px;">
	<tr style="font-size: 30px;  text-align: left; color:white; height:20px; ">
	  <th style="border-color: #D0DDEA;">

		<form name="entryfrm" method="post">
		  <input class="input" type="hidden" name="ReverseCounterID" size="55" maxlength="55" value="600">
			<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
				<tr bgcolor="#e8ecf1">
					<td style="text-align: center;">

					<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Hash Main&nbsp;</b>
					<input name="r_name" height="40" type="text" style="width:137px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="30"  onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,#/ ')">

					<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Hash&nbsp;</b>
					<input name="r_location" id ="ip" name height="40"type="text" style="color:black;font-weight:bold; height: 28px;  width:137px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="30"  onkeyup="filtery(this.value,this.form.compare_ip)" onchange="filtery(this.value,this.form.compare_ip)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,#/ ')">

<!-- 					<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Client IP</b>
					<input name="ip" id ="ip" name height="40"type="text" style="color:black;font-weight:bold; height: 28px;  width:137px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="15"  onkeyup="filtery(this.value,this.form.compare_ip)" onchange="filtery(this.value,this.form.compare_ip)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, '1234567890.')">
					&nbsp;&nbsp;&nbsp; -->
					
					<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Table Type&nbsp;</b>
					<input name="input_icp" height="40" type="text" style="color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="10" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')">
					<!--filtery function-->
					<!--letternumber function-->
					<select class="form-select-sm" name="compare_icp" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
						<option value="IM_TRANS_ARR_TOTAL">IM_TRANS_ARR_TOTAL</option>
						<option value="IM_TRANS_DEP_TOTAL">IM_TRANS_DEP_TOTAL</option>
					</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
					<button class="btn btn-primary btn-md" type="button" onClick="compare_report()"> Submit </button>
					</td>
				</tr>
			</table>
		</form>
		
	  </th>
	</tr>
</table>
</div>
</div>
</div>
<%/////////////////////////////////Start - IP Address and ICP Table//////////////////////////////////%>
<!-- <div class="container">
<div class="row" style="margin-top: 50px;">
<div class="col-sm-12" style="margin: auto;">

<div class="fixTableHead">
	<table class="tableDesign"> -->
<!-- 	<thead>
		<tr style="font-size: 15px;  text-align: right; color:white; border-color: #bae6ff;height:25px;">
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">S.No.</th>
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">Client&nbsp;IP&nbsp;Address</th>
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">ICP No.</th>
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">ICP Names</th>
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">Requester's&nbsp;Name</th>
			<th  style="text-align: center;background-color:#044e8d;border-color: #004076;text-align: center;">Requester's&nbsp;Location</th>
		</tr> -->
	</thead>
<%
/*int srno = 0;
	try
	{
		String ICP_DESCRING = "";
		table_icp_ip = "select IP_ADDRESS, ICP_LIST, REQUESTERS_NAME, REQUESTERS_LOCATION from imigration.IM_DASHBOARD_IP_ICP_LIST";
		//out.println("&nbsp;<BR>" + table_icp_ip);
		stmtTemp = con.createStatement();
		rsTemp = stmtTemp.executeQuery(table_icp_ip);
		while(rsTemp.next())
		{
			ip_Address = rsTemp.getString("IP_ADDRESS");
			//out.println("IP_ADDRESS - " + ip_Address);
			icp_Number = rsTemp.getString("ICP_LIST");
			print_Requesters_Name = rsTemp.getString("REQUESTERS_NAME");
			print_Requesters_Location = rsTemp.getString("REQUESTERS_LOCATION");
			srno++;
			//out.println("<BR>Name - " + print_Requesters_Name);
			//if(icp_Number.contains("#"))
			{
				String[] icp_srno = icp_Number.split("#");
				//out.println("----------<BR><BR>"+icp_srno);
				ICP_DESCRING = "";
				for(String icpdesc : icp_srno)
				{    
					//out.println("----------<BR><BR>"+icpdesc);
					ICP_DESCRING = ICP_DESCRING + ", " + getIcpDesc(icpdesc,con);
					ICP_DESCRING = capitalizeFirstChar(ICP_DESCRING);

				}
			}
			//out.println("&nbsp;<BR><BR><BR>" + ICP_DESCRING);
*/			
%>
<%			
/*		}
		rsTemp.close();
		stmtTemp.close();		
	}
	catch(SQLException e)
	{
		out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + table_icp_ip + "<BR><BR></b></font>");
	}
	*/
%>
<!-- 	</table>
</div>
</div>
</div>
</div> -->

<%/////////////////////////////////End - IP Address and ICP Table//////////////////////////////////%>
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