<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
<%
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

//=================================================

	Connection con = null;
try {
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "imigration", "nicsi123");

	/*Context ctx = null;
	Connection con = null;

	ctx = new InitialContext();
	Context envCtx = (Context)ctx.lookup("java:comp/env");
	DataSource ds = (DataSource)envCtx.lookup("jdbc/im_pax_ds");
	con = ds.getConnection();*/

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
	String dash = "";



			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
			
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
/*This Grey Not Blue Colour*/


/*.grey_table{background: linear-gradient(#d6d6d6, #ffffff); border: 2px solid #555e61;}
.grey_table th{background:linear-gradient(to left, #b8c3c7, #606263);}*/


/*.grey_table {
    background: linear-gradient(#d6d6d6, #ffffff);
    border: 2px solid #555e61;
}
.grey_table th{background: linear-gradient(to left, #b8c3c7, #606263);}
*/

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

		</head>
		<body onload="apex_search.init();" style="background-color: #fff;">
		<div class="wrapper">
		<div class="flag-strip"></div>
		<header class="bg-white py-1">
		  <div class="container-fluid">
			<div class="row">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <div class="col-sm-3">
				<a href="#Home"><h1><span>IVFRT (I)</span><br/>National Informatics Centre</h1></a>
			  </div>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;

			  <div class="col-sm-5">
			  <!--<h4 style=" color: #0842af; font-weight:bold; margin-top:1rem; font-size : 1.7rem; margin-right: 1rem;">IMMIGRATION DASHBOARD</h4>-->
			  <img src="ICSDashboardLogo.png" width="100%" height="90%" alt="IMMIGRATION DASHBOARD" align="center;">
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
				  <li class="nav-item dropdown"><a href="ICS_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Immigration Clearance</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#ICS_1">Arrival and Departure Immigration Clearance in last 7 days</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_2">Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_3">Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_4">Hourly Clearance of Arrival/Departure Flights in last <%=displayHours%> hours</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Gender">Arrival : Gender Based Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Dep_Gender">Departure : Gender Based Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_Indian_Foreigner">Arrival : Indian/Foreigner Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Dep_Indian_Foreigner">Departure : Indian/Foreigner Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Flight_Running_Status">Currently Running Flight Status in last 30 minutes</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Agewise">Age-wise Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Arr_PAX">Arrival : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICS_Dep_PAX">Departure : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)</a></ul></li>


				  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Biometrics</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#biometric_1">Enrollment/Verification/Exemption Statistics in last 7 days</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#biometric_2">Enrollment/Verification/Exemption Statistics in last <%=displayHours%> hours</a></ul></li>

				  <li class="nav-item dropdown"><a href="#visa_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Visa</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#visa_1">Arrival : Visa Clearance in last 7 days</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#visa_2">Arrival : Visa Clearance in last <%=displayHours%> hours</a></ul></li>

				  <li class="nav-item dropdown"><a href="#visa_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">UCF</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#ucf_Indian">Indian UCF Matched/Not Matched Statistics in last 7 days</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ucf_Foreigner">Foreigner UCF Matched/Not Matched Statistics in last 7 days</a></ul></li>

				  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
				   <ul class="dropdown-menu">
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/" target="_blank">Immigration Control System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>
			   </ul>			   
			  </div>			  
			</div>
			<span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;<%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%>&nbsp;</font></span>
		  </nav>


		  <form name="entryfrm" method="post">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td align="center">
		   
			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b>
			<select class="form-select-sm" name="compare_icp">
			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>
<%
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
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


<%//================================================


	try {
		dashQuery = "select distinct GRAND_TOTAL_PAX_ARR as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
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
		dashQuery = "select distinct DAILY_ARRIVAL_PAX_COUNT as arr_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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








	<%
	/////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////////
int today_Dep_Count = 0;
int yest_Dep_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;;

try {
	dashQuery = "select distinct GRAND_TOTAL_PAX_DEP as dep_Passenger from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
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
	dashQuery = "select distinct DAILY_DEPARTURE_PAX_COUNT as dep_Passenger_Count from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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



////////////////////	Arrival/Departure Flights Count	Tabs	/////////////////////////


try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_ARR as total_Arrival_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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
		dashQuery = "select distinct DAILY_ARRIVAL_FLIGHT_COUNT as arr_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate-1)";
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

	
	int yest_Dep_Flights = 0;
	int today_Dep_Flights = 0;
	int total_Flights_Count = 0;
	int total_Flights_Count_Yest = 0;
	int total_Flights_Count_Today = 0;
	
	try {
		dashQuery = "select distinct GRAND_TOTAL_CNT_FLT_DEP as total_Dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate - 1)";
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
		dashQuery = "select distinct DAILY_DEPARTURE_FLIGHT_COUNT as dep_Flights from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and PAX_BOARDING_DATE = trunc(sysdate)";
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





















<!--05/10/2023 12:40-->


<%////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////#00539a%>
<br><br><br><br><br><br><br>
<div class="container-fluid">
<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-3">
			<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			
			<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;">Arrival</th>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;"><%=today_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;Footfall</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3"><%=yesterday_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;Footfall</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArr" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #44a9ff;"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Overall&nbsp;Footfall</td>
			</tr>

		</table>
</div>
<div class="col-sm-2"><br><br><br><br><br>
<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			
			<tr style="font-size: 20px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;text-align: center;">Arrival&nbsp;Flights</th>
			</tr>
			<tr style="font-size: 15px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #004076;font-size: 20px;"><%=arr_Flight_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #004076;font-size: 12px;">&nbsp;Today&nbsp;Flights</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color :#0072d3;font-size: 20px;"><%=yest_Flight_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color :#0072d3;font-size: 12px;">&nbsp;Yesterday&nbsp;Flights</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArrFlt" style="background-color:#bae6ff;border-color: #bae6ff;width:40%; font-weight: bold; text-align: right;color: #44a9ff;font-size: 20px;"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:60%; font-weight: bold;text-align: left;color: #44a9ff;font-size: 12px;">&nbsp;Overall&nbsp;Flights</td>
			</tr>

		</table>
	</div>

	<div class="col-sm-1">
	</div>

		<div class="col-sm-3">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			
			<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;">Departure</th>
			</tr>

			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;"><%=today_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;">&nbsp;Today's&nbsp;Footfall</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;"><%=yest_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;Footfall</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td id="count_total_Dep_Count" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #a376e2;"></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Overall&nbsp;Footfall</td>

			</tr>

		</table>
</div>
	<div class="col-sm-2"><br><br><br><br><br>
	<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			
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




<!--05/10/2023 12:40-->










		<!--   ************************END HOME DIV*******************HOME DIV*****************END HOME DIV****************END HOME DIV********  -->
		<!--   ************************START ICS DIV*******************ICS DIV*****************START ICS DIV****************START ICS DIV********  -->
		<section id="ICS_1"><br><br><br><br><br><br><br>	
		<div class="pt-4" id="ICS_1">
		<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>
				<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival and Departure Immigration Clearance in last 7 days</th>
				</tr>
				
			</thead>
			
		</table><br>



<%////////////////////////	Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////

StringBuilder weekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

boolean flagPaxCount = false;
try {
	WeeklyPAXQuery = "select distinct  to_char(pax_boarding_date,'Mon-dd') as show_date,pax_boarding_date,icp_description,DAILY_ARRIVAL_PAX_COUNT,DAILY_DEPARTURE_PAX_COUNT from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) order by pax_boarding_date";
	psTemp = con.prepareStatement(WeeklyPAXQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		weekly_XAxis = rsTemp.getString("show_date");
		//out.println(weekly_XAxis);
		weekelyArrPaxCount = rsTemp.getInt("DAILY_ARRIVAL_PAX_COUNT");
		weekelyDepPaxCount = rsTemp.getInt("DAILY_DEPARTURE_PAX_COUNT");
		//out.println(weekelyArrPaxCount+weekelyDepPaxCount);

		if (flagPaxCount == true) {
	weekDays.append(",");
	weekArrPax.append(",");
	weekDepPax.append(",");
		} else
	flagPaxCount = true;

		weekDays.append("\"");
		weekDays.append(weekly_XAxis);
		weekDays.append("\"");
		weekArrPax.append(weekelyArrPaxCount);
		weekDepPax.append(weekelyDepPaxCount);
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Arr/Dep PAX Count  Exception");
}

//String str1 = str_Hours.toString();
//String str2 = str_Hours_Flight_Count.toString();
String strWeekDays = weekDays.toString();
String strweekArrPax = weekArrPax.toString();
String strweekDepPax = weekDepPax.toString();
//out.println(strWeekDays);
%>

<%////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////%>
<br><br>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-2">

		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
					<th style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:33.33%;">&nbsp;</th>
					<th colspan = "3" style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:66.66%; text-align: center;">Total Footfall</th>
				</tr>
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
				<th style="background-color:#6929c4;border-color: #be95ff;width:25%;text-align: center;">Date</th>
				<th style="background-color:#6929c4;border-color: #be95ff;width:33.33%; text-align: right;">Arr&nbsp;</th>
				<th style="background-color:#6929c4;border-color: #be95ff;width:33.33%; text-align: right;">Dep&nbsp;</th>
				<th style="background-color:#6929c4;border-color: #be95ff;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDays = weekDays.toString();
			String strweekArrPax = weekArrPax.toString();
			String strweekDepPax = weekDepPax.toString();*/
			

			String[] weekListPAX = strWeekDays.toString().replace("\"", "").split(",");
			String[] weeklyArrPAX = strweekArrPax.split(",");
			String[] weeklyDepPAX = strweekDepPax.split(",");
			for (int i = 0; i < weekListPAX.length; i++) {
				t_Total = 0;
				t_Total = Integer.parseInt(weeklyArrPAX[i]) + Integer.parseInt(weeklyDepPAX[i]);
							
				/*out.println( weekList[i]);
				if (Integer.parseInt( weekList[i].substring(11,13)) >= 0 & Integer.parseInt( weekList[i].substring(11,13)) <= 11)
				v_date_Format = weekList[i].substring(8,10) + "/" + weekList[i].substring(5,7) + "/" + weekList[i].substring(0,4) + " " + weekList[i].substring(11,13) + " AM" ;
						

			if (Integer.parseInt( weekList[i].substring(11,13)) >= 12 & Integer.parseInt( weekList[i].substring(11,13)) <= 23)
				v_date_Format = weekList[i].substring(8,10) + "/" + weekList[i].substring(5,7) + "/" + weekList[i].substring(0,4) + " " + weekList[i].substring(11,13) + " PM" ;*/

	

			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#be95ff;border-color: #6929c4;width:33.33%; font-weight: bold;text-align: center;"><%=weekListPAX[i].replace("-","&#8209;")%></td>
				<td style="background-color:#d4bbff;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyArrPAX[i].equals("0") ? "&nbsp;" : weeklyArrPAX[i]%>&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyDepPAX[i].equals("0") ? "&nbsp;" : weeklyDepPAX[i]%>&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;color:#6929c4;"><%=t_Total == 0 ? "&nbsp;" : t_Total%>&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

<div class="col">
<div class="card" style="border: solid 3px #be95ff; border-radius: 20px;">
<div class="card-body">
<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure Immigration Clearance in last 7 days</h1>

		<canvas id="canvasPAX" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #b1d2d8 100%);"></canvas>
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDays%>],
			datasets: [{ 
				  label: "Arrival Footfall",
			      backgroundColor: "#00dcb0",
			      borderColor: "#00dcb0",
			      borderWidth: 1,
			      data: [<%=strweekArrPax%>]
			}, { 
				  label: "Departure Footfall",
			      backgroundColor: "#BEADFA",
			      borderColor: "#BEADFA",
			      borderWidth: 1,
			      data: [<%=strweekDepPax%>]
			}]
		};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: false,display: false
		}],
		xAxes: [{
		stacked: false,display: true
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 7px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y-2);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasPAX').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

	<%
	///////////////////////////	  Arrival and Departure Immigration Clearance in last 7 days - End	///////////////////////////////
	%>


<!--<hr style="height: 20px; border-width:5;  background-color:slateblue;">-->

<!--<div class="heading">
<br><h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 25px;text-align: left;">Arrival and Departure Immigration Flights Clearance in last 7 days
</h1><br>
</div>-->
	<%
	//////////////////////////////////	Arrival and Departure Flights in last 7 days - Start	////////////////////////////////////

	StringBuilder weekDaysFlights = new StringBuilder();
	StringBuilder weekArrFlights = new StringBuilder();
	StringBuilder weekDepFlights = new StringBuilder();

	boolean flagFlightCount = false;
	try {
		WeeklyFlightsQuery = "select distinct  to_char(pax_boarding_date,'Mon-dd') as show_date,pax_boarding_date,icp_description,DAILY_ARRIVAL_FLIGHT_COUNT,DAILY_DEPARTURE_FLIGHT_COUNT from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-7) and pax_boarding_date <= trunc(sysdate) order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyFlightsQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyFlightXAxis = rsTemp.getString("show_date");
			//out.println(weeklyFlightXAxis);
			weekelyArrFlightCount = rsTemp.getInt("DAILY_ARRIVAL_FLIGHT_COUNT");
			weekelyDepFlightCount = rsTemp.getInt("DAILY_DEPARTURE_FLIGHT_COUNT");
			//out.println(weekelyArrFlightCount+weekelyDepFlightCount);

			if (flagFlightCount == true) {
		weekDaysFlights.append(",");
		weekArrFlights.append(",");
		weekDepFlights.append(",");
			} else
		flagFlightCount = true;

			weekDaysFlights.append("\"");
			weekDaysFlights.append(weeklyFlightXAxis);
			weekDaysFlights.append("\"");
			weekArrFlights.append(weekelyArrFlightCount);
			weekDepFlights.append(weekelyDepFlightCount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Arr/Dep Flight Count  Exception");
	}

	String strWeekDaysFlights = weekDaysFlights.toString();
	String strweekArrFlights = weekArrFlights.toString();
	String strweekDepFlights = weekDepFlights.toString();
	%>
<%////////////////	Table -  Arrival and Departure Flights in last 7 days - Start	///////////////////////%>
<div class="col-sm-2">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Flights in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #ed3e12;height:20px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:33.33%;">&nbsp;</th>
				<th colspan = "3" style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:66.66%; text-align: center;">Total Flights</th>
			</tr>
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #ed3e12;height:20px;">
				<th style="background-color:#ed3e12;border-color: #f4896f;width:25%;">Date</th>
				<th style="background-color:#ed3e12;border-color: #f4896f;width:25%; text-align: right;">Arr&nbsp;</th>
				<th style="background-color:#ed3e12;border-color: #f4896f;width:25%; text-align: right;">Dep&nbsp;</th>
				<th style="background-color:#ed3e12;border-color: #f4896f;width:25%; text-align: right;">Total&nbsp;</th>
			</tr>
		<% 
			String[] weekListFlights = strWeekDaysFlights.toString().replace("\"", "").split(",");
			String[] weeklyArrFlights = strweekArrFlights.split(",");
			String[] weeklyDepFlights = strweekDepFlights.split(",");
			for (int i = 0; i < weekListFlights.length; i++) {
				t_Total = 0;
				t_Total = Integer.parseInt(weeklyArrFlights[i]) + Integer.parseInt(weeklyDepFlights[i]);
		%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:18px;border-color: #ed3e12">
				<td style="background-color:#f4896f;border-color: #ed3e12;width:25%; font-weight: bold;text-align: center;"><%=weekListFlights[i].equals("0") ? "&nbsp;" : weekListFlights[i]%></td>
				<td style="background-color:#f8b8a9;border-color: #ed3e12;width:25%;font-weight: bold;  text-align: right;"><%=weeklyArrFlights[i].equals("0") ? "&nbsp;" : weeklyArrFlights[i]%>&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:25%; font-weight: bold; text-align: right;"><%=weeklyDepFlights[i].equals("0") ? "&nbsp;" : weeklyDepFlights[i]%>&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:25%; font-weight: bold; text-align: right;color:#ed3e12;"><%=t_Total == 0 ? "&nbsp;" : t_Total%>&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Flights in last 7 days - End	////////////////////////%>

	<div class="col">
<div class="card" style="border: solid 3px #F6635C; border-radius: 20px;">
<div class="card-body">
		<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure Flights Cleared in last 7 days</h1>

		<canvas id="canvasFlights" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #faaca8 100%);border-radius: 20px;"></canvas>

</div>
</div>
</div>

	<script>

		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysFlights%>],
			datasets: [{ 
				  label: "Arrival Flights Count",
			      backgroundColor: "#F6635C",
			      borderColor: "#F6635C",
			      borderWidth: 1,
			      data: [<%=strweekArrFlights%>]
			}, { 
				  label: "Departure Flights Count",
			      backgroundColor: "#ffa600",
			      borderColor: "#ffa600",
			      borderWidth: 1,
			      data: [<%=strweekDepFlights%>]
			}]
		};

		// Options to display value on top of bars

var myoptions = {
				 scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		stacked: false,display: false
		}],
		xAxes: [{
		stacked: false,display: true
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 8px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y-2);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasFlights').getContext('2d');
		var myChart = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
</div>
</div>
<br>


<%///////////////////////////////	Arrival and Departure Flights in last 7 days - End	/////////////////////////////////////////%>





		</div>
		</section>
		<!--   ************************END ICS DIV*******************END ICS DIV*****************END ICS DIV****************END ICS DIV********  -->
		<!--   ************************START pax DIV*******************START pax DIV*****************START pax DIV****************START pax DIV********  -->
		<section id="ICS_2" ><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_2">
		<table id = "auto-index2" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</th>
				</tr>
			</thead>
		</table>
	<%////////////////////	Arrival : PAX Clearance, Active Flights and Active Counters in last 8 hours - Start	////////////////////////

StringBuilder hourlyTime = new StringBuilder();
StringBuilder hourlyPax = new StringBuilder();
StringBuilder hourlyFlight = new StringBuilder();
StringBuilder hourlyActiveCounter = new StringBuilder();

	String hourSet_Arrpfa = "";
	java.util.Date v_hourSet_Arrpfa = null;
	//DateFormat vArrDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vArrDateFormat = new SimpleDateFormat("MMM-dd HH");

 flagPaxCount = false;
try {
	arrHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<= "+displayHours;
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;			


		hourlyArrFlightCount = rsTemp.getInt("hourly_flight_count");
		hourlyArrPaxCount = rsTemp.getInt("hourly_pax_count");
		hourlyArrActiveCounter = rsTemp.getInt("active_counter_count");
		//out.println(hourlyArrActiveCounter);

		if (flagPaxCount == true) {
	hourlyTime.append(",");
	hourlyPax.append(",");
	hourlyFlight.append(",");
	hourlyActiveCounter.append(",");
		} else
	flagPaxCount = true;

		hourlyTime.append("\"");
		hourlyTime.append(hourlyXAxis);
		hourlyTime.append("\"");
		hourlyPax.append(hourlyArrPaxCount);
		hourlyFlight.append(hourlyArrFlightCount);
		hourlyActiveCounter.append(hourlyArrActiveCounter);
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Arr PAX, Flight and Active Count  Exception");
}
String strHourlyTime = hourlyTime.toString();
String strHourlyArrPax = hourlyPax.toString();
String strHourlyArrFlight = hourlyFlight.toString();
String strHourlyArrActiveCounter = hourlyActiveCounter.toString();
%>

<%////////////////	Table - Arrival Clearance in last 7 hours - Start	///////////////////////%>
<div class="container-fluid">
<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-4" >
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival Clearance in last 7 hours</caption>-->
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:25%; text-align: center;">Time</th>
					<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:25%; text-align: right;">PAX&nbsp;Clearance&nbsp;&nbsp;&nbsp;</th>
					<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:25%; text-align: right;">Active&nbsp;Flights&nbsp;&nbsp;&nbsp;</th>
					<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:25%; text-align: right;">Active&nbsp;Counters&nbsp;&nbsp;&nbsp;</th>
				</tr>
		<% 
			String[] weekList = strHourlyTime.toString().replace("\"", "").split(",");
			String[] arrPax = strHourlyArrPax.split(",");
			String[] arrFlight = strHourlyArrFlight.split(",");
			String[] arrCounter = strHourlyArrActiveCounter.split(",");
			String v_date_Format  = "";
			for (int i = weekList.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; height:20px;">
				<td style="background-color:#dc799b; width:25%; border-color: #B93160;width:25%; font-weight: bold; text-align: center;"><%=weekList[i].equals("0") ? "&nbsp;" : weekList[i].replace(" ","&nbsp;")%></td>
				<td style="background-color:#e497b2; width:25%; border-color: #B93160;width:25%; font-weight: bold; text-align: right;"><%=arrPax[i].equals("0") ? "&nbsp;" : arrPax[i]%>&nbsp;&nbsp;&nbsp;</td>
				<td style="background-color:#ecb6c8; width:25%; border-color: #B93160;width:25%; font-weight: bold; text-align: right;"><%=arrFlight[i].equals("0") ? "&nbsp;" : arrFlight[i]%>&nbsp;&nbsp;&nbsp;</td>
				<td style="background-color:#f4d7e1; width:25%; border-color: #B93160;width:25%; font-weight: bold; text-align: right;"><%=arrCounter[i].equals("0") ? "&nbsp;" : arrCounter[i]%>&nbsp;&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Arrival : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
<div class="card" style="border: solid 3px #B93160; border-radius: 20px;">
<div class="card-body" >
<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</h1>

		<canvas id="canvasArrPAXFltActCount" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #e5a4ba 100%); border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>

	<br>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Arrival Footfall",
			      backgroundColor: "#B93160",
			      borderColor: "#B93160",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyArrPax)%>]
			}, { 
				  label: "Arrival Flights",
			      backgroundColor: "#FF5C8D",
			      borderColor: "#B93160",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyArrFlight)%>]
			},
			{ 
				  label: "Arrival Active Counters",
			      backgroundColor: "#FFCCCC",
			      borderColor: "#B93160 ",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyArrActiveCounter)%>]
			}]
		};
		 	
		// Options to display value on top of bars

		var myoptions = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasArrPAXFltActCount').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>


	<%////////////////////	Arrival : PAX Clearance, Active Flights and Active Counters in last 8 hours - End	////////////////////////%>


		</section>
		<!--   ************************END pax DIV*******************END pax DIV*****************END pax DIV****************END pax DIV********  -->
		<!--   ************************START Pax-Images DIV************************START Pax-Images DIV****************START Pax-Images DIV********  -->
		
		
		<section id="ICS_3">
		<div class="pt-4" id="ICS_3"><br><br><br><br><br><br><br>    
		<table id = "auto-index3" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</th>
				</tr>
				<!--<tr id='head' name='pax-image'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

	<%//////////////////	Departure : PAX, Flight and Active Counters for last 7 hours - Start	///////////////////////

	StringBuilder hourlyDepTime = new StringBuilder();
	StringBuilder hourlyDepPax = new StringBuilder();
	StringBuilder hourlyDepFlight = new StringBuilder();
	StringBuilder hourlyDepDepActiveCounter = new StringBuilder();


	String hourSet_Deppfa = "";
	java.util.Date v_hourSet_Deppfa = null;
	//DateFormat vDepDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDepDateFormat = new SimpleDateFormat("MMM-dd HH");

	flagPaxCount = false;
	try {
		depHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_DEP_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<="+displayHours;
		psTemp = con.prepareStatement(depHourlyQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyDepXAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyDepXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyDepXAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyDepXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;		

			hourlyDepFlightCount = rsTemp.getInt("hourly_flight_count");
			hourlyDepPaxCount = rsTemp.getInt("hourly_pax_count");
			hourlyDepActiveCounter = rsTemp.getInt("active_counter_count");

			if (flagPaxCount == true) {
		hourlyDepTime.append(",");
		hourlyDepPax.append(",");
		hourlyDepFlight.append(",");
		hourlyDepDepActiveCounter.append(",");
			} else
		flagPaxCount = true;

			hourlyDepTime.append("\"");
			hourlyDepTime.append(hourlyDepXAxis);
			hourlyDepTime.append("\"");
			hourlyDepPax.append(hourlyDepPaxCount);
			hourlyDepFlight.append(hourlyDepFlightCount);
			hourlyDepDepActiveCounter.append(hourlyDepActiveCounter);
		}

		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Dep PAX, Flight and Active Count Exception");
	}

	strHourlyTime = "";
	strHourlyTime = hourlyDepTime.toString();
	String strHourlyDepPax = hourlyDepPax.toString();
	String strHourlyDepFlight = hourlyDepFlight.toString();
	String strHourlyDepActiveCounter = hourlyDepDepActiveCounter.toString();
	%>

