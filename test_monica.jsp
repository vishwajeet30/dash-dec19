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



			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017') order by ICP_DESC");
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
<%//.tableDesign tr:hover {background-color: coral;}%>




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




<script>
		function compare_report()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;

		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				document.entryfrm.submit();
				return true;

		}

</script>

		</head>
		<body onload="apex_search.init();">
		<div class="wrapper">
		<div class="flag-strip"></div>
		<header class="bg-white py-1">
		  <div class="container">
			<div class="row">
			  <div class="col-sm-4">
				<a href="../OCI-html/index.html"><h1><span>IVFRT (I)</span><br/>National Informatic Centre</h1></a>
			  </div>
			  <!--<div class="col-sm-8">
				<table border="0" cellpadding="0" cellspacing="0">
		<input type="text" size="30" maxlength="1000" value="" id="S" onkeyup="apex_search.search(event);" /> &nbsp <input type="button" value=" Search" onclick="apex_search.lsearch();"/> 
		</table>
			  </div>
			  -->
			  <div class="col-sm-4">
			  <h4 style=" color: #0842af; font-weight:bold; margin-top:1rem; font-size : 1.7rem; margin-right: 1rem;">IMMIGRATION DASHBOARD</h4>
			  
			  </div>
			  <div class="col-sm-4 search">
				<input class="form-control me-2" type="text" id="S" onkeyup="apex_search.search(event);" placeholder="Search" />
				<button class="btn btn-primary" type="button" onclick="apex_search.lsearch();"> Search </button>&nbsp;&nbsp;&nbsp;
				<button class="btn btn-primary" type="button" onClick="apex_reload();"> Refresh </button>
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
				  <li> <a class="scrollLink dropdown-item" href="#ICS_4">Hourly Clearance of Arrival/Departure Flights in last <%=displayHours%> hours</a></ul></li>

				  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Biometrics</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#biometric_1">Enrollment/Verification/Exemption Statistics in last 7 days</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#biometric_2">Enrollment/Verification/Exemption Statistics in last <%=displayHours%> hours</a></ul></li>

				  <li class="nav-item dropdown"><a href="#visa_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Visa</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#visa_1">Arrival : Visa Clearance in last 7 days</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="#visa_2">Arrival : Visa Clearance in last <%=displayHours%> hours</a></ul></li>

				  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
				   <ul class="dropdown-menu">
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/" target="_blank">Immigration Control System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>
			   </ul>			   
			  </div>			  
			</div>
			<span class="airport_name"><%=dash%></span>
		  </nav>
		</div>
		</div>
		




		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
		<div class="aboutsection">
		<section id="Home">
		<div class="pt-4" id="home">
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
<form name="entryfrm" method="post">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td align="center">
		   
			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b><select name="compare_icp">
			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>
<%
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017') order by ICP_DESC");
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
			&nbsp;&nbsp;<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>




			<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;Select Hours&nbsp;&nbsp;</b><select name="default_hrs">
			<option value="6" <%if(default_hrs.equals("6")){%> selected<%}%>>6</option>
			<option value="7" <%if(default_hrs.equals("7")){%> selected<%}%>>7</option>
			<option value="8" <%if(default_hrs.equals("8")){%> selected<%}%>>8</option>
			<option value="9" <%if(default_hrs.equals("9")){%> selected<%}%>>9</option>
			<option value="10" <%if(default_hrs.equals("10")){%> selected<%}%>>10</option>
			<option value="11" <%if(default_hrs.equals("11")){%> selected<%}%>>11</option>
			<option value="12" <%if(default_hrs.equals("12")){%> selected<%}%>>12</option>
			</select>&nbsp;&nbsp;
			&nbsp;&nbsp;<input type="button" class="Button" value="Go" onclick=" compare_hrs();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>

			</td>
		</tr>
	</table>
</form>
<br>

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




<!--05/10/2023 12:40-->



