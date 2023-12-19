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

//String filter_icp = request.getParameter("icp") == null ? "004" : request.getParameter("icp");
String default_hrs = request.getParameter("default_hrs") == null ? "8" : request.getParameter("default_hrs");
displayHours = Integer.parseInt(default_hrs);
//out.println("kuhkihfayfdjhj" + filter_icp);
///////////////////////////////////////// Start : Cliet Ip Retrival /////////////////////////////////////////////////////
	
				String Client_IP = request.getRemoteAddr();
				if(Client_IP.equals("null") || Client_IP.length() == 0)
					{Client_IP = "null";}
				else 
					Client_IP = Client_IP;
				//out.println("<br>Client_IP : " + Client_IP);

				Map<String,String> ipToIcpMapping = new LinkedHashMap<String,String>();
				
				ipToIcpMapping.put("10.52.158.36","016#022#004");
				ipToIcpMapping.put("10.52.158.44","016#008");
				ipToIcpMapping.put("10.52.158.441","004#008#016#006");



//|| !ipToIcpMapping.get(Client_IP).contains("004")


	if ( !ipToIcpMapping.containsKey(Client_IP)  )
	{
		%>
			<jsp:forward page="im_icp_dashboard_00_logout.jsp" />
		<%
	}

String filter_icp = request.getParameter("icp") == null ? ipToIcpMapping.get(Client_IP).split("#")[0] : request.getParameter("icp");
///////////////////////////////////////// End : Cliet Ip Retrival //////////////////////////////////////////////////////

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
		/*function compare_report()
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
		}
		*/

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
<%////////////////////////////////////////////	Hourly Clearance of Arrival Flights - Start	////////////////////////////////////////////////////

	String hours_Axis = "";
	String hourly_flight_count_Axis = "";

	StringBuilder hourlyArrAxis = new StringBuilder();
	StringBuilder hourlyArrFlt = new StringBuilder();

	//String hourSet = "";

	boolean zero_entry_Arr = false;
	try {
		dashQuery = "select * from (select to_date(hours,'HH24mi') as date_time, icp_description, hours,hourly_flight_count,active_counter_count,hourly_pax_count from imigration.im_dashboard_combined where table_type = 'IM_TRANS_ARR_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {


			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hours_Axis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hours_Axis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hours_Axis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hours_Axis = rsTemp.getString("hours").substring(0,2) +" PM" ;

			hourly_flight_count_Axis = rsTemp.getString("hourly_flight_count");

			if (zero_entry_Arr == true) {
				hourlyArrAxis.append(",");
				hourlyArrFlt.append(",");
			} else
		zero_entry_Arr = true;
			hourlyArrAxis.append("\"");
			hourlyArrAxis.append(hours_Axis);
			hourlyArrAxis.append("\"");
			hourlyArrFlt.append(hourly_flight_count_Axis);
		}

		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Hourly Count of Arrival Flights Exception");
	}

	String strhours_Axis = hourlyArrAxis.toString();
	String strhourly_flight_count_Axis = hourlyArrFlt.toString();
	//out.println(str1);
	%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-2" style="flex:1;">
	<%////////////////	Table - Hourly Clearance of Arrival Flights - Start	///////////////////////%>
