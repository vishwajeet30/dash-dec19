<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>

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

<script>
function compare_report()
{
			
			
		document.entryfrm.target="_self";
		document.entryfrm.action="im_icp_epassport_dashboard.jsp?&icp="+document.entryfrm.compare_icp.value;
		document.entryfrm.submit();
		return true;

}
</script>
<%
     Map<String, String> icpValue = new LinkedHashMap<String,String>(); 

	icpValue.put("022","AMD");	// AMD
	icpValue.put("010","CAL");	// CAL
	icpValue.put("162","HAR");	// HAR
	icpValue.put("006","JAI");	// JAI
	icpValue.put("033","GOA");	// GOA
	icpValue.put("023","TVM");	// TVM
	icpValue.put("007","VAR");	// VAR
	icpValue.put("094","CBE");	// CBE
	icpValue.put("012","GAY");	// GAY
	icpValue.put("019","GUW");	// GUW
	icpValue.put("021","LUC");  // LUC 
	icpValue.put("092","MNG");  // MNG 
	icpValue.put("026","PNE");  // PNE 
	icpValue.put("003","TRY");  // TRY 
	icpValue.put("016","NAG");  // NAG 
	icpValue.put("364","GED");  // GED 
	icpValue.put("032","AMR");  // AMR 
	icpValue.put("002","KOL");  // KOL 
	icpValue.put("309","MUN");  // MUN 
	icpValue.put("305","ATT");  // ATT 
	icpValue.put("105","WAG");// WAG
	icpValue.put("008","CHN");// CHN
	icpValue.put("004","DEL") ;// IGI
	icpValue.put("001","BOM") ;// BOM
	icpValue.put("041","HYD") ;// HYD
	icpValue.put("085","BNG") ;// BNG
	icpValue.put("024","COH") ;// COH
	icpValue.put("077","AND"); // AND
	icpValue.put("095","SRI") ;// SRI
	icpValue.put("025","VTZ") ;// VTZ
	icpValue.put("015","MDU") ;// MDU
	icpValue.put("096","BAG") ;// BAG
	icpValue.put("084","BHU") ;// BHU
	icpValue.put("005","CHA") ;// CHA
	icpValue.put("030","KAN") ;// KAN
	icpValue.put("029","SUR") ;// SUR
	icpValue.put("397","CHIT") ;// CHIT
	icpValue.put("107","KAR") ;// KAR
	icpValue.put("017","IDR") ;// IDR
	icpValue.put("224","COHSEA") ;// COHSEAPORT
	icpValue.put("888","CICS") ;// CICS 
	icpValue.put("002","KOL");  // KOL 
	icpValue.put("034","MOPA");  // MOPA
	icpValue.put("208","CHN SEA");  // CHENNAI SEAPORT
	icpValue.put("201","BOM SEA");  // MUMBAI SEAPORT
	icpValue.put("163","GHOJA");  // GHOJADANGA
	icpValue.put("173","CHANGRABANDHA");  // CHANGRABANDHA
	icpValue.put("240","NHAVA SEA");  // NHAVA SHEVA SEAPORT
	icpValue.put("277","PBLAIR SEA");  // PORT BLAIR SEAPORT


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
int displayHours = 8;
%>

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
			  <div class="col-sm-4"></div>
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

	<%
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
	
	int daily_Dep_Count = 0;
	int total_Arrival_Count = 0;
	int yesterday_Arrival_Count = 0;
	int total_Dep_Count = 0;
	
////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

		 DateFormat formetter = new SimpleDateFormat("dd/MM/yyyy");
		 DateFormat vDateFormatYes = new SimpleDateFormat("dd MMM");
		 java.util.Date current_Server_Time = new java.util.Date();
		 String today_date = vDateFormatYes.format(current_Server_Time);
		
		
		 java.util.Date yesterday_date_in_millis = new java.util.Date(System.currentTimeMillis()-1*24*60*60*1000);
		 String yesterday_date = vDateFormatYes.format(yesterday_date_in_millis);

		 String filter_icp = request.getParameter("icp") == null ? "004" : request.getParameter("icp");
		 //out.println("kuhkihfayfdjhj" + filter_icp);
   	 	 if(filter_icp.equals("")) filter_icp = "" + filter_icp + "";

