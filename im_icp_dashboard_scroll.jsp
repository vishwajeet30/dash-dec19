<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>
<%
Connection con = null;
try {

Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "imigration", "nicsi123");

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

 


<title>IndexForm</title>
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style1.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" href="css/all.min.css" media="all">
<link rel="stylesheet" href="css/style.css" media="all">


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
	.fixTableHead thead tr:nth-child(1) {
	position: sticky; 
	top: 0; 
	} 
	.fixTableHead thead tr:nth-child(2) {
	position: sticky; 
	top: 0; 
	}  


 
    th { 
      background: #ABDD93; 
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

<!-- End :  Reverse Timer Functions -->
<%//////////////////////// New Table ////////////////////////////////%>

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
		ps = con.prepareStatement("select to_char(APIS_FILE_REC_TIME,'dd/mm/yyyy hh24:mi:ss') as APIS_FILE_REC_TIME from im_apis_flight@ICSSP_TO_DMRC66 where FLIGHT_SCH_ARR_DATE = to_date('"+boarding_date+"','dd/mm/yyyy') and APIS_FILENAME = '"+file_name+"'");
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
<body  style="background-color: #ffffff;">

<br>
	</div>
		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->
		<div class="aboutsection">
		<section id="Home">
		<div class="pt-4" id="Home">
		



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
<%
out.flush(); //20/09/2022 use for loader
java.util.Date currentDatetime = new java.util.Date(System.currentTimeMillis());
DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM);
sdf = new SimpleDateFormat("dd/MM/yyyy");
String current_year = sdf.format(currentDatetime);