<table class="tableDesign">
		<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:5%;">
				<th style="text-align: center;background-color:#da1e28;border-color: #ab181f;width:50%; text-align: center;">Time</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #ab181f;width:50%; text-align: right;">Arrival&nbsp;Flights&nbsp;&nbsp;</th>
			</tr>									
		<% 
			/*String strhours_Axis = hourlyArrAxis.toString();
				String strhourly_flight_count_Axis = hourlyArrFlt.toString();*/
			String[] hourListArrFlt = strhours_Axis.toString().replace("\"", "").split(",");
			String[] hourListArrFltCount = strhourly_flight_count_Axis.split(",");
			

			for (int i = hourListArrFlt.length-1; i >= 0; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:5%;">
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: center;"><%=hourListArrFlt[i].equals("0") ? "&nbsp;" : hourListArrFlt[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=hourListArrFltCount[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(hourListArrFltCount[i]))%>&nbsp;&nbsp;</td>


			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Arrival Flights - End	////////////////////////%>


	<div class="col-sm-4"  style="flex:2;">
	<div class="card" style="border: solid 3px #da1e28; border-radius: 20px; height:314px;">
	<div class="card-body" style="height:314px;">
<!-- 		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Arrival Flights</h1>
 -->		<canvas id="myPlot1" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #ffd8d8 100%); border-radius: 20px; height:314px;"></canvas>
		</div>
		</div>
		</div>
		<script>
		// Data define for bar chart

		var myDataaaaaa = {
			labels: [<%=reverseOnComma(strhours_Axis)%>],
			datasets: [{ 
				  label: "Arrival Flights",
			      backgroundColor: "#FF6363",
			      borderColor: "red",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strhourly_flight_count_Axis)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptionsssssss = {
			responsive: true,
			maintainAspectRatio:false,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines:{
								display:false,
							}
				        }]
				    },

		 title: {
				display: true,
					text:'Hourly Clearance of Arrival Flights',
				fontSize: 15,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metasssssss = chartInstances.controller.getDatasetMeta(i);
						metasssssss.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x , bar._model.y );
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot1').getContext('2d');
		var myChartsssssss = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myDataaaaaa,    	// Chart data
			options: myoptionsssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

	<%	////////////////////////////////////////////	Hourly Clearance of Arrival Flights - End	////////////////////////////////////////////////////%>




	
	<%////////////////////////////////////////////	Hourly Clearance of Departure Flights - Start	////////////////////////////////////////////////////

	String hours_Axis_Dep = "";
	String hourly_flight_count_Axis_Dep = "";

	StringBuilder hourlyDepAxis = new StringBuilder();
	StringBuilder hourlyDepFlt = new StringBuilder();

	String hourSet_Dep = "";
	java.util.Date v_hourSet_Dep = null;
	//DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDateFormat = new SimpleDateFormat("MMM-dd HH");

	boolean zero_entry2 = false;
	try {
		depQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24miss') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count from imigration.im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
		psTemp = con.prepareStatement(depQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hours_Axis_Dep =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hours_Axis_Dep = rsTemp.getString("hours").substring(0,2) +" PM" ;			

			hourly_flight_count_Axis_Dep = rsTemp.getString("hourly_flight_count");

			if (zero_entry2 == true) {
				hourlyDepAxis.append(",");
				hourlyDepFlt.append(",");
			} else
		zero_entry2 = true;
			hourlyDepAxis.append("\"");
			hourlyDepAxis.append(hours_Axis_Dep);
			hourlyDepAxis.append("\"");
			hourlyDepFlt.append(hourly_flight_count_Axis_Dep);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		e.printStackTrace();
	}

	String strhours_Axis_Dep = hourlyDepAxis.toString();
	String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();
	//out.println(str1);
	%>

<%////////////////	Table - Hourly Clearance of Departure Flights - Start	///////////////////////%>

	<div class="col-sm-2" style="flex:1;">
		<table class="tableDesign" >
			<tr style="font-size: 14px; color:white; border-color: #006778;height:40%;">
					<th style="text-align: center;background-color:#006778;border-color: #004753;width:50%;text-align: center;">Time</th>
					<th style="text-align: center;background-color:#006778;border-color: #004753;width:50%; text-align: right;">Departure&nbsp;Flights&nbsp;&nbsp;</th>
				</tr>
		<% 
			/*String strhours_Axis_Dep = hourlyDepAxis.toString();
			String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();*/
			String[] hourListDepFlt = strhours_Axis_Dep.toString().replace("\"", "").split(",");
			String[] hourListDepFltCount = strhourly_flight_count_Axis_Dep.split(",");
			for (int i = hourListDepFlt.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#b3f4ff;border-color: #006778;width:50%; font-weight: bold;text-align: center;"><%=hourListDepFlt[i].equals("0") ? "&nbsp;" : hourListDepFlt[i]%></td>
				<td style="background-color:#e5fbff;border-color: #006778;width:50%; font-weight: bold; text-align: right;"><%=hourListDepFltCount[i].equals("0") ? "&nbsp;" : getIndianFormat(Integer.parseInt(hourListDepFltCount[i]))%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Departure Flights - End	////////////////////////%>

	<div class="col-sm-4" style="flex:2;">
	<div class="card"style="border: solid 3px #006778; border-radius: 20px; height: 314px;">
	<div class="card-body" style="height:314px;">
<!-- 		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Departure Flights</h1>
 -->
		<canvas id="myPlot2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #c4f2fa 100%);border-radius: 20px; height:314px;"></canvas>
		</div>
			</div>
		</div>
		</div>
		</div>
		<script>
		// Data define for bar chart

		var myDataaaaa = {
			labels: [<%=reverseOnComma(strhours_Axis_Dep)%>],
			datasets: [{ 
				  label: "Departure Flights",
			      backgroundColor: "#79E0EE",
			      borderColor: "#3AA6B9",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strhourly_flight_count_Axis_Dep)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptionssssss = {
			responsive: true,
			maintainAspectRatio: false,
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            },
							gridLines:{
								display:false,
							}
				        }]
				    },
		 title: {
				display: true,
					text:'Hourly Clearance of Departure Flights',
				fontSize: 15,		
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metassssss = chartInstances.controller.getDatasetMeta(i);
						metassssss.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data.toLocaleString('en-IN'), bar._model.x + 2 , bar._model.y );
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot2').getContext('2d');
		var myChartssssss = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myDataaaaa,    	// Chart data
			options: myoptionssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%
///////////////////////////////////////	Hourly Clearance of Departure Flights - End	/////////////////////////////////////////////%>
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





























