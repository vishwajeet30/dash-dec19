<!--

SELECT b.FLIGHT_SCH_ARR_DATE FLIGHT_SCH_ARR_DATE, b.clearence_range, ( SELECT COUNT(DISTINCT flight_no) FROM IM_APIS@DBL_IVFRT004 a WHERE a.FLIGHT_SCH_ARR_DATE = b.FLIGHT_SCH_ARR_DATE AND b.clearence_range = ( rpad(lpad(floor(a.FLIGHT_SCH_ARR_TIME / 100), 2, 0),4,0) ) ) flights, total, indians, foreigners, male, female, others FROM ( SELECT FLIGHT_SCH_ARR_DATE, ( rpad(lpad(floor(FLIGHT_SCH_ARR_TIME / 10000), 2, 0),4,0) ) clearence_range, COUNT(1) AS total, SUM( CASE WHEN pax_nalty_code = 'IND' THEN 1 ELSE 0 END ) indians, SUM( CASE WHEN pax_nalty_code <> 'IND' THEN 1 ELSE 0 END ) foreigners, SUM( CASE WHEN pax_sex = 'M' THEN 1 ELSE 0 END ) male, SUM( CASE WHEN pax_sex = 'F' THEN 1 ELSE 0 END ) female, SUM( CASE WHEN pax_sex = 'X' THEN 1 ELSE 0 END ) others FROM IM_APIS@DBL_IVFRT004 WHERE FLIGHT_SCH_ARR_DATE >= '22/09/2023' AND FLIGHT_SCH_ARR_DATE <= '27/09/2023' GROUP BY FLIGHT_SCH_ARR_DATE, ( rpad(lpad(floor(FLIGHT_SCH_ARR_TIME / 10000), 2, 0), 4, 0) ) ORDER BY 1, 2, 3 ) b WHERE b.FLIGHT_SCH_ARR_DATE >= '22/09/2023' AND b.FLIGHT_SCH_ARR_DATE <= '27/09/2023'; 


SELECT b.FLIGHT_SCH_ARR_DATE FLIGHT_SCH_ARR_DATE, b.clearence_range, ( SELECT COUNT(DISTINCT flight_no) FROM IM_APIS@DBL_IVFRT004 a WHERE a.FLIGHT_SCH_ARR_DATE = b.FLIGHT_SCH_ARR_DATE AND b.clearence_range = ( rpad(lpad(floor(a.FLIGHT_SCH_ARR_TIME / 100), 2, 0),4,0) ) ) flights, total, indians, foreigners, male, female, others FROM ( SELECT FLIGHT_SCH_ARR_DATE, ( rpad(lpad(floor(FLIGHT_SCH_ARR_TIME / 100), 2, 0),4,0) ) clearence_range, COUNT(1) AS total, SUM( CASE WHEN pax_nalty_code = 'IND' THEN 1 ELSE 0 END ) indians, SUM( CASE WHEN pax_nalty_code <> 'IND' THEN 1 ELSE 0 END ) foreigners, SUM( CASE WHEN pax_sex = 'M' THEN 1 ELSE 0 END ) male, SUM( CASE WHEN pax_sex = 'F' THEN 1 ELSE 0 END ) female, SUM( CASE WHEN pax_sex = 'X' THEN 1 ELSE 0 END ) others FROM IM_APIS@DBL_IVFRT004 WHERE FLIGHT_SCH_ARR_DATE >= '27/09/2023' AND FLIGHT_SCH_ARR_DATE <= '27/09/2023' GROUP BY FLIGHT_SCH_ARR_DATE, ( rpad(lpad(floor(FLIGHT_SCH_ARR_TIME / 100), 2, 0), 4, 0) ) ORDER BY 1, 2, 3 ) b WHERE b.FLIGHT_SCH_ARR_DATE >= '27/09/2023' AND b.FLIGHT_SCH_ARR_DATE <= '27/09/2023';


select fl.flight_no, fl.boarding_date, fl.boarding_time ,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans fl left join im_trans_arr_total  main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date group by fl.flight_no, fl.boarding_date, fl.boarding_time;


select  fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no ,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@DBL_IVFRT004 fl left join im_trans_arr_total@DBL_IVFRT004  main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 1,2,3;



select fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) hours ,count( main_table.PAXLOG_ID) as real_passenger_count , count( apis_table.pax_name) as expected_passegner_count
from im_flight_trans@DBL_IVFRT004 fl 
left join 
im_trans_arr_total@DBL_IVFRT004  main_table 
on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time
left join 
im_apis@DBL_IVFRT004  apis_table 
on fl.flight_no = apis_table.flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date and fl.boarding_time = apis_table.FLIGHT_SCH_ARR_TIME
group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 2,3;


select fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) hours ,count( main_table.PAXLOG_ID) as real_passenger_count , count( apis_table.pax_name) as expected_passegner_count
from im_flight_trans@DBL_IVFRT004 fl 
left join 
im_trans_arr_total@DBL_IVFRT004  main_table 
on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time
left join 
im_apis@DBL_IVFRT004  apis_table 
on fl.flight_no = (apis_table.CARRIER_CODE||'-'||apis_table.flight_no) and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date and fl.boarding_time = apis_table.FLIGHT_SCH_ARR_TIME
group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 2,3;





//////////////////   Query for APIS ///////////////////////////////
select fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) hours  , count( apis_table.pax_name) as expected_passegner_count
from im_flight_trans@DBL_IVFRT004 fl
left join 
im_apis@DBL_IVFRT004  apis_table 
on fl.flight_no = (apis_table.CARRIER_CODE||'-'||apis_table.flight_no) and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date 
group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 2,3;


and fl.boarding_time = apis_table.FLIGHT_SCH_ARR_TIME /// Don't use this for APIS Table Queries 




//////////////////   Query for IM_TRANS_ARR_TOTAL ///////////////////////////////
select fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) hours ,count( main_table.PAXLOG_ID) as real_passenger_count
from im_flight_trans@DBL_IVFRT004 fl 
left join 
im_trans_arr_total@DBL_IVFRT004  main_table 
on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time
group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 2,3;

select distinct CARRIER_CODE||'-'||flight_no from im_apis where FLIGHT_SCH_ARR_Date >= sysdate-10;

select count(1) from

-->