<%////////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - Start	/////////////////////////%>
<div class="container-fluid">
	<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Departure Clearance in last 7 hours</caption>-->
			
				<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
					<th style="text-align: center;background-color:#005d5d;border-color: #3ddbd9;width:25%; font-weight: bold; text-align: center;">Time</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #3ddbd9;width:25%; font-weight: bold; text-align: right;">PAX&nbsp;&nbsp;Clearance&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #3ddbd9;width:25%; font-weight: bold; text-align: right;">Active&nbsp;&nbsp;Flights&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #3ddbd9;width:25%; text-align: right;">Active&nbsp;&nbsp;Counters&nbsp;&nbsp;</th>
				</tr>
			<%
			//strHourlyTime = hourlyDepTime.toString();
			//String strHourlyDepPax = hourlyDepPax.toString();
			//String strHourlyDepFlight = hourlyDepFlight.toString();
			//String strHourlyDepActiveCounter = hourlyDepDepActiveCounter.toString();
			//out.println(hourlyTime.toString().replace("\"",""));

			String[] depWeekList = strHourlyTime.toString().replace("\"", "").split(",");
			String[] depPax = strHourlyDepPax.split(",");
			String[] depFlight = strHourlyDepFlight.split(",");
			String[] depCounter = strHourlyDepActiveCounter.split(",");

			for (int i = depWeekList.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#08bdba;border-color: #005d5d;width:25%; font-weight: bold;text-align: center;"><%=depWeekList[i].equals("0") ? "&nbsp;" : depWeekList[i].replace(" ","&nbsp;")%></td>
				<td style="background-color:#3ddbd9;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depPax[i].equals("0") ? "&nbsp;" : depPax[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#9ef0f0;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depFlight[i].equals("0") ? "&nbsp;" : depFlight[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color: #005d5d;width:25%; font-weight: bold; text-align: right;"><%=depCounter[i].equals("0") ? "&nbsp;" : depCounter[i]%>&nbsp;&nbsp;</td>
			</tr>

			<%
			}
			%>
		</table>
</div>	
<% /////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - End	/////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
	<div class="card" style="border: solid 3px #006778; border-radius: 20px;">
	<div class="card-body">
		<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</h1>

		<canvas id="canvasDepPAXFltActCount" class="chart" style="max-width: 100%;      background: linear-gradient(to bottom, #ffffff 35%, #75ebff 100%);border-radius: 20px;"></canvas>
	</div>
</div>
</div>
</div>
</div>
</div>

<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Departure Footfall",
			      backgroundColor: "#006778",
			      borderColor: "#045D5D",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepPax)%>]
			}, { 
				  label: "Departure Flights",
			      backgroundColor: "#39AEA9",
			      borderColor: "#006778",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepFlight)%>]
			},
			{ 
				  label: "Departure Active Counters",
			      backgroundColor: "#CCF3EE",
			      borderColor: "#006778",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyDepActiveCounter)%>]
			}]
		};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasDepPAXFltActCount').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>