//=================================================

	%>
<form name="entryfrm" method="post">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td align="center">
		   
			</select><font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b><select name="compare_icp">
			<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>
<%
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017') order by ICP_DESC");
			while(rsTemp.next())
			{
%>
				<option value="<%=rsTemp.getString("ICP_SRNO")%>" <%if(filter_icp.equals(rsTemp.getString("ICP_SRNO"))){%> selected<%}%>><%=rsTemp.getString("ICP_DESC")%></option>
<%
			}
			 rsTemp.close();  
			 int div_hgt = 200; 
			 if(filter_icp.equals("All")) {
				 div_hgt = 600;
			 }
%> 
			</select>&nbsp;&nbsp;
			&nbsp;&nbsp;<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>
			</td>
		</tr>
	</table>
</form>
<br>

<%//================================================


	try {
		dashQuery = "select VISA_ON_ARRIVAL_PAX from IM_DASHBOARD_EVISA_ICP where ICP_SRNO = '" + filter_icp + "'";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		while(rsTemp.next()) {

	     total_Arrival_Count = total_Arrival_Count+rsTemp.getInt("VISA_ON_ARRIVAL_PAX");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}

	/*try {
		dashQuery = "select count(1) as arr_epassport from IM_TRANS_ARR_EPASSPORT where ICP_SRNO = '" + filter_icp + "' and FLIGHT_SCHEDULE_DATE = trunc(sysdate-1)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

		yesterday_Arrival_Count = rsTemp.getInt("arr_epassport");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
	try {
		dashQuery = "select count(1) as arr_epassport from IM_TRANS_ARR_EPASSPORT where ICP_SRNO = '" + filter_icp + "' and FLIGHT_SCHEDULE_DATE = trunc(sysdate)";
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		if (rsTemp.next()) {

	today_Arrival_Count = rsTemp.getInt("arr_epassport");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Exception");
	}
*/
	
%>

<div class="container-fluid">
<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-3">
			<table class="tableDesign">
			
			
			<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;">Arrival&nbsp;e&#8209;Passport</th>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;" id="countArr"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Total&nbsp;e&#8209;Passports</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3" id="countArrY"><%=yesterday_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArrT" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #44a9ff;"><%=today_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Today's&nbsp;e&#8209;Passports</td>
			</tr>

		</table>
</div>


	<%
	/////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////////
int today_Dep_Count = 0;
int yest_Dep_Count = 0;
int total_PAX_Count = 0;
int total_Yest_Count = 0;
int total_Today_PAX_Count = 0;;

try {
	dashQuery = "select DEPARTURE_PAX from IM_DASHBOARD_EPASSPORT_ICP where ICP_SRNO = '" + filter_icp + "'";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		total_Dep_Count = total_Dep_Count+rsTemp.getInt("DEPARTURE_PAX");

		//total_PAX_Count = total_Arrival_Count + total_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select count(1) as dep_Passenger_Count from IM_TRANS_DEP_EPASSPORT where ICP_SRNO = '" + filter_icp + "' and FLIGHT_SCHEDULE_DATE = trunc(sysdate-1)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		yest_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		//total_Yest_Count = yest_Dep_Count + yesterday_Arrival_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}

try {
	dashQuery = "select count(1) as dep_Passenger_Count from IM_TRANS_DEP_EPASSPORT where ICP_SRNO = '" + filter_icp + "' and FLIGHT_SCHEDULE_DATE = trunc(sysdate)";
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	if (rsTemp.next()) {

		today_Dep_Count = rsTemp.getInt("dep_Passenger_Count");

		//total_Today_PAX_Count = today_Arrival_Count + today_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Exception");
}
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-3">
			<table class="tableDesign">
			
			
			<tr style="font-size: 40px;  text-align: right; color:white; border-color: #6929c4;height:20px;">
				<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;">&nbsp;Departure&nbsp;e&#8209;Passport&nbsp;</th>
			</tr>

			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;" id="count_total_Dep_Count"></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;" >&nbsp;Total&nbsp;e&#8209;Passports</td>
			</tr>



			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;" id="count_total_Dep_CountY"><%=yest_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td id="count_total_Dep_CountT" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #a376e2;"><%=today_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Today's&nbsp;e&#8209;Passports</td>

			</tr>

		</table>
</div>

	
</div>
</div>
		</section>
		<!--   ************************END HOME DIV*******************HOME DIV*****************END HOME DIV****************END HOME DIV********  -->
		<!--   ************************START ICS DIV*******************ICS DIV*****************START ICS DIV****************START ICS DIV********  -->
		<section id="ICS_1"><br><br><br>
		<div class="pt-4" id="ICS_1">
		<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>
				<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Arrival
			and Departure e-Passport Processed in last 7 days</th>
				</tr>
				
			</thead>
			
		</table><br>



<%////////////////////////	Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////

String SQLQUERY = "";
StringBuilder WeekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

StringBuilder YearDays = new StringBuilder();
StringBuilder YearArrPax = new StringBuilder();
StringBuilder YearDepPax = new StringBuilder();

StringBuilder TotalDays = new StringBuilder();
StringBuilder TotalArrPax = new StringBuilder();
StringBuilder TotalDepPax = new StringBuilder();

String strWeekDays = "";
String strweekArrPax = "";
String strweekDepPax = "";

String strYearDays = "";
String strYearArrPax = "";
String strYearDepPax = "";

String strTotalDays = "";
String strTotalArrPax = "";
String strTotalDepPax = "";

StringBuilder IcpPax = new StringBuilder();
StringBuilder ArrIcpPax = new StringBuilder();
StringBuilder DepIcpPax = new StringBuilder();
String strIcpPax = "";
String strArricp = "";
String strDepicp = "";

StringBuilder NaltyPax = new StringBuilder();
StringBuilder ArrNaltyPax = new StringBuilder();
StringBuilder DepNaltyPax = new StringBuilder();
String strNaltyPax = "";
String strArrNalty = "";
String strDepNalty = "";

%>

	<%///////////////////////////	  Arrival and Departure e-Passport Processed in last 7 days - Start	///////////////////////////////%>
<div class="container-fluid">
<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-3">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
	
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #6929c4;height:12px;">
				<th style="text-align: center;background-color:#6929c4;width:25%; border-color: #6929c4;">Date</th>
				<th style="text-align: center;background-color:#6929c4;width:25%;border-color: #6929c4; text-align: right;">Arrival&nbsp;</th>
				<th style="text-align: center;background-color:#6929c4;width:25%;border-color: #6929c4;text-align: right;">Departure&nbsp;</th>
				<th style="text-align: center;background-color:#6929c4;width:25%;border-color: #6929c4; text-align: right;">Total&nbsp;</th>
			</tr>
<%
try
	{
	SQLQUERY = "";
	SQLQUERY = "select FLIGHT_SCHEDULE_DATE,count(1) as arr_epassport from IM_TRANS_ARR_EPASSPORT where FLIGHT_SCHEDULE_DATE >= trunc(sysdate-8) and ICP_SRNO = '" + filter_icp + "' GROUP BY FLIGHT_SCHEDULE_DATE order by FLIGHT_SCHEDULE_DATE";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
		SQLQUERY = "";
		SQLQUERY = "select count(1) as dep_epassport from IM_TRANS_DEP_EPASSPORT where FLIGHT_SCHEDULE_DATE = TO_DATE('"+formetter.format(rsTemp.getDate("FLIGHT_SCHEDULE_DATE"))+"', 'DD/MM/YYYY') and ICP_SRNO = '" + filter_icp + "'";
		psMain = con.prepareStatement(SQLQUERY);
		
		rsMain = psMain.executeQuery();
		if (rsMain.next()) {
			WeekDays.append("\"");
			WeekDays.append(vDateFormatYes.format(rsTemp.getDate("FLIGHT_SCHEDULE_DATE")));
			WeekDays.append("\"");
			WeekDays.append(",");
			weekArrPax.append(rsTemp.getInt("arr_epassport")+",");
			weekDepPax.append(rsMain.getInt("dep_epassport")+",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#d7beff;border-color: #6929c4;width:25%; font-weight: bold;text-align: center;"><%=formetter.format(rsTemp.getDate("FLIGHT_SCHEDULE_DATE"))%></td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("arr_epassport") == 0 ? "&nbsp;" : rsTemp.getInt("arr_epassport")%>&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:25%; font-weight: bold; text-align: right;"><%=rsMain.getInt("dep_epassport") == 0 ? "&nbsp;" : rsMain.getInt("dep_epassport")%>&nbsp;</td>
				<td style="background-color:#e8daff;border-color: #6929c4;width:25%; font-weight: bold; text-align: right;color:#6929c4; font-size: 16px;"><%=(rsTemp.getInt("arr_epassport") + rsMain.getInt("dep_epassport")) == 0 ? "&nbsp;" : (rsTemp.getInt("arr_epassport") + rsMain.getInt("dep_epassport"))%>&nbsp;</td>

			</tr>
<%
	}
			rsMain.close();
			psMain.close();
			}
			rsTemp.close();
			psTemp.close();

			strWeekDays = WeekDays.toString();
			strWeekDays = strWeekDays.substring(0,strWeekDays.length()-1);
			strweekArrPax = weekArrPax.toString();
			strweekArrPax = strweekArrPax.substring(0,strweekArrPax.length()-1);
			strweekDepPax = weekDepPax.toString();
			strweekDepPax = strweekDepPax.substring(0,strweekDepPax.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-7">
	<div class="card"style="border: solid 3px #6929c4; border-radius: 20px;">
	<div class="card-body">
		<h1 style="font-size: 20px; color: black;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure e-Passport Processed in last 7 days</h1>

		<canvas id="canvasPAX" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #d5c1f2 100%);border-radius: 20px;""></canvas>
		
	</div>
	</div>
	</div>
	</div>
	</div>
	<script>
	var myData = {
			labels: [<%=strWeekDays%>],
			datasets: [{ 
				  label: "Arrival e-Passports",
			      backgroundColor: "#e8daff",
			      borderColor: "#6929c4",
			      borderWidth: 2,
			      data: [<%=strweekArrPax%>]
			}, { 
				  label: "Departure e-Passports",
			      backgroundColor: "#6929c4",
			      borderColor: "#6929c4",
			      borderWidth: 1,
			      data: [<%=strweekDepPax%>]
			}]
		};	

				  
		// Options to display value on top of bars

		var myoption = {
				 scales: {
				        yAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
					ctx.fillStyle = "#0F292F";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 10px Verdana";

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
			options: myoption 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
	</script>
	<%///////////////////////////	  Arrival and Departure e-Passport Processed in last 7 days - End	///////////////////////////////%>


	<%///////////////////////////	  Year-wise Arrival and Departure e-Passport Statistics - Start	///////////////////////////////%>

<br><br><br>
<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>
				<tr id='head1'>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">Year-wise Arrival and Departure e-Passport Statistics</th>
				</tr>
			</thead>
			
		</table><br>


<div class="container-fluid">
	<div class="row">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-3">
		<table class="tableDesign">
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->

			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #B93160;height:12px;">
				<th style="text-align: center;background-color:#B93160;border-color: #B93160;width:25%;">Year</th>
				<th style="text-align: center;background-color:#B93160;border-color: #B93160;width:25%; text-align: right;">Arrival&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #B93160;width:25%; text-align: right;">Departure&nbsp;</th>
				<th style="text-align: center;background-color:#B93160;border-color: #B93160;width:25%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
try
	{
	SQLQUERY = "";
	SQLQUERY = "select year as arr_year,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_ICP where ICP_SRNO = '" + filter_icp + "' group by year order by 1";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
		
			YearDays.append("\"");
			YearDays.append(rsTemp.getString("arr_year"));
			YearDays.append("\"");
			YearDays.append(",");
			YearArrPax.append(rsTemp.getInt("arr_count")+",");
			YearDepPax.append(rsTemp.getInt("dep_count")+",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#edbdce;border-color:#B93160;width:25%; font-weight: bold;text-align: center;"><%=rsTemp.getString("arr_year")%></td>
				<td style="background-color:#f4d7e1;border-color:#B93160;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("arr_count") == 0 ? "&nbsp;" : rsTemp.getInt("arr_count")%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#B93160;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("dep_count") == 0 ? "&nbsp;" : rsTemp.getInt("dep_count")%>&nbsp;</td>
				<td style="background-color:#f4d7e1;border-color:#B93160;width:25%; font-weight: bold; text-align: right;color:#B93160;font-size:16px;"><%=(rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count")) == 0 ? "&nbsp;" : (rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count"))%>&nbsp;</td>

			</tr>
<%  
	
			}
			rsTemp.close();
			psTemp.close();

			strYearDays = YearDays.toString();
			strYearDays = strYearDays.substring(0,strYearDays.length()-1);
			strYearArrPax = YearArrPax.toString();
			strYearArrPax = strYearArrPax.substring(0,strYearArrPax.length()-1);
			strYearDepPax = YearDepPax.toString();
			strYearDepPax = strYearDepPax.substring(0,strYearDepPax.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-7">
	<div class="card"style="border: solid 3px #B93160; border-radius: 20px;">
	<div class="card-body">
		<h1 style="font-size: 20px; color: black;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Year-wise Arrival and Departure e-Passport Statistics</h1>

		<canvas id="canvasPAX_year" class="chart" style="max-width: 100%;border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	</div>
	</div>
	</section>
<br><br>
	<script>
		// Data define for bar chart
		var myData_year = {
			labels: [<%=strYearDays%>],
			datasets: [{ 
				  label: "Arrival e-Passports",
			      backgroundColor: "#B93160",
			      borderColor: "#B93160",
			      borderWidth: 1,
			      data: [<%=strYearArrPax%>]
			}, { 
				  label: "Departure e-Passports",
			      backgroundColor: "#f4d7e1",
			      borderColor: "#B93160",
			      borderWidth: 2,
			      data: [<%=strYearDepPax%>]
			}]
		};      
		
		// Options to display value on top of bars

		var myoptions = {
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
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
					ctx.fillStyle = "#0F292F";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 10px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x+28, bar._model.y+5);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart
		
		var ctx = document.getElementById('canvasPAX_year').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData_year,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

</script>

	<%///////////////////////////	  Year-wise Arrival and Departure e-Passport Statistics - End	///////////////////////////////%>



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


/////////////////////////////////Total Departure Footfalls ///////////////////////////////////////


let counts_dep_pax = setInterval(updated_dep_pax);
        let upto_dep_pax = <%=(total_Dep_Count)-2000%>;
        function updated_dep_pax() {
            upto_dep_pax = ++upto_dep_pax;
            document.getElementById('count_total_Dep_Count').innerHTML = upto_dep_pax.toLocaleString('en-IN');
            if (upto_dep_pax === <%=total_Dep_Count%>) {
                clearInterval(counts_dep_pax);
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


</script>

<%
} catch (Exception e) {
e.printStackTrace();
} finally {
if (con != null)
	con.close();

}

%>

		</body>
		</html>