PreparedStatement ps = null;
PreparedStatement ps_in = null;
PreparedStatement ps1 = null;
PreparedStatement ps2 = null;
ResultSet rs = null;
ResultSet rs_in = null;
ResultSet rs1 = null;
String sql_qry = "";
String sql_qry_Dep = "";
int distinct_evisa_total = 0;
int distinct_voa_total = 0;
%>
<%////////////////// Start - Arrived and Expected Flights /////////////////%>
<div class="container-fluid">
<div class="row">
<%/////////////////////////////////Start - ARR////////////////////////////////%>
<div class="col-sm-7">
<%
try
  {
%>
<form action="im_icp_dashboard_scroll.jsp#Arr_Sch_Flts" method="post" >
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table class="tableDesign">
	<tr style="background-color:#a56eff;font-weight:bold;font-size: 22px;height: 40px;">
		<th style="text-align:center;background-color:#915be8; border-color: #915be8; color: white;" colspan="11"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Arrived and Expected Flights</th>
	</tr>
	<tr style="background-color:#a56eff;font-weight:bold;font-size: 12px;height: 30px;">
		<th style="text-align:left;background-color:#a56eff; border-color: #a56eff; color: white;font-weight:normal;" colspan="5">List of flights in last <select type="text" name="filter_time" style="border-radius: 3px;">
	
		<%for(int i=1; i <= 24; i++){%>
		<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
		<%}%>
		</select>
		 hours &nbsp;<input type="submit" name="submit" style="background-color: #1780c4; border-color: #1780c4; color: white; border-radius: 4px;" value="Go"> since <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%>
		 </th>

		<th style="text-align:right;background-color:#a56eff; border-color: #a56eff; color: white; font-weight:normal;" colspan="4">Current Server Time : <%=vFileName%></th>
	</tr>

</table>
</form>

<div class="fixTableHead">
<table class="tableDesign">
		<thead>
			<tr style="background-color:#be95ff;font-weight:bold; color: white;font-size: 14px;border-top-right-radius: 0px;">
				<th colspan="4"  style="text-align:center;border-color: #a56eff;background-color:#be95ff;border-top-left-radius: 0px;">&nbsp;&nbsp;</th>
				<th colspan="2" style="text-align:center;border-color: #a56eff;background-color:#be95ff;">&nbsp;Footfall&nbsp;</th>
				<th colspan="2" style="text-align:center;border-color: #a56eff;background-color:#be95ff;">&nbsp;e-Visa&nbsp;</th>
				<th colspan="2" style="text-align:center;border-color: #a56eff;background-color:#be95ff;">&nbsp;Biometric&nbsp;Enrollment&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff; border-radius: 0px;">&nbsp;&nbsp;</th>
			</tr>
			<tr style="background-color:#be95ff;font-weight:bold; color: white;font-size: 14px;border-top-right-radius: 0px;">
				<th style="text-align:center;border-color: #a56eff;background-color:#be95ff;border-top-left-radius: 0px;">&nbsp;S.No.&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff;">Flight&nbsp;No.&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff;">Schedule&nbsp;Time</th>
				<th style="text-align:center;border-color: #a56eff;background-color:#be95ff;">Arrived<BR>From</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;PAX&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;APIS&nbsp;</th>
				<th style="text-align:center;border-color: #a56eff;background-color:#be95ff;">&nbsp;Processed&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;Expected&nbsp;</th>
				<th style="text-align:right;border-color: #a56eff;background-color:#be95ff;">&nbsp;Processed&nbsp;</th>
				<th style="text-align:center;border-color: #a56eff;background-color:#be95ff;">&nbsp;Expected&nbsp;</th>
				<th style="text-align:left;border-color: #a56eff;background-color:#be95ff; border-radius: 0px;">Clearance&nbsp;<BR>Time&nbsp;</th>
			</tr>

		</thead>
			<%
		String str_filter_icp  = "";
		if(filter_icp.trim().length() > 0) str_filter_icp = " and icp_srno = '"+filter_icp+"'";

	        if(calTime > 0)
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '"+filter_time+"' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");
			else
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '0000' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");

			rs = ps.executeQuery();
			int counter = 1;
			int biometric_count = 0;
			while(rs.next())
			 {	
				biometric_count = 0;
				 if(calTime > 0)
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT,APIS_EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_DATE <= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
				else
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT,APIS_EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_ARR where (SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_TIME <= '2359') OR SCHEDULE_DATE >= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
					String bgcolor = "";
					ps1 = con.prepareStatement(sql_qry);
					rs1 = ps1.executeQuery();
					
					if(rs1.next())
					{
						////////////////////////////////////
						ps_in = con.prepareStatement("select BIOMETRIC_NO from IM_DASHBOARD_APIS_BIOMETRIC_TEMP where FLIGHT_SCH_ARR_DATE = to_date('"+sdf.format(rs1.getDate("SCHEDULE_DATE"))+"','dd/mm/yyyy') and FLIGHT_NO = '"+rs1.getString("FLIGHT_NO")+"'");
						rs_in = ps_in.executeQuery();
						if(rs_in.next())
						biometric_count = rs_in.getInt("BIOMETRIC_NO");
						rs_in.close();
						ps_in.close();
						//////////////////////////////////////////////
						bgcolor = "";
						
						if(rs1.getString("STATUS_COLOR") != null )
						{
							if(rs1.getString("STATUS_COLOR").equals("G")) bgcolor = "#98FB98";
							if(rs1.getString("STATUS_COLOR").equals("R")) bgcolor = "#F7A9A8";
							if(rs1.getString("STATUS_COLOR").equals("Y")) bgcolor = "";
							
						}else
							bgcolor = "#E3D26F";
						%>
						<tr style="font-size: 14px;"> 
							<td style="text-align:center;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=rs1.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:center;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=rs1.getString("APIS_FILENAME") == null ? "" : rs1.getString("APIS_FILENAME").substring(7,10)%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 16px; font-weight:bold;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 12px; font-weight:normal;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 16px; font-weight:bold;"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=rs1.getInt("APIS_EVISA_COUNT") == 0 ? "" : rs1.getInt("APIS_EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 16px; font-weight:bold;"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=biometric_count == 0 ? "" : biometric_count%></td>
							<td style="text-align:left;border-color: #a56eff;background-color: #f5f0ff;font-size: 14px; font-weight:bold;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%
						rs1.close();
						ps1.close();
					}
					else
						{
						
						rs1.close();
						ps1.close();
						ps1 = con.prepareStatement("select * from IM_DASHBOARD_SCH_FLIGHTS_ARR where ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE desc");
						rs1 = ps1.executeQuery();
						if(rs1.next())
						{
							////////////////////////////////////
						ps_in = con.prepareStatement("select BIOMETRIC_NO from IM_DASHBOARD_APIS_BIOMETRIC_TEMP where FLIGHT_SCH_ARR_DATE = to_date('"+sdf.format(rs1.getDate("SCHEDULE_DATE"))+"','dd/mm/yyyy') and FLIGHT_NO = '"+rs1.getString("FLIGHT_NO")+"'");
						rs_in = ps_in.executeQuery();
						if(rs_in.next())
						biometric_count = rs_in.getInt("BIOMETRIC_NO");
						rs_in.close();
						ps_in.close();
						//////////////////////////////////////////////
							%>
						<tr style="background-color:#f6f2ff;">
							<td style="text-align:center;border-color: #a56eff;font-size: 12px; font-weight:normal;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 12px; font-weight:normal;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;color:#449cf5;border-color: #a56eff;font-size: 12px; font-weight:normal;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<font color='black'><%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></font></td>
							<td style="text-align:right;border-color: #a56eff;background-color: #f5f0ff;font-size: 12px; font-weight:normal;">&nbsp;</td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getInt("APIS_EVISA_COUNT") == 0 ? "" : rs1.getInt("APIS_EVISA_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:right;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=biometric_count == 0 ? "" : biometric_count%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 12px;color:#449cf5; font-weight:normal;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%					
						}
						else
							{
							%>
						<tr> 
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 14px; font-weight:bold;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 14px; font-weight:bold;"><%=rs.getString("SCHEDULE_TIME")%></td>
							<td style="text-align:left;border-color: #a56eff;font-size: 14px; font-weight:bold;" colspan="6">&nbsp;</td>
						</tr>
						<%
							}
						rs1.close();
						ps1.close();

						}
						rs1.close();
						ps1.close();
					counter++;
					}
			rs.close();
			ps.close();

			%>
			</table>
			</div>
			</div>
<%	
	}
	catch(Exception e)
	{
		out.println(e);
		e.printStackTrace();
	}

%>
<%///////////////////////////////End - ARR//////////////////////////////////%>
<%////////////////// End - Arrived and Expected Flights /////////////////%>

<%////////////////// Start - Departed and Expected Flights /////////////////%>

<div class="col-sm-5">



<form action="im_icp_dashboard_scroll.jsp#Arr_Sch_Flts" method="post">
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table class="tableDesign">
		<tr style="background-color:#a56eff;font-weight:bold;font-size: 22px;height: 40px;">
			<th style="text-align:center;background-color:#d53c71; border-color: #d53c71; color: white;" colspan="6"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%> : Departed and Expected Flights</th>
		</tr>
		<tr style="font-weight:bold;font-size: 12px;height: 30px;">
			<th style="text-align:left;background-color:#db5a87; border-color: #db5a87; color: white; font-weight:normal;" colspan="3">List of flights in last <select type="text" name="filter_time" style="border-radius: 3px;">
			<%for(int i=1; i <= 24; i++){%>
			<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
			<%}%>
			</select> hours <input type="submit" name="submit" style="background-color: #1780c4; border-color: #1780c4; color: white; border-radius: 4px;" value="Go"> since <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%></th>
			<th style="text-align:right;background-color:#db5a87; border-color: #db5a87; color: white; font-weight:normal;" colspan="3">Current Server Time : <%=vFileName%></th>
		</tr>

</table>
</form>

<div class="fixTableHead">
<table class="tableDesign">
	<thead>
			<tr style="background-color:#be95ff;font-weight:bold; color: white;font-size: 14px;height: 35px;border-top-right-radius: 0px;">
				<th style="text-align:center;border-color: #d53c71;background-color:#e88cac;border-top-left-radius: 0px;">&nbsp;S.No.&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac;">Flight&nbsp;No.&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac;">Schedule&nbsp;Time</th>
				<th style="text-align:right;border-color: #d53c71;background-color:#e88cac;">&nbsp;PAX&nbsp;</th>
				<th style="text-align:right;border-color: #d53c71;background-color:#e88cac;">&nbsp;APIS&nbsp;</th>
				<th style="text-align:left;border-color: #d53c71;background-color:#e88cac; border-radius: 0px;">Clearance&nbsp;<BR>Time&nbsp;</th>
			</tr>
	</thead>
			<%
		try
		{ 	
		String str_filter_icp  = "";
		if(filter_icp.trim().length() > 0) str_filter_icp = " and icp_srno = '"+filter_icp+"'";


	        if(calTime > 0)
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '"+filter_time+"' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");
			else
				ps = con.prepareStatement("select DISTINCT ICP_SRNO,FLIGHT_NO,SCHEDULE_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= trunc(sysdate-2) and SCHEDULE_TIME >= '0000' "+str_filter_icp+" order by SCHEDULE_TIME,FLIGHT_NO");

			rs = ps.executeQuery();
			int counter = 1;
			while(rs.next())
			{
						
				 if(calTime > 0)
					sql_qry_Dep = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_DATE <= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";

				else
					sql_qry_Dep = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where (SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_TIME <= '2359') OR SCHEDULE_DATE >= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
			   //out.println(sql_qry_Dep);
					String bgcolor = "";
					ps1 = con.prepareStatement(sql_qry_Dep);
					rs1 = ps1.executeQuery();
					
					if(rs1.next())
					{
						bgcolor = "";
						
						if(rs1.getString("STATUS_COLOR") != null )
						{
							if(rs1.getString("STATUS_COLOR").equals("G")) bgcolor = "#98FB98";
							if(rs1.getString("STATUS_COLOR").equals("R")) bgcolor = "#F7A9A8";
							if(rs1.getString("STATUS_COLOR").equals("Y")) bgcolor = "";
							
						}else
							bgcolor = "#E3D26F";
						%>
						<tr> 
							<td style="text-align:center;border-color: #d53c71;background-color: #fcf0f4;font-size: 14px; font-weight:bold;"><%=counter%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 14px; font-weight:bold;"><%=rs1.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 14px; font-weight:bold;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 16px; font-weight:bold;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:bold;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 14px; font-weight:bold;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>
						<%
						
					rs1.close();
					ps1.close();
					}
					else
						{
						rs1.close();
						ps1.close();
						ps1 = con.prepareStatement("select * from IM_DASHBOARD_SCH_FLIGHTS_DEP where ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE desc");
						rs1 = ps1.executeQuery();
						if(rs1.next())
						{
							%>
						<tr> 
							<td style="text-align:center;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal;"><%=counter%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal;color:#449cf5"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal;color:#449cf5"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal;color:#449cf5"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:left;border-color: #d53c71;background-color: #fcf0f4;font-size: 12px; font-weight:normal; color:#449cf5;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME").replace("Hour","Hr").replace("Minutes","Min")%></td>
						</tr>

						<%
						rs1.close();
						ps1.close();
						}
						else
							{
							%>
						<tr> 
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;"><%=rs.getString("SCHEDULE_TIME")%></td>
							<td style="text-align:left;" colspan="3">&nbsp;</td>
						</tr>
						<%
							}
						}
					counter++;
					}
			rs.close();
			ps.close();

			%>
			</table>
			</div>
			</div>
<%		
	}
	catch(Exception e)
	{
		out.println(e);
		e.printStackTrace();
	}
////////////////// End - Departed and Expected Flights /////////////////%>


</section>

</div>
</div>
</div>

<%///////////////////////////	End - Arrived, Departed and Expected Flights	/////////////////////////////%>

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
