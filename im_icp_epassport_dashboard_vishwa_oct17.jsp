<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
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

String dash = "";

////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

		 DateFormat formetter = new SimpleDateFormat("dd/MM/yyyy");
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

		 String vishwaFilter = " where ICP_SRNO = '" + filter_icp + "'";
   	 	 if(filter_icp.equals("All")) vishwaFilter = "";
		 else vishwaFilter = " where ICP_SRNO = '" + filter_icp + "'";
		 		 out.println(vishwaFilter);

//=================================================
		int div_hgt = 200; 
		if(filter_icp.equals("All")) {dash = "All ICPs";  div_hgt = 600;}
		else{
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('004', '022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397') order by ICP_DESC");
			
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
			  div_hgt = 200; 
			 
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
		document.entryfrm.action="im_icp_wise_epassport_dashboard_vishwa.jsp?&icp="+document.entryfrm.compare_icp.value;
		document.entryfrm.submit();
		document.Arrival_form.source_port1.value = "";
		document.Arrival_form.source_port.value = "";


		return true;

}



function compare_report()
{
			
			
		document.entryfrm.target="_self";
		document.entryfrm.action="im_icp_epassport_dashboard_vishwa.jsp?&icp="+document.entryfrm.compare_icp.value;
		document.entryfrm.submit();
		return true;

}
</script>



		</head>
		<body onload="apex_search.init();">
		<div class="wrapper">
		<div class="flag-strip"></div>
		<header class="bg-white py-1">
		  <div class="container-fluid">
			<div class="row">
			  <div class="col-sm-4">
				<a href="#Home"><h1><span>IVFRT (I)</span><br/>National Informatics Centre</h1></a>
			  </div>
			  <div class="col-sm-5">
			  <!--<h4 style=" color: #0842af; font-weight:bold; margin-top:1rem; font-size : 1.7rem; margin-right: 1rem;">IMMIGRATION DASHBOARD</h4>-->
			  <img src="e-Passport.png" width="100%" height="90%" alt="e-Passport Dashboard" align="center;">
			  </div>

		 <!--<div class="col-sm-8">
				<table border="0" cellpadding="0" cellspacing="0">
		<input type="text" size="30" maxlength="1000" value="" id="S" onkeyup="apex_search.search(event);" /> &nbsp <input type="button" value=" Search" onclick="apex_search.lsearch();"/> 
		</table>
			  </div>
			  -->
			 
			</div> 
		  </div>
		</header>
		<div class="menu">
		  <nav class="navbar navbar-expand-sm">
			<div class="container"> 
			  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#collapsibleNavbar"><span class="navbar-toggler-icon"></span> </button>
			  <div class="collapse navbar-collapse" id="collapsibleNavbar">
				<ul class="navbar-nav">
				  <li class="nav-item"><a href="#Home" class="scrollLink nav-link">Home</a></li>
				  <li class="nav-item dropdown"><a href="#Home" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">e-Passport</a>
				  <ul class="dropdown-menu">
				  <li> <a class="scrollLink dropdown-item" href="#ICP_1">All ICPs Arrival and Departure e-Passport Statistics</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICP_2">ICP-wise Arrival and Departure e-Passport Statistics</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICP_3">Country-wise Arrival and Departure e-Passport Statistics</a></li>
				  <li> <a class="scrollLink dropdown-item" href="#ICP_4">Country-wise Arrival and Departure e-Passport Statistics</a></ul></li>
				

				  <li class="nav-item dropdown"><a href="#biometric_0" class="scrollLink nav-link dropdown-toggle" data-toggle="dropdown">Centralised Dashboard</a>
				   <ul class="dropdown-menu">
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/" target="_blank">Immigration Control System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_apis.jsp" target="_blank">Advanced Passenger Information System</a> </li>
					<li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_epassport.jsp" target="_blank">e-Passport Statistics</a> </li>
				  <li> <a class="scrollLink dropdown-item" href="http://10.248.168.222:8080/dashboard/index_evisa.jsp" target="_blank">e-Visa Statistics</a></ul></li>


			   </ul>
			  </div>
			</div>
				<%if(filter_icp.equals("All")) {	%>	
					 <span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;All ICPs&nbsp;</font></span>
				<%} else {%>
					 <span class="airport_name"><font style="background-color:white; color:#0842af; font-weight: bold; font-size: 35px;">&nbsp;<%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%>&nbsp;</font></span>
				<%} %>
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
					<th colspan="9" >HOME</th>
				</tr>
				<tr id='head' name='home'>
					<th>S.No.</th>
					<th>Date</th>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<th colspan=6>Description</th>
				</tr>
			</thead>