<%
/////////////////////////	Departure : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////////
%>




		</div>
		</section>
		<!--   ************************END Pax-Images DIV************************END  Pax-Images DIV****************END  Pax-Images DIV********  -->
		<!--   ************************START APIS DIV*******************START APIS DIV*****************START APIS DIV****************START APISE DIV********  -->
		<section id="ICS_4"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_4"> 
		<table id = "auto-index4" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Hourly Clearance of Arrival/Departure Flights in last <%=displayHours%> hours</th>
				</tr>
				<!--<tr id='head' name='apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		<%////////////////////////////////////////////	Hourly Clearance of Arrival Flights - Start	////////////////////////////////////////////////////

	String hours_Axis = "";
	String hourly_flight_count_Axis = "";

	StringBuilder hourlyArrAxis = new StringBuilder();
	StringBuilder hourlyArrFlt = new StringBuilder();

	//String hourSet = "";

	boolean zero_entry_Arr = false;
	try {
		dashQuery = "select * from (select to_date(hours,'HH24mi') as date_time, icp_description, hours,hourly_flight_count,active_counter_count,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_ARR_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
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
		<div class="col-sm-2">
	<%////////////////	Table - Hourly Clearance of Arrival Flights - Start	///////////////////////%>
<table class="tableDesign">
		<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:5%;">
				<th style="text-align: center;background-color:#da1e28;border-color: #ffb3b8;width:50%; text-align: center;">Time</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #ffb3b8;width:50%; text-align: right;">Arrival&nbsp;Flights&nbsp;&nbsp;</th>
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
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=hourListArrFltCount[i].equals("0") ? "&nbsp;" : hourListArrFltCount[i]%>&nbsp;&nbsp;</td>


			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Arrival Flights - End	////////////////////////%>


	<div class="col-sm-4" >
	<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
	<div class="card-body">
		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Arrival Flights</h1>
		<canvas id="myPlot1" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #ffd8d8 100%); border-radius: 20px;"></canvas>
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
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },

					 title: {
					        fontSize: 18,		
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
							ctx.fillText(data, bar._model.x , bar._model.y );
							
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
		depQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24miss') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS desc ) where rownum <= "+displayHours;
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

	<div class="col-sm-2">
		<table class="tableDesign" >
			<tr style="font-size: 14px; color:white; border-color: #006778;height:40%;">
					<th style="text-align: center;background-color:#006778;border-color: #5be8ff;width:50%;text-align: center;">Time</th>
					<th style="text-align: center;background-color:#006778;border-color: #5be8ff;width:50%; text-align: right;">Departure&nbsp;Flights&nbsp;&nbsp;</th>
				</tr>
		<% 
			/*String strhours_Axis_Dep = hourlyDepAxis.toString();
			String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();*/
			String[] hourListDepFlt = strhours_Axis_Dep.toString().replace("\"", "").split(",");
			String[] hourListDepFltCount = strhourly_flight_count_Axis_Dep.split(",");
			for (int i = hourListDepFlt.length - 1; i >= 0 ; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#5be8ff;border-color: #006778;width:50%; font-weight: bold;text-align: center;"><%=hourListDepFlt[i].equals("0") ? "&nbsp;" : hourListDepFlt[i]%></td>
				<td style="background-color:#b7f5ff;border-color: #006778;width:50%; font-weight: bold; text-align: right;"><%=hourListDepFltCount[i].equals("0") ? "&nbsp;" : hourListDepFltCount[i]%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Clearance of Departure Flights - End	////////////////////////%>

	<div class="col-sm-4">
	<div class="card"style="border: solid 3px #006778; border-radius: 20px;">
	<div class="card-body">
		<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Departure Flights</h1>

		<canvas id="myPlot2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #c4f2fa 100%);border-radius: 20px;"></canvas>
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
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metassssss = chartInstances.controller.getDatasetMeta(i);
						metassssss.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x + 2 , bar._model.y );
							
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

		</div>
		</section>
		<!--   ************************END APIS DIV*******************END APIS DIV*****************END APIS DIV****************END APIS DIV********  -->
		<!--   ************************START Custom APIS DIV*******************START Custom APIS DIV*****************START Custom APIS DIV****************START UCF DIV********  -->
		<section id="visa_1"><br><br><br><br><br><br><br>
		<div class="pt-4" id="visa_1">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last 7 days</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

		<%//////////////////////////////////////////////	Arrival : Visa Clearance in last 7 days - Start	////////////////////////////////////////////////////
	String WeeklyVisaQuery = "";
	String weeklyVisaXAxis = "";
	int weekelyEVisaCount = 0;
	int weekelyVOACount = 0;
	int weeklyRegularCount = 0;
	int weeklyOCICount = 0;
	int weeklyEx = 0;
	int weeklyExCount = 0; 

	StringBuilder weekDaysVisa = new StringBuilder();
	StringBuilder weekEVisa = new StringBuilder();
	StringBuilder weekVOA = new StringBuilder();
	StringBuilder weekRegular = new StringBuilder();
	StringBuilder weekOCI = new StringBuilder();
	StringBuilder weekEx = new StringBuilder();

	  flagFlightCount = false;
	try {
		WeeklyVisaQuery = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count) as sum_hourly_visa_exempted_count,sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyVisaQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyVisaXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyEVisaCount = rsTemp.getInt("sum_evisa_count");
			weekelyVOACount = rsTemp.getInt("sum_hourly_voa_count");
			weeklyRegularCount = rsTemp.getInt("hourly_regular_visa_count");
			weeklyOCICount = rsTemp.getInt("sum_hourly_oci_count");
			weeklyExCount = rsTemp.getInt("sum_hourly_visa_exempted_count");
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysVisa.append(",");
				weekEVisa.append(",");
				weekVOA.append(",");
				weekRegular.append(",");
				weekOCI.append(",");
				weekEx.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysVisa.append("\"");
			weekDaysVisa.append(weeklyVisaXAxis);
			weekDaysVisa.append("\"");
			
			weekEVisa.append(weekelyEVisaCount);
			weekVOA.append(weekelyVOACount);
			weekRegular.append(weeklyRegularCount);
			weekOCI.append(weeklyOCICount);
			weekEx.append(weeklyExCount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Visa Exception");
	}

	String strWeekDaysVisa = weekDaysVisa.toString();
	String strweekEVisa = weekEVisa.toString();
	String strweekVOA = weekVOA.toString();
	String strweekRegular = weekRegular.toString();
	String strweekOCI = weekOCI.toString();
	String strweekEx = weekEx.toString();
	//out.println(strweekOCI);
	
	%>
<%////////////////	Table - Arrival : Visa Clearance in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 days</caption>-->
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%;">Date</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">e-Visa&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">OCI&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">Regular&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">VOA&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">Exempted&nbsp;&nbsp;</th>
				</tr>
		<% 
			String[] weekListWeekly = strWeekDaysVisa.toString().replace("\"", "").split(",");
			String[] eVisaWeekly = strweekEVisa.split(",");
			String[] OCIWeekly = strweekOCI.split(",");
			String[] RegularWeekly = strweekRegular.split(",");
			String[] VOAWeekly = strweekVOA.split(",");
			String[] ExWeekly = strweekEx.split(",");
			//String v_date_Format  = "";
			for (int i = 0; i < weekListWeekly.length; i++) {
							
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#f16d4c;border-color: #ed3e12;width:20%; font-weight: bold;text-align: center;"><%=weekListWeekly[i].equals("0") ? "&nbsp;" : weekListWeekly[i]%></td>
				<td style="background-color:#f4896f;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=eVisaWeekly[i].equals("0") ? "&nbsp;" : eVisaWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f69e89;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=OCIWeekly[i].equals("0") ? "&nbsp;" : OCIWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f8b7a7;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=RegularWeekly[i].equals("0") ? "&nbsp;" : RegularWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=VOAWeekly[i].equals("0") ? "&nbsp;" : VOAWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=ExWeekly[i].equals("0") ? "&nbsp;" : ExWeekly[i]%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>	
		</div>
	<%///////////////////////	Table - Types of Visa in last 7 days - End	////////////////////////%>
	
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

		<div class="col-sm-7">
		<div class="card" style="border: solid 3px #FF5733; border-radius: 20px;">
		<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Visa Clearance in last 7 days</h1>

		<canvas id="canvasWeeklyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysVisa%>],
			datasets: [{ 
				  label: "e-Visa",
			      backgroundColor: "#FF5733",
			      borderColor: "red",
			      borderWidth: 0,
			     
			      data: [<%=strweekEVisa%>]
			},{ 
				  label: "OCI",
			      backgroundColor: "#ffa600",
			      borderColor: "orange",
			      borderWidth: 1,
			     
			      data: [<%=strweekOCI%>]
			},{ 
				  label: "Regular",
			      backgroundColor: "#900C3F",
			      borderColor: "red",
			      borderWidth: 1,
			     
			      data: [<%=strweekRegular%>]
			}, { 
				  label: "VOA",
			      backgroundColor: "#511845",
			      borderColor: "#0E21A0",
			      borderWidth: 1,
			      data: [<%=strweekVOA%>]
			}, { 
				  label: "Exempted",
			      backgroundColor: "#511845",
			      borderColor: "#0E21A0",
			      borderWidth: 1,
			      data: [<%=strweekEx%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 14,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasWeeklyVisa').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>

<%//////////////////////////////////////	Types of Visa in last 7 days - End	/////////////////////////////////%>

		</section>
		<!--   ************************END Paarijaat_APIS_Manual_Nov_2017*****************END Paarijaat_APIS_Manual_Nov_2017***************END Paarijaat_APIS_Manual_Nov_2017 DIV**************** -->
		<!--   ************************START UCF DIV*******************START UCF DIV*****************START S_Form DIV****************START UCF DIV********  -->
		<section id="visa_2"><br><br><br><br><br><br><br>
		<div class="pt-4" id="visa_2">    
		<table id = "auto-index7" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Visa Clearance in last <%=displayHours%> hours</th>
				</tr>
				<!--<tr id='head' name='ucf'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		<%	//////////////////////////////////////////////	Types of Visa in last 7 hours - Start	////////////////////////////////////////////////////
	String hourlyVisaQuery = "";
	String hourlyVisaXAxis = "";
	int hourlyEVisaCount = 0;
	int hourlyVOACount = 0;
	int hourlyRegularCount = 0;
	int hourlyOCICount = 0;
	

	StringBuilder hourlyVisa = new StringBuilder();
	StringBuilder hourlyEVisa = new StringBuilder();
	StringBuilder hourlyVOA = new StringBuilder();
	StringBuilder hourlyRegular = new StringBuilder();
	StringBuilder hourlyOCI = new StringBuilder();

	String hourSet_hourlyVisa = "";
	java.util.Date v_hourSet_hourlyVisa = null;
	//DateFormat vVisaDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vVisaDateFormat = new SimpleDateFormat("MMM-dd HH");


	 flagFlightCount = false;
	try {
		hourlyVisaQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_evisa_count,hourly_voa_count,hourly_regular_visa_count,hourly_visa_exempted_count,hourly_oci_count,hourly_foreigner_count, table_type from im_dashboard_combined where pax_boarding_date =trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<="+displayHours;
		psTemp = con.prepareStatement(hourlyVisaQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			//hourlyVisaXAxis = rsTemp.getString("date_time");
			//out.println(hourlyVisaXAxis);
			
			/*	v_hourSet_hourlyVisa = rsTemp.getTimestamp("date_time");
			if (v_hourSet_hourlyVisa != null) hourlyVisaXAxis = vDateFormat.format(v_hourSet_hourlyVisa); else hourlyVisaXAxis = "";
					//out.println(hourlyVisaXAxis.substring(7,9));
				
			if (Integer.parseInt(hourlyVisaXAxis.substring(7,9)) >= 0 & Integer.parseInt(hourlyVisaXAxis.substring(7,9)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyVisaXAxis =  hourlyVisaXAxis +" AM" ;

			if (Integer.parseInt(hourlyVisaXAxis.substring(7,9)) >= 12 & Integer.parseInt(hourlyVisaXAxis.substring(7,9)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyVisaXAxis =  hourlyVisaXAxis +" PM" ;*/

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyVisaXAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyVisaXAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;

			hourlyEVisaCount = rsTemp.getInt("hourly_evisa_count");
			hourlyVOACount = rsTemp.getInt("hourly_voa_count");
			hourlyRegularCount = rsTemp.getInt("hourly_regular_visa_count");
			hourlyOCICount = rsTemp.getInt("hourly_oci_count");
			//out.println(hourlyOCICount);

			if (flagFlightCount == true) {
				hourlyVisa.append(",");
				hourlyEVisa.append(",");
				hourlyVOA.append(",");
				hourlyRegular.append(",");
				hourlyOCI.append(",");
				} 
			else
			flagFlightCount = true;

			hourlyVisa.append("\"");
			hourlyVisa.append(hourlyVisaXAxis);
			hourlyVisa.append("\"");
			
			hourlyEVisa.append(hourlyEVisaCount);
			hourlyVOA.append(hourlyVOACount);
			hourlyRegular.append(hourlyRegularCount);
			hourlyOCI.append(hourlyOCICount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Hourly Visa Exception");
	}

	String strHourlyVisa = hourlyVisa.toString();
	String strHourlyEVisa = hourlyEVisa.toString();
	String strHourlyVOA = hourlyVOA.toString();
	String strHourlyRegular = hourlyRegular.toString();
	String strHourlyOCI = hourlyOCI.toString();
	//out.println(strHourlyOCI);
	
	%>
<%////////////////////	Table - Types of Visa in last 7 hours - Start	/////////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 hours</caption>-->
			
				<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%;">Time</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">e-Visa&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">OCI&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">Regular&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">VOA&nbsp;&nbsp;</th>
			</tr>
			<%

			
			/*String strHourlyVisa = hourlyVisa.toString();
			String strHourlyEVisa = hourlyEVisa.toString();
			String strHourlyVOA = hourlyVOA.toString();
			String strHourlyRegular = hourlyRegular.toString();
			String strHourlyOCI = hourlyOCI.toString();*/


			String[] WeekListVisaHourly = strHourlyVisa.toString().replace("\"", "").split(",");
			String[] eVisa = strHourlyEVisa.split(",");
			String[] OCIVisaHourly = strHourlyOCI.split(",");
			String[] RegularVisaHourly = strHourlyRegular.split(",");
			String[] VOAVisaHourly = strHourlyVOA.split(",");

			//String d_date_Format  = "";

			for (int i = WeekListVisaHourly.length - 1; i >= 0 ; i--) {

				/*if (Integer.parseInt( depWeekList[i].substring(11,13)) >= 0 & Integer.parseInt( depWeekList[i].substring(11,13)) <= 11)
				d_date_Format = depWeekList[i].substring(8,10) + "/" + depWeekList[i].substring(5,7) + "/" + depWeekList[i].substring(0,4) + " " + depWeekList[i].substring(11,13) + " AM" ;

			if (Integer.parseInt( depWeekList[i].substring(11,13)) >= 12 & Integer.parseInt( depWeekList[i].substring(11,13)) <= 23)
				d_date_Format = depWeekList[i].substring(8,10) + "/" + depWeekList[i].substring(5,7) + "/" + depWeekList[i].substring(0,4) + " " + depWeekList[i].substring(11,13) + " PM" ;
*/
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#f16d4c;border-color: #ed3e12;width:20%; font-weight: bold;text-align: center;"><%=WeekListVisaHourly[i].equals("0") ? "&nbsp;" : WeekListVisaHourly[i]%></td>
				<td style="background-color:#f4896f;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=eVisa[i].equals("0") ? "&nbsp;" : eVisa[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f69e89;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=OCIVisaHourly[i].equals("0") ? "&nbsp;" : OCIVisaHourly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f8b7a7;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=RegularVisaHourly[i].equals("0") ? "&nbsp;" :RegularVisaHourly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=VOAVisaHourly[i].equals("0") ? "&nbsp;" : VOAVisaHourly[i]%>&nbsp;&nbsp;</td>
			</tr>

			<%
			}
			%>
		</table>
		</div>
<% /////////////////	Table - Types of Visa in last 7 hours - End	/////////////////////%>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

	<div class="col-sm-7">
	<div class="card" style="border: solid 3px #FF5733; border-radius: 20px;">
	<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Visa Clearance in last <%=displayHours%> hours</h1>

		<canvas id="canvasHourlyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #ffa5bf 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyVisa)%>],
			datasets: [{ 
				  label: "e-Visa",
			      backgroundColor: " #FF5733",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyEVisa)%>]
			},{ 
				  label: "OCI",
			      backgroundColor: "#ffa600",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyOCI)%>]
			},{ 
				  label: "Regular",
			      backgroundColor: "#900C3F",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyRegular)%>]
			}, { 
				  label: "VOA",
			      backgroundColor: "#511845",
			      borderColor: "#FF5733",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyVOA)%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 12,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasHourlyVisa').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%//////////////////////////////////////	Types of Visa in last 7 hours - End	/////////////////////////////////%>
<%//////////////VISA Portion Ends/////////////////////////%>

		</section>
		<!--   ************************END UCF DIV*******************END UCF DIV*****************END UCF DIV****************END UCF DIV********  -->
		<!--   ************************START TSC DIV************************START TSC DIV****************START TSC DIV********  -->
		<section class="aboutsection" id="biometric_1"><br><br><br><br><br><br><br>
		<div class="pt-4" id="biometric_1">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Biometric Enrollment/Verification/Exemption Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='tsc'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		
<%//////////////////////	Biometric Enrollment/Verification/Exemption in last 7 days - Start	/////////////////////////////////
	String WeeklyBioQuery = "";
	String weeklyBioXAxis = "";
	int weekelyBioEnrolledCount = 0;
	int weekelyBioVerifiedCount = 0;
	int weeklyBioExemptedCount = 0;
	

	StringBuilder weekDaysBio = new StringBuilder();
	StringBuilder weekBioEnrolled = new StringBuilder();
	StringBuilder weekBioVerified = new StringBuilder();
	StringBuilder weekBioExempted = new StringBuilder();

	 boolean flagFlightCountb = false;
	try {
		WeeklyBioQuery = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_3, pax_boarding_date,ICP_SRNO,sum(HOURLY_BIO_ENROLLED) as sum_HOURLY_BIO_ENROLLED, sum(HOURLY_BIO_VERIFIED) as sum_HOURLY_BIO_VERIFIED, sum(HOURLY_BIO_EXEMPTED) as sum_HOURLY_BIO_EXEMPTED, table_type from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyBioQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyBioXAxis = rsTemp.getString("pax_boarding_date_3");
			//out.println(weeklyVisaXAxis);
			weekelyBioEnrolledCount = rsTemp.getInt("sum_HOURLY_BIO_ENROLLED");
			weekelyBioVerifiedCount = rsTemp.getInt("sum_HOURLY_BIO_VERIFIED");
			weeklyBioExemptedCount = rsTemp.getInt("sum_HOURLY_BIO_EXEMPTED");
			//out.println(weeklyOCICount);

			if (flagFlightCountb == true) {
				weekDaysBio.append(",");
				weekBioEnrolled.append(",");
				weekBioVerified.append(",");
				weekBioExempted.append(",");
				} 
			else
				flagFlightCountb = true;

			weekDaysBio.append("\"");
			weekDaysBio.append(weeklyBioXAxis);
			weekDaysBio.append("\"");
			
			weekBioEnrolled.append(weekelyBioEnrolledCount);
			weekBioVerified.append(weekelyBioVerifiedCount);
			weekBioExempted.append(weeklyBioExemptedCount);
			
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Bio Exception");
	}

	String strWeekDaysBio = weekDaysBio.toString();
	String strWeekBioEnrolled = weekBioEnrolled.toString();
	String strWeekBioVerified = weekBioVerified.toString();
	String strWeekBioExempted = weekBioExempted.toString();
	
	%>

	<%////////////////	Table -  Biometric Enrollment/Verification/Exemption in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Enrollment&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Verification&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Exempted&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysBio.toString();
			String strWeekBioEnrolled = weekBioEnrolled.toString();
			String strWeekBioVerified = weekBioVerified.toString();
			String strWeekBioExempted = weekBioExempted.toString();*/
			

			String[] weekListBioDays = strWeekDaysBio.toString().replace("\"", "").split(",");
			String[] weeklyBioEnrolledDays = strWeekBioEnrolled.split(",");
			String[] weeklyBioVerifiedDays = strWeekBioVerified.split(",");
			String[] weeklyBioExemptedDays = strWeekBioExempted.split(",");

			for (int i = 0; i < weekListBioDays.length; i++) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weekListBioDays[i].equals("0") ? "&nbsp;" : weekListBioDays[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioEnrolledDays[i].equals("0") ? "&nbsp;" : weeklyBioEnrolledDays[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioVerifiedDays[i].equals("0") ? "&nbsp;" : weeklyBioVerifiedDays[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioExemptedDays[i].equals("0") ? "&nbsp;" : weeklyBioExemptedDays[i]%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Biometric Enrollment/Verification/Exemption in last 7 days - End	////////////////////////%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-7">
	<div class="card"style="border: solid 3px #B93160; border-radius: 20px;">
	<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Biometric Enrollment/Verification/Exemption in last 7 days</h1>

		<canvas id="canvasWeeklyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);border-radius: 20px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysBio%>],
			datasets: [{ 
				  label: "Bio Enrolled",
			      backgroundColor: "#FF6D60",
			      borderColor: "red",
			      borderWidth: 0,
			     
			      data: [<%=strWeekBioEnrolled%>]
			},{ 
				  label: "Bio Verified",
			      backgroundColor: "#F7D060",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strWeekBioVerified%>]
			},{ 
				  label: "Bio Exempted",
			      backgroundColor: "#B3005E",
			      borderColor: "red",
			      borderWidth: 1,
			     
			      data: [<%=strWeekBioExempted%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },
				 title: {
				        fontSize: 12,		
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
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y);
							
						});
					});
				}
			}
		};
		
		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyBio').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%///////////////////	Biometric Enrollment/Verification/Exemption in last 7 days - End	///////////////////%>

		</section>
		<!--   ************************END TSC DIV************************END  TSC DIV****************END  TSC DIV********  -->
		<!--   ************************START BIOMETRIC DIV*******************START BIOMETRIC DIV*****************START BIOMETRIC DIV****************START BIOMETRIC DIV********  -->
		<section id="biometric_2"><br><br><br><br><br><br><br>
		<div class="pt-4" id="biometric_2">
		<table id = "auto-index9" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Biometric Enrollment/Verification/Exemption Statistics in last <%=displayHours%> hours</th>
				</tr>
				<!--<tr id='head' name='biometric'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>	
		</table>
	</section>

		<%////////////////////////////	Biometric Enrollment/Verification/Exemption in last 7 hours - Start	/////////////////
	String hourlyBioQuery = "";
	String hourlyBioYAxis = "";
	int hourlyBioEnrolledCount = 0;
	int hourlyBioVerifiedCount = 0;
	int hourlyBioExemptedCount = 0;
	

	StringBuilder hourlyBio = new StringBuilder();
	StringBuilder hourlyBioEnrolled = new StringBuilder();
	StringBuilder hourlyBioVerified = new StringBuilder();
	StringBuilder hourlyBioExempted = new StringBuilder();

	flagFlightCount = false;
	try {
		hourlyBioQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,HOURLY_BIO_ENROLLED,HOURLY_BIO_VERIFIED,HOURLY_BIO_EXEMPTED, table_type from im_dashboard_combined where pax_boarding_date >= trunc(sysdate-1) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date desc,HOURS desc ) where rownum<="+displayHours;
		psTemp = con.prepareStatement(hourlyBioQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {			
			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 0 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 11)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" AM" ;
				hourlyBioYAxis =  rsTemp.getString("hours").substring(0,2) +" AM" ;

			if (Integer.parseInt(rsTemp.getString("hours").substring(0,2)) >= 12 & Integer.parseInt(rsTemp.getString("hours").substring(0,2)) <= 23)
				//hourlyBioYAxis = rsTemp.getString("show_date") + " : " + rsTemp.getString("hours").substring(0,2) +" PM" ;
				hourlyBioYAxis = rsTemp.getString("hours").substring(0,2) +" PM" ;


			//out.println(hourlyVisaXAxis);
			hourlyBioEnrolledCount = rsTemp.getInt("HOURLY_BIO_ENROLLED");
			hourlyBioVerifiedCount = rsTemp.getInt("HOURLY_BIO_VERIFIED");
			hourlyBioExemptedCount = rsTemp.getInt("HOURLY_BIO_EXEMPTED");
			//out.println(hourlyOCICount);

			if (flagFlightCount == true) {
				hourlyBio.append(",");
				hourlyBioEnrolled.append(",");
				hourlyBioVerified.append(",");
				hourlyBioExempted.append(",");
				} 
			else
				flagFlightCount = true;

			hourlyBio.append("\"");
			hourlyBio.append(hourlyBioYAxis);
			hourlyBio.append("\"");
			
			hourlyBioEnrolled.append(hourlyBioEnrolledCount);
			hourlyBioVerified.append(hourlyBioVerifiedCount);
			hourlyBioExempted.append(hourlyBioExemptedCount);
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Hourly Bio Exception");
	}

	String strHourlyBio = hourlyBio.toString();
	String strHourlyBioEnrolled = hourlyBioEnrolled.toString();
	String strHourlyBioVerified = hourlyBioVerified.toString();
	String strHourlyBioExempted = hourlyBioExempted.toString();
	//out.println(strHourlyOCI);
	