<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,javax.sql.*,java.io.InputStream"%>

<!DOCTYPE html>
<html>
<head>
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

.tabeleDesign {
	margin: 30px;
	border-collapse: separate;
	border-spacing: 0;
	min-width: 350px;
	
}
<%// tr:hover {background-color: coral;}%>


.canvasArrPAXFltActCount 


.tabeleDesign tr th, .tabeleDesign tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tabeleDesign tr th:first-child, .tabeleDesign tr td:first-child {
	border-left: 1px solid #bbb;
}

.tabeleDesign tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}

/* top-left border-radius */
.tabeleDesign tr:first-child th:first-child {
	border-top-left-radius: 10px;
}

/* top-right border-radius */
.tabeleDesign tr:first-child th:last-child {
	border-top-right-radius: 10px;
}

/* bottom-left border-radius */
.tabeleDesign tr:last-child td:first-child {
	border-bottom-left-radius: 10px;
}

/* bottom-right border-radius */
.tabeleDesign tr:last-child td:last-child {
	border-bottom-right-radius: 10px;
}
</style>


<style>
canvas {
   
    background: linear-gradient(to bottom, #ffffff 40%, #fff9b0 100%);
}


.canvasArrPAXFltActCount 
{
    background: linear-gradient(to bottom, #ffffff 40%, #99ccff 100%);
	
}

.tabeleDesign2 {
	margin: 30px;
	border-collapse: separate;
	border-spacing: 0;
	min-width: 100px;
	
}
<%// tr:hover {background-color: coral;}%>


.canvasArrPAXFltActCount 


.tabeleDesign2 tr th, .tabeleDesign tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tabeleDesign2 tr th:first-child, .tabeleDesign tr td:first-child {
	border-left: 1px solid #bbb;
}

.tabeleDesign2 tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}

/* top-left border-radius */
.tabeleDesign2 tr:first-child th:first-child {
	border-top-left-radius: 10px;
}

/* top-right border-radius */
.tabeleDesign2 tr:first-child th:last-child {
	border-top-right-radius: 10px;
}

/* bottom-left border-radius */
.tabeleDesign2 tr:last-child td:first-child {
	border-bottom-left-radius: 10px;
}

/* bottom-right border-radius */
.tabeleDesign2 tr:last-child td:last-child {
	border-bottom-right-radius: 10px;
}
</style>



<style>
body{font-family:Arial, Helvetica, sans-serif;}

.wrapper{margin:0 auto; width:60%;}
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
.main_table th{padding:6px; color:#fff;}
.main_table td{text-align:center; padding:5px;}
.red_table{background: linear-gradient(#ffd2d4, #fff3f4); border: 2px solid #e11a25;}
.red_table th{background: linear-gradient(to left, #ee515a, #e11a25);}
.green_table{background: linear-gradient(#bdf1f4, #e6f9fa); border: 2px solid #317a83;}
.green_table th{background:linear-gradient(to left, #52bac7, #317a83);}
.purple_table{background: linear-gradient(#ebccf9, #f2e7f7); border: 2px solid #7f3f9f;}
.purple_table th{background:linear-gradient(to left, #bf83dd, #7f3f9f);}
.blue_table{background: linear-gradient(#b7e9fc, #def3fb); border: 2px solid #3ba8d1;}
.blue_table th{background:linear-gradient(to left, #94d8f2, #3ba8d1);}
</style>
<script>
		function compare_report()
		{
			
			
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_ankit_copy.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;

		}
</script>

</head>

<body style="background: #fff;">
<div class="heading">
<h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 40px; text-align: center;">Immigration Control System</h1><br>
</div>

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
	DataSource ds = (DataSource)envCtx.lookup("jdbc/im_pax_flights");
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
	
////////////////////	Arrival/Departure PAX Count	Tabs	/////////////////////////

		// DateFormat vDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
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
		   
			</select><font face="Verdana" color="#0000FF" size="2"><b>&nbsp;&nbsp;ICP&nbsp;&nbsp;</b><select name="compare_icp">
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


/************************************** Start : Flight Count Statistics *******************************************/

	
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
		out.println(current_hour);

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
				int current_hour_in_int = Integer.parseInt(current_hour);

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;
					
					int current_row_hour_in_int = Integer.parseInt(keyValue.split("#####")[1]);
					
					if(current_row_hour_in_int > current_hour_in_int)
						future_flag = true;

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
														</table>
														
														<%if( future_flag == false && serial_no%2==0){%>
															<table class="main_table red_table" width="100%">
														<%}else if( future_flag == false && serial_no%2!=0) {%>
															<table class="main_table green_table" width="100%">
														<%}
														else if( future_flag != false && serial_no%2==0){%>
															<table class="main_table purple_table" width="100%">
														<%}else if( future_flag != false && serial_no%2!=0) {%>
															<table class="main_table blue_table" width="100%">
														<%}
													
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(future_flag == false)
															{
																if(serial_no%2==0)
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style="font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
															else
															{
																if(serial_no%2==0)
																{%>
																	<tr >
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
																else
																{%>
																	<tr>
																		<td style="font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																		<td style=" font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																	</tr>
																<%}
															}
														}
													%>
													<tr>
														<th style="font-weight: bold;text-align: left;" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%>&nbsp;</th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

								
					</table><BR><BR> <%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and ARRIVAL Statistics ////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////// Start : Combined APIS and DEPARTURE Statistics ////////////////////////////////////////////////////////////////////////

	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "( select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_dep_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) <= " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 " + " union " + "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis_pax_dep@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = apis_table.pax_flight_no and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) > " + current_hour  +  " and fl.flight_type = 'D' group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 ) order by 1,3,passenger_count desc";

		out.println(strSqlFlightDetails);

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
				int current_hour_in_int = Integer.parseInt(current_hour);

				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;
					
					int current_row_hour_in_int = Integer.parseInt(keyValue.split("#####")[1]);
					
					if(current_row_hour_in_int > current_hour_in_int)
						future_flag = true;

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
														</table>
														<%if( future_flag == false && serial_no%2==0){%>
															<table class="main_table red_table" width="100%">
														<%}else if( future_flag == false && serial_no%2!=0) {%>
															<table class="main_table green_table" width="100%">
														<%}
														else if( future_flag != false && serial_no%2==0){%>
															<table class="main_table purple_table" width="100%">
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
														<th style="font-weight: bold;text-align: left;" colspan="2"><%=convertToAmPm(keyValue.split("#####")[1])%>&nbsp;</th>
													</tr>
												</table>
											</td>
					<%		
				}
				%>				</tr>

							
					</table><BR><BR><%

	}

	////////////////////////////////////////////////////////////// End : Combined APIS and DEP Statistics ////////////////////////////////////////////////////////////////////////


	//////////////////////////////////////////////////////////////Start : IM_TRANS_ARR_TOTAL_STATISTICS /////////////////////////////////////////////////////////////////////////
	
	
	{
		String icp_sr_no = filter_icp;

		String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 order by 1,3,passenger_count desc";

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
							<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;text-align:right;" align="center" bordercolorlight="black" bordercolordark="black" bordercolor="black" border="0"  cellpadding="0" cellspacing="0" width="100%"> 
							
								
								<tr>
				<%
				serial_no = 0;
				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;

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
														</table>
														<table  style="padding:1px 1px;border-collapse: collapse;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="black" bordercolordark="black" bordercolor="white" border=2;  width="100%" cellpadding="0" cellspacing="0">
													
													<%
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(serial_no%2==0)
															{%>
																<tr>
																	<td style="background-color:#fb666e;border-color: #00539a;width:25%;font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																	<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																</tr>
															<%}
															else
															{%>
																<tr>
																	<td style="background-color:#38acff;border-color: #00539a;width:25%;font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																	<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																</tr>
															<%}
														}
													%>
												</table>
											</td>
					<%		
				}
				%>				</tr>

								<tr style="background-color:#E6E6EA;font-weight:bold">
									<%
										for(String keyValue:borDateHoursFlightnameCountPair.keySet())
										{
									%>									
											<!--<td style="text-align:center;"><%=keyValue.split("#####")[0]%> : <%=keyValue.split("#####")[1]%></td>-->
											<td style="text-align:center;"><%=keyValue.split("#####")[1]%></td>
									<%	
										}
									%>
								</tr>
					</table><BR><BR><%

	}
	
	
	
	//////////////////////////////////////////////////////////////End : IM_TRANS_ARR_TOTAL_STATISTICS /////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////// Start : APIS Flight Statistics ////////////////////////////////////////////////////////////////////////////////

	{
		
		
		String icp_sr_no = filter_icp;



		//String strSqlFlightDetails = "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = (apis_table.CARRIER_CODE||'-'||apis_table.flight_no) and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) order by 2,3,passenger_count desc";

		String strSqlFlightDetails = "select fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no, count( apis_table.pax_name) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl left join  im_apis@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " apis_table on fl.flight_no = (apis_table.CARRIER_CODE||'-'||apis_table.flight_no) and fl.boarding_date = apis_table.FLIGHT_SCH_ARR_Date where fl.flight_no not in ('TRNG') and substr(fl.boarding_time,0,2) >= " + current_hour  +  " group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( apis_table.pax_name) > 0 order by 1,3,passenger_count desc";


		//String strSqlFlightDetails = "select  fl.boarding_date boarding_date, fl.boarding_time boarding_time, substr(fl.boarding_time,0,2) hours, fl.flight_no flight_no,count( main_table.PAXLOG_ID) as passenger_count from im_flight_trans@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " fl  left join im_trans_arr_total@" + icp_srno_dba_link.get(icp_sr_no).get_db_link() + " main_table on fl.flight_no = main_table.pax_flight_no and fl.boarding_date = main_table.pax_boarding_date and fl.boarding_time = main_table.pax_boarding_time where fl.flight_no not in ('TRNG') group by fl.flight_no, fl.boarding_date, fl.boarding_time, substr(fl.boarding_time,0,2) having count( main_table.PAXLOG_ID) > 0 order by 1,3,passenger_count desc";

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
							<table  style="padding:1px 1px;border-collapse: collapse;background-color:#FFFFFF;font-family:verdana;font-size:10pt;text-align:right;" align="center" bordercolorlight="black" bordercolordark="black" bordercolor="black" border="0"  cellpadding="0" cellspacing="0" width="100%"> 
							
								
								<tr>
				<%
				serial_no = 0;
				for(String keyValue:borDateHoursFlightnameCountPair.keySet())
				{

					serial_no++;
					int currentFlightInHour = borDateHoursFlightnameCountPair.get(keyValue).split("####").length;
					int differenceInFlightInHour = maxFlightInHour - currentFlightInHour;

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
														</table>
														<table  style="padding:1px 1px;border-collapse: collapse;font-family:verdana;font-size:10pt;" align="center" bordercolorlight="black" bordercolordark="black" bordercolor="white" border=2;  width="100%" cellpadding="0" cellspacing="0">
													
													<%
														for(int i = 0 ;i<borDateHoursFlightnameCountPair.get(keyValue).split("####").length;i++)
														{
															if(serial_no%2==0)
															{%>
																<tr>
																	<td style="background-color:#fb666e;border-color: #00539a;width:25%;font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																	<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																</tr>
															<%}
															else
															{%>
																<tr>
																	<td style="background-color:#38acff;border-color: #00539a;width:25%;font-weight: bold;text-align: left;" ><%=borDateHoursFlightnameCountPair.get(keyValue).split("####")[i].split("##")[0].replace("-","&#8209;")%>&nbsp;</td>
																	<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;" align="right"><%=(borDateHoursFlightnameCountPair.get(keyValue).split("####")[i]).split("##")[1]%></td>
																</tr>
															<%}
														}
													%>
												</table>
											</td>
					<%		
				}
				%>				</tr>

								<tr style="background-color:#E6E6EA;font-weight:bold">
									<%
										for(String keyValue:borDateHoursFlightnameCountPair.keySet())
										{
									%>									
											<!--<td style="text-align:center;"><%=keyValue.split("#####")[0]%> : <%=keyValue.split("#####")[1]%></td>-->
											<td style="text-align:center;"><%=keyValue.split("#####")[1]%></td>
									<%	
										}
									%>
								</tr>
					</table><BR><BR><%

	}

	////////////////////////////////////////////////////////////// End : APIS Flight Statistics//////////////////////////////////////////////////////////////////////////////



/************************************** End : Flight Count Statistics *******************************************/





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
<div class="row">
	<div class="column2" style="border-radius: 20px;">
		<div class="box_main red" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-plane-arrival"></i>
				</div>
				<div>
					<table>
						<tr>
							<td><h1 id="countArr"></h1></td>
							<td>Total Arrival Footfall</td>
						</tr>
						<tr>
							<td><h2 id="countArrY"></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
						</tr>
						<tr>
							<td><h3 id="countArrT"></h3></td>
							<td style="font-size:12px">Today's Footfall</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>



	<%
///////////////////////////////////////////////////////////////////////////////////////




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
%>

	<div class="column2" style="border-radius: 20px;">
		<div class="box_main blue" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-plane-departure"></i>
				</div>
				<div>
					<table>
						<tr>
							<td><h1 id="count_total_Dep_Count"></h1></td>
							<td>Total Departure Footfalls</td>
						</tr>
						<tr>
							<td><h2 id="count_total_Dep_CountY"></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
						</tr>
						<tr>
							<td><h3 id="count_total_Dep_CountT"></h3></td>
							<td style="font-size:12px">Today's Footfall</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	



	<div class="column2" style="border-radius: 20px;">
		<div class="box_main orange" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-chart-simple"></i>
				</div>
				<div>
					<table>
						<tr>
							<td><h1 id="total_PAX"></h1></td>
							<td>Total Footfalls</td>
						</tr>
						<tr>
							<td><h2 id="total_PAX_Y"></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
						</tr>
						<tr>
							<td><h3 id="total_PAX_T"></h3></td>
							<td style="font-size:12px">Today's Total Footfall</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<%




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
	%>
	<div class="row">

	<div class="column2" style="border-radius: 20px;">
		<div class="box_main red" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-plane-arrival"></i>
				</div>
				<div>
					<table>
						<tr>
							<td><h1 id="countArrFlt"></h1></td>
							<td>Total Arrival Flights</td>
						</tr>
						<tr>
							<td><h2 id="countArrFltY"></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
						</tr>
						<tr>
							<td><h3 id="countArrFltT"></h3></td>
							<td style="font-size:12px">Today's Flights</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<%
	
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
	<div class="column2" style="border-radius: 20px;">
		<div class="col-lg-4">
			<div class="box_main blue" style="border-radius: 20px;">
				<div class="d_flex">
					<div class="icon">
						<i class="fa-solid fa-plane-departure"></i>
					</div>
					<div>
						<table>
							<tr>
								<td><h1 id="count_total_Dep_Flights"></h1></td>
								<td>Total Departure Flights</td>
							</tr>
							<tr>
								<td><h2 id="count_total_Dep_FlightsY"></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
							</tr>
							<tr>
								<td><h3 id="count_total_Dep_FlightsT"></h3></td>
							<td style="font-size:12px">Today's Flights</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="column2" style="border-radius: 20px;">
		<div class="box_main orange" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-chart-simple"></i>
				</div>
				<div>
					<table>
						<tr>
							<td><h1 id="total_Flights"></h1></td>
							<td>Total Flights</td>
						</tr>
						<tr>
							<td><h2 id="total_Flights_Y" ></h2></td>
							<td style="font-size:12px"><%=yesterday_date%></td>
						</tr>
						<tr>
							<td><h3 id="total_Flights_T"></h3></td>
							<td style="font-size:12px">Today's Total Flights</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>


</div>

<div class="row">
	<div class="column3" style="border-radius: 20px;">
		<div class="box red" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-globe"></i>
				</div>
				<div>
					<h2 id="count1"></h2>
					<p>hello world!</p>
				</div>
			</div>
		</div>
	</div>
	<div class="column3" style="border-radius: 20px;">
		<div class="box blue" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-user"></i>
				</div>
				<div>
					<h2 id="count2"></h2>
					<p>hello world!</p>
				</div>
			</div>
		</div>
	</div>
	<div class="column3" style="border-radius: 20px;">
		<div class="box orange" style="border-radius: 20px;">
			<div class="d_flex">
				<div class="icon">
					<i class="fa-solid fa-chart-line"></i>
				</div>
				<div>
					<h2 id="count3"></h2>
					<p>hello world!</p>
				</div>
			</div>
		</div>
	</div>
	<div class="column3" style="border-radius: 20px;">
		<div class="col-lg-4">
			<div class="box green" style="border-radius: 20px;">
				<div class="d_flex">
					<div class="icon">
						<i class="fa-solid fa-chart-simple"></i>
					</div>
					<div>
						<h2 id="count4"></h2>
						<p>hello world!</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="column3" style="border-radius: 20px;">
		<div class="col-lg-4">
			<div class="box voilet" style="border-radius: 20px;">
				<div class="d_flex">
					<div class="icon">
						<i class="fa-solid fa-chart-pie"></i>
					</div>
					<div>
						<h2 id="count5"></h2>
						<p>hello world!</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="column3" style="border-radius: 20px;">
		<div class="col-lg-4">
			<div class="box yellow" style="border-radius: 20px;">
				<div class="d_flex">
					<div class="icon">
						<i class="fa-solid fa-chart-pie"></i>
					</div>
					<div>
						<h2 id="count6"></h2>
						<p>hello world!</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>






<!-- CHARTS -->


<div class="heading">
<br><br><br>
<h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 35px;text-align: left;">Biometric</h1><br><br><br>
</div>

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
%>

	
<%
	//////////////////////////////////////////////	Types of Bio in last 7 hours - Start	////////////////////////////////////////////////////
	String hourlyBioQuery = "";
	String hourlyBioYAxis = "";
	int hourlyBioEnrolledCount = 0;
	int hourlyBioVerifiedCount = 0;
	int hourlyBioExemptedCount = 0;
	

	StringBuilder hourlyBio = new StringBuilder();
	StringBuilder hourlyBioEnrolled = new StringBuilder();
	StringBuilder hourlyBioVerified = new StringBuilder();
	StringBuilder hourlyBioExempted = new StringBuilder();

	 boolean flagFlightCount = false;
	try {
		hourlyBioQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,HOURLY_BIO_ENROLLED,HOURLY_BIO_VERIFIED,HOURLY_BIO_EXEMPTED, table_type from im_dashboard_combined where pax_boarding_date >= trunc(sysdate-1) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date desc,HOURS desc ) where rownum<=7";
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
	
	%>
	<div class="row">
	<div class="column">
	<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Types of Bio in last 7 hours</h1>

		<canvas id="canvasHourlyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #8ecddd 100%);"></canvas>
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
<%//////////////////////////////////////	Types of Bio in last 7 hours - End	/////////////////////////////////%>


<%//////////////////////////////////////////////	Types of Bio in last 7 days - Start	////////////////////////////////////////////////////
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
	<div class="column">
	<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Types of Bio in last 7 days</h1>

		<canvas id="canvasWeeklyBio" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);"></canvas>
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
		
		//Code to draw Chart

		var ctx = document.getElementById('canvasWeeklyBio').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

<%//////////////////////////////////////	Types of Bio in last 7 days - End	/////////////////////////////////%>


<%////////////////	Table - Types of Bio in last 7 hours - Start	///////////////////////%>

<div class="row">
		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Bio in last 7 hours
	
</caption>
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%;">Time</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Bio Enrolled</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Bio Verified</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Bio Exempted</th>
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

			for (int i = 0; i < hourListBio.length; i++) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#38acff;border-color: #00539a;width:25%; font-weight: bold;"><%=hourListBio[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioEnrolled[i]%></td>
				<td style="background-color:#86cdff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioVerified[i]%></td>
				<td style="background-color:#cceaff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourBioExempted[i]%></td>
			</tr>
<%
			}
			%>
		</table>	
	<%///////////////////////	Table - Types of Bio in last 7 hours - End	////////////////////////%>
	

	<%////////////////	Table -  Types of Bio in last 7 days - Start	///////////////////////%>

		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Bio in last 7 days
</caption>
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Bio Enrolled</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Bio Verified</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Bio Exempted</th>
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
				<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;"><%=weekListBioDays[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioEnrolledDays[i]%></td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioVerifiedDays[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=weeklyBioExemptedDays[i]%></td>

			</tr>
<%
			}
			%>
		</table>	

</div>	
	<%///////////////////////	Table - Types of Bio in last 7 days - End	////////////////////////%>







<div class="heading">
<br>
<h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 35px;text-align: left;">Hourly Count</h1><br>
</div>

<div class="row">

	<%
	////////////////////////////////////////////	Hourly Count of Arrival Flights - Start	////////////////////////////////////////////////////

	String hours_Axis = "";
	String hourly_flight_count_Axis = "";

	

	StringBuilder hourlyArrAxis = new StringBuilder();
	StringBuilder hourlyArrFlt = new StringBuilder();

	//String hourSet = "";

	boolean zero_entry_Arr = false;
	try {
		dashQuery = "select to_date(hours,'HH24mi') as date_time, icp_description, hours,hourly_flight_count,active_counter_count,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_ARR_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) order by HOURS asc";
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
	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly
			Count of Arrival Flights</h1>
		<canvas id="myPlot1" class="chart" style="max-width: 100%;background: linear-gradient(to bottom, #ffffff 35%, #ffd8d8 100%);"></canvas>
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
				        xAxes: [{
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
							ctx.fillText(data, bar._model.x - 10, bar._model.y + 7);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot1').getContext('2d');
		var myChartsssssss = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataaaaaa,    	// Chart data
			options: myoptionsssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</div>
	<%	////////////////////////////////////////////	Hourly Count of Arrival Flights - End	////////////////////////////////////////////////////%>



	
	<%////////////////////////////////////////////	Hourly Count of Departure Flights - Start	////////////////////////////////////////////////////

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
		depQuery = "select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24miss') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count from im_dashboard_combined where table_type = 'IM_TRANS_DEP_TOTAL' and ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate)";
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
	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Hourly
			Count of Departure Flights</h1>

		<canvas id="myPlot2" class="chart" style="max-width: 100%;  background: linear-gradient(to bottom, #ffffff 35%, #c4f2fa 100%);"></canvas>
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
				        xAxes: [{
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
							ctx.fillText(data, bar._model.x - 10, bar._model.y + 7);
							
						});
					});
				}
			}
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('myPlot2').getContext('2d');
		var myChartssssss = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myDataaaaa,    	// Chart data
			options: myoptionssssss 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
	</div>
</div>
<%
///////////////////////////////////////	Hourly Count of Departure Flights - End	/////////////////////////////////////////////%>


<%////////////////	Table - Hourly Count of Arrival Flights - Start	///////////////////////%>

<div class="row">
		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Hourly Count of Arrival Flights

	
</caption>			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:50%; text-align: center;">Time</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:50%; text-align: right;">Arrival Flights</th>

			</tr>
			
				
					
		<% 
			/*String strhours_Axis = hourlyArrAxis.toString();
				String strhourly_flight_count_Axis = hourlyArrFlt.toString();*/
			String[] hourListArrFlt = strhours_Axis.toString().replace("\"", "").split(",");
			String[] hourListArrFltCount = strhourly_flight_count_Axis.split(",");
			

			for (int i = 0; i < hourListArrFlt.length; i++) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: center;"><%=hourListArrFlt[i]%></td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=hourListArrFltCount[i]%></td>


			</tr>
<%
			}
			%>
		</table>
	<%///////////////////////	Table - Hourly Count of Arrival Flights - End	////////////////////////%>

<%////////////////	Table - Hourly Count of Departure Flights - Start	///////////////////////%>

		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Hourly Count of Departure Flights

	
</caption>
<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%;">Time</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Arrival Flights</th>
				</tr>
		
		<% 
			/*String strhours_Axis_Dep = hourlyDepAxis.toString();
			String strhourly_flight_count_Axis_Dep = hourlyDepFlt.toString();*/
			String[] hourListDepFlt = strhours_Axis_Dep.toString().replace("\"", "").split(",");
			String[] hourListDepFltCount = strhourly_flight_count_Axis_Dep.split(",");
			

			for (int i = 0; i < hourListDepFlt.length; i++) {
			%>



			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#38acff;border-color: #00539a;width:25%; font-weight: bold;"><%=hourListDepFlt[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=hourListDepFltCount[i]%></td>

			</tr>
<%
			}
			%>
		</table>
		</div>
	<%///////////////////////	Table - Hourly Count of Departure Flights - End	////////////////////////%>



<div class="heading">
<br><br><h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 35px;text-align: left;">Arrival and Departure Immigration Clearance in last 7 hours
</h1><br><br>
</div>
	<%////////////////////	Arrival : PAX, Flight and Active Counters for last 7 hours - Start	////////////////////////

StringBuilder hourlyTime = new StringBuilder();
StringBuilder hourlyPax = new StringBuilder();
StringBuilder hourlyFlight = new StringBuilder();
StringBuilder hourlyActiveCounter = new StringBuilder();

	String hourSet_Arrpfa = "";
	java.util.Date v_hourSet_Arrpfa = null;
	//DateFormat vArrDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DateFormat vArrDateFormat = new SimpleDateFormat("MMM-dd HH");

boolean flagPaxCount = false;
try {
	arrHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<=7";
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

 <div class="row">

	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			: PAX, Flight and Active Counters for last 7 hours</h1>

		<canvas id="canvasArrPAXFltActCount" class="chart"
			style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #e5a4ba 100%);
			"></canvas>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Arrival Footfalls",
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
		depHourlyQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_flight_count,active_counter_count,pax_boarding_date,hourly_pax_count  from im_dashboard_combined where pax_boarding_date = trunc(sysdate) and table_type = 'IM_TRANS_DEP_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<=7";
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


	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Departure
			: PAX, Flight and Active Counters for last 7 hours</h1>

		<canvas id="canvasDepPAXFltActCount" class="chart"
			style="max-width: 100%;      background: linear-gradient(to bottom, #ffffff 35%, #75ebff 100%);"></canvas>
	</div>
</div>
<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyTime)%>],
			datasets: [{ 
				  label: "Departure Footfalls",
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


<%////////////////	Table - Arrival : PAX, Flight and Active Counters for last 7 hours - Start	///////////////////////%>

<div class="row">
		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival Clearance in last 7 hours
</caption>
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%;">Time</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">PAX&nbsp;Clearance</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Active&nbsp;Flights</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:25%; text-align: right;">Active&nbsp;Counters</th>
				</tr>
		<% 
			String[] weekList = hourlyTime.toString().replace("\"", "").split(",");
			String[] arrPax = strHourlyArrPax.split(",");
			String[] arrFlight = strHourlyArrFlight.split(",");
			String[] arrCounter = strHourlyArrActiveCounter.split(",");
			String v_date_Format  = "";
			for (int i = 0; i < weekList.length; i++) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#38acff;border-color: #00539a;width:25%; font-weight: bold;"><%=weekList[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=arrPax[i]%></td>
				<td style="background-color:#86cdff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=arrFlight[i]%></td>
				<td style="background-color:#cceaff;border-color: #00539a;width:25%; font-weight: bold; text-align: right;"><%=arrCounter[i]%></td>
			</tr>
<%
			}
			%>
		</table>	
	<%///////////////////////	Table - Arrival : PAX, Flight and Active Counters for last 7 hours - End	////////////////////////%>
	
	<%////////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - Start	/////////////////////////%>
	
		<table class="tabeleDesign" style="width:100%">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Departure Clearance in last 7 hours</caption>
			
				<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
					<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:25%; font-weight: bold;">Time</th>
					<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"'>PAX Clearance</th>
					<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;">Active Flights</th>
					<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:25%; text-align: right;">Active Counters</th>
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
			String d_date_Format  = "";

			for (int i = 0; i < depWeekList.length; i++) {
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:25%; font-weight: bold;"><%=depWeekList[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=depPax[i]%></td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=depFlight[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:25%; font-weight: bold; text-align: right;"><%=depCounter[i]%></td>
			</tr>

			<%
			}
			%>
		</table>
</div>	
<% /////////////////	Table - Departure : PAX, Flight and Active Counters for last 7 hours - End	/////////////////////%>



<div class="heading">
<br><h1 style="font-family: Arial;background-color: #D0DDEA; color: #347FAA; font-size: 35px;text-align: left;">Visa</h1><br><br>
</div>
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
<div class="row">
	<div class="column">
	<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Types of Visa in last 7 days</h1>

		<canvas id="canvasWeeklyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #f79bbe 100%);"></canvas>
	</div>
	
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDaysVisa%>],
			datasets: [{ 
				  label: "E Visa",
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


<%
	//////////////////////////////////////////////	Types of Visa in last 7 hours - Start	////////////////////////////////////////////////////
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
		hourlyVisaQuery = "select * from (select to_date(to_char(pax_boarding_date,'dd/mm/yyyy')||':'||hours,'dd/mm/yyyy:HH24mi') as date_time, to_char(pax_boarding_date,'Mon-dd') as show_date,icp_description,hours,hourly_evisa_count,hourly_voa_count,hourly_regular_visa_count,hourly_visa_exempted_count,hourly_oci_count,hourly_foreigner_count, table_type from im_dashboard_combined where pax_boarding_date =trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL' and icp_srno = '" + filter_icp + "' order by pax_boarding_date,HOURS desc ) where rownum<=7";
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
	<div class="column">
	<h1 style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
	 background-color: #ffffff">Types of Visa in last 7 hours</h1>

		<canvas id="canvasHourlyVisa" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #ffa5bf 100%);"></canvas>
	</div>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=reverseOnComma(strHourlyVisa)%>],
			datasets: [{ 
				  label: "E Visa",
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

		var ctx = document.getElementById('canvasHourlyVisa').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'bar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
<%//////////////////////////////////////	Types of Visa in last 7 hours - End	/////////////////////////////////%>




<%////////////////	Table - Types of Visa in last 7 days - Start	///////////////////////%>

<div class="row">
		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 days
</caption>
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%;">Date</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">E Visa</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">OCI</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">Regular</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">VOA</th>

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
				<td style="background-color:#38acff;border-color: #00539a;width:20%; font-weight: bold;"><%=weekListWeekly[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=eVisaWeekly[i]%></td>
				<td style="background-color:#86cdff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=OCIWeekly[i]%></td>
				<td style="background-color:#cceaff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=RegularWeekly[i]%></td>
				<td style="background-color:#cceaff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=VOAWeekly[i]%></td>
			</tr>
<%
			}
			%>
		</table>	
	<%///////////////////////	Table - Types of Visa in last 7 days - End	////////////////////////%>
	

	<%////////////////////	Table - Types of Visa in last 7 hours - Start	/////////////////////////%>
	
		<table class="tabeleDesign" style="width:100%">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Types of Visa in last 7 hours
</caption>
			
				<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%;">Time</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">E Visa</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">OCI</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Regular</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">VOA</th>
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

			for (int i = 0; i < WeekListVisaHourly.length; i++) {

				/*if (Integer.parseInt( depWeekList[i].substring(11,13)) >= 0 & Integer.parseInt( depWeekList[i].substring(11,13)) <= 11)
				d_date_Format = depWeekList[i].substring(8,10) + "/" + depWeekList[i].substring(5,7) + "/" + depWeekList[i].substring(0,4) + " " + depWeekList[i].substring(11,13) + " AM" ;

			if (Integer.parseInt( depWeekList[i].substring(11,13)) >= 12 & Integer.parseInt( depWeekList[i].substring(11,13)) <= 23)
				d_date_Format = depWeekList[i].substring(8,10) + "/" + depWeekList[i].substring(5,7) + "/" + depWeekList[i].substring(0,4) + " " + depWeekList[i].substring(11,13) + " PM" ;
*/
			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:20px;">
				<td style="background-color:#fb666e;border-color: #da1e28;width:20%; font-weight: bold;"><%=WeekListVisaHourly[i]%></td>
				<td style="background-color:#ff888e;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=eVisa[i]%></td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=OCIVisaHourly[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=RegularVisaHourly[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=VOAVisaHourly[i]%></td>

			</tr>

			<%
			}
			%>
		</table>
</div>	
<% /////////////////	Table - Types of Visa in last 7 hours - End	/////////////////////%>




<%////////////////////////	Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////

StringBuilder weekDays = new StringBuilder();
StringBuilder weekArrPax = new StringBuilder();
StringBuilder weekDepPax = new StringBuilder();

flagPaxCount = false;
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

<div class="row">

	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
			and Departure Immigration Clearance in last 7 days</h1>

		<canvas id="canvasPAX" class="chart" style="max-width: 100%;    background: linear-gradient(to bottom, #ffffff 35%, #b1d2d8 100%);"></canvas>
	</div>
	<script>
		// Data define for bar chart

		var myData = {
			labels: [<%=strWeekDays%>],
			datasets: [{ 
				  label: "Arrival Footfalls",
			      backgroundColor: "#79E0EE",
			      borderColor: "MediumSeaGreen",
			      borderWidth: 1,
			      data: [<%=strweekArrPax%>]
			}, { 
				  label: "Departure Footfalls",
			      backgroundColor: "#BEADFA",
			      borderColor: "Violet",
			      borderWidth: 1,
			      data: [<%=strweekDepPax%>]
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
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var metas = chartInstances.controller.getDatasetMeta(i);
						metas.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x - 22, bar._model.y + 6);
							
						});
					});
				}
			},
			
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasPAX').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

	<%
	///////////////////////////	  Arrival and Departure Immigration Clearance in last 7 days - End	///////////////////////////////
	%>

	<%
	//////////////////////////////////	Arrival and Departure Flights in last 7 days - Start	////////////////////////////////////

	StringBuilder weekDaysFlights = new StringBuilder();
	StringBuilder weekArrFlights = new StringBuilder();
	StringBuilder weekDepFlights = new StringBuilder();

	flagFlightCount = false;
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

	<div class="column">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif; background-color: #ffffff">Arrival
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
				        xAxes: [{
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
					ctx.font = "bold 11px Verdana";

					this.data.datasets.forEach(function (dataset, i) {
						var meta = chartInstance.controller.getDatasetMeta(i);
						meta.data.forEach(function (bar, index) {
							var data = dataset.data[index];
							ctx.fillText(data, bar._model.x - 12, bar._model.y + 6);

						});
					});
				}
			}
		};

		//Code to drow Chart

		var ctx = document.getElementById('canvasFlights').getContext('2d');
		var myChart = new Chart(ctx, {
			type: 'horizontalBar',    	// Define chart type
			data: myData,    	// Chart data
			options: myoption 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>
</div>


<%///////////////////////////////	Arrival and Departure Flights in last 7 days - End	/////////////////////////////////////////%>

<%////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - Start	///////////////////////%>

<div class="row">
		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Immigration Clearance in last 7 days

</caption>
			
				<tr style="font-size: 16px;  text-align: right; color:white; border-color: #003a6d;height:40px;">
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%;">Date</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">Arrival Footfall</th>
					<th style="text-align: center;background-color:#00539a;border-color: #00539a;width:20%; text-align: right;">Departure Footfall</th>
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
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:18px;">
				<td style="background-color:#38acff;border-color: #00539a;width:20%; font-weight: bold;"><%=weekListPAX[i]%></td>
				<td style="background-color:#50b6ff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=weeklyArrPAX[i]%></td>
				<td style="background-color:#86cdff;border-color: #00539a;width:20%; font-weight: bold; text-align: right;"><%=weeklyDepPAX[i]%></td>

			</tr>
<%
			}
			%>
		</table>	
	<%///////////////////////	Table -  Arrival and Departure Immigration Clearance in last 7 days - End	////////////////////////%>

	<%////////////////	Table -  Arrival and Departure Flights in last 7 days - Start	///////////////////////%>

		<table class="tabeleDesign" style="width:100%;">
			<caption style="font-size: 22px; color: grey; line-height: 50px; text-align: center; padding-top: 5px;font-weight: bold; font-family: 'Arial', serif;">Arrival and Departure Flights in last 7 days</caption>
			
			<tr style="font-size: 16px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%;">Date</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Arrival Flights</th>
				<th style="text-align: center;background-color:#da1e28;border-color: #da1e28;width:20%; text-align: right;">Departure Flights</th>
			</tr>
		<% 

			/*	String strWeekDaysFlights = weekDaysFlights.toString();
				String strweekArrFlights = weekArrFlights.toString();
				String strweekDepFlights = weekDepFlights.toString();*/
			

			String[] weekListFlights = strWeekDaysFlights.toString().replace("\"", "").split(",");
			String[] weeklyArrFlights = strweekArrFlights.split(",");
			String[] weeklyDepFlights = strweekDepFlights.split(",");
			for (int i = 0; i < weekListFlights.length; i++) {
	

			%>
			<tr style="font-size: 16px; font-family: 'Arial', serif; text-align: center;height:18px;">
				<td style="background-color:#ff888e;border-color: #da1e28;width:20%; font-weight: bold;"><%=weekListFlights[i]%></td>
				<td style="background-color:#ffb3b8;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyArrFlights[i]%></td>
				<td style="background-color:#ffd7d9;border-color: #da1e28;width:20%; font-weight: bold; text-align: right;"><%=weeklyDepFlights[i]%></td>

			</tr>
<%
			}
			%>
		</table>	
	</div>
	<%///////////////////////	Table -  Arrival and Departure Flights in last 7 days - End	////////////////////////%>


<%////////////////////	Pie Chart - Arrival : Daily Indian and Foreigner Count - Start	////////////////////////

int indianCountArr = 0;
int foreignerCountArr = 0;
String arrIndForeignQuery = "";

 flagPaxCount = false;
try {
	arrIndForeignQuery = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) and table_type='IM_TRANS_ARR_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
	psTemp = con.prepareStatement(arrIndForeignQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		
		indianCountArr = rsTemp.getInt("sum_hourly_indian_count");
		foreignerCountArr = rsTemp.getInt("sum_hourly_foreigner_count");
		
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Daily Indian and Foreigner Arrival Count Exception");
}
%><div class="row">

	<div class="column" style="max-width: 27%;">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
			 background-color: #ffffff">Arrival : Daily Indian and Foreigner Count</h1>

		<canvas id="canvasIndianForeignerArr" class="chart"></canvas>
	</div>
	
	<script src="js/chart.min.js"></script>
<script src="js/chartjs-plugin-datalabels.min.js"></script>
	
	<script>
    Chart.register(ChartDataLabels);

		// Data define for bar chart

		var myData = {
				labels: ['Indian count', 'Foreigner count'],
				  datasets: [{
				    data: [<%=indianCountArr%>,<%=foreignerCountArr%>],
				    backgroundColor: [
				      '#f79bbe',
				      '#B5EAEA'
				    ],
				    hoverOffset: 4
				  }]

		};
		 	
		// Options to display value on top of bars

		var myoptions = {
				 title: {
					        fontSize: 14,		
					      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
		       plugins: {
		            datalabels: { // This code is used to display data values
		                anchor: 'end',
		                align: 'top',
		                formatter: Math.round,
		                font: {
		                    weight: 'bold',
		                    size: 16
		                }
		            }
		        }

		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasIndianForeignerArr').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'pie',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>

	<%////////////////////	Pie Chart - Arrival : Daily Indian and Foreigner Count - End	////////////////////////%>

<%////////////////////	Pie Chart - Departure : Daily Indian and Foreigner Count - Start	////////////////////////

int indianCountDep = 0;
int foreignerCountDep = 0;
String depIndForeignQuery = "";

 flagPaxCount = false;
try {
	depIndForeignQuery = "select SUM(HOURLY_INDIAN_COUNT) as sum_hourly_indian_count, SUM(HOURLY_FOREIGNER_COUNT) as sum_hourly_foreigner_count,icp_description,to_char(pax_boarding_date,'Mon-dd') as pax_boarding_date_2, pax_boarding_date,ICP_SRNO,sum(hourly_evisa_count) as sum_evisa_count, sum(hourly_voa_count) as sum_hourly_voa_count, sum(hourly_regular_visa_count) as hourly_regular_visa_count, sum(hourly_visa_exempted_count),sum(hourly_oci_count) as sum_hourly_oci_count,sum(hourly_foreigner_count), table_type from im_dashboard_combined where ICP_SRNO = '" + filter_icp + "' and pax_boarding_date = trunc(sysdate) and table_type='IM_TRANS_DEP_TOTAL'  group by pax_boarding_date,table_type,icp_description,ICP_SRNO order by pax_boarding_date";
	psTemp = con.prepareStatement(depIndForeignQuery);
	rsTemp = psTemp.executeQuery();
	while (rsTemp.next()) {

		
		indianCountDep = rsTemp.getInt("sum_hourly_indian_count");
		foreignerCountDep = rsTemp.getInt("sum_hourly_foreigner_count");
		
	}
	rsTemp.close();
	psTemp.close();

} catch (Exception e) {
	out.println("Daily Indian and Foreigner Departure Count Exception");
}
%>

	<div class="column" style="max-width: 27%;">
		<h1
			style="font-size: 22px; color: grey; line-height: 35px; text-align: center; padding-top: 5px; font-family: 'Arial', serif;
			 background-color: #ffffff">Departure : Daily Indian and Foreigner Count</h1>

		<canvas id="canvasIndianForeignerDep" class="chart"></canvas>
	</div>
	</div>
	

	
	<script>
    Chart.register(ChartDataLabels);

		// Data define for bar chart

		var myData = {
				labels: ['Indian count', 'Foreigner count'],
				  datasets: [{
				    data: [<%=indianCountDep%>,<%=foreignerCountDep%>],
				    backgroundColor: [
				      '#f79bbe',
				      '#B5EAEA'
				    ],
				    hoverOffset: 4
				  }]

		};
		 	
		// Options to display value on top of bars

		var myoptions = {
				 title: {
					        fontSize: 14,		
					      },
			tooltips: {
				enabled: true
			},
			hover: {
				animationDuration: 2
			},
		       plugins: {
		            datalabels: { // This code is used to display data values
		                anchor: 'end',
		                align: 'top',
		                formatter: Math.round,
		                font: {
		                    weight: 'bold',
		                    size: 16
		                }
		            }
		        }
		};
		
		//Code to drow Chart

		var ctx = document.getElementById('canvasIndianForeignerDep').getContext('2d');
		var myCharts = new Chart(ctx, {
			type: 'pie',    	// Define chart type
			data: myData,    	// Chart data
			options: myoptions 	// Chart Options [This is optional paramenter use to add some extra things in the chart].
		});

	</script>


	<%////////////////////	Pie Chart - Departure : Daily Indian and Foreigner Count - End	////////////////////////%>
	
</body>


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
///////////////////////////// Total Footfalls ///////////////////////////////////

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
} finally {
if (con != null)
	con.close();

}

%>

</body>
</html>