</table><br>
</section>
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


	
<form name="entryfrm" method="post">
	<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
		<tr bgcolor="#D0DDEA">
			<td align="center">
		   
			</select><font face="Verdana" color="#347FAA" size="2"><b>&nbsp;&nbsp;Select&nbsp;ICP&nbsp;&nbsp;</b>

			<input height="40" type="text" style="color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;text-transform:uppercase;font-family:Verdana" size="4" maxlength="10" name="source_port1" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')">
			<!--filtery function-->
			<!--letternumber function-->
			<select class="form-select-sm" name="compare_icp" onKeyDown="if(event.keyCode==13) event.keyCode=9;">

				<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICP's</option>

			<!--<option value="All" <%if(filter_icp.equals("All")){%> selected<%}%>>All ICPs</option>-->
<%
			/*rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST where ICP_SRNO in ('022', '010', '006', '033', '023', '007', '094', '012', '019', '021', '092', '026', '003', '016', '032', '002', '008', '" + filter_icp + "', '001', '041', '085', '024', '077', '095', '025', '015', '096', '084', '005', '030', '029', '017', '162', '305', '364', '397','004') order by ICP_DESC");*/
			rsTemp = st_icp.executeQuery("select ICP_SRNO,ICP_DESC from IM_ICP_LIST  order by ICP_DESC");
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
			&nbsp;&nbsp;<!--<input type="button" class="Button" value="Generate" onclick=" compare_report();" style=" font-family: Verdana; font-size: 9pt; color:#000000; font-weight: bold"></input>-->
			<button class="btn btn-primary btn-sm" type="button" onClick="compare_report();"> Generate </button>
			</td>
		</tr>
	</table>
</form>
<br><%
//====================	Arr Counter Tabs	============================%>

<%

	try {
		dashQuery = "select SUM(ARRIVAL_PAX) from IM_DASHBOARD_EPASSPORT_ICP" + vishwaFilter;
		psTemp = con.prepareStatement(dashQuery);
		rsTemp = psTemp.executeQuery();
		while(rsTemp.next()) {

	     total_Arrival_Count = total_Arrival_Count+rsTemp.getInt("SUM(ARRIVAL_PAX)");

		}
		rsTemp.close();
		psTemp.close();
	} catch (Exception e) {
		out.println("Arrival Total Exception");
	}

	try {
		dashQuery = "select count(1) as arr_epassport from IM_TRANS_ARR_EPASSPORT where FLIGHT_SCHEDULE_DATE = trunc(sysdate-1)";
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
		dashQuery = "select count(1) as arr_epassport from IM_TRANS_ARR_EPASSPORT where FLIGHT_SCHEDULE_DATE = trunc(sysdate)";
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

	
%>
<br><br><br>
<div class="container-fluid">
<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-3">
			<table class="tableDesign" width="50px">
			
			
			<tr style="font-size: 40px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th colspan="2" style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;font-size: 35px;">Arrival&nbsp;e&#8209;Passport</th>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #004076;" id="countArrT"><%=today_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #004076;">&nbsp;Today's&nbsp;e&#8209;Passports</td>
			</tr>
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td  style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color :#0072d3" id="countArrY"><%=yesterday_Arrival_Count%></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color :#0072d3">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td id="countArr" style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #44a9ff;"></td>
				<td style="background-color:#bae6ff;border-color: #bae6ff;width:50%; font-weight: bold;text-align: left;color: #44a9ff;">&nbsp;Total&nbsp;e&#8209;Passports</td>
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
	dashQuery = "select SUM(DEPARTURE_PAX) from IM_DASHBOARD_EPASSPORT_ICP" + vishwaFilter;
	psTemp = con.prepareStatement(dashQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		total_Dep_Count = total_Dep_Count+rsTemp.getInt("SUM(DEPARTURE_PAX)");

		//total_PAX_Count = total_Arrival_Count + total_Dep_Count;

	}
	rsTemp.close();
	psTemp.close();
} catch (Exception e) {
	out.println("Arrival Total Exception");
}