////////////////	Table - Biometric Enrollment/Verification/Exemption in last 7 hours - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign">
		<!--	<caption style="font-size: 15px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 hours</caption>-->
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #38acff;width:25%;">Time</th>
					<th style="text-align: center;background-color:#00539a;border-color: #38acff;width:25%; text-align: right;">Enrollment&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#00539a;border-color: #38acff;width:25%; text-align: right;">Verification&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#00539a;border-color: #38acff;width:25%; text-align: right;">Exempted&nbsp;&nbsp;</th>
				</tr>
		<% 
			String[] hourListBio = strHourlyBio.toString().replace("\"", "").split(",");
			String[] hourBioEnrolled = strHourlyBioEnrolled.split(",");
			String[] hourBioVerified = strHourlyBioVerified.split(",");
			String[] hourBioExempted = strHourlyBioExempted.split(",");
			//String v_date_Format  = "";
			/*String strHourlyBio = hourlyBio.toString();
			String strHourlyBioEnrolled = hourlyBioEnrolled.toString();
			String strHourlyBioVerified = hourlyBioVerified.toString();
			String strHourlyBioExempted = hourlyBioExempted.toString();*/

			for (int i = hourListBio.length - 1; i >= 0; i--) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#38acff;border-color: #00539a;width:25%; font-weight: bold; text-align: center;"><%=hourListBio[i].equals("0") ? "&nbsp;" : hourListBio[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioEnrolled[i].equals("0") ? "&nbsp;" : hourBioEnrolled[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#86cdff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioVerified[i].equals("0") ? "&nbsp;" : hourBioVerified[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#cceaff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioExempted[i].equals("0") ? "&nbsp;" : hourBioExempted[i]%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Biometric Enrollment/Verification/Exemption in last 7 hours - End	////////////////////////%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
	<div class="card" style="border: solid 3px #22668D; border-radius: 20px;">
	<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Biometric Enrollment/Verification/Exemption in last <%=displayHours%> hours</h1>

		<canvas id="canvasHourlyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #8ecddd 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
		</div>
		</div>
		</div>

	<script>
		// Data define for bar chart

		var myDatabb = {
			labels: [<%=reverseOnComma(strHourlyBio)%>],
			datasets: [{ 
				  label: "Bio Enrolled",
			      backgroundColor: "#22668D",
			      borderColor: "#26577C",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyBioEnrolled)%>]
			}, { 
				  label: "Bio Verified",
			      backgroundColor: "#8ECDDD",
			      borderColor: "#26577C",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyBioVerified)%>]
			},
			{ 
				  label: "Bio Exempted",
			      backgroundColor: "#0C134F",
			      borderColor: "#26577C ",
			      borderWidth: 1,
			      data: [<%=reverseOnComma(strHourlyBioExempted)%>]
			}]
		};
		 	

		// Options to display value on top of bars

		var myoptionsbb = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
				var chartInstancesbb = this.chart,
					ctx = chartInstancesbb.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metasbb = chartInstancesbb.controller.getDatasetMeta(i);
						metasbb.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y);
							
						});
					});
				}
			}
		};
		//Code to drow Chart

		var ctx = document.getElementById('canvasHourlyBio').getContext('2d');
		var myChartsbb = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myDatabb,    	// Chart data
			options: myoptionsbb	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%//////////////////////////	Biometric Enrollment/Verification/Exemption in last 7 hours - End	/////////////////////////////////%>


<!--New-->
		<!--   ************************END UCF DIV*******************END UCF DIV*****************END UCF DIV****************END UCF DIV********  -->
		<!--   ************************START TSC DIV************************START TSC DIV****************START TSC DIV********  -->
		<section class="aboutsection" id="ICS_Arr_Gender"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Arr_Gender">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Gender Based Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='tsc'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		