<div class="table_wrapper">
<table width="100%" class="main_table">
  <tr>
    <td rowspan="2" class="box_main">
    	<table class="blue_table">
        	<tbody>
            <tr><td colspan="2" class="heading">Arrival</td></tr>
            <tr>
            	<td><h1><%=today_Arrival_Count%></h1></td>
                <td>&nbsp;Today's&nbsp;Footfall</td>
            </tr>
            <tr class="blue_faded">
            	<td><h2><%=yesterday_Arrival_Count%></h2></td>
                <td>&nbsp;Yesterday's&nbsp;Footfall</td>
            </tr>
            <tr class="blue_faded1">
            	<td id="countArr"><h3></h3></td>
                <td>&nbsp;Overall&nbsp;Footfall</td>
            </tr>
        	</tbody>
        </table>
    </td>
    <td height="50%">&nbsp;</td>
	<td width="4%" rowspan="2"></td>
    <td rowspan="2" class="box_main">
    	<table class="purple_table">
        	<tbody>
            <tr><td colspan="2" class="heading">Departure</td></tr>
            <tr>
            	<td><h1><%=today_Dep_Count%></h1></td>
                <td>&nbsp;Today's&nbsp;Footfall</td>
            </tr>
            <tr class="purple_faded">
            	<td><h2><%=yest_Dep_Count%></h2></td>
                <td>&nbsp;Yesterday's&nbsp;Footfall</td>
            </tr>
            <tr class="purple_faded1">
            	<td id="count_total_Dep_Count"><h3></h3></td>
                <td>&nbsp;Overall&nbsp;Footfall</td>
            </tr>
        	</tbody>
        </table>
    </td>
     <td height="50%">&nbsp;</td>
  </tr>
  <tr>
    <td class="box_small">
    	<table class="blue_table">
        	<tbody>
            <tr><td colspan="2" class="heading">Arrival</td></tr>
            <tr>
            	<td><h4><%=arr_Flight_Count%></h4></td>
                <td>&nbsp;Today&nbsp;Flights</td>
            </tr>
            <tr class="blue_faded">
            	<td><h5><%=yest_Flight_Count%></h5></td>
                <td>&nbsp;Yesterday&nbsp;Flights</td>
            </tr>
            <tr class="blue_faded1">
            	<td id="countArrFlt"><h6></h6></td>
                <td>&nbsp;Overall&nbsp;Flights</td>
            </tr>
        	</tbody>
        </table>
    </td>
    <td class="box_small">
    	<table class="purple_table">
        	<tbody>
            <tr><td colspan="2" class="heading">Departure</td></tr>
            <tr>
            	<td><h4><%=today_Dep_Flights%></h4></td>
                <td>&nbsp;Today&nbsp;Flights</td>
            </tr>
            <tr class="purple_faded">
            	<td><h5><%=yest_Dep_Flights%></h5></td>
                <td>&nbsp;Yesterday&nbsp;Flights</td>
            </tr>
            <tr class="purple_faded1">
            	<td id="count_total_Dep_Flights"><h6></h6></td>
                <td>&nbsp;Overall&nbsp;Flights</td>
            </tr>
        	</tbody>
        </table>
    </td>
  </tr>