try {
	dashQuery = "select count(1) as dep_Passenger_Count from IM_TRANS_DEP_EPASSPORT where FLIGHT_SCHEDULE_DATE = trunc(sysdate-1)";
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
	dashQuery = "select count(1) as dep_Passenger_Count from IM_TRANS_DEP_EPASSPORT where FLIGHT_SCHEDULE_DATE = trunc(sysdate)";
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
				<th colspan="2" style="text-align: center;background-color:#5521a0;border-color: #5521a0;width:40%; text-align: center;font-size: 35px;">&nbsp;Departure&nbsp;e&#8209;Passport&nbsp;</th>
			</tr>

			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 50px;color: #5521a0;" id="count_total_Dep_CountT"><%=today_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #5521a0;" >&nbsp;Today's&nbsp;e&#8209;Passports</td>
			</tr>



			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 40px;color: #864cd9;" id="count_total_Dep_CountY"><%=yest_Dep_Count%></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #864cd9;">&nbsp;Yesterday's&nbsp;e&#8209;Passports</td>
			</tr>
			
			<tr style="font-size: 14px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				
				<td id="count_total_Dep_Count" style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: right;font-size: 30px;color: #a376e2;"></td>
				<td style="background-color:#e8daff;border-color: #e8daff;width:50%; font-weight: bold; text-align: left;color: #a376e2;">&nbsp;Total&nbsp;e&#8209;Passports</td>

			</tr>

		</table>
</div>

	
</div>
</div>
		</section>

<%//=========================	Dep Counter tabs	=======================%>

		
		

		



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

StringBuilder NaltyPax_Week = new StringBuilder();
StringBuilder ArrNaltyPax_Week = new StringBuilder();
StringBuilder DepNaltyPax_Week = new StringBuilder();
String strNaltyPax_Week = "";
String strArrNalty_Week = "";
String strDepNalty_Week = "";

%>

	<%//////////////////////////////////////////////////////////////////////////////////////////////////////////////%>
		<section id="ICP_1">
		<div class="pt-4" id="ICP_1"><br><br><br><br><br>
	<table id = "auto-index1" class="table table-sm table-striped" >
			<thead>

				<tr id='head1'>
				<%if(filter_icp.equals("All")) {%>	
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;">All ICPs Arrival and Departure e-Passport Statistics</th>
				<%} else {%>
					<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 20px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Arrival and Departure e-Passport Statistics</th>
				<%} %>
				</tr>
				
			</thead>
			
		</table>
		</section>
<div class="container-fluid">
<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-3">
		<table class="tableDesign" >
			<!--<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days</caption>-->
	
			<tr style="font-size: 15px;  text-align: right; color:white; border-color: #009688;height:12px;">
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%;">Date</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Arrival&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Departure&nbsp;</th>
				<th style="text-align: center;background-color:#007d79;border-color: #005555;width:33.33%; text-align: right;">Total&nbsp;</th>
			</tr>
<%
	int all_ICP_Arr_Total = 0 ;
	int all_ICP_Dep_Total = 0 ;
	int all_ICP_Total = 0 ;
try
	{
	SQLQUERY = "";
	SQLQUERY = "select year as arr_year,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_ICP "+ vishwaFilter +" group by year order by 1";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()){
	
			TotalDays.append("\"");
			TotalDays.append(rsTemp.getString("arr_year"));
			TotalDays.append("\"");
			TotalDays.append(",");
			TotalArrPax.append(rsTemp.getInt("arr_count")+",");
			TotalDepPax.append(rsTemp.getInt("dep_count")+",");
			%>
			<tr style="font-size: 14px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;"><%=rsTemp.getString("arr_year")%></td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("arr_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("arr_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("dep_count") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("dep_count"))%>&nbsp;</td>
				<td style="background-color:#d9fbfb;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;color: #005653;font-size:15px;"><%=getIndianFormat((rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count")))%>&nbsp;</td>

			</tr>

<%
			all_ICP_Arr_Total = all_ICP_Arr_Total + rsTemp.getInt("arr_count");
			all_ICP_Dep_Total = all_ICP_Dep_Total + rsTemp.getInt("dep_count");
			all_ICP_Total = all_ICP_Total + rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count");
		}
%>			
			<tr style="font-size: 16px;  text-align: right; color:#005653; border-color: #009688;height:12px;">
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold;text-align: center;">Total</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Arr_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;"><%=getIndianFormat(all_ICP_Dep_Total)%>&nbsp;</td>
				<td style="background-color:#8ee8f2;border-color:#005555;width:33.33%; font-weight: bold; text-align: right;font-size:15px;"><%=getIndianFormat(all_ICP_Total)%>&nbsp;</td>

			</tr>
			<%
			rsTemp.close();
			psTemp.close();

			strTotalDays = TotalDays.toString();
			strTotalDays = strTotalDays.substring(0,strTotalDays.length()-1);
			strTotalArrPax = TotalArrPax.toString();
			strTotalArrPax = strTotalArrPax.substring(0,strTotalArrPax.length()-1);
			strTotalDepPax = TotalDepPax.toString();
			strTotalDepPax = strTotalDepPax.substring(0,strTotalDepPax.length()-1);
		
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
	<div class="col-sm-8">
	<div class="card"style="border: solid 3px #007d79; border-radius: 20px;">
	<div class="card-body">
		<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">All ICPs Arrival and Departure e-Passport Statistics</h1>-->

		<canvas id="canvasPAX_Total" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 20%, #cdf7f7 100%);border-radius: 20px;"></canvas>
	</div>
	</div>
	</div>
	 <script>

		// Data define for bar chart

		var myData_total = {
			labels: [<%=strTotalDays%>],
			datasets: [{ 
				  label: "Arrival e-Passport",
			      backgroundColor: "#007d79",
			      borderColor: "#005555",
			      borderWidth: 1,
			      data: [<%=strTotalArrPax%>]
			}, { 
				  label: "Departure e-Passport",
			      backgroundColor: "#FFBB5C",
			      borderColor: "#FFBB5C",
			      borderWidth: 2,
			      data: [<%=strTotalDepPax%>]
			}]
		};

// Options to display value on top of bars

		var myoptions = {
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },
					 title: {
							display: true,
								text:'Arrival and Departure e-Passport Statistics',
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
				var ctx = document.getElementById('canvasPAX_Total').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData_total,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

 </script>


<%		 /*if (start for ICP = All)*/

if(filter_icp.equals("All")){

			
%>
	</div>
	</div>
	<%//////////////////////////	ICP-wise Arrival and Departure e-Passport Statistics	//////////////////////////////////////////%>
		<section id="ICP_2">
		<div class="pt-4" id="ICP_2"><br><br><br>
	<br><br><table id = "auto-index1" class="table table-sm table-striped">
			<thead>
				<tr id='head1'>
					<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">ICP-wise Arrival and Departure e-Passport Statistics</th>
				</tr>
				
			</thead>
			
		</table><br>


<div class="container-fluid">
<div class="row">


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-2">
<table>
			
			
<%
try
	{
    int srno = 0;
	SQLQUERY = "";
	int ePass_Arr_Total = 0 ;
	int ePass_Dep_Total = 0 ;
	int ePass_Total = 0 ;
	
	/*SQLQUERY = " select ICP_SRNO,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_ICP where ICP_SRNO not in('163','173','240','277') group by ICP_SRNO order by 2 desc";*/

	SQLQUERY = " select ICP_SRNO,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_ICP "+ vishwaFilter +" group by ICP_SRNO order by 2 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

			if(srno < 200)
			{
			IcpPax.append("\"");
			IcpPax.append(icpValue.get(rsTemp.getString("ICP_SRNO")));
			IcpPax.append("\"");
			IcpPax.append(",");
			ArrIcpPax.append(rsTemp.getInt("arr_count")+",");
			DepIcpPax.append(rsTemp.getInt("dep_count")+",");
			}
			
			if(srno%17 == 0)
			{
				if(srno!=0)
				{%>
					</td>
					</table>
					</div><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<%}
				
				%>
				<td>
					<div class="col-sm-2" style="width:450px;">
						<table class="tableDesign">
						
						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
							<th style="background-color:#ed459d;border-color: #f6a2ce;text-align: center; width:10%;">S.No.</th>
							<th style="background-color:#ed459d;border-color: #f6a2ce;text-align: left;width:20%;">ICP</th>
							<th style="background-color:#ed459d;border-color: #f6a2ce; text-align: right;width:22%;">Arrival&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #f6a2ce; text-align: right;width:23%;">Departure&nbsp;</th>
							<th style="background-color:#ed459d;border-color: #f6a2ce; text-align: right;width:25%;">Total&nbsp;</th>
						</tr>
				<% 
					}
					%>
						<tr style="font-size: 14px;color:black; font-family: 'Arial', serif; border-color: #ed459d;height:18px;">
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: center;width:10%;"><%=++srno%></td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;"><%=icpValue.get(rsTemp.getString("ICP_SRNO"))%></td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:22%;"><%=rsTemp.getInt("arr_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("arr_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=rsTemp.getInt("dep_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("dep_count"))%>&nbsp;</td>
						<td style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold; text-align: right;color:#e81784;font-size: 15px;width:25%;"><%=getIndianFormat((rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count")))%>&nbsp;</td>
					</tr>
<%
					ePass_Arr_Total = ePass_Arr_Total + rsTemp.getInt("arr_count");
					ePass_Dep_Total = ePass_Dep_Total + rsTemp.getInt("dep_count");
					ePass_Total = ePass_Total + rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count");
	}
				int whileCounter = 0;
				while(srno%17!=0)
				{
					whileCounter++;
					if(whileCounter == 1)
					{
%>						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
						<td colspan="2" style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;text-align: center;">Total&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;width:22%;"><%=getIndianFormat(ePass_Arr_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=getIndianFormat(ePass_Dep_Total)%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;color:white;font-size: 15px;width:25%;"><%=getIndianFormat(ePass_Total)%>&nbsp;</td>
					</tr>
<%					} 
					else 
					{ 
%>
						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
							<td colspan="5" style="background-color:#fdeef6;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;text-align: center;">&nbsp;</td>
						</tr>
<%
					}
					srno++; 
				}
%>

</table>
</div><%
			rsTemp.close();
			psTemp.close();

			strIcpPax = IcpPax.toString();
			strIcpPax = strIcpPax.substring(0,strIcpPax.length()-1);

			strArricp = ArrIcpPax.toString();
			strArricp = strArricp.substring(0,strArricp.length()-1);

			strDepicp = DepIcpPax.toString();
			strDepicp = strDepicp.substring(0,strDepicp.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
		</div>
		</div>
	
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="container-fluid">
<div class="row">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<div class="col-sm-6">
	<div class="card"style="border: solid 3px #e81784; border-radius: 20px;width:1200px;">
	<div class="card-body" style="height:1500px; width:1200px;">		
	<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Top 20 : ICP-wise Arrival and Departure e-Passport Statistics</h1>-->

		<canvas id="canvasPAX_icp" class="chart" style="max-width: 100%;border-radius: 20px;"></canvas><br>
</div>
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>

<script>
	var myData_ICP = {
			labels: [<%=strIcpPax%>],
			datasets: [{ 
				  label: "Arrival e-Passport",
			      backgroundColor: "#FF2171",
			      borderColor: "#FF2171",
			      borderWidth: 1,
			      data: [<%=strArricp%>]
			},
					  { 
				  label: "Departure e-Passport",
			      backgroundColor: "#687EFE",
			      borderColor: "#687EFE",
			      borderWidth: 1,
			      data: [<%=strDepicp%>]
			}]
		};


// Options to display value on top of bars

		var myoptionsp = {
			maintainAspectRatio: false,
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },
					  title: {
							display: true,
								text: 'Top 20 : ICP-wise Arrival and Departure e-Passport Statistics',
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
					ctx.fillStyle = "#0F292F";
					ctx.textBaseline = 'bottom';
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x+32, bar._model.y+6);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart


				  var ctx = document.getElementById('canvasPAX_icp').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type  horizontalBar
			data: myData_ICP,    	// Chart data
			options: myoptionsp 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
</script>

		<%} /*if (closed for ICP = All*/%>
		




	<!--	<h1 style="font-size: 20px; color: blue;font-weight: bold; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Departure ICPs Wise e-Passport Statistics</h1>

		<canvas id="canvasPAX_icp_dep" class="chart" style="max-width: 100%;border-radius: 20px;"></canvas>-->
	
	


	<%//////////////////////   Country-wise Arrival and Departure e-Passport Statistics   //////////////////////////////%>

		<section id="ICP_3">
		<div class="pt-4" id="ICP_3"><br><br><br>
		<br><br><table id = "auto-index1" class="table table-sm table-striped" >
			<thead>
				<tr id='head1'>
					<%if(filter_icp.equals("All")) {	%>	
						<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">All ICPs : Country-wise Arrival and Departure e-Passport Statistics</th>
					<%} else {%>
						<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Country-wise Arrival and Departure e-Passport Statistics</th>
					<%} %>
				</tr>
				
			</thead>
</table><br>

<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-2">
		<table>
			
<%
try
	{
    int srno = 0;
	SQLQUERY = "";
	int country_Arr_Total = 0 ;
	int country_Dep_Total = 0 ;
	int country_Total = 0 ;
	
	SQLQUERY = "select NALTY_CODE,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_NALTY " + vishwaFilter + " group by NALTY_CODE order by 2 desc";
	//SQLQUERY = "select NALTY_CODE,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_NALTY where ICP_SRNO = '004' and NALTY_CODE = 'USA' group by NALTY_CODE order by 2 desc";
	
	psTemp = con.prepareStatement(SQLQUERY);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
		
			//if(srno >= 42)
			//	continue;
			if(srno < 200)
			{
			NaltyPax.append("\"");
			NaltyPax.append(rsTemp.getString("NALTY_CODE"));
			NaltyPax.append("\"");
			NaltyPax.append(",");
			ArrNaltyPax.append(rsTemp.getInt("arr_count")+",");
			DepNaltyPax.append(rsTemp.getInt("dep_count")+",");
			}
			if(srno%17 == 0)
			{
				if(srno!=0)
				{%>
					</td>
					</table>
					</div><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<%}
				%>
				<td>
				<div class="col-sm-2" style="width:450px;">
				<table class="tableDesign">
			<tr style="font-size: 15px;   color:white; border-color: #3B7DD8;height:12px;border-radius: 20px;">
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: center;width:10%;">S.No.</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: center;width:15%;">Country</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Arrival&nbsp;</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Departure&nbsp;</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Total&nbsp;</th>
			</tr>
			<%
			}

			%>
			<tr style="font-size: 14px;color:black; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#efedf6;border-color:#776ab9;width:10%; font-weight: bold;text-align: center;"><%=++srno%></td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:15%; font-weight: bold;text-align: center;"><%=rsTemp.getString("NALTY_CODE")%></td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("arr_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("arr_count"))%>&nbsp;</td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("dep_count") == 0 ? "&nbsp;" : getIndianFormat(rsTemp.getInt("dep_count"))%>&nbsp;</td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;color:#554799;font-size: 15px;"><%=getIndianFormat((rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count")))%>&nbsp;</td>
			</tr>
<%
				country_Arr_Total = country_Arr_Total + rsTemp.getInt("arr_count");
				country_Dep_Total = country_Dep_Total + rsTemp.getInt("dep_count");
				country_Total = country_Total + rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count");
	}
				int whileCounter = 0;
				while(srno%17!=0)
				{	
					whileCounter++;
					if(whileCounter == 1)
					{
%>						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
							<td colspan="2" style="background-color:#6D5EB4;border-color:#efedf6; font-weight: bold;text-align: left;width:20%;text-align: center;">Total&nbsp;</td>
							<td style="background-color:#6D5EB4;border-color:#efedf6; font-weight: bold; text-align: right;width:22%;"><%=getIndianFormat(country_Arr_Total)%>&nbsp;</td>
							<td style="background-color:#6D5EB4;border-color:#efedf6; font-weight: bold; text-align: right;width:23%;"><%=getIndianFormat(country_Dep_Total)%>&nbsp;</td>
							<td style="background-color:#6D5EB4;border-color:#efedf6; font-weight: bold; text-align: right;color:white;font-size: 15px;width:25%;"><%=getIndianFormat(country_Total)%>&nbsp;</td>
						</tr>
<%					} 
					else 
					{ 
%>
						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
							<td colspan="5" style="background-color:#efedf6;border-color:#776ab9; font-weight: bold;text-align: left;width:20%;text-align: center;">&nbsp;</td>
						</tr>
<%
					}
					srno++; 
				}
%>

</table>
	</div><%
			rsTemp.close();
			psTemp.close();

			strNaltyPax = NaltyPax.toString();
			strNaltyPax = strNaltyPax.substring(0,strNaltyPax.length()-1);

			strArrNalty = ArrNaltyPax.toString();
			strArrNalty = strArrNalty.substring(0,strArrNalty.length()-1);

			strDepNalty = DepNaltyPax.toString();
			strDepNalty = strDepNalty.substring(0,strDepNalty.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
		</div>
		</div>


		<br><br><br>
	<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-6" style="height:1200px;">
<div class="card" style="border: solid 3px #776ab9; border-radius: 20px; height:1500px;width:1200px;">
<div class="card-body" style="height:1500px; width:1200px;">
		<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 25px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Country-wise Arrival and Departure e-Passport Statistics</h1>-->

		<canvas id="canvasPAX_nality" class="chart" style="max-width: 100%;border-radius: 20px;  background: linear-gradient(to bottom, #ffffff 35%, # 100%);height:1500px;" ></canvas><br>
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>
	</section>


<script>
	var myData_NALTY = {
			labels: [<%=strNaltyPax%>],
			datasets: [{ 
				  label: "Arrival e-Passport",
			      backgroundColor: "#6D5EB4",
			      borderColor: "#6D5EB4",
			      borderWidth: 1,
			      data: [<%=strArrNalty%>]
			},
					  { 
				  label: "Departure e-Passport",
			      backgroundColor: "#45FFCA",
			      borderColor: "#00B380",
			      borderWidth: 1,
			      data: [<%=strDepNalty%>]
			}]
		};
			

				  	// Options to display value on top of bars

		var myoptions = {
			
					maintainAspectRatio: false,
				
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },
							
					 title: {
							display: true,
								text: 'Country-wise Arrival and Departure e-Passport Statistics',
								fontSize:25,
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
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x+40, bar._model.y+6);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart
		 	
var ctx = document.getElementById('canvasPAX_nality').getContext('2d');
ctx.height = 1000;
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type  horizontalBar
			data: myData_NALTY,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
</script>

	
<br><br>
	


	<%
	///////////////////////////	 Country-wise Arrival and Departure e-Passport Statistics - End	///////////////////////////////
	%>







<%//////////////////////   Country-wise Arrival and Departure e-Passport Statistics 7 days   //////////////////////////////%>
<br><br><br><br><br><br>
		<section id="ICP_4">
		<div class="pt-4" id="ICP_4"><br><br><br>
		<br><br><table id = "auto-index1" class="table table-sm table-striped" >
			<thead>
				<tr id='head1'>
					<%if(filter_icp.equals("All")) {	%>	
						<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;">All ICPs : Country-wise Arrival and Departure e-Passport Statistics for last 7 days</th>
					<%} else {%>
						<th colspan="4" style="font-family: Arial;background-color: #1192e8; color: white; font-size: 22px;text-align: left;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Country-wise Arrival and Departure e-Passport Statistics for last 7 days</th>
					<%} %>
				</tr>
			</thead>
</table><br>

<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div class="col-sm-2">
		<table>
			
<%
try
	{
    int srno = 0;
	//SQLQUERY = "";
	String SQLQUERY_Week = "";
	int country_Arr_Total_Week = 0 ;
	int country_Dep_Total_Week = 0 ;
	int country_Total_Week = 0 ;
	
	/*SQLQUERY = "select NALTY_CODE,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_NALTY " + vishwaFilter + "  group by NALTY_CODE order by 2 desc";*/

	SQLQUERY_Week = "select ICP_SRNO,to_char(ENTRY_DATE,'Mon-dd') as ENTRY_DATE_1, NALTY_CODE,sum(ARRIVAL_PAX) as arr_count,sum(DEPARTURE_PAX) as dep_count from IM_DASHBOARD_EPASSPORT_NALTY where ICP_SRNO = '" + filter_icp + "' and  ENTRY_DATE >= trunc(sysdate-7) and ENTRY_DATE <= trunc(sysdate) group by NALTY_CODE, ICP_SRNO, to_char(ENTRY_DATE,'Mon-dd') order by (sum(ARRIVAL_PAX) + sum(DEPARTURE_PAX)) desc";
	
	psTemp = con.prepareStatement(SQLQUERY_Week);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {
		
			if(srno >= 42)
				continue;
			if(srno < 20)
			{
			NaltyPax_Week.append("\"");
			NaltyPax_Week.append(rsTemp.getString("NALTY_CODE"));
			NaltyPax_Week.append("\"");
			NaltyPax_Week.append(",");
			ArrNaltyPax_Week.append(rsTemp.getInt("arr_count")+",");
			DepNaltyPax_Week.append(rsTemp.getInt("dep_count")+",");
			}
			if(srno%17 == 0)
			{
				if(srno!=0)
				{%>
					</td>
					</table>
					</div><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<%}
				%>
				<td>
				<div class="col-sm-2" style="width:450px;">
				<table class="tableDesign">
			<tr style="font-size: 15px;   color:white; border-color: #3B7DD8;height:12px;border-radius: 20px;">
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: center;width:10%;">S.No.</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: center;width:15%;">Country</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Arrival&nbsp;</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Departure&nbsp;</th>
				<th style="background-color:#6D5EB4;border-color: #efedf6; text-align: right;width:25%;">Total&nbsp;</th>
			</tr>
			<%
			}

			%>
			<tr style="font-size: 14px;color:black; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
				<td style="background-color:#efedf6;border-color:#776ab9;width:10%; font-weight: bold;text-align: center;"><%=++srno%></td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:15%; font-weight: bold;text-align: center;"><%=rsTemp.getString("NALTY_CODE")%></td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("arr_count")%>&nbsp;</td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;"><%=rsTemp.getInt("dep_count")%>&nbsp;</td>
				<td style="background-color:#efedf6;border-color:#776ab9;width:25%; font-weight: bold; text-align: right;color:#554799;font-size: 15px;"><%=(rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count"))%>&nbsp;</td>
			</tr>
<%
				country_Arr_Total_Week = country_Arr_Total_Week + rsTemp.getInt("arr_count");		//out.println(country_Arr_Total_Week+ "<br>")
				country_Dep_Total_Week = country_Dep_Total_Week + rsTemp.getInt("dep_count");
				country_Total_Week = country_Total_Week + rsTemp.getInt("arr_count") + rsTemp.getInt("dep_count");
	}
				while(srno%17!=0)
					{
%>						<tr style="font-size: 15px;  text-align: right; color:white; border-color: #3B7DD8;height:12px;background-color:#ed459d;">
						<td colspan="2" style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold;text-align: left;width:20%;text-align: center;">Total&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;width:22%;"><%=country_Arr_Total_Week%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;width:23%;"><%=country_Dep_Total_Week%>&nbsp;</td>
						<td style="background-color:#ed459d;border-color:#f6a2ce; font-weight: bold; text-align: right;color:white;font-size: 15px;width:25%;"><%=country_Total_Week%>&nbsp;</td>
					</tr>
	<%srno++; }%>

</table>
	</div><%
			rsTemp.close();
			psTemp.close();

			strNaltyPax_Week = NaltyPax_Week.toString();
			strNaltyPax_Week = strNaltyPax_Week.substring(0,strNaltyPax_Week.length()-1);

			strArrNalty_Week = ArrNaltyPax_Week.toString();
			strArrNalty_Week = strArrNalty_Week.substring(0,strArrNalty_Week.length()-1);

			strDepNalty_Week = DepNaltyPax_Week.toString();
			strDepNalty_Week = strDepNalty_Week.substring(0,strDepNalty_Week.length()-1);
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
			%>
		</table>
		</div>
		</div>
		</div>


		<br><br><br>
	<div class="container-fluid">
	<div class="row">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div class="col-sm-6" style="height:1200px;">
<div class="card" style="border: solid 3px #776ab9; border-radius: 20px; height:1500px;width:1200px;">
<div class="card-body" style="height:1500px; width:1200px;">
		<!--<h1 style="font-size: 20px; color: #666666;font-weight: bold; line-height: 25px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Country-wise Arrival and Departure e-Passport Statistics</h1>-->

		<canvas id="canvasPAX_nality_Week" class="chart" style="max-width: 100%;border-radius: 20px;  background: linear-gradient(to bottom, #ffffff 35%, # 100%);height:1500px;" ></canvas><br>
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>
	</section>


<script>
	var myData_NALTY = {
			labels: [<%=strNaltyPax_Week%>],
			datasets: [{ 
				  label: "Arrival e-Passport",
			      backgroundColor: "#6D5EB4",
			      borderColor: "#6D5EB4",
			      borderWidth: 1,
			      data: [<%=strArrNalty_Week%>]
			},
					  { 
				  label: "Departure e-Passport",
			      backgroundColor: "#45FFCA",
			      borderColor: "#00B380",
			      borderWidth: 1,
			      data: [<%=strDepNalty_Week%>]
			}]
		};
			

				  	// Options to display value on top of bars

		var myoptions = {
			
					maintainAspectRatio: false,
				
				 scales: {
				        xAxes: [{
				            ticks: {
				                display: false //removes y axis values in  bar graph 
				            }
				        }]
				    },
							
					 title: {
							display: true,
								text: 'Country-wise Arrival and Departure e-Passport Statistics',
								fontSize:25,
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
					ctx.font = "bold 12px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x+40, bar._model.y+6);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart
		 	
var ctx = document.getElementById('canvasPAX_nality_Week').getContext('2d');
ctx.height = 1000;
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type  horizontalBar
			data: myData_NALTY,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});
</script>

	
<br><br>
	


	<%
	///////////////////////////	 Country-wise Arrival and Departure e-Passport Statistics 7 days- End	///////////////////////////////
	%>


<script>
/////////////////// Total Arrival Footfall /////////////////////
let counts_arr_total_pax = setInterval(updated_arr_total_pax);
        let upto_arr_total_pax = <%=(total_Arrival_Count)-400%>;
        function updated_arr_total_pax() {
            upto_arr_total_pax = ++upto_arr_total_pax;
            document.getElementById('countArr').innerHTML = upto_arr_total_pax.toLocaleString('en-IN');
            if (upto_arr_total_pax === <%=total_Arrival_Count%>) {
                clearInterval(counts_arr_total_pax);
            }
        }

let counts_yest_arr_pax = setInterval(updated_yest_arr_pax);
        let upto_yest_arr_pax = <%=(yesterday_Arrival_Count)-400%>;
        function updated_yest_arr_pax() {
            upto_yest_arr_pax = ++upto_yest_arr_pax;
            document.getElementById('countArrY').innerHTML = upto_yest_arr_pax.toLocaleString('en-IN');
            if (upto_yest_arr_pax === <%=yesterday_Arrival_Count%>) {
                clearInterval(counts_yest_arr_pax);
            }
        }

let counts_today_arr_pax = setInterval(updated_today_arr_pax);
        let upto_today_arr_pax = <%=(today_Arrival_Count)-400%>;
        function updated_today_arr_pax() {
            upto_today_arr_pax = ++upto_today_arr_pax;
            document.getElementById('countArrT').innerHTML = upto_today_arr_pax.toLocaleString('en-IN');
            if (upto_today_arr_pax === <%=today_Arrival_Count%>) {
                clearInterval(counts_today_arr_pax);
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

let counts_yest_dep_pax = setInterval(updated_yest_dep_pax);
        let upto_yest_dep_pax = <%=(yest_Dep_Count)-400%>;
        function updated_yest_dep_pax() {
            upto_yest_dep_pax = ++upto_yest_dep_pax;
            document.getElementById('count_total_Dep_CountY').innerHTML = upto_yest_dep_pax.toLocaleString('en-IN');
            if (upto_yest_dep_pax === <%=yest_Dep_Count%>) {
                clearInterval(counts_yest_dep_pax);
            }
        }

let counts_today_dep_pax = setInterval(updated_today_dep_pax);
        let upto_today_dep_pax = <%=(today_Dep_Count)-400%>;
        function updated_today_dep_pax() {
            upto_today_dep_pax = ++upto_today_dep_pax;
            document.getElementById('count_total_Dep_CountT').innerHTML = upto_today_dep_pax.toLocaleString('en-IN');
            if (upto_today_dep_pax === <%=today_Dep_Count%>) {
                clearInterval(counts_today_dep_pax);
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


counterAnim("#countArr", 50, <%=total_Arrival_Count%>, 2200);
counterAnim("#countArrY", 50, <%=yesterday_Arrival_Count%>, 2200);
counterAnim("#countArrT", 50, <%=today_Arrival_Count%>, 2200);

counterAnim("#count_total_Dep_Count", 50, <%=total_Dep_Count%>, 2200);
counterAnim("#count_total_Dep_CountY", 50, <%=yest_Dep_Count%>, 2200);
counterAnim("#count_total_Dep_CountT", 50, <%=today_Dep_Count%>, 2200);



});
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