<%///////////////////	Arrival : Gender Based Statistics in last 7 days - End	///////////////////

	String WeeklyGender_Arr = "";
	String weeklyGenderXAxis_Arr = "";
	int weekelyMaleCount_Arr = 0;
	int weekelyFemaleCount_Arr = 0;
	int weeklyOthersCount_Arr = 0;
	

	StringBuilder weekDaysGender_Arr = new StringBuilder();
	StringBuilder weekMale_Arr = new StringBuilder();
	StringBuilder weekFemale_Arr = new StringBuilder();
	StringBuilder weekOthers_Arr = new StringBuilder();

	 flagFlightCountb = false;
	try {
		WeeklyGender_Arr = "select SUM(HOURLY_MALE_COUNT) as sum_hourly_male_count, SUM(HOURLY_FEMALE_COUNT) as sum_hourly_female_count, SUM(HOURLY_OTHERS_COUNT) as sum_hourly_others_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from IM_DASHBOARD_COMBINED where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyGender_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyGenderXAxis_Arr = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyMaleCount_Arr = rsTemp.getInt("sum_hourly_male_count");
			weekelyFemaleCount_Arr = rsTemp.getInt("sum_hourly_female_count");
			if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount_Arr = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount_Arr = rsTemp.getInt("sum_hourly_others_count") + (( weekelyMaleCount_Arr + weekelyFemaleCount_Arr )/10);
			
			//weeklyOthersCountPrint = rsTemp.getInt("sum_hourly_others_count");

			if (flagFlightCountb == true) {
				weekDaysGender_Arr.append(",");
				weekMale_Arr.append(",");
				weekFemale_Arr.append(",");
				weekOthers_Arr.append(",");
				} 
			else
				flagFlightCountb = true;

			weekDaysGender_Arr.append("\"");
			weekDaysGender_Arr.append(weeklyGenderXAxis_Arr);
			weekDaysGender_Arr.append("\"");
			
			weekMale_Arr.append(weekelyMaleCount_Arr);
			weekFemale_Arr.append(weekelyFemaleCount_Arr);
			weekOthers_Arr.append(weeklyOthersCount_Arr);
			
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysGender_Arr = weekDaysGender_Arr.toString();
	String strWeekMale_Arr = weekMale_Arr.toString();
	String strWeekFemale_Arr = weekFemale_Arr.toString();
	String strWeekOthers_Arr = weekOthers_Arr.toString();
	//out.println(strWeekOthers);

	//String additionRequired

	String othersData_Arr = strWeekOthers_Arr.replaceAll(",0",",");
	if(othersData_Arr.substring(0,1).equals("0"))
		othersData_Arr = othersData_Arr.substring(1,othersData_Arr.length());
	
	//out.println(strWeekOthers + "<BR>");
	//out.println(othersData);
	
	%>

	<%////////////////	Table -  Male/Female Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">

		<table class="tableDesign">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Male&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Female&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Others&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysGender.toString();
			String strWeekBioEnrolled = weekMale.toString();
			String strWeekBioVerified = weekFemale.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weekGenderDays_Arr = strWeekDaysGender_Arr.toString().replace("\"", "").split(",");
			String[] weeklyMaleDays_Arr = strWeekMale_Arr.split(",");
			String[] weeklyFemaleDays_Arr = strWeekFemale_Arr.split(",");
			String[] weeklyOthersDays_Arr = strWeekOthers_Arr.split(",");
			
			for (int i = 0; i < weekGenderDays_Arr.length; i++) {
				t_Total_Arr = 0;
				if(Integer.parseInt(weeklyOthersDays_Arr[i]) != 0)
					t_Total_Arr = Integer.parseInt(weeklyMaleDays_Arr[i]) + Integer.parseInt(weeklyFemaleDays_Arr[i]) + Integer.parseInt(weeklyOthersDays_Arr[i]) -(Integer.parseInt(weeklyMaleDays_Arr[i]) + Integer.parseInt(weeklyFemaleDays_Arr[i])) /10;
				else
					t_Total_Arr = Integer.parseInt(weeklyMaleDays_Arr[i]) + Integer.parseInt(weeklyFemaleDays_Arr[i]) + Integer.parseInt(weeklyOthersDays_Arr[i]);
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:20%; font-weight: bold;text-align: center;"><%=weekGenderDays_Arr[i].equals("0") ? "&nbsp;" : weekGenderDays_Arr[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyMaleDays_Arr[i].equals("0") ? "&nbsp;" : weeklyMaleDays_Arr[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyFemaleDays_Arr[i].equals("0") ? "&nbsp;" : weeklyFemaleDays_Arr[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyOthersDays_Arr[i].equals("0") ? "&nbsp;" : Integer.parseInt(weeklyOthersDays_Arr[i]) - (Integer.parseInt(weeklyMaleDays_Arr[i]) + Integer.parseInt(weeklyFemaleDays_Arr[i])) /10%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right; color:#da1e28"><%=t_Total_Arr == 0 ? "&nbsp;" : t_Total_Arr%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Male/Female Count in last 7 days - End	////////////////////////%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
<div class="card-body">	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Gender Based Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyGender_Arr" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);border-radius: 20px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysGender_Arr%>],
			datasets: [{ 
				  label: "Male",
			      backgroundColor: "#377ff3",
			      borderColor: "#377ff3",
			      borderWidth: 1,
			     
			      data: [<%=strWeekMale_Arr%>]
			},{ 
				  label: "Female",
			      backgroundColor: "#FF4B91",
			      borderColor: "#FF4B91",
			      borderWidth: 1,
			     
			      data: [<%=strWeekFemale_Arr%>]
			},{ 
				  label: "Others",
			      backgroundColor: "#00e0b2",
			      borderColor: "#00e0b2",
			      borderWidth: 1,
			     
			      data: [<%=othersData_Arr%>]
			}]};
		 	

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
				enabled: false
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
					//alert(this.data.datasets[0].data[2]);
					male = this.data.datasets[0].data;
					female = this.data.datasets[1].data;

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						//alert(metas.data[0]);
						metas.data.forEach(function (bar, index) {
							var data1 = dataset.data[index];
							if(i==2)
							{	
								ctx.fillText(data1- Math.floor((male[index]+female[index])/10) , bar._model.x-28, bar._model.y+8 );
							}
							else
								ctx.fillText(data1, bar._model.x-28, bar._model.y+8 );
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyGender_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</section>

<%///////////////////	Arrival : Gender Based Statistics in last 7 days - End	///////////////////%>









<!--New-->
		<!--   ************************END UCF DIV*******************END UCF DIV*****************END UCF DIV****************END UCF DIV********  -->
		<!--   ************************START TSC DIV************************START TSC DIV****************START TSC DIV********  -->
		<section class="aboutsection" id="ICS_Dep_Gender"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Dep_Gender">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : Gender Based Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='tsc'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>
		


<%//////////////////////	Departure : Gender Based Statistics in last 7 days - Start	/////////////////////////////////
	String WeeklyGender = "";
	String weeklyGenderXAxis = "";
	int weekelyMaleCount = 0;
	int weekelyFemaleCount = 0;
	int weeklyOthersCount = 0;
	

	StringBuilder weekDaysGender = new StringBuilder();
	StringBuilder weekMale = new StringBuilder();
	StringBuilder weekFemale = new StringBuilder();
	StringBuilder weekOthers = new StringBuilder();

	 flagFlightCountb = false;
	try {
		WeeklyGender = "select SUM(HOURLY_MALE_COUNT) as sum_hourly_male_count, SUM(HOURLY_FEMALE_COUNT) as sum_hourly_female_count, SUM(HOURLY_OTHERS_COUNT) as sum_hourly_others_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from IM_DASHBOARD_COMBINED where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyGender);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyGenderXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyMaleCount = rsTemp.getInt("sum_hourly_male_count");
			weekelyFemaleCount = rsTemp.getInt("sum_hourly_female_count");
			if(rsTemp.getInt("sum_hourly_others_count") == 0)
				weeklyOthersCount = rsTemp.getInt("sum_hourly_others_count");
			else
				weeklyOthersCount = rsTemp.getInt("sum_hourly_others_count") + (( weekelyMaleCount + weekelyFemaleCount )/10);
			
			//weeklyOthersCountPrint = rsTemp.getInt("sum_hourly_others_count");

			if (flagFlightCountb == true) {
				weekDaysGender.append(",");
				weekMale.append(",");
				weekFemale.append(",");
				weekOthers.append(",");
				} 
			else
				flagFlightCountb = true;

			weekDaysGender.append("\"");
			weekDaysGender.append(weeklyGenderXAxis);
			weekDaysGender.append("\"");
			
			weekMale.append(weekelyMaleCount);
			weekFemale.append(weekelyFemaleCount);
			weekOthers.append(weeklyOthersCount);
			
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysGender = weekDaysGender.toString();
	String strWeekMale = weekMale.toString();
	String strWeekFemale = weekFemale.toString();
	String strWeekOthers = weekOthers.toString();
	//out.println(strWeekOthers);

	//String additionRequired

	String othersData = strWeekOthers.replaceAll(",0",",");
	if(othersData.substring(0,1).equals("0"))
		othersData = othersData.substring(1,othersData.length());
	
	//out.println(strWeekOthers + "<BR>");
	//out.println(othersData);
	
	%>

	<%////////////////	Table -  Male/Female Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">

		<table class="tableDesign">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Male&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Female&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Others&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysGender.toString();
			String strWeekBioEnrolled = weekMale.toString();
			String strWeekBioVerified = weekFemale.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weekGenderDays = strWeekDaysGender.toString().replace("\"", "").split(",");
			String[] weeklyMaleDays = strWeekMale.split(",");
			String[] weeklyFemaleDays = strWeekFemale.split(",");
			String[] weeklyOthersDays = strWeekOthers.split(",");
			
			for (int i = 0; i < weekGenderDays.length; i++) {
				t_Total = 0;
				if(Integer.parseInt(weeklyOthersDays[i]) != 0)
					t_Total = Integer.parseInt(weeklyMaleDays[i]) + Integer.parseInt(weeklyFemaleDays[i]) + Integer.parseInt(weeklyOthersDays[i])- (Integer.parseInt(weeklyMaleDays[i]) + Integer.parseInt(weeklyFemaleDays[i])) /10;
				else
					t_Total = Integer.parseInt(weeklyMaleDays[i]) + Integer.parseInt(weeklyFemaleDays[i]) + Integer.parseInt(weeklyOthersDays[i]);
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:20%; font-weight: bold;text-align: center;"><%=weekGenderDays[i].equals("0") ? "&nbsp;" : weekGenderDays[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyMaleDays[i].equals("0") ? "&nbsp;" : weeklyMaleDays[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyFemaleDays[i].equals("0") ? "&nbsp;" : weeklyFemaleDays[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyOthersDays[i].equals("0") ? "&nbsp;" : Integer.parseInt(weeklyOthersDays[i])- (Integer.parseInt(weeklyMaleDays[i]) + Integer.parseInt(weeklyFemaleDays[i])) /10%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right; color:#da1e28"><%=t_Total == 0 ? "&nbsp;" : t_Total%>&nbsp;&nbsp;</td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Male/Female Count in last 7 days - End	////////////////////////%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
<div class="card-body">	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Departure : Gender Based Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyGender" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);border-radius: 20px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysGender%>],
			datasets: [{ 
				  label: "Male",
			      backgroundColor: "#377ff3",
			      borderColor: "#377ff3",
			      borderWidth: 1,
			     
			      data: [<%=strWeekMale%>]
			},{ 
				  label: "Female",
			      backgroundColor: "#FF4B91",
			      borderColor: "#FF4B91",
			      borderWidth: 1,
			     
			      data: [<%=strWeekFemale%>]
			},{ 
				  label: "Others",
			      backgroundColor: "#00e0b2",
			      borderColor: "#00e0b2",
			      borderWidth: 1,
			     
			      data: [<%=othersData%>]
			}]};
		 	

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
				enabled: false
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
					//alert(this.data.datasets[0].data[2]);
					male = this.data.datasets[0].data;
					female = this.data.datasets[1].data;

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						//alert(metas.data[0]);
						metas.data.forEach(function (bar, index) {
							var data1 = dataset.data[index];
							if(i==2)
							{	
								ctx.fillText(data1- Math.floor((male[index]+female[index])/10) , bar._model.x-28, bar._model.y+8 );
							}
							else
								ctx.fillText(data1, bar._model.x-28, bar._model.y+8 );
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyGender').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</section>

<%///////////////////	Male/Female Count in last 7 days - End	///////////////////%>


<!--   ************************END UCF DIV*******************END UCF DIV*****************END UCF DIV****************END UCF DIV********  -->
		<!--   ************************START TSC DIV************************START TSC DIV****************START TSC DIV********  -->
		<section class="aboutsection" id="ICS_Arr_Indian_Foreigner"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Arr_Indian_Foreigner">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Indian/Foreigner Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='tsc'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>


<%///////////////////	Arrival : Indian/Foreigner Statistics in last 7 days - End	///////////////////
	String WeeklyNationality_Arr = "";
	String weeklyNationalityXAxis_Arr = "";
	int weekelyIndianCount_Arr = 0;
	int weekelyForeignerCount_Arr = 0;
	

	StringBuilder weekDaysNationality_Arr = new StringBuilder();
	StringBuilder weekIndian_Arr = new StringBuilder();
	StringBuilder weekForeigner_Arr = new StringBuilder();

	 flagFlightCountb = false;
	try {
		WeeklyNationality_Arr = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyNationality_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyNationalityXAxis_Arr = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyIndianCount_Arr = rsTemp.getInt("sum_hourly_indian_count");
			weekelyForeignerCount_Arr = rsTemp.getInt("sum_hourly_foreigner_count");
			//out.println(weeklyOCICount);

			if (flagFlightCountb == true) {
				weekDaysNationality_Arr.append(",");
				weekIndian_Arr.append(",");
				weekForeigner_Arr.append(",");
				} 
			else
				flagFlightCountb = true;

			weekDaysNationality_Arr.append("\"");
			weekDaysNationality_Arr.append(weeklyNationalityXAxis_Arr);
			weekDaysNationality_Arr.append("\"");
			
			weekIndian_Arr.append(weekelyIndianCount_Arr);
			weekForeigner_Arr.append(weekelyForeignerCount_Arr);
			
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysNationality_Arr = weekDaysNationality_Arr.toString();
	String strWeekIndian_Arr = weekIndian_Arr.toString();
	String strWeekForeigner_Arr = weekForeigner_Arr.toString();
	
	%>

	<%////////////////	Table -  Arrival : Indian/Foreigner Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign" height="100">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Indian&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Foreingner&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysNationality.toString();
			String strWeekBioEnrolled = weekIndian.toString();
			String strWeekBioVerified = weekForeigner.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weekNationalityDay_Arr = strWeekDaysNationality_Arr.toString().replace("\"", "").split(",");
			String[] weeklyIndianDay_Arr = strWeekIndian_Arr.split(",");
			String[] weeklyForeignerDay_Arr = strWeekForeigner_Arr.split(",");

			for (int i = 0; i < weekNationalityDay_Arr.length; i++) {
				t_Total_Arr = 0;
				t_Total_Arr = Integer.parseInt(weeklyIndianDay_Arr[i]) + Integer.parseInt(weeklyForeignerDay_Arr[i]);
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weekNationalityDay_Arr[i].equals("0") ? "&nbsp;" : weekNationalityDay_Arr[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyIndianDay_Arr[i].equals("0") ? "&nbsp;" : weeklyIndianDay_Arr[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyForeignerDay_Arr[i].equals("0") ? "&nbsp;" : weeklyForeignerDay_Arr[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;color:#da1e28;"><%=t_Total_Arr == 0 ? "&nbsp;" : t_Total_Arr%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Arrival : Indian/Foreigner Count in last 7 days - End	////////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
<div class="card-body">
<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Indian/Foreigner Statistics in last 7 days</h1>

	<canvas id="canvasWeeklyNationality_Arr" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%); border-radius: 20px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysNationality_Arr%>],
			datasets: [{ 
				  label: "Indian",
			      backgroundColor: "#FF004D",
			      borderColor: "#FF004D",
			      borderWidth: 0,
			     
			      data: [<%=strWeekIndian_Arr%>]
			},{ 
				  label: "Foreigner",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strWeekForeigner_Arr%>]
			}]};
		 	

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
							ctx.fillText(data, bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyNationality_Arr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</section>

<%///////////////////	Arrival : Indian/Foreigner Statistics in last 7 days - End	///////////////////%>

</div>
		</section>




<!--   ************************END UCF DIV*******************END UCF DIV*****************END UCF DIV****************END UCF DIV********  -->
		<!--   ************************START TSC DIV************************START TSC DIV****************START TSC DIV********  -->
		<section class="aboutsection" id="ICS_Dep_Indian_Foreigner"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Dep_Indian_Foreigner">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : Indian/Foreigner Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='tsc'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>


<%//////////////////////	Indian/Foreigner Count in last 7 days - Start	/////////////////////////////////
	String WeeklyNationality = "";
	String weeklyNationalityXAxis = "";
	int weekelyIndianCount = 0;
	int weekelyForeignerCount = 0;
	

	StringBuilder weekDaysNationality = new StringBuilder();
	StringBuilder weekIndian = new StringBuilder();
	StringBuilder weekForeigner = new StringBuilder();

	 flagFlightCountb = false;
	try {
		WeeklyNationality = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from  IM_DASHBOARD_COMBINED where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

		psTemp = con.prepareStatement(WeeklyNationality);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyNationalityXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyIndianCount = rsTemp.getInt("sum_hourly_indian_count");
			weekelyForeignerCount = rsTemp.getInt("sum_hourly_foreigner_count");
			//out.println(weeklyOCICount);

			if (flagFlightCountb == true) {
				weekDaysNationality.append(",");
				weekIndian.append(",");
				weekForeigner.append(",");
				} 
			else
				flagFlightCountb = true;

			weekDaysNationality.append("\"");
			weekDaysNationality.append(weeklyNationalityXAxis);
			weekDaysNationality.append("\"");
			
			weekIndian.append(weekelyIndianCount);
			weekForeigner.append(weekelyForeignerCount);
			
		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Gender Exception");
	}

	String strWeekDaysNationality = weekDaysNationality.toString();
	String strWeekIndian = weekIndian.toString();
	String strWeekForeigner = weekForeigner.toString();
	
	%>

	<%////////////////	Table -  Indian/Foreigner Count in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-4">
		<table class="tableDesign" height="100">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Indian&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Foreingner&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Total&nbsp;&nbsp;</th>
			</tr>
		<% 

			/*String strWeekDaysBio = weekDaysNationality.toString();
			String strWeekBioEnrolled = weekIndian.toString();
			String strWeekBioVerified = weekForeigner.toString();
			String strWeekBioExempted = weekOthers.toString();*/
			

			String[] weekNationalityDay = strWeekDaysNationality.toString().replace("\"", "").split(",");
			String[] weeklyIndianDay = strWeekIndian.split(",");
			String[] weeklyForeignerDay = strWeekForeigner.split(",");

			for (int i = 0; i < weekNationalityDay.length; i++) {
				t_Total = 0;
				t_Total = Integer.parseInt(weeklyIndianDay[i]) + Integer.parseInt(weeklyForeignerDay[i]);
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weekNationalityDay[i].equals("0") ? "&nbsp;" : weekNationalityDay[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyIndianDay[i].equals("0") ? "&nbsp;" : weeklyIndianDay[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyForeignerDay[i].equals("0") ? "&nbsp;" : weeklyForeignerDay[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;color:#da1e28;"><%=t_Total == 0 ? "&nbsp;" : t_Total%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Indian/Foreigner Count in last 7 days - End	////////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-7">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
<div class="card-body">
<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Departure : Indian/Foreigner Statistics in last 7 days</h1>

	<canvas id="canvasWeeklyNationality" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%); border-radius: 20px;"></canvas>
	</div>
	</div>	
	</div>
	</div>
	</div>	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysNationality%>],
			datasets: [{ 
				  label: "Indian",
			      backgroundColor: "#FF004D",
			      borderColor: "#FF004D",
			      borderWidth: 0,
			     
			      data: [<%=strWeekIndian%>]
			},{ 
				  label: "Foreigner",
			      backgroundColor: "#FC7300",
			      borderColor: "#FC7300",
			      borderWidth: 1,
			     
			      data: [<%=strWeekForeigner%>]
			}]};
		 	

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
							ctx.fillText(data, bar._model.x-30, bar._model.y+9 );
							
						});
					});
				}
			},
			
		};

		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyNationality').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</section>

<%///////////////////	Indian/Foreigner Count in last 7 days - End	///////////////////%>

</div>
		</section>

		<!--   ************************Currently Running Flight Status******************START pax DIV*****************START pax DIV****************START pax DIV********  -->
		<section id="ICS_Flight_Running_Status" ><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Flight_Running_Status">
		<table id = "auto-index2" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Currently Running Flight Status in last 30 minutes</th>
				</tr>
			</thead>
		</table><br>
	<%////////////////////	Arr - Currently Running Flight Status - Start	////////////////////////
String srNo = "";
String paxBoardingDate = "";
String paxBoardingTime = "";
String flightNo = "";
String flightDescription = "";
String firstPaxCheckTime = "";
String latestPaxCheckTime = "";
String totalPaxChecked = "";

/*StringBuilder hourlyTime = new StringBuilder();
StringBuilder hourlyPax = new StringBuilder();
StringBuilder hourlyFlight = new StringBuilder();
StringBuilder hourlyActiveCounter = new StringBuilder();*/


	/*String hourSet_Arrpfa = "";
	java.util.Date v_hourSet_Arrpfa = null;
	//DateFormat vArrDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vArrDateFormat = new SimpleDateFormat("MMM-dd HH");*/
			////////////////	Table - Arrival Clearance in last 7 hours - Start	//////////////////////


// flagPaxCount = false;
try {
	arrHourlyQuery = "select ICP_SRNO, ICP_DESCRIPTION, TABLE_TYPE, to_char(PAX_BOARDING_DATE, 'dd/mm/yyyy') || ' ' || substr(PAX_BOARDING_TIME,0,2) || ':' ||  substr(PAX_BOARDING_TIME,3,2) as PAX_BOARDING_DATE, FLIGHT_NO, FIRST_PAX_CHECK_TIME, LATEST_PAX_CHECK_TIME, TOTAL_PAX_CHECK, FLIGHT_DESC from IM_CURRENT_RUNNING_FLIGHT_STATUS where icp_srno = '"+ filter_icp +"' and table_type = 'IM_TRANS_ARR_TOTAL' order by  LATEST_PAX_CHECK_TIME DESC";
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
%>
	<div class="container-fluid">
	<div class="row">
	<div class="col-sm-5">
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival Clearance in last 7 hours</caption>-->
			
				<tr style="font-size: 20px;  text-align: right; color:white; border-color: #003a6d;">
					<th colspan="6" style="text-align: center; width:25%; background-color:#0072c3;border-color: #0072c3;width:12.5%; text-align: center;">Arrival : Currently Running Flight Status</th>
				</tr>
				<tr style="font-size: 15px;  text-align: right; color:white; border-color: #003a6d;">
					<th style=" width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: center;">S.No.</th>
					<th style="text-align: center; width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: center;">Scheduled&nbsp;Date</th>
					<th style="text-align: center; width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: left;">Flight&nbsp;No.</th>
					<!--<th style="text-align: center; width:25%; background-color:#B93160;border-color: #e497b2;width:12.5%; text-align: right;">Flight&nbsp;Description&nbsp;&nbsp;&nbsp;</th>-->
					<th style="text-align: center; width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: center;">First&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center; width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: center;">Latest&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center; width:25%; background-color:#1192e8;border-color: #0072c3;width:12.5%; text-align: right;">PAX&nbsp;Checked&nbsp;&nbsp;</th>
				</tr>
		<% 
					int counter = 0;

	while (rsTemp.next()) {	
		//srNo = rsTemp.getString("ICP_SRNO");
		paxBoardingDate = rsTemp.getString("PAX_BOARDING_DATE");
		flightNo = rsTemp.getString("FLIGHT_NO");
		flightDescription = rsTemp.getString("FLIGHT_DESC");
		firstPaxCheckTime = rsTemp.getString("FIRST_PAX_CHECK_TIME");
		latestPaxCheckTime = rsTemp.getString("LATEST_PAX_CHECK_TIME");
		totalPaxChecked = rsTemp.getString("TOTAL_PAX_CHECK");
		//out.println(hourlyArrActiveCounter);
		%>
		<tr style="font-size: 12px; font-family: 'Arial', serif; height:20px;">
			<td style="background-color:#74caff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=++counter%></td>
			<td style="background-color:#8dd3ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=paxBoardingDate.replace(" ","&nbsp;")%></td>
			<td style="background-color:#a0daff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: left;"><%=flightNo%></td>
			<!--<td style="background-color:#f4d7e1; width:25%; border-color: #B93160;width:12.5%; font-weight: bold; text-align: center;"><%=flightDescription%>&nbsp;&nbsp;&nbsp;</td>-->
			<td style="background-color:#bae6ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=firstPaxCheckTime%></td>
			<td style="background-color:#d3eeff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: center;"><%=latestPaxCheckTime%></td>
			<td style="background-color:#e5f6ff; width:25%; border-color: #0072c3;width:12.5%; font-weight: bold; text-align: right; font-size:16px;"><%=totalPaxChecked%>&nbsp;&nbsp;</td>
		</tr>
<%
	}
	rsTemp.close();
	psTemp.close();
	if(counter == 0)
		{
			%>
		<tr style="font-size: 25px; font-family: 'Arial', serif; height:20px;background-color:white;">
			<td colspan="6" style="background-color:#f6f2ff; border-color: #004144; font-weight: bold; text-align: center; align:center;color:red;"><br><br>!!! No Records Found !!!<br><br><br></td>
		</tr>
		
		<%
		}
		%>
	</table>
		
		</div>
	<div class="col-sm-1">
	</div>
		<%

} catch (Exception e) {
	out.println("Currently Running Flight Status");
}

%>


<%/////////////////		Arr - Currently Running Flight Status - End		///////////////////%>




	<%////////////////////	Dep - Currently Running Flight Status - Start	////////////////////////
String paxBoardingDate_Dep = "";
String paxBoardingTime_Dep = "";
String flightNo_Dep = "";
String flightDescription_Dep = "";
String firstPaxCheckTime_Dep = "";
String latestPaxCheckTime_Dep = "";
String totalPaxChecked_Dep = "";

/*StringBuilder hourlyTime = new StringBuilder();
StringBuilder hourlyPax = new StringBuilder();
StringBuilder hourlyFlight = new StringBuilder();
StringBuilder hourlyActiveCounter = new StringBuilder();*/


	/*String hourSet_Arrpfa = "";
	java.util.Date v_hourSet_Arrpfa = null;
	//DateFormat vArrDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vArrDateFormat = new SimpleDateFormat("MMM-dd HH");*/
			////////////////	Table - Arrival Clearance in last 7 hours - Start	//////////////////////


// flagPaxCount = false;
try {
	arrHourlyQuery = "select ICP_SRNO, ICP_DESCRIPTION, TABLE_TYPE, to_char(PAX_BOARDING_DATE, 'dd/mm/yyyy') || ' ' || substr(PAX_BOARDING_TIME,0,2) || ':' ||  substr(PAX_BOARDING_TIME,3,2) as PAX_BOARDING_DATE, FLIGHT_NO, FIRST_PAX_CHECK_TIME, LATEST_PAX_CHECK_TIME, TOTAL_PAX_CHECK, FLIGHT_DESC from IM_CURRENT_RUNNING_FLIGHT_STATUS where icp_srno = '"+ filter_icp +"' and table_type = 'IM_TRANS_DEP_TOTAL' order by  LATEST_PAX_CHECK_TIME DESC";
	psTemp = con.prepareStatement(arrHourlyQuery);
	rsTemp = psTemp.executeQuery();
%>
	<div class="col-sm-5">
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival Clearance in last 7 hours</caption>-->
			
				<tr style="font-size: 20px;  text-align: right; color:white; border-color: #003a6d;">
					<th colspan="6" style="text-align: center; width:25%; background-color:#005d5d;border-color: #005d5d;width:12.5%; text-align: center;">Departure : Currently Running Flight Status</th>
				</tr>
				<tr style="font-size: 15px;  text-align: right; color:white; border-color: #005d5d;">					
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d; text-align: center;">S.No.</th>
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d; text-align: center;">Scheduled&nbsp;Date</th>
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d; text-align: left;">Flight&nbsp;No.</th>
					<!--<th style="text-align: center;  background-color:#B93160;border-color: #e497b2;width:12.5%; text-align: right;">Flight&nbsp;Description&nbsp;&nbsp;&nbsp;</th>-->
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d;text-align: center;">First&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d; text-align: center;">Latest&nbsp;PAX&nbsp;Check&nbsp;Time</th>
					<th style="text-align: center;  background-color:#007d79;border-color: #005d5d; text-align: right;">PAX&nbsp;Checked&nbsp;&nbsp;</th>
				</tr>
		<% 
					int counter = 0;

	while (rsTemp.next()) {	
		//srNo = rsTemp.getString("ICP_SRNO");
		paxBoardingDate_Dep = rsTemp.getString("PAX_BOARDING_DATE");
		flightNo_Dep = rsTemp.getString("FLIGHT_NO");
		flightDescription_Dep = rsTemp.getString("FLIGHT_DESC");
		firstPaxCheckTime_Dep = rsTemp.getString("FIRST_PAX_CHECK_TIME");
		latestPaxCheckTime_Dep = rsTemp.getString("LATEST_PAX_CHECK_TIME");
		totalPaxChecked_Dep = rsTemp.getString("TOTAL_PAX_CHECK");
		//out.println(hourlyArrActiveCounter);
		%>
		<tr style="font-size: 12px; font-family: 'Arial', serif; height:20px;">
			<td style="background-color:#3ddbd9;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=++counter%></td>
			<td style="background-color:#69e3e2;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=paxBoardingDate_Dep.replace(" ","&nbsp;")%></td>
			<td style="background-color:#84e8e7;  border-color: #005d5d; font-weight: bold; text-align: left;"><%=flightNo_Dep%></td>
			<!--<td style="background-color:#f4d7e1;  border-color: #B93160; font-weight: bold; text-align: center;"><%=flightDescription_Dep%>&nbsp;&nbsp;&nbsp;</td>-->
			<td style="background-color:#9ef0f0;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=firstPaxCheckTime_Dep%></td>
			<td style="background-color:#b8f4f4;  border-color: #005d5d; font-weight: bold; text-align: center;"><%=latestPaxCheckTime_Dep%></td>
			<td style="background-color:#d9fbfb;  border-color: #005d5d; font-weight: bold; text-align: right;font-size:16px;"><%=totalPaxChecked_Dep%>&nbsp;&nbsp;</td>
		</tr>
<%
	}
	rsTemp.close();
	psTemp.close();
	
		if(counter == 0)
		{
			%>
		<tr style="font-size: 25px; font-family: 'Arial', serif; height:20px;background-color:white;">
			<td colspan="6" style="background-color:#f6f2ff; border-color: #004144; font-weight: bold; text-align: center; align:center;color:red;"><br><br>!!! No Records Found !!!<br><br><br></td>
		</tr>
		
		<%
		}
		%>
		</table>
		</div>
		</div>
		</div>
		<%

} catch (Exception e) {
	out.println("Currently Running Flight Status");
}

%>










</div>
		</section>








<!--   ************************Currently Running Flight Status******************START pax DIV*****************START pax DIV****************START pax DIV********  -->
		<section id="ICS_Agewise" ><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Agewise">
		<table id = "auto-index2" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Age-wise Statistics in last 7 days</th>
				</tr>
			</thead>
		</table><br>
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

	 flagFlightCountb = false;
	try {
		WeeklyArrAgewise = "select SUM(M0_M6) as M0_M6, SUM(M6_Y1) as M6_Y1,SUM(Y1_Y5) as Y1_Y5,SUM(Y5_Y10) as Y5_Y10,SUM(Y10_Y20) as Y10_Y20,SUM(Y20_Y30) as Y20_Y30,SUM(Y30_Y40) as Y30_Y40,SUM(Y40_Y50) as Y40_Y50,SUM(Y50_Y60) as Y50_Y60,SUM(Y60_Y70) as Y60_Y70,SUM(Y70_Y80) as Y70_Y80,  SUM(Y80_Y90) as Y80_Y90,  SUM(Y90_Y100) as Y90_Y100,  SUM(Y100) as Y100, icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";

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
		<div class="col">

		<table class="tableDesign" height="100">
		<!--	<caption style="font-size: 19px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Biometric Enrollment/Verification/Exemption in last 7 days</caption>-->
			
			<tr style="font-size: 14px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: center;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Below&nbsp;06&nbsp;Months&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">06&nbsp;Months&nbsp;to&nbsp;01&nbsp;Yr&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">01&nbsp;to&nbsp;05&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">05&nbsp;to&nbsp;10&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">10&nbsp;to&nbsp;20&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">20&nbsp;to&nbsp;30&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">30&nbsp;to&nbsp;40&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">40&nbsp;to&nbsp;50&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">50&nbsp;to&nbsp;60&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">60&nbsp;to&nbsp;70&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">70&nbsp;to&nbsp;80&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">80&nbsp;to&nbsp;90&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">90&nbsp;to&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #fb666e;width:20%; text-align: right;">Above&nbsp;100&nbsp;Yrs&nbsp;&nbsp;</th>
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
		<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;text-align: center;"><%=weeklyDaysAgewise[i].replace("-","&#8209;")%></td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM0_M6_Arr[i].equals("0") ? "&nbsp;" : weeklyM0_M6_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyM6_Y1_Arr[i].equals("0") ? "&nbsp;" : weeklyM6_Y1_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY1_Y5_Arr[i].equals("0") ? "&nbsp;" : weeklyY1_Y5_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY5_Y10_Arr[i].equals("0") ? "&nbsp;" : weeklyY5_Y10_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY10_Y20_Arr[i].equals("0") ? "&nbsp;" :weeklyY10_Y20_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY20_Y30_Arr[i].equals("0") ? "&nbsp;" : weeklyY20_Y30_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY30_Y40_Arr[i].equals("0") ? "&nbsp;" : weeklyY30_Y40_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY40_Y50_Arr[i].equals("0") ? "&nbsp;" : weeklyY40_Y50_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY50_Y60_Arr[i].equals("0") ? "&nbsp;" : weeklyY50_Y60_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY60_Y70_Arr[i].equals("0") ? "&nbsp;" : weeklyY60_Y70_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY70_Y80_Arr[i].equals("0") ? "&nbsp;" : weeklyY70_Y80_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY80_Y90_Arr[i].equals("0") ? "&nbsp;" : weeklyY80_Y90_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY90_Y100_Arr[i].equals("0") ? "&nbsp;" : weeklyY90_Y100_Arr[i]%>&nbsp;&nbsp;</td>
		<td style="background-color:#fc8b92;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyY100_Arr[i].equals("0") ? "&nbsp;" : weeklyY100_Arr[i]%>&nbsp;&nbsp;</td>
	</tr>
<%
			}
			%>
		</table>
		</div>
		</div>
	</div>
	<%///////////////////////	Table - Indian/Foreigner Count in last 7 days - End	////////////////////////%>

<br>
<br>
<div class="container">
<div class="row">

<div class="col-sm-12">
<div class="card" style="border: solid 3px #da1e28; border-radius: 20px;">
<div class="card-body">
<h1 style="font-size: 20px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Age-wise Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyAgewise2" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);border-radius: 20px;"></canvas>
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
			      backgroundColor: "darkMagenta",
			      borderColor: "darkMagenta",
			      borderWidth: 1,
			     
			      data: [<%=strweekY50_Y60_Arr%>]
			},{ 
				  label: "60-70 Years",
			      backgroundColor: "fireBrick",
			      borderColor: "fireBrick",
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
				
scales: {
		yAxes: [{
		ticks: { beginAtZero: true },
		//stacked: true
		display: false
		}],
		xAxes: [{
		//stacked: true,
		
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
					ctx.fillStyle = "#303030";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 9px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x-1, bar._model.y );

							
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

		</section>



		<!--   ************************START Custom APIS DIV*******************START Custom APIS DIV*****************START Custom APIS DIV****************START UCF DIV********  -->
		<section id="ucf_Indian"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ucf_Indian">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Indian UCF Matched/Not Matched Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

		<%//////////////////////////////////////////////	Types of Indian UCF in last 7 days - Start	////////////////////////////////////////////////////
	String WeeklyUcfQuery = "";
	String weeklyUcfXAxis = "";
	int weekelyUcfExistsIndCount = 0;
	int weekelyUcfNotExistsIndCount = 0;
	
	StringBuilder weekDaysUcf = new StringBuilder();
	StringBuilder weekUcfExistsInd = new StringBuilder();
	StringBuilder weekUcfNotExistsInd = new StringBuilder();


	String WeeklyUcfQuery_Dep = "";
	String weeklyUcfXAxis_Dep = "";
	int weekelyUcfExistsIndCount_Dep = 0;
	int weekelyUcfNotExistsIndCount_Dep = 0;

	StringBuilder weekDaysUcf_Dep = new StringBuilder();
	StringBuilder weekUcfExistsInd_Dep = new StringBuilder();
	StringBuilder weekUcfNotExistsInd_Dep = new StringBuilder();
	
	  flagFlightCount = false;
	try {
		WeeklyUcfQuery = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_INDIAN) as SUM_UCF_EXISTS_INDIAN,SUM(UCF_NOT_EXISTS_INDIAN) as SUM_UCF_NOT_EXISTS_INDIAN from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyUcfQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyUcfXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyUcfXAxis);
			weekelyUcfExistsIndCount = rsTemp.getInt("SUM_UCF_EXISTS_INDIAN");
			weekelyUcfNotExistsIndCount = rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN");
			
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysUcf.append(",");
				weekUcfExistsInd.append(",");
				weekUcfNotExistsInd.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysUcf.append("\"");
			weekDaysUcf.append(weeklyUcfXAxis);
			weekDaysUcf.append("\"");
			
			weekUcfExistsInd.append(weekelyUcfExistsIndCount);
			weekUcfNotExistsInd.append(weekelyUcfNotExistsIndCount);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Ucf Indian Exception");
	}

///////////////////////////////////////////////////////////////////////////////////
flagFlightCount = false;
try {
		WeeklyUcfQuery_Dep = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_INDIAN) as SUM_UCF_EXISTS_INDIAN,SUM(UCF_NOT_EXISTS_INDIAN) as SUM_UCF_NOT_EXISTS_INDIAN from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyUcfQuery_Dep);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyUcfXAxis_Dep = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyUcfXAxis);
			weekelyUcfExistsIndCount_Dep = rsTemp.getInt("SUM_UCF_EXISTS_INDIAN");
			weekelyUcfNotExistsIndCount_Dep = rsTemp.getInt("SUM_UCF_NOT_EXISTS_INDIAN");
			
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysUcf_Dep.append(",");
				weekUcfExistsInd_Dep.append(",");
				weekUcfNotExistsInd_Dep.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysUcf_Dep.append("\"");
			weekDaysUcf_Dep.append(weeklyUcfXAxis_Dep);
			weekDaysUcf_Dep.append("\"");
			
			weekUcfExistsInd_Dep.append(weekelyUcfExistsIndCount_Dep);
			weekUcfNotExistsInd_Dep.append(weekelyUcfNotExistsIndCount_Dep);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Ucf Indian Exception");
	}
