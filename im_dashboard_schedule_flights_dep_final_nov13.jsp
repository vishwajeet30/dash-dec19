<!DOCTYPE html><html><head><title>APIS - Flight Count Statistics</title>
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
	DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vDate = new SimpleDateFormat("dd/MM/yyyy");
	DateFormat vHours = new SimpleDateFormat("HH");
	DateFormat vMinut = new SimpleDateFormat("mm");
	DateFormat vDay = new SimpleDateFormat("dd");
	java.util.Date current_Server_Time = new java.util.Date();
    String vFileName = vDateFormat.format(current_Server_Time);
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
	
	String filter_icp = request.getParameter("filter_icp") == null ? "" : request.getParameter("filter_icp");
%>
<%!
public String getRecTime(String file_name,String boarding_date,Connection con)
{
	String rectime = "";
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		ps = con.prepareStatement("select to_char(APIS_FILE_REC_TIME,'dd/mm/yyyy hh24:mi:ss') as APIS_FILE_REC_TIME from im_apis_flight_dep@ICSSP_TO_DMRC66 where FLIGHT_SCH_DEP_DATE = to_date('"+boarding_date+"','dd/mm/yyyy') and APIS_FILENAME = '"+file_name+"'");
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
<body onload="enableTimer()">
<form name="clkfrm" method="post">
	<input type="hidden" name="stop_timer" value="1">
	<SPAN id="Clock" style="position:absolute;left:15px;top:5px;width:250px;height:50px;"></span>
</form>

<script>
	CreateTimer(0);
</script>
<div id="loading" name="loading/">
	<br><br>
	<br><br><CENTER><font face="verdana" color="blue" size="3"><b>APIS File Scheduling
</b></font></CENTER><br><br><br>
	<CENTER><IMG SRC="loading.gif" HSPACE="0" VSPACE="0" BORDER="0" NAME="ProgBar" ALT="Generating Results, Please Wait...">
	</CENTER><BR><BR><br>
	<CENTER><font face="verdana" color="DarkGreen"><H2><i>Generating Results, Please Wait......</i></H2></font></CENTER><br><br>
</div>

<table align="right" width="40%" cellspacing="0"  cellpadding="0" border="0">
		<tr style="font-family: Verdana; font-size: 8pt; color:#43CD80;font-weight: bold;text-align:right">
			<td>Page Auto referesh after every 10 minutes</center></td>
		</tr>
		
</table>

<table align="center" width="100%" border="0">

<tr style="border-color:red;font-family: Verdana; font-size: 8pt; color:blue;font-weight: bold">
<td><center>################ Start of Time <%=vFileName %> ################</center></td>
</tr>
</table>
<BR><BR>
<form action="im_dashboard_schedule_flights_dep_final_nov13.jsp" method="post">
<input type="hidden" name="filter_date" value="<%=vDate.format(current_Server_Time)%>"/>
<table align="center" width="40%" cellspacing="0"  cellpadding="0" border="0">

		<tr style="font-family: Verdana; font-size: 8pt; color:#43CD80;font-weight: bold;text-align:center">
			<td>Hours : <select type="text" name="filter_time">
		
			<%for(int i=1; i <= 24; i++){%>
			<option <%if(Integer.parseInt(select_time) == i){%>selected<%}%> value="<%=i%>"><%=i%></option>
			<%}%>
			</select>
			</td><td>ICP : <input type="text" name="filter_icp" size="3" value="<%=filter_icp%>" placeholder="icp code"/></td>
			<td><input type="submit" name="submit" value="submit"></td>
		</tr>
		
</table>
</form>
<!--<br><table align="center" width="97%" border="0">

<tr style="border-color:red;font-family: Verdana; font-size: 10pt; color:blue;font-weight: bold">
<td>Current Time <%=vFileName %> Time Before <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%></td>
</tr>
</table>-->
<%
out.flush(); //20/09/2022 use for loader
	HashMap<String,String> icpMap = new HashMap<String,String>();
	icpMap.put("BOM","001");
	icpMap.put("DEL","004");
	icpMap.put("HYD","041");
	icpMap.put("AMD","022");
	icpMap.put("ATQ","032");
	icpMap.put("BBI","084");
	icpMap.put("BLR","085");
	icpMap.put("CCJ","010");
	icpMap.put("CNN","030");
	icpMap.put("CCU","002");
	icpMap.put("COK","024");
	icpMap.put("GOI","033");
	icpMap.put("IXC","005");
	icpMap.put("IXE","092");
	icpMap.put("MAA","008");
	icpMap.put("TRV","023");
	icpMap.put("TRZ","003");
	icpMap.put("LKO","021");
	icpMap.put("GOX","034");
	icpMap.put("VNS","007");
	icpMap.put("JAI","006");
	icpMap.put("GAY","012");
	icpMap.put("NAG","016");
	icpMap.put("GAU","019");
	icpMap.put("PNQ","026");
	icpMap.put("IXZ","077");
	icpMap.put("SRX","095");
	icpMap.put("CJB","094");
	icpMap.put("IXB","096");
	icpMap.put("WGH","105");
	icpMap.put("IXM","015");
	icpMap.put("VTZ","025");
	icpMap.put("IDR","017");
	icpMap.put("STV","029");

	java.util.Date currentDatetime = new java.util.Date(System.currentTimeMillis());
	DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM);
	sdf = new SimpleDateFormat("dd/MM/yyyy");
	String current_year = sdf.format(currentDatetime);
	Class.forName("oracle.jdbc.OracleDriver");
	String vURL = "jdbc:oracle:thin:@10.248.168.201:1521:ICSSP";
	
	Connection con = null;
	con = DriverManager.getConnection(vURL , "imigration" , "nicsi123");

	PreparedStatement ps = null;
	PreparedStatement ps1 = null;
	PreparedStatement ps2 = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	
	String sql_qry = "";
	
	int distinct_evisa_total = 0;
	int distinct_voa_total = 0;
	try
	{
		

			
%>
<table align="center" border="1" id="theTable" width="85%" cellpadding="8" cellspacing="0" bordercolorlight="#FF99CC" bordercolordark="#FF99CC" bordercolor="#FF99CC" style="border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:8pt;text-align:right;">

			<tr style="background-color:#E6E6EA;font-weight:bold">
				<td style="text-align:left;" colspan="7">List of Flights from time <%=filter_date %>&nbsp;<%=filter_time.substring(0,2)+":"+ filter_time.substring(2,4)%></td>
				<td style="text-align:right;" colspan="11">Current Time : <%=vFileName%></td>
				
			</tr>
			<tr style="background-color:#E6E6EA;font-weight:bold">
				<td style="text-align:center;">&nbsp;S.No.&nbsp;</td>
				<td style="text-align:left;">&nbsp;ICP&nbsp;</td>
				<td style="text-align:left;">&nbsp;Flight&nbsp;No.&nbsp;</td>
				<td style="text-align:left;">&nbsp;Schedule&nbsp;Time&nbsp;</td>
				<!--<td style="text-align:left;">&nbsp;Estimated&nbsp;Arrival&nbsp;Time&nbsp;</td>-->
				<td style="text-align:left;">&nbsp;API&nbsp;File&nbsp;Name&nbsp;</td>
				<td style="text-align:left;">&nbsp;API&nbsp;Received&nbsp;Time&nbsp;</td>
				<td style="text-align:center;">&nbsp;Process&nbsp;Start&nbsp;Time&nbsp;</td>
				<td style="text-align:center;">&nbsp;Process&nbsp;End&nbsp;Time&nbsp;</td>
				<td style="text-align:right;">&nbsp;PAX&nbsp;</td>
				<td style="text-align:right;">&nbsp;APIS&nbsp;</td>
				<td style="text-align:right;">&nbsp;Time&nbsp;Difference&nbsp;</td>
				<td style="text-align:right;">&nbsp;Process&nbsp;Time&nbsp;Difference&nbsp;</td>
				<td style="text-align:right;">&nbsp;eVisa&nbsp;</td>
				<td style="text-align:right;">&nbsp;Biometric&nbsp;Enrolment&nbsp;</td>
				<td style="text-align:right;">&nbsp;First&nbsp;pax&nbsp;time&nbsp;</td>
				<td style="text-align:right;">&nbsp;Last&nbsp;pax&nbsp;time&nbsp;</td>
				<td style="text-align:right;">&nbsp;Pax&nbsp;cleared_95&nbsp;</td>
				<td style="text-align:right;">&nbsp;Flight&nbsp;cleared&nbsp;time&nbsp;</td>
			</tr>
			<%
				
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
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_DATE <= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";

				else
					sql_qry = "select ICP_SRNO, FLIGHT_NO, SCHEDULE_DATE, SCHEDULE_TIME, APIS_FILENAME, APIS_RECEIVED_TIME, PROCESS_START_TIME, PROCESS_END_TIME, APIS_COUNT, BIOMETRIC_COUNT, EVISA_COUNT, PAX_COUNT,STATUS_COLOR,TIME_DIFFERENCE,PROCESS_TIME_DIFFERENCE,FIRST_PAX_TIME,LAST_PAX_TIME,PAX_CLEARED_95,FLIGHT_CLEARED_TIME from IM_DASHBOARD_SCH_FLIGHTS_DEP where (SCHEDULE_DATE >= to_date('"+filter_date+"','dd/mm/yyyy') and SCHEDULE_TIME >= '"+filter_time+"' and SCHEDULE_TIME <= '2359') OR SCHEDULE_DATE >= trunc(sysdate) "+str_filter_icp+" and ICP_SRNO = '"+rs.getString("ICP_SRNO")+"' and FLIGHT_NO = '"+rs.getString("FLIGHT_NO")+"' order by SCHEDULE_DATE,SCHEDULE_TIME";
			   //out.println(sql_qry);
					String bgcolor = "";
					ps1 = con.prepareStatement(sql_qry);
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
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;"><%=rs1.getString("ICP_SRNO")%></td>
							<td style="text-align:left;"><%=rs1.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							
							<!--<td style="text-align:left;"><%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							--><td style="text-align:left;"><%=rs1.getString("APIS_FILENAME") == null ? "" : rs1.getString("APIS_FILENAME")%></td>
							<td style="text-align:left;"><%=rs1.getString("APIS_RECEIVED_TIME") == null ? "" : rs1.getString("APIS_RECEIVED_TIME")%></td>

							<td style="text-align:left;"><%=rs1.getString("PROCESS_START_TIME") == null ? "" : rs1.getString("PROCESS_START_TIME")%></td>
							<td style="text-align:left;"><%=rs1.getString("PROCESS_END_TIME") == null ? "" : rs1.getString("PROCESS_END_TIME")%></td>
							<td style="text-align:right;"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;" bgcolor="<%=bgcolor%>"><%=rs1.getString("TIME_DIFFERENCE") == null ? "" : rs1.getString("TIME_DIFFERENCE")%></td>
							<td style="text-align:right;"><%=rs1.getString("PROCESS_TIME_DIFFERENCE") == null ? "" : rs1.getString("PROCESS_TIME_DIFFERENCE")%></td>
							<td style="text-align:right;"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:left;"><%=rs1.getString("FIRST_PAX_TIME") == null ? "" : rs1.getString("FIRST_PAX_TIME")%></td>
							<td style="text-align:left;"><%=rs1.getString("LAST_PAX_TIME") == null ? "" : rs1.getString("LAST_PAX_TIME")%></td>
							<td style="text-align:left;"><%=rs1.getString("PAX_CLEARED_95") == null ? "" : rs1.getString("PAX_CLEARED_95")%></td>
							<td style="text-align:left;"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME")%></td>
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
							<td style="text-align:center;"><%=counter%></td>
							<td style="text-align:left;"><%=rs.getString("ICP_SRNO")%></td>
							<td style="text-align:left;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=sdf.format(rs1.getDate("SCHEDULE_DATE"))%>&nbsp;<%=rs1.getString("SCHEDULE_TIME").substring(0,2)+":"+rs1.getString("SCHEDULE_TIME").substring(2,rs1.getString("SCHEDULE_TIME").trim().length())%></td>
							
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("APIS_FILENAME") == null ? "" : rs1.getString("APIS_FILENAME")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("APIS_RECEIVED_TIME") == null ? "" : rs1.getString("APIS_RECEIVED_TIME")%></td>

							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("PROCESS_START_TIME") == null ? "" : rs1.getString("PROCESS_START_TIME")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("PROCESS_END_TIME") == null ? "" : rs1.getString("PROCESS_END_TIME")%></td>
							<td style="text-align:right;color:#9DCEFF"><%=rs1.getInt("PAX_COUNT") == 0 ? "" : rs1.getInt("PAX_COUNT")%></td>
							<td style="text-align:right;color:#9DCEFF"><%=rs1.getInt("APIS_COUNT") == 0 ? "" : rs1.getInt("APIS_COUNT")%></td>
							<td style="text-align:right;color:#9DCEFF" bgcolor="<%=bgcolor%>"><%=rs1.getString("TIME_DIFFERENCE") == null ? "" : rs1.getString("TIME_DIFFERENCE")%></td>
							<td style="text-align:right;color:#9DCEFF"><%=rs1.getString("PROCESS_TIME_DIFFERENCE") == null ? "" : rs1.getString("PROCESS_TIME_DIFFERENCE")%></td>
							<td style="text-align:right;color:#9DCEFF"><%=rs1.getInt("EVISA_COUNT") == 0 ? "" : rs1.getInt("EVISA_COUNT")%></td>
							<td style="text-align:right;color:#9DCEFF"><%=rs1.getInt("BIOMETRIC_COUNT") == 0 ? "" : rs1.getInt("BIOMETRIC_COUNT")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("FIRST_PAX_TIME") == null ? "" : rs1.getString("FIRST_PAX_TIME")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("LAST_PAX_TIME") == null ? "" : rs1.getString("LAST_PAX_TIME")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("PAX_CLEARED_95") == null ? "" : rs1.getString("PAX_CLEARED_95")%></td>
							<td style="text-align:left;color:#9DCEFF"><%=rs1.getString("FLIGHT_CLEARED_TIME") == null ? "" : rs1.getString("FLIGHT_CLEARED_TIME")%></td>
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
							<td style="text-align:left;"><%=rs.getString("ICP_SRNO")%></td>
							<td style="text-align:left;"><%=rs.getString("FLIGHT_NO")%></td>
							<td style="text-align:left;"><%=rs.getString("SCHEDULE_TIME")%></td>
							<td style="text-align:left;" colspan="14">&nbsp;</td>
							
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
<%
			///////////////////////////////////////////
		
	}
	catch(Exception e)
	{
		out.println(e);
		e.printStackTrace();
	}
	finally
	{
		con.close();
	}
	java.util.Date end_time = new java.util.Date();
	String vend_time = vDateFormat.format(end_time);	

%>
<br><br><table align="center" width="100%" border="0">
<tr style="border-color:red;font-family: Verdana; font-size: 8pt; color:blue;font-weight: bold">
<td><center>################ End of Time <%=vend_time %> ################</center></td>
</tr>
</table>
</body>
</html>