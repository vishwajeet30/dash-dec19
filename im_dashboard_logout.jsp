<%@ page language="java" import="java.sql.*,java.io.*,java.awt.*,java.util.*, java.text.*,javax.naming.*, javax.sql.*"%>
<% 
	

	/* To use logout by destroying  the session, uncomment the line below;*/
	session.invalidate();
	
	
%>
<HTML><HEAD><TITLE>Dashboard Logout Form</TITLE>

<STYLE type="text/css">
	BODY { background: url("im_pax_bg.gif");background-repeat: repeat;}
</STYLE>
<STYLE>
	.javascript { border: 0px solid white; }
	.Button {BACKGROUND-COLOR:#ffffff; BORDER-BOTTOM:#000000 2px solid; BORDER-LEFT:#000000 1px solid; BORDER-RIGHT: #000000 2px solid; BORDER-TOP:#000000 1px solid; COLOR:red; FONT-FAMILY:Verdana; FONT-SIZE:12px; CURSOR:Hand;}
	.input {BACKGROUND-COLOR: #ffffff; BORDER-BOTTOM: #000000 1px solid; BORDER-LEFT: #000000 1px solid; BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; COLOR: #000000; FONT-FAMILY:Verdana; FONT-SIZE: 12px;}
	.DropDown {BACKGROUND-COLOR: #ffffff; COLOR: #000000; FONT-FAMILY:Verdana; FONT-SIZE: 12px; font-weight:normal; Height:12px; Line-Height:12px;}
</STYLE>




<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
</head>
<BODY bgColor="#FFFFFF" onhelp="return openHelpPage()" onKeyDown="return document_onkeypress()" 	ONLOAD="LaunchApp();">
	<table border="0" width="100%">
		<tr>
			<td align="right" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2"><FONT color="#993333" face="Verdana" size="5"><b><I>GOVERNMENT OF INDIA</I></b></FONT></td>
		</tr>
		<tr>
			<td align="center" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2"><FONT color="#993333" face="Verdana" size="6" ><b><I>Immigration Control System</I></b></FONT></td>
			<td align="center" colspan="2"><FONT color="#993333" face="Verdana" size="6" ><b><I>You are not authorised to access this page</I></b></FONT></td>
		</tr>
	</table>
	<br>
	<center><img src="BOILogo.gif" align="center">
	<TABLE align="center" border="0" width="80%">
		<TR>
			<TD colspan="4">&nbsp;</TD>
		</TR> 
		<TR>
			<!-- <TD width="100%" style="text-align: justify">
				<H2><FONT face=arial color=red>Infinity Error:</FONT></H2>
				<P><B>This error has occured for one of the following reasons :</B> 
				<OL>
					<LI><B>You have used Back/Forward/Refresh button of your Browser.</B> 
					<LI><B>You have double clicked on any options/buttons.</B> 
					<LI><B>You have kept the browser window idle for a long time.</B></LI>
				</OL>
				<P><A href="javascript:window.close()" target=_top>Close this window and start the application again.</A>
			</TD> -->
			<TD width="100%" style="text-align: justify">
				<H2><FONT face=arial color=red>Logout / Infinity Error:</FONT></H2>
				<P><B>This logout / error has occured for one of the following reasons :</B> 
				<OL>
					<LI><B>You have used F12 key to exit from the application.</B> 
					<LI><B>You have kept the browser window idle for a long time.</B></LI>
					<LI><B>Your machine address is not authorised.</B></LI>
				</OL>
				<!-- <P align="center"><A href="javascript:window.close()" target=_top>Close this window and start the application again.</A> -->
			</TD>

		</TR> 
	</TABLE>
</BODY>
</HTML>