///////////////////////////////////////////////////////////////////////////////////


	String strweekDaysUcf = weekDaysUcf.toString();
	String strweekUcfExistsInd = weekUcfExistsInd.toString();
	String strweekUcfNotExistsInd = weekUcfNotExistsInd.toString();


	String strweekDaysUcf_Dep = weekDaysUcf_Dep.toString();
	String strweekUcfExistsInd_Dep = weekUcfExistsInd_Dep.toString();
	String strweekUcfNotExistsInd_Dep = weekUcfNotExistsInd_Dep.toString();
	
	//out.println(strweekOCI);
	
	%>
<%////////////////	Table - Types of Indian UCF in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-4">
		
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 days</caption>-->
			

				<tr style="font-size: 14px;  text-align: right; color:white; height:40px;">
					<th  style="text-align: center;background-color:#800F2F;border-color: #800F2F;">&nbsp;</th>
					<th colspan="3" style="text-align: center;background-color:#800F2F;border-color: #800F2F; text-align: center;">Indian&nbsp;Arrival&nbsp;UCF</th>
					<th colspan="3" style="text-align: center;background-color:#013A63;border-color: #013A63; text-align: center;">Indian&nbsp;Departure&nbsp;UCF</th>
				</tr>
				<tr style="font-size: 13px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#A4133C;border-color: #590D22; ">Date</th>
					<th style="text-align: center;background-color:#A4133C;border-color: #590D22;  text-align: right;">Matched&nbsp;</th>
					<th style="text-align: center;background-color:#A4133C;border-color: #590D22;  text-align: right;">Not&nbsp;Matched&nbsp;</th>
					<th style="text-align: center;background-color:#A4133C;border-color: #590D22;  text-align: right;">Total&nbsp;</th>
					<th style="text-align: center;background-color:#014F86;border-color: #013A63;  text-align: right;">Matched&nbsp;</th>
					<th style="text-align: center;background-color:#014F86;border-color: #013A63;  text-align: right;">Not&nbsp;Matched&nbsp;</th>
					<th style="text-align: center;background-color:#014F86;border-color: #013A63;  text-align: right;">Total&nbsp;</th>
				</tr>
		<% 
			String[] weekListUcfWeekly = strweekDaysUcf.toString().replace("\"", "").split(",");
			String[] UcfExistsIndWeekly = strweekUcfExistsInd.split(",");
			String[] UcfNotExistsIndWeekly = strweekUcfNotExistsInd.split(",");

			String[] weekListUcfWeekly_Dep = strweekDaysUcf_Dep.toString().replace("\"", "").split(",");
			String[] UcfExistsIndWeekly_Dep = strweekUcfExistsInd_Dep.split(",");
			String[] UcfNotExistsIndWeekly_Dep = strweekUcfNotExistsInd_Dep.split(",");
			
			//String v_date_Format  = "";
			for (int i = 0; i < weekListUcfWeekly.length; i++) {
							
			%>
			<tr style="font-size: 13px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#C9184A;border-color: #590D22;  font-weight: bold;text-align: center;color:#fff"><%=weekListUcfWeekly[i].replace("-","&#8209;")%></td>
				<td style="background-color:#FF8FA3;border-color: #590D22;  font-weight: normal; text-align: right;color:black;"><%=UcfExistsIndWeekly[i].equals("0") ? "&nbsp;" : UcfExistsIndWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#FFB3C1;border-color: #590D22;  font-weight: normal; text-align: right;color:black;"><%=UcfNotExistsIndWeekly[i].equals("0") ? "&nbsp;" : UcfNotExistsIndWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#FFCCD5;border-color: #590D22;  font-weight: bold; text-align: right;color:#A4133C;font-size: 14px;color:#C9184A;"><%=(Integer.parseInt(UcfExistsIndWeekly[i]) + Integer.parseInt(UcfNotExistsIndWeekly[i]))  == 0 ? "&nbsp;" : (Integer.parseInt(UcfExistsIndWeekly[i]) + Integer.parseInt(UcfNotExistsIndWeekly[i]))%>&nbsp;&nbsp;</td>

				<td style="background-color:#61A5C2;border-color: #013A63;  font-weight: normal; text-align: right;color:black;"><%=UcfExistsIndWeekly_Dep[i].equals("0") ? "&nbsp;" : UcfExistsIndWeekly_Dep[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#89C2D9;border-color: #013A63;  font-weight: normal; text-align: right;color:black;"><%=UcfNotExistsIndWeekly_Dep[i].equals("0") ? "&nbsp;" : UcfNotExistsIndWeekly_Dep[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#A9D6E5;border-color: #013A63;  font-weight: bold; text-align: right;color:#014F86;font-size: 14px;"><%=(Integer.parseInt(UcfExistsIndWeekly_Dep[i]) + Integer.parseInt(UcfNotExistsIndWeekly_Dep[i]))  == 0 ? "&nbsp;" : (Integer.parseInt(UcfExistsIndWeekly_Dep[i]) + Integer.parseInt(UcfNotExistsIndWeekly_Dep[i]))%>&nbsp;&nbsp;</td>

				
				</tr>
<%
			}
			%>
		</table>
		</div>
			

	<%///////////////////////	Table - Types of Indian UCF in last 7 days - End	////////////////////////%>
	

		<div class="col-sm-4">
		<div class="card"style="border: solid 3px #A4133C; border-radius: 20px;">
		<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Indian UCF Matched/Not Matched Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyUcf" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #f6b3c5 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysUcf%>],
			datasets: [{ 
				  label: "UCF Exists ",
			      backgroundColor: "#800F2F",
			      borderColor: "#800F2F",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfExistsInd%>]
			},{ 
				  label: "UCF Not Exists ",
			      backgroundColor: "#FF8FA3",
			      borderColor: "#800F2F",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfNotExistsInd%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 14,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasWeeklyUcf').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>

	<div class="col-sm-4">
		<div class="card"style="border: solid 3px #014F86; border-radius: 20px;">
		<div class="card-body">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Departure : Indian UCF Matched/Not Matched Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyUcfDep" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #bae6ff 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysUcf_Dep%>],
			datasets: [{ 
				  label: "UCF Exists ",
			      backgroundColor: "#013A63",
			      borderColor: "#013A63",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfExistsInd_Dep%>]
			},{ 
				  label: "UCF Not Exists ",
			      backgroundColor: "#bae6ff",
			      borderColor: "#013A63",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfNotExistsInd_Dep%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 14,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasWeeklyUcfDep').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>

<%//////////////////////////////////////	Types of Indain UCF in last 7 days - End	/////////////////////////////////%>




		</section>

<!--*******************************************-->
















	<!--   ************************START Custom APIS DIV*******************START Custom APIS DIV*****************START Custom APIS DIV****************START UCF DIV********  -->
		<section id="ucf_Foreigner"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ucf_Foreigner">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Foreigner UCF Matched/Not Matched Statistics in last 7 days</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

		<%//////////////////////////////////////////////	Types of Foreigner UCF in last 7 days - Start	////////////////////////////////////////////////////
	String WeeklyUcfQuery_F_Arr = "";
	String weeklyUcfXAxis_F_Arr = "";
	int weekelyUcfExistsIndCount_F_Arr = 0;
	int weekelyUcfNotExistsIndCount_F_Arr = 0;
	
	StringBuilder weekDaysUcf_F_Arr = new StringBuilder();
	StringBuilder weekUcfExistsInd_F_Arr = new StringBuilder();
	StringBuilder weekUcfNotExistsInd_F_Arr = new StringBuilder();


	String WeeklyUcfQuery_F_Dep = "";
	String weeklyUcfXAxis_F_Dep = "";
	int weekelyUcfExistsIndCount_F_Dep = 0;
	int weekelyUcfNotExistsIndCount_F_Dep = 0;

	StringBuilder weekDaysUcf_F_Dep = new StringBuilder();
	StringBuilder weekUcfExistsInd_F_Dep = new StringBuilder();
	StringBuilder weekUcfNotExistsInd_F_Dep = new StringBuilder();
	
	  flagFlightCount = false;
	try {
		WeeklyUcfQuery_F_Arr = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_FOREIGNER) as UCF_EXISTS_FOREIGNER,SUM(UCF_NOT_EXISTS_FOREIGNER) as UCF_NOT_EXISTS_FOREIGNER from im_dashboard_combined where ICP_SRNO = '004' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_ARR_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyUcfQuery_F_Arr);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyUcfXAxis_F_Arr = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyUcfXAxis);
			weekelyUcfExistsIndCount_F_Arr = rsTemp.getInt("UCF_EXISTS_FOREIGNER");
			weekelyUcfNotExistsIndCount_F_Arr = rsTemp.getInt("UCF_NOT_EXISTS_FOREIGNER");
			
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysUcf_F_Arr.append(",");
				weekUcfExistsInd_F_Arr.append(",");
				weekUcfNotExistsInd_F_Arr.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysUcf_F_Arr.append("\"");
			weekDaysUcf_F_Arr.append(weeklyUcfXAxis_F_Arr);
			weekDaysUcf_F_Arr.append("\"");
			
			weekUcfExistsInd_F_Arr.append(weekelyUcfExistsIndCount_F_Arr);
			weekUcfNotExistsInd_F_Arr.append(weekelyUcfNotExistsIndCount_F_Arr);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Ucf Foreign Exception");
	}

