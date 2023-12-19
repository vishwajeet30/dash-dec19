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
Statement stmtTemp = null;
Statement stmtTempN = null;
Statement st_icp = con.createStatement();
ResultSet rs_icp = null;
ResultSet rsMain = null;
ResultSet rsTemp = null;
ResultSet rsTempN = null;
ResultSet rsTempV = null;
String dashQuery = "";
String depQuery = "";

int displayHours = 12;
int t_Total = 0;
int t_Total_Arr = 0;

String dash = "";
/////////////////////////////////////////////////////////////////////////////////////////////

String requesters_name = request.getParameter("r_name") == null ? "" : request.getParameter("r_name");
String requesters_location = request.getParameter("r_location") == null ? "004" : request.getParameter("r_location");

String filter_ip = request.getParameter("ip") == null ? "10.248.168.222" : request.getParameter("ip");
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


////////////////////////////////////////////////////////////////////////////////////////////%>

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
	height: 385px; 
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
				document.entryfrm.action="im_icp_dashboard_00_test_ip_main_00.jsp?&icp="+document.entryfrm.compare_icp.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value;
				document.entryfrm.submit();
				return true;
		}

		function compare_hrs()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="im_icp_dashboard_00_test_ip_main_00.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				//document.entryfrm.action="test2.jsp?&icp="+document.entryfrm.compare_icp.value+"&default_hrs="+document.entryfrm.default_hrs.value;
				document.entryfrm.submit();
				return true;
		}

</script>


</script>
<%@ page language = "java" import = "java.sql.*, java.io.*, java.awt.*, java.util.*, java.text.*, javax.naming.*, javax.sql.*"%>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

</head>

<%///////////////////////////////////////////////////////////////////////////%>

<body onload="DigitalTime(); StartTimer();" style="background-color: #ffffff;">
  <div class="wrapper">
	<div class="flag-strip"></div>
<!-- 	<header class="bg-white py-1">
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
	</header> -->

<!-- 	<table>
		<thead>
			<tr>
				<th  style="font-family: Arial;background-color: #1780c4; color: #ffffff;"></th>
			</tr>				
		</thead>
	</table> -->
	<table id = "auto-index8" class="table table-sm table-striped">
		<thead>
		<tr id='head1'>
			<th colspan=4 style="font-family: Arial;background-color: #1192e8; color: white; font-size: 30px;text-align: center;padding: 0px;">IP and ICP List</th>
			</tr>
		</thead>
	</table>
	</div>
  </div>

<BR><BR><BR><BR>

<%////////////////////////////////////////////////////////////////////////////////

int ip_Exists = 0;
int ip_ICP_Exists = 0;
String str_icp = "";
String str_icp_ip = "";
String str_icp_ip_check = "";
String icp_list_from_table = "";

try
{
	str_icp_ip_check = "select count(1) as count_rows from imigration.IM_DASHBOARD_IP_ICP_LIST where  IP_ADDRESS = '" + filter_ip + "'";
	stmtTemp = con.createStatement();

	//out.println("<BR>" + str_icp_ip_check);
	rsTemp = stmtTemp.executeQuery(str_icp_ip_check);

	while(rsTemp.next())
	{
		ip_Exists = rsTemp.getInt("count_rows");
		//out.println("<BR>ip_Exists = " + ip_Exists);
	}
	if(rsTemp != null)
	{
		rsTemp.close();
		stmtTemp.close();
	}
}
catch(SQLException e)
{
	out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + str_icp_ip_check + "<BR><BR></b></font>");
}

//////////////////////////////////////////////////////
if(ip_Exists == 0)
{
	try
	{
		str_icp_ip = "INSERT INTO imigration.IM_DASHBOARD_IP_ICP_LIST (IP_ADDRESS, ICP_LIST, REQUESTERS_NAME, REQUESTERS_LOCATION) VALUES ('" + filter_ip + "','" + filter_icp + "','" + requesters_name + "','" + requesters_location + "')";
		//out.println("&nbsp;<BR>" + str_icp_ip);
		stmtTemp = con.createStatement();
		rsTemp = stmtTemp.executeQuery(str_icp_ip);
		if(rsTemp!=null)
		{
			rsTemp.close();
			stmtTemp.close();
		}
		//out.println("<BR><h1><center>Inserting New IP Address and ICP<center><h1>");
%>
	<div class="container">
	<div class="row" style="margin-top: 245px;">
	<div class="col-sm-12">
		<table class="tableDesign">
			<tr style="font-size: 45px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
				<th  style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;"></th>
			</tr>
			<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#ebf8ff;border-color: #004076;width:50%; font-weight: bold;text-align: center;color: #004076;font-size: 27px;"><BR>Granting access to Client IP :  <font style="color:#1780c4;"><%=filter_ip%></font> for <font style="color:#1780c4;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%></font><BR>&nbsp;</td>
			</tr>
		</table>

		<table class="tableDesign">
			<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;"></td>
			</tr>
			<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;"><a href="http://10.248.168.222:8888/Imm/icp_dashboard/im_icp_dashboard_00_test_ip_main_00.jsp" target="_blank" ><button class="btn btn-primary btn-md" type="button"> Home</button></a></td>
			</tr>
		</table>
	</div>
<%
	}
	catch(SQLException e)
	{
		out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + str_icp_ip + "<BR><BR></b></font>");
	}
}