</table>
</div>









		<!--   ************************END HOME DIV*******************HOME DIV*****************END HOME DIV****************END HOME DIV********  -->
		<!--   ************************START ICS DIV*******************ICS DIV*****************START ICS DIV****************START ICS DIV********  -->
		<section id="ICS_1"><br><br><br><br><br>
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
<div class="container-fluid">
<div class="row">
	<div class="col-sm-2">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
					<th style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:33.33%;">&nbsp;</th>
					<th colspan = "2" style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:66.66%; text-align: center;">Total Footfall</th>
				</tr>
			<tr style="font-size: 16px;  text-align: right; color:white; border-color: #6929c4;height:20px; ">
				<th style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:33.33%;text-align: center;">Date</th>
				<th style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:33.33%; text-align: center;">Arrival</th>
				<th style="text-align: center;background-color:#6929c4;border-color: #be95ff;width:33.33%; text-align: center;">Departure</th>
			</tr>
		<% 

			/*String strWeekDays = weekDays.toString();
			String strweekArrPax = weekArrPax.toString();
			String strweekDepPax = weekDepPax.toString();*/
			

			String[] weekListPAX = strWeekDays.toString().replace("\"", "").split(",");
			String[] weeklyArrPAX = strweekArrPax.split(",");
			String[] weeklyDepPAX = strweekDepPax.split(",");
			for (int i = 0; i < weekListPAX.length; i++) {
							
				/*out.println( weekList[i]);
				if (Integer.parseInt( weekList[i].substring(11,13)) >= 0 & Integer.parseInt( weekList[i].substring(11,13)) <= 11)
				v_date_Format = weekList[i].substring(8,10) + "/" + weekList[i].substring(5,7) + "/" + weekList[i].substring(0,4) + " " + weekList[i].substring(11,13) + " AM" ;
						

			if (Integer.parseInt( weekList[i].substring(11,13)) >= 12 & Integer.parseInt( weekList[i].substring(11,13)) <= 23)
				v_date_Format = weekList[i].substring(8,10) + "/" + weekList[i].substring(5,7) + "/" + weekList[i].substring(0,4) + " " + weekList[i].substring(11,13) + " PM" ;*/

	

			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#be95ff;border-color: #6929c4;width:33.33%; font-weight: bold;text-align: center;"><%=weekListPAX[i].equals("0") ? "&nbsp;" : weekListPAX[i]%></td>
				<td style="background-color:#d4bbff;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyArrPAX[i].equals("0") ? "&nbsp;" : weeklyArrPAX[i]%>&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyDepPAX[i].equals("0") ? "&nbsp;" : weeklyDepPAX[i]%>&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

	<div class="col-sm-4">
		<h1
			style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure Immigration Clearance in last 7 days</h1>

		<canvas id="canvasPAX" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #b1d2d8 100%);"></canvas>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDays%>],
			datasets: [{ 
				  label: "Arrival Footfall",
			      backgroundColor: "#00dcb0",
			      borderColor: "MediumSeaGreen",
			      borderWidth: 1,
			      data: [<%=strweekArrPax%>]
			}, { 
				  label: "Departure Footfall",
			      backgroundColor: "#BEADFA",
			      borderColor: "Violet",
			      borderWidth: 1,
			      data: [<%=strweekDepPax%>]
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
					ctx.fillStyle = "black";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 7px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y);
							
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
				<th colspan = "2" style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:66.66%; text-align: center;">Total Flights</th>
			</tr>
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #ed3e12;height:20px;">
				<th style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:33.33%;">Date</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:33.33%; text-align: center;">Arrival</th>
				<th style="text-align: center;background-color:#ed3e12;border-color: #f4896f;width:33.33%; text-align: center;">Departure</th>
			</tr>
		<% 
			String[] weekListFlights = strWeekDaysFlights.toString().replace("\"", "").split(",");
			String[] weeklyArrFlights = strweekArrFlights.split(",");
			String[] weeklyDepFlights = strweekDepFlights.split(",");
			for (int i = 0; i < weekListFlights.length; i++) {
		%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center;height:18px;border-color: #ed3e12">
				<td style="background-color:#f4896f;border-color: #ed3e12;width:33.33%; font-weight: bold;text-align: center;"><%=weekListFlights[i].equals("0") ? "&nbsp;" : weekListFlights[i]%></td>
				<td style="background-color:#f8b8a9;border-color: #ed3e12;width:33.33%;font-weight: bold;  text-align: right;"><%=weeklyArrFlights[i].equals("0") ? "&nbsp;" : weeklyArrFlights[i]%>&nbsp;&nbsp;&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:33.33%; font-weight: bold; text-align: right;"><%=weeklyDepFlights[i].equals("0") ? "&nbsp;" : weeklyDepFlights[i]%>&nbsp;&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Flights in last 7 days - End	////////////////////////%>

	<div class="col-sm-4">
		<h1
			style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure Flights in last 7 days</h1>

		<canvas id="canvasFlights" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #faaca8 100%);"></canvas>

</div>
	<script>

		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysFlights%>],
			datasets: [{ 
				  label: "Arrival Flights Count",
			      backgroundColor: "#F6635C",
			      borderColor: "Tomato",
			      borderWidth: 1,
			      data: [<%=strweekArrFlights%>]
			}, { 
				  label: "Departure Flights Count",
			      backgroundColor: "#ffa600",
			      borderColor: "Orange",
			      borderWidth: 1,
			      data: [<%=strweekDepFlights%>]
			}]
		};

		// Options to display value on top of bars

		var myoption = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes x axis values in  bar graph 
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
				animationDuration: 1
			},
			animation: {
			duration: 1,
			onComplete: function () {
				var chartInstance = this.chart,
					ctx = chartInstance.ctx;
					ctx.textAlign = 'center';
					ctx.fillStyle = "rgba(0, 0, 0, 1)";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 8px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var meta = chartInstance.controller.getDatasetMeta(i);
						meta.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x, bar._model.y);

						});
					});
				}
			}
		};

		//Code to drow Chart

		var ctx = document.getElementById('canvasFlights').getContext('2d');
		var myChart = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoption 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
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
		<section id="ICS_2" ><br><br><br><br><br>
		<div class="pt-4" id="ICS_2">
		<table id = "auto-index2" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</th>
				</tr>
			</thead>
		</table><br>
	<%////////////////////	Arrival : PAX, Flight and Active Counters for last 7 hours - Start	////////////////////////

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
	<div class="col-sm-4">
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

	<div class="col-sm-8">
		<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</h1>

		<canvas id="canvasArrPAXFltActCount" class="chart"
			style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #e5a4ba 100%);
			"></canvas>
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
			      borderColor: "red",
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


	<%////////////////////	Arrival : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////%>


		</section>
		<!--   ************************END pax DIV*******************END pax DIV*****************END pax DIV****************END pax DIV********  -->
		<!--   ************************START Pax-Images DIV************************START Pax-Images DIV****************START Pax-Images DIV********  -->
		
		
		<section id="ICS_3"><br><br><br><br><br>
		<div class="pt-4" id="ICS_3">    
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
		</table><br>

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

	<div class="col-sm-8">
		<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Departure : PAX Clearance, Active Flights and Active Counters in last <%=displayHours%> hours</h1>

		<canvas id="canvasDepPAXFltActCount" class="chart" style="max-width: 100%;      background: linear-gradient(to bottom, #ffffff 35%, #75ebff 100%);"></canvas>
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
		<section id="ICS_4"><br><br><br><br><br>
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
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Arrival Flights</h1>
		<canvas id="myPlot1" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #ffd8d8 100%);"></canvas>
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
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly Clearance of Departure Flights</h1>

		<canvas id="myPlot2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #c4f2fa 100%);"></canvas>
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
		<section id="visa_1"><br><br><br><br><br>
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

		<%//////////////////////////////////////////////	Types of Visa in last 7 days - Start	////////////////////////////////////////////////////
	String WeeklyVisaQuery = "";
	String weeklyVisaXAxis = "";
	int weekelyEVisaCount = 0;
	int weekelyVOACount = 0;
	int weeklyRegularCount = 0;
	int weeklyOCICount = 0;
	

	StringBuilder weekDaysVisa = new StringBuilder();
	StringBuilder weekEVisa = new StringBuilder();
	StringBuilder weekVOA = new StringBuilder();
	StringBuilder weekRegular = new StringBuilder();
	StringBuilder weekOCI = new StringBuilder();

	  flagFlightCount = false;
	try {
		WeeklyVisaQuery = "select icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date >= trunc(sysdate-6) and pax_boarding_date <= trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
		psTemp = con.prepareStatement(WeeklyVisaQuery);
		rsTemp = psTemp.executeQuery();
		while (rsTemp.next()) {

			weeklyVisaXAxis = rsTemp.getString("pax_boarding_date_2");
			//out.println(weeklyVisaXAxis);
			weekelyEVisaCount = rsTemp.getInt("sum_evisa_count");
			weekelyVOACount = rsTemp.getInt("sum_hourly_voa_count");
			weeklyRegularCount = rsTemp.getInt("hourly_regular_visa_count");
			weeklyOCICount = rsTemp.getInt("sum_hourly_oci_count");
			//out.println(weeklyOCICount);

			if (flagFlightCount == true) {
				weekDaysVisa.append(",");
				weekEVisa.append(",");
				weekVOA.append(",");
				weekRegular.append(",");
				weekOCI.append(",");
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
	//out.println(strweekOCI);
	
	%>
<%////////////////	Table - Types of Visa in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-4">
	<table class="tableDesign">
		<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 days</caption>-->
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%;">Date</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">e-Visa&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">OCI&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">Regular&nbsp;&nbsp;</th>
					<th style="text-align: center;background-color:#ed3e12;border-color: #f69e89;width:20%; text-align: right;">VOA&nbsp;&nbsp;</th>
				</tr>
		<% 
			String[] weekListWeekly = strWeekDaysVisa.toString().replace("\"", "").split(",");
			String[] eVisaWeekly = strweekEVisa.split(",");
			String[] OCIWeekly = strweekOCI.split(",");
			String[] RegularWeekly = strweekRegular.split(",");
			String[] VOAWeekly = strweekVOA.split(",");
			//String v_date_Format  = "";
			for (int i = 0; i < weekListWeekly.length; i++) {
							
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#f16d4c;border-color: #ed3e12;width:20%; font-weight: bold;text-align: center;"><%=weekListWeekly[i].equals("0") ? "&nbsp;" : weekListWeekly[i]%></td>
				<td style="background-color:#f4896f;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=eVisaWeekly[i].equals("0") ? "&nbsp;" : eVisaWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f69e89;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=OCIWeekly[i].equals("0") ? "&nbsp;" : OCIWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#f8b7a7;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=RegularWeekly[i].equals("0") ? "&nbsp;" : RegularWeekly[i]%>&nbsp;&nbsp;</td>
				<td style="background-color:#fcddd5;border-color: #ed3e12;width:20%; font-weight: bold; text-align: right;"><%=VOAWeekly[i].equals("0") ? "&nbsp;" : VOAWeekly[i]%>&nbsp;&nbsp;</td>
			</tr>
<%
			}
			%>
		</table>	
		</div>
	<%///////////////////////	Table - Types of Visa in last 7 days - End	////////////////////////%>
	

		<div class="col-sm-8">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Visa Clearance in last 7 days</h1>

		<canvas id="canvasWeeklyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);"></canvas>
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
		<section id="visa_2"><br><br><br><br><br>
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



	<div class="col-sm-8">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Arrival : Visa Clearance in last <%=displayHours%> hours</h1>

		<canvas id="canvasHourlyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #ffa5bf 100%);"></canvas>
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
			      borderColor: "orange",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyEVisa)%>]
			},{ 
				  label: "OCI",
			      backgroundColor: "#ffa600",
			      borderColor: "orange",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyOCI)%>]
			},{ 
				  label: "Regular",
			      backgroundColor: "#900C3F",
			      borderColor: "red",
			      borderWidth: 1,
			     
			      data: [<%=reverseOnComma(strHourlyRegular)%>]
			}, { 
				  label: "VOA",
			      backgroundColor: "#511845",
			      borderColor: "#0E21A0",
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
		<section class="aboutsection" id="biometric_1"><br><br><br><br><br>
		<div class="pt-4" id="biometric_1">    
		<table id = "auto-index8" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
				<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Biometric Enrollment/Verification/Exemption Statistics in last 7 days</th>
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


	<div class="col-sm-8">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Biometric Enrollment/Verification/Exemption in last 7 days</h1>

		<canvas id="canvasWeeklyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);"></canvas>
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
		<section id="biometric_2"><br><br><br><br><br>
		<div class="pt-4" id="biometric_2">
		<table id = "auto-index9" class="table table-sm table-striped">
			<thead>
			<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Biometric Enrollment/Verification/Exemption Statistics in last <%=displayHours%> hours</th>
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

	
	<div class="col-sm-8">
	<h1 style="font-size: 15px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Biometric Enrollment/Verification/Exemption in last <%=displayHours%> hours</h1>

		<canvas id="canvasHourlyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #8ecddd 100%);"></canvas>
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

		






<!--   ************************END TSC DIV************************END  TSC DIV****************END  TSC DIV********  -->
		<!--   ************************START BIOMETRIC DIV*******************START BIOMETRIC DIV*****************START BIOMETRIC DIV****************START BIOMETRIC DIV********  -->
		<section id="biometric_2"><br><br><br><br><br>
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





<!--New-->



















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