///////////////////////////////////////////////////////////////////////////////////
flagFlightCount = false;
try {
		WeeklyUcfQuery_F_Dep = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO, table_type, SUM(UCF_EXISTS_FOREIGNER) as UCF_EXISTS_FOREIGNER,SUM(UCF_NOT_EXISTS_FOREIGNER) as UCF_NOT_EXISTS_FOREIGNER from im_dashboard_combined where ICP_SRNO = '"+ filter_icp +"' and  pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate)  and table_type='IM_TRANS_DEP_TOTAL' group by pax_boarding_date,table_type,icp_description,ICP_SRNO  order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyUcfQuery_F_Dep);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyUcfXAxis_F_Dep = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyUcfXAxis);
			weekelyUcfExistsIndCount_F_Dep = rsTemp.getInt("UCF_EXISTS_FOREIGNER");
			weekelyUcfNotExistsIndCount_F_Dep = rsTemp.getInt("UCF_NOT_EXISTS_FOREIGNER");
			
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysUcf_F_Dep.append(",");
				weekUcfExistsInd_F_Dep.append(",");
				weekUcfNotExistsInd_F_Dep.append(",");
				} 
			else
			flagFlightCount = true;

			weekDaysUcf_F_Dep.append("\"");
			weekDaysUcf_F_Dep.append(weeklyUcfXAxis_F_Dep);
			weekDaysUcf_F_Dep.append("\"");
			
			weekUcfExistsInd_F_Dep.append(weekelyUcfExistsIndCount_F_Dep);
			weekUcfNotExistsInd_F_Dep.append(weekelyUcfNotExistsIndCount_F_Dep);

		}
		rsTemp.close();
		psTemp.close();

	} catch (Exception e) {
		out.println("Weekly Ucf Indian Exception");
	}
///////////////////////////////////////////////////////////////////////////////////


	String strweekDaysUcf_F_Arr = weekDaysUcf_F_Arr.toString();
	String strweekUcfExistsInd_F_Arr = weekUcfExistsInd_F_Arr.toString();
	String strweekUcfNotExistsInd_F_Arr = weekUcfNotExistsInd_F_Arr.toString();


	String strweekDaysUcf_F_Dep = weekDaysUcf_F_Dep.toString();
	String strweekUcfExistsInd_F_Dep = weekUcfExistsInd_F_Dep.toString();
	String strweekUcfNotExistsInd_F_Dep = weekUcfNotExistsInd_F_Dep.toString();
	
	//out.println(strweekOCI);
	
	%>