if(ip_Exists > 0)
{
	try
	{
		str_icp_ip_check = "select count(1) as count_rows from imigration.IM_DASHBOARD_IP_ICP_LIST where  IP_ADDRESS = '" + filter_ip + "' and ICP_LIST like '%" + filter_icp + "%'";
		//out.println("<BR>" + str_icp_ip_check);
		stmtTemp = con.createStatement();
		rsTemp = stmtTemp.executeQuery(str_icp_ip_check);
		while(rsTemp.next())
		{
			ip_ICP_Exists = rsTemp.getInt("count_rows");
			//out.println("&nbsp;<BR>ip_ICP_Exists = " + ip_ICP_Exists);
		}
		if(rsTemp!=null)
		{
			rsTemp.close();
			stmtTemp.close();
		}
	}
	catch(SQLException e)
	{
		out.println("<font face='Verdana' color='#FF0000' size='2'><b><BR><BR>!!! " + e.getMessage() + " !!! " + str_icp_ip_check + "<BR><BR></b></font>");
	}

//////////////////////////////////////////////////

	if(ip_ICP_Exists > 0)
	{
%>
		<div class="container">
		<div class="row" style="margin-top: 245px;">
		<div class="col-sm-12">
			<table class="tableDesign">
				<tr style="font-size: 45px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
					<th  style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;"></th>
				</tr>
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
					<td style="background-color:#ebf8ff;border-color: #004076;width:50%; font-weight: bold;text-align: center;color: #004076;font-size: 27px;"><BR>The Client IP Address : <font style="color:#1780c4;"><%=filter_ip%></font> already has access to <font style="color:#1780c4;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%></font><BR>&nbsp;</td>
				</tr>
			</table>
			<table class="tableDesign">
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;">	 </td>
				</tr>
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;">	 <a href="http://10.248.168.222:8888/Imm/icp_dashboard/im_icp_dashboard_00_test_ip_main_00.jsp" target="_blank" ><button class="btn btn-primary btn-md" type="button"> Home</button></a></td>
				</tr>
			</table>
		</div>
<%
	}
	else
	{
		//out.println("<BR><h1><center>Updating ICP List...<center><h1>");
		str_icp_ip = "UPDATE imigration.IM_DASHBOARD_IP_ICP_LIST SET ICP_LIST = ICP_LIST || '#' ||  '" + filter_icp + "' where IP_ADDRESS = '" +  filter_ip + "'";
		//out.println("<BR>" + str_icp_ip);
		stmtTemp = con.createStatement();
		rsTemp = stmtTemp.executeQuery(str_icp_ip);
%>
		<div class="container">
		<div class="row" style="margin-top: 245px;">
		<div class="col-sm-12">
			<table class="tableDesign">
				<tr style="font-size: 45px;  text-align: right; color:white; border-color: #bae6ff;height:20px; ">
					<th  style="text-align: center;background-color:#004076;border-color: #004076;width:40%;text-align: center;"></th>
				</tr>
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
				<td style="background-color:#ebf8ff;border-color: #004076;width:50%; font-weight: bold;text-align: center;color: #004076;font-size: 27px;"><BR>Granting access to Client IP :  <font style="color:#1780c4;"><%=filter_ip%></font> for <font style="color:#1780c4;"><%=capitalizeFirstChar(dash.replace("INTERNATIONAL",""))%></font><BR>&nbsp;</td>
				</tr>
			</table>
			<table class="tableDesign">
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;"></td>
				</tr>
				<tr style="font-size: 25px; font-family: 'Arial', serif; text-align: center; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffffff;border-color: #ffffff;width:50%; font-weight: bold;text-align: center;color: #750e13;"><a href="http://10.248.168.222:8888/Imm/icp_dashboard/im_icp_dashboard_00_test_ip_main_00.jsp" target="_blank" ><button class="btn btn-primary btn-md" type="button"> Home</button></a></td>
				</tr>
			</table>
		</div>
<%  }
}
con.commit();

////////////////////////////////////////////////////////////////////////////////

} catch (Exception e) 
	{
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