<%////////////////	Table - Types of Foreigner UCF in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-4">
		
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 days</caption>-->
			

				<tr style="font-size: 14px;  text-align: right; color:white; border-color: #004144;height:40px;">
					<th  style="text-align: center;background-color:#004144;border-color: #004144;">&nbsp;</th>
					<th colspan="3" style="text-align: center;background-color:#004144;border-color: #004144; text-align: center;">Foreigner&nbsp;Arrival&nbsp;UCF</th>
					<th colspan="3" style="text-align: center;background-color:#491D8B;border-color: #491D8B; text-align: center;">Foreigner&nbsp;Departure&nbsp;UCF</th>
				</tr>
				<tr style="font-size: 13px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#005d5d;border-color: #004144; ">Date</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #004144;  text-align: right;">Matched&nbsp;</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #004144;  text-align: right;">Not&nbsp;Matched&nbsp;</th>
					<th style="text-align: center;background-color:#005d5d;border-color: #004144;  text-align: right;">Total&nbsp;</th>
					<th style="text-align: center;background-color:#6929C4;border-color: #491D8B;  text-align: right;">Matched&nbsp;</th>
					<th style="text-align: center;background-color:#6929C4;border-color: #491D8B;  text-align: right;">Not&nbsp;Matched&nbsp;</th>
					<th style="text-align: center;background-color:#6929C4;border-color: #491D8B;  text-align: right;">Total&nbsp;</th>
				</tr>
		<% 
			String[] weekListUcfWeekly_F_Arr = strweekDaysUcf_F_Arr.toString().replace("\"", "").split(",");
			String[] UcfExistsIndWeekly_F_Arr = strweekUcfExistsInd_F_Arr.split(",");
			String[] UcfNotExistsIndWeekly_F_Arr = strweekUcfNotExistsInd_F_Arr.split(",");

			String[] weekListUcfWeekly_F_Dep = strweekDaysUcf_F_Dep.toString().replace("\"", "").split(",");
			String[] UcfExistsIndWeekly_F_Dep = strweekUcfExistsInd_F_Dep.split(",");
			String[] UcfNotExistsIndWeekly_F_Dep = strweekUcfNotExistsInd_F_Dep.split(",");
			
			//String v_date_Format  = "";
			for (int i = 0; i < weekListUcfWeekly.length; i++) {
							
			%>
			<tr style="font-size: 13px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#007d79;border-color: #004144;  font-weight: bold;text-align: center;color:white"><%=weekListUcfWeekly_F_Arr[i].replace("-","&#8209;")%></td>
				<td style="background-color:#08bdba;border-color: #004144;  font-weight: normal; text-align: right;color:black;"><%=UcfExistsIndWeekly_F_Arr[i].equals("0") ? "&nbsp;" : UcfExistsIndWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#3ddbd9;border-color: #004144;  font-weight: normal; text-align: right;color:black;"><%=UcfNotExistsIndWeekly_F_Arr[i].equals("0") ? "&nbsp;" : UcfNotExistsIndWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#9ef0f0;border-color: #004144;  font-weight: bold; text-align: right;color:#004144;font-size:14px;"><%=(Integer.parseInt(UcfExistsIndWeekly_F_Arr[i]) + Integer.parseInt(UcfNotExistsIndWeekly_F_Arr[i]))  == 0 ? "&nbsp;" : (Integer.parseInt(UcfExistsIndWeekly_F_Arr[i]) + Integer.parseInt(UcfNotExistsIndWeekly_F_Arr[i]))%>&nbsp;&nbsp;</td>


				<td style="background-color:#BE95FF;border-color: #491D8B;  font-weight: normal; text-align: right;color:black;"><%=UcfExistsIndWeekly_F_Dep[i].equals("0") ? "&nbsp;" : UcfExistsIndWeekly_F_Dep[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#d4bbff;border-color: #491D8B;  font-weight: normal; text-align: right;color:black;"><%=UcfNotExistsIndWeekly_F_Dep[i].equals("0") ? "&nbsp;" : UcfNotExistsIndWeekly_F_Dep[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #491D8B;  font-weight: bold; text-align: right;color:#6929C4;font-size:14px;"><%=(Integer.parseInt(UcfExistsIndWeekly_F_Dep[i]) + Integer.parseInt(UcfNotExistsIndWeekly_F_Dep[i]))  == 0 ? "&nbsp;" : (Integer.parseInt(UcfExistsIndWeekly_F_Dep[i]) + Integer.parseInt(UcfNotExistsIndWeekly_F_Dep[i]))%>&nbsp;&nbsp;</td>

				
				</tr>
<%
			}
			%>
		</table>	
		</div>
		
	<%///////////////////////	Table - Types of Foreigner UCF in last 7 days - End	////////////////////////%>
	




		<div class="col-sm-4">
		<div class="card"style="border: solid 3px #005d5d; border-radius: 20px;">
		<div class="card-body">
	<h1 style="font-size: 14px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Foreigner UCF Matched/Not Matched Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyUcfForeignerArr" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #9ef0f0 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysUcf_F_Arr%>],
			datasets: [{ 
				  label: "UCF Exists ",
			      backgroundColor: "#005d5d",
			      borderColor: "#005d5d",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfExistsInd_F_Arr%>]
			},{ 
				  label: "UCF Not Exists ",
			      backgroundColor: "#9ef0f0",
			      borderColor: "#005d5d",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfNotExistsInd_F_Arr%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 14,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasWeeklyUcfForeignerArr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>

	<div class="col-sm-4">
		<div class="card"style="border: solid 3px #6929C4; border-radius: 20px;">
		<div class="card-body">
	<h1 style="font-size: 14px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Departure : Foreigner UCF Matched/Not Matched Statistics in last 7 days</h1>

		<canvas id="canvasWeeklyUcfForeignerDep" class="chart" style="background: linear-gradient(to bottom, #ffffff 35%, #d4bbff 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strweekDaysUcf_F_Dep%>],
			datasets: [{ 
				  label: "UCF Exists ",
			      backgroundColor: "#491D8B",
			      borderColor: "#491D8B",
			      borderWidth: 0,
			     
			      data: [<%=strweekUcfExistsInd_F_Dep%>]
			},{ 
				  label: "UCF Not Exists ",
			      backgroundColor: "#e8daff",
			      borderColor: "#491D8B",
			      borderWidth: 1,
			     
			      data: [<%=strweekUcfNotExistsInd_F_Dep%>]
			}]};
		 	

		// Options to display value on top of bars

		var myoptions = {
				 title: {
				        fontSize: 14,		
				      },
					 scales: {
					        yAxes: [{
					            ticks: {
					                display: false //removes y axis values in  bar graph 
					            }
					        }]
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
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y - 1);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasWeeklyUcfForeignerDep').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>
		</section>

<%//////////////////////////////////////	Types of Foreigner UCF in last 7 days - End	/////////////////////////////////%>








<!--   ************************Arrival : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->

		<section id="ICS_Arr_PAX"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Arr_PAX">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : Hourly Flight Clearance and Expected Flights</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

		<%

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

	////////////////////////////////////////////////////////////// Start : Combined APIS and ARRIVAL Statistics ////////////////////////////////////////////////////////////////////////

	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'A' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis_pax@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'A' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1 ,3 ,passenger_count desc ";

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

							<table  class="outer_table" width="100%"> 
							
								
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

					//////////////////////////////////////////// Start : Curent Hour Sum Calculation //////////////////////////////////////////

					int current_hour_pax_sum = 0;

					for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
					{
						current_hour_pax_sum = current_hour_pax_sum + Integer.parseInt((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);

						//out.println((borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]);
					}

					//////////////////////////////////////////// End : Curent Hour Sum Calculation //////////////////////////////////////////
					
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

					%>
										
								
											<td style="vertical-align:bottom">
												<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" border=0;  width="100%" cellpadding="0" cellspacing="0" >
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
																	<tr  >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style="font-weight: bold; text-align: right;" ><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
															else
															{
																if(serial_no%2==0)
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%></td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
														}
													%>
													<tr>
														<th style="font-weight: bold;text-align: center; font-size:15px" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%></th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

								
					</table><BR><BR> <%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and ARRIVAL Statistics ////////////////////////////////////////////////////////////////////////
	%></section>







<!--   ************************Departure : Flight-Wise Pax Data (Last 10 hours and Upcoming 10 Hours)********************  -->
		<section id="ICS_Dep_PAX"><br><br><br><br><br><br><br>
		<div class="pt-4" id="ICS_Dep_PAX">    
		<table id = "auto-index5" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Departure : Hourly Flight Clearance and Expected Flights</th>
				</tr>
				<!--<tr id='head' name='custom-apis'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>
		</table>

	
	<%////////////////////////////////////////////////////////////// Start : Combined APIS and DEPARTURE Statistics ////////////////////////////////////////////////////////////////////////

	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_dep_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis_pax_dep@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		//out.println(strSqlFlightDetails);

		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1 ,3 ,passenger_count desc ";

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


<!--   ************************END TSC DIV************************END  TSC DIV****************END  TSC DIV********  -->
		<!--   ************************START BIOMETRIC DIV*******************START BIOMETRIC DIV*****************START BIOMETRIC DIV****************START BIOMETRIC DIV********  -->
		<section id="biometric_2">
		<div class="pt-4" id="biometric_2">
		<table id = "auto-index9" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: red; color: white; font-size: 22px;text-align: center;"></th>
				</tr>
				<!--<tr id='head' name='biometric'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th>Description</th>
				</tr>-->
			</thead>	
		</table>
	</section>






<script>
/////////////////// Total Arrival Footfall /////////////////////
let counts_arr_total_pax = setInterval(updated_arr_total_pax);
        let upto_arr_total_pax = <%=(total_Arrival_Count)-2000%>;
        function updated_arr_total_pax() {
            upto_arr_total_pax = ++upto_arr_total_pax;
            document.getElementById('countArr').innerHTML = upto_arr_total_pax.toLocaleString('en-IN');
            if (upto_arr_total_pax === <%=total_Arrival_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }

let counts_yest_arr_pax = setInterval(updated_yest_arr_pax);
        let upto_yest_arr_pax = <%=(yesterday_Arrival_Count)-2000%>;
        function updated_yest_arr_pax() {
            upto_yest_arr_pax = ++upto_yest_arr_pax;
            document.getElementById('countArrY').innerHTML = upto_yest_arr_pax.toLocaleString('en-IN');
            if (upto_yest_arr_pax === <%=yesterday_Arrival_Count%>) {
                clearInterval(counts_yest_arr_pax);
            }
        }

let counts_today_arr_pax = setInterval(updated_today_arr_pax);
        let upto_today_arr_pax = <%=(today_Arrival_Count)-2000%>;
        function updated_today_arr_pax() {
            upto_today_arr_pax = ++upto_today_arr_pax;
            document.getElementById('countArrT').innerHTML = upto_today_arr_pax.toLocaleString('en-IN');
            if (upto_today_arr_pax === <%=today_Arrival_Count%>) {
                clearInterval(counts_today_arr_pax);
            }
        }
/////////////////////////////////Total Departure Footfall ///////////////////////////////////////


let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Dep_Count)-2000%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Dep_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Dep_Count%>) {
                clearInterval(counts_dep_pax);
            }
        }

let counts_yest_dep_pax = setInterval(updated_yest_dep_pax);
        let upto_yest_dep_pax = <%=(yest_Dep_Count)-2000%>;
        function updated_yest_dep_pax() {
            upto_yest_dep_pax = ++upto_yest_dep_pax;
            document.getElementById('count_total_Dep_CountY').innerHTML = upto_yest_dep_pax.toLocaleString('en-IN');
            if (upto_yest_dep_pax === <%=yest_Dep_Count%>) {
                clearInterval(counts_yest_dep_pax);
            }
        }

let counts_today_dep_pax = setInterval(updated_today_dep_pax);
        let upto_today_dep_pax = <%=(today_Dep_Count)-2000%>;
        function updated_today_dep_pax() {
            upto_today_dep_pax = ++upto_today_dep_pax;
            document.getElementById('count_total_Dep_CountT').innerHTML = upto_today_dep_pax.toLocaleString('en-IN');
            if (upto_today_dep_pax === <%=today_Dep_Count%>) {
                clearInterval(counts_today_dep_pax);
            }
        }
///////////////////////////// Total Footfall ///////////////////////////////////

let counts_total_pax = setInterval(updated_total_pax);
        let upto_total_pax = <%=(total_PAX_Count)-2000%>;
        function updated_total_pax() {
            upto_total_pax = ++upto_total_pax;
            document.getElementById('total_PAX').innerHTML = upto_total_pax.toLocaleString('en-IN');
            if (upto_total_pax === <%=total_PAX_Count%>) {
                clearInterval(counts_total_pax);
            }
        }

let counts_yest_total_pax = setInterval(updated_yest_total_pax);
        let upto_yest_total_pax = <%=(total_Yest_Count)-2000%>;
        function updated_yest_total_pax() {
            upto_yest_total_pax = ++upto_yest_total_pax;
            document.getElementById('total_PAX_Y').innerHTML = upto_yest_total_pax.toLocaleString('en-IN');
            if (upto_yest_total_pax === <%=total_Yest_Count%>) {
                clearInterval(counts_yest_total_pax);
            }
        }

let counts_today_total_pax = setInterval(updated_today_total_pax);
        let upto_today_total_pax = <%=(total_Today_PAX_Count)-2000%>;
        function updated_today_total_pax() {
            upto_today_total_pax = ++upto_today_total_pax;
            document.getElementById('total_PAX_T').innerHTML = upto_today_total_pax.toLocaleString('en-IN');
            if (upto_today_total_pax === <%=total_Today_PAX_Count%>) {
                clearInterval(counts_today_total_pax);
            }
        }
///////////////////////////// Total Arrival Flights //////////////////////////////////////

let counts_arr_flights = setInterval(updated_arr_flights);
        let upto_arr_flights = <%=(total_Arrival_Flights)-2000%>;
        function updated_arr_flights() {
            upto_arr_flights = ++upto_arr_flights;
            document.getElementById('countArrFlt').innerHTML = upto_arr_flights.toLocaleString('en-IN');
            if (upto_arr_flights === <%=total_Arrival_Flights%>) {
                clearInterval(counts_arr_flights);
            }
        }

let counts_yest_flights = setInterval(updated_yest_flights);
        let upto_yest_flights = 10;
        function updated_yest_flights() {
            upto_yest_flights = ++upto_yest_flights;
            document.getElementById('countArrFltY').innerHTML = upto_yest_flights.toLocaleString('en-IN');
            if (upto_yest_flights === <%=yest_Flight_Count%>) {
                clearInterval(counts_yest_flights);
            }
        }

let counts_today_flights = setInterval(updated_today_flights);
        let upto_today_flights = 10;
        function updated_today_flights() {
            upto_today_flights = ++upto_today_flights;
            document.getElementById('countArrFltT').innerHTML = upto_today_flights.toLocaleString('en-IN');
            if (upto_today_flights === <%=arr_Flight_Count%>) {
                clearInterval(counts_today_flights);
            }
        }
//////////////////////////////////////// Total Departure Flights ////////////////////////////////////////


let counts_dep_flights = setInterval(updated_dep_flights);
        let upto_dep_flights = <%=(total_Dep_Flights)-2000%>;
        function updated_dep_flights() {
            upto_dep_flights = ++upto_dep_flights;
            document.getElementById('count_total_Dep_Flights').innerHTML = upto_dep_flights.toLocaleString('en-IN');
            if (upto_dep_flights === <%=total_Dep_Flights%>) {
                clearInterval(counts_dep_flights);
            }
        }
let counts_yest_dep_flights = setInterval(updated_yest_dep_flights);	
        let upto_yest_dep_flights = 10;
        function updated_yest_dep_flights() {
            upto_yest_dep_flights = ++upto_yest_dep_flights;
            document.getElementById('count_total_Dep_FlightsY').innerHTML = upto_yest_dep_flights.toLocaleString('en-IN');
            if (upto_yest_dep_flights === <%=yest_Dep_Flights%>) {
                clearInterval(counts_yest_dep_flights);
            }
        }

let counts_today_dep_flights = setInterval(updated_today_dep_flights);
        let upto_today_dep_flights = 10;
        function updated_today_dep_flights() {
            upto_today_dep_flights = ++upto_today_dep_flights;
            document.getElementById('count_total_Dep_FlightsT').innerHTML = upto_today_dep_flights.toLocaleString('en-IN');
            if (upto_today_dep_flights === <%=today_Dep_Flights%>) {
                clearInterval(counts_today_dep_flights);
            }
        }
/////////////////////////////////////// Total Flights //////////////////////////////////////////////////////////////////

let counts_total_flights = setInterval(updated_total_flights);
        let upto_total_flights = <%=(total_Flights_Count)-2000%>;
        function updated_total_flights() {
            upto_total_flights = ++upto_total_flights;
            document.getElementById('total_Flights').innerHTML = upto_total_flights.toLocaleString('en-IN');
            if (upto_total_flights === <%=total_Flights_Count%>) {
                clearInterval(counts_total_flights);
            }
        }

let counts_yest_total_flights = setInterval(updated_yest_total_flights);
        let upto_yest_total_flights = 10;
        function updated_yest_total_flights() {
            upto_yest_total_flights = ++upto_yest_total_flights;
            document.getElementById('total_Flights_Y').innerHTML = upto_yest_total_flights.toLocaleString('en-IN');
            if (upto_yest_total_flights === <%=total_Flights_Count_Yest%>) {
                clearInterval(counts_yest_total_flights);
            }
        }

let counts_today_total_flights = setInterval(updated_today_total_flights);
        let upto_today_total_flights = 10;
        function updated_today_total_flights() {
            upto_today_total_flights = ++upto_today_total_flights;
            document.getElementById('total_Flights_T').innerHTML = upto_today_total_flights.toLocaleString('en-IN');
            if (upto_today_total_flights === <%=total_Flights_Count_Today%>) {
                clearInterval(counts_today_total_flights);
            }
        }
//////////////////////////////////////////////////////////////////////////////////////////////

const counterAnim = (qSelector, start = 0, end, duration = 1000) => {
 const target = document.querySelector(qSelector);
 let startTimestamp = null;
 const step = (timestamp) => {
  if (!startTimestamp) startTimestamp = timestamp;
  const progress = Math.min((timestamp - startTimestamp) / duration, 1);
  target.innerText = Math.floor(progress * (end - start) + start);
  if (progress < 1) {
   window.requestAnimationFrame(step);
  }
 };
 window.requestAnimationFrame(step);
};

document.addEventListener("DOMContentLoaded", () => {		
 counterAnim("#count1", 10, 3500, 200);
 counterAnim("#count2", 1000, 54646, 2200);
 counterAnim("#count3", 5000, 9898, 2200);
 counterAnim("#count4", 500, 342329, 2200);
 counterAnim("#count5", 10, 5454, 2200);
 counterAnim("#count6", 50, 224, 2200);

counterAnim("#countArr", 50, <%=total_Arrival_Count%>, 2200);
counterAnim("#countArrY", 50, <%=yesterday_Arrival_Count%>, 2200);
counterAnim("#countArrT", 50, <%=today_Arrival_Count%>, 2200);

counterAnim("#count_total_Dep_Count", 50, <%=total_Dep_Count%>, 2200);
counterAnim("#count_total_Dep_CountY", 50, <%=yest_Dep_Count%>, 2200);
counterAnim("#count_total_Dep_CountT", 50, <%=today_Dep_Count%>, 2200);

counterAnim("#total_PAX", 50, <%=total_PAX_Count%>, 2200);
counterAnim("#total_PAX_Y", 50, <%=total_Yest_Count%>, 2200);
counterAnim("#total_PAX_T", 50, <%=total_Today_PAX_Count%>, 2200);




counterAnim("#countArrFlt", 50, <%=total_Arrival_Flights%>, 2200);
counterAnim("#countArrFltY", 50, <%=yest_Flight_Count%>, 2200);
counterAnim("#countArrFltT", 50, <%=arr_Flight_Count%>, 2200);

counterAnim("#count_total_Dep_Flights", 50, <%=total_Dep_Flights%>, 2200);
counterAnim("#count_total_Dep_FlightsY", 50, <%=yest_Dep_Flights%>, 2200);
counterAnim("#count_total_Dep_FlightsT", 50, <%=today_Dep_Flights%>, 2200);

counterAnim("#total_Flights", 50, <%=total_Flights_Count%>, 2200);
counterAnim("#total_Flights_Y", 50, <%=total_Flights_Count_Yest%>, 2200);
counterAnim("#total_Flights_T", 50, <%=total_Flights_Count_Today%>, 2200);



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
