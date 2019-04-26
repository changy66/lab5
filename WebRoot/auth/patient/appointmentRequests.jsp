<%@page import="java.text.ParseException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptTypeBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.beans.HCPVisitBean"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewVisitedHCPsAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="edu.ncsu.csc.itrust.action.AddApptRequestAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptRequestBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.CustomizedApptFacadeBean"%>
<%@page import="java.util.List"%>

<%@include file="/global.jsp"%>

<%
	pageTitle = "iTrust - Appointment Requests";
%>
<%@include file="/header.jsp"%>
<%
	AddApptRequestAction action = new AddApptRequestAction(prodDAO); //ViewAppt in HCP
	ViewVisitedHCPsAction hcpAction = new ViewVisitedHCPsAction(
			prodDAO, loggedInMID.longValue()); //ViewAppt in HCP

	List<HCPVisitBean> visits = hcpAction.getVisitedHCPs();
			
	CustomizedApptFacadeBean customAppt = new CustomizedApptFacadeBean();
	
	ApptTypeDAO apptTypeDAO = prodDAO.getApptTypeDAO();
	List<ApptTypeBean> apptTypes = apptTypeDAO.getApptTypes();
	String msg = "";
	long hcpid = 0L;
	String comment = "";
	String date = "";
	String hourI = "";
	String minuteI = "";
	String tod = "";
	String apptType = "";
	String prompt = "";
	String numShow = "";
	String numDays = "";
	if (request.getParameter("request") != null) {
		ApptBean appt = new ApptBean();
		appt.setPatient(loggedInMID);
		hcpid = Long.parseLong(request.getParameter("lhcp"));
		appt.setHcp(hcpid);
		comment = request.getParameter("comment");
		appt.setComment(comment);
		SimpleDateFormat frmt = new SimpleDateFormat(
				"MM/dd/yyyy hh:mm a");
		date = request.getParameter("startDate");
		date = date.trim();
		hourI = request.getParameter("time1");
		minuteI = request.getParameter("time2");
		tod = request.getParameter("time3");
		apptType = request.getParameter("apptType");
		appt.setApptType(apptType);
		
		// New to custom appt feature
		numShow = request.getParameter("numShow");
		numDays = request.getParameter("numDays");
		customAppt.parseNumShowStr(numShow);
		customAppt.parseNumDaysStr(numDays);
				
		try {
			if(date.length() == 10){
				Date d = frmt.parse(date + " " + hourI + ":" + minuteI
						+ " " + tod);
				appt.setDate(new Timestamp(d.getTime()));
				ApptRequestBean req = new ApptRequestBean();
				req.setRequestedAppt(appt);
				msg = action.addApptRequest(req);
										
				if (msg.contains("conflicts")) {	
					msg = "ERROR: " + msg;
					frmt = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
					List<ApptBean> open = action.getNextAvailableAppts(customAppt.getNumShow(), appt);					
		
					// Submit entire new form with previous data including new data for "numShow" and "numDays"
					prompt="<br/>The following nearby time slots are available:<br/>"
						  +"<div style='padding:5px;margin:5px;display:inline-block;border:1px solid gray;'>"
						  +"<form action='appointmentRequests.jsp' method='post'>"
					     	 +"Max number of displayed slots: <input name='numShow' value='"+customAppt.getNumShow().toString()+"' size='5'>&nbsp;&nbsp"
					     	 +"Number of days to look: <input name='numDays' value='"+customAppt.getNumDays().toString()+"' size='5'> &nbsp;&nbsp;"
							 +"<input type='hidden' name='lhcp' value='"+hcpid+"'/>"
							 +"<input type='hidden' name='apptType' value='"+apptType+"'/>	"
							 +"<input type='hidden' name='startDate' value='"+date+"'/>"
							 +"<input type='hidden' name='time1' value='"+hourI+"'/>"
							 +"<input type='hidden' name='time2' value='"+minuteI+"'/>"
							 +"<input type='hidden' name='time3' value='"+tod+"'/>"
							 +"<input type='hidden' name='comment' value='"+comment+"'/>"
				    	 	 +"<input type='submit' name='request' value='Submit'>"
				          +"</form>"
				          +"</div><br/>";
				    
					int index = 0;
					Timestamp lastDay = customAppt.getLastDay(d);
					
					for(ApptBean possible : open) {
						Timestamp thisDay = possible.getDate();

						// Exit early if we've passed the last day
						if (thisDay.after(lastDay)) { break; }

						index++;
						String newDate = frmt.format(thisDay);
						
						prompt += "<div style='padding:5px;margin:5px;float:left;border:1px solid black;'><b>Option " + index+ "</b><br/>"+ frmt.format(possible.getDate()); 
						prompt += "<form action='appointmentRequests.jsp' method='post'>"
							+"<input type='hidden' name='lhcp' value='"+hcpid+"'/>"
							+"<input type='hidden' name='apptType' value='"+apptType+"'/>	"
							+"<input type='hidden' name='startDate' value='"+newDate.substring(0,10)+"'/>"
							+"<input type='hidden' name='time1' value='"+newDate.substring(11,13)+"'/>"
							+"<input type='hidden' name='time2' value='"+newDate.substring(14,16)+"'/>"
							+"<input type='hidden' name='time3' value='"+newDate.substring(17)+"'/>"
							+"<input type='hidden' name='comment' value='"+comment+"'/>"
							+"<input type='hidden' name='numShow' value='"+customAppt.getNumShow().toString()+"'/>"
							+"<input type='hidden' name='numDays' value='"+customAppt.getNumDays().toString()+"'/>"
							+"<input type='submit' name='request' value='Select this time'/>"
						+"</form></div>";
						
					}
					prompt+="<div style='clear:both;'><br/></div>";
				} else {
					loggingAction.logEvent(
							TransactionType.APPOINTMENT_REQUEST_SUBMITTED,
							loggedInMID, hcpid, "");
				}
			}else{
				msg = "ERROR: Date must by in the format: MM/dd/yyyy";
			}
		} catch (ParseException e) {
			msg = "ERROR: Date must by in the format: MM/dd/yyyy";
		}
	}
%>
<h1>Request an Appointment</h1>
<%
	if (msg.contains("ERROR")) {
%>
<span class="iTrustError"><%=msg%></span>
<%
	} else {
%>
<span class="iTrustMessage"><%=msg%></span>
<%
	}
%>
<%=prompt%>
<form action="appointmentRequests.jsp" method="post">
	<p>HCP:</p>
	<select name="lhcp">
		<%
			for (HCPVisitBean visit : visits) {
		%><option
			<%if (visit.getHCPMID() == hcpid)
					out.println("selected");%>
			value="<%=visit.getHCPMID()%>"><%=visit.getHCPName()%></option>
		<%
			}
		%>
	</select>
	<p>Appointment Type:</p>
	<select name="apptType">
		<%
			for (ApptTypeBean appt : apptTypes) {
		%><option
			<%if (appt.getName().equals(apptType))
					out.print("selected='selected'");%>
			value="<%=appt.getName()%>"><%=appt.getName()%></option>
		<%
			}
			String startDate = "";
		%>
	</select>
	<p>Date:</p>
	<input name="startDate"
		value="<%=StringEscapeUtils.escapeHtml("" + (date))%>" size="10">
	<input type=button value="Select Date"
		onclick="displayDatePicker('startDate');">
	<p>Time:</p>
	<select name="time1">
		<%
			String hour = "";
			for (int i = 1; i <= 12; i++) {
				if (i < 10)
					hour = "0" + i;
				else
					hour = i + "";
		%>
		<option <%if (hour.equals(hourI))
					out.print("selected");%>
			value="<%=hour%>"><%=StringEscapeUtils.escapeHtml("" + (hour))%></option>
		<%
			}
		%>
	</select>:<select name="time2">
		<%
			String min = "";
			for (int i = 0; i < 60; i += 5) {
				if (i < 10)
					min = "0" + i;
				else
					min = i + "";
		%>
		<option <%if (min.equals(minuteI))
					out.print("selected");%>
			value="<%=min%>"><%=StringEscapeUtils.escapeHtml("" + (min))%></option>
		<%
			}
		%>
	</select> <select name="time3">
		<option <%if ("AM".equals(tod))
				out.print("selected");%> value="AM">AM</option>
		<option <%if ("PM".equals(tod))
				out.print("selected");%> value="PM">PM</option>
	</select>
	<p>Comment:</p>
	<textarea name="comment" cols="100" rows="10"><%=StringEscapeUtils.escapeHtml("" + (comment))%></textarea>
	
	<!-- New to custom appt feature; simply upload form with default data in order to confirm field will be in request -->
	<input type="hidden" name="numShow" value="<%=customAppt.getNumShow()%>"></input>
	<input type="hidden" name="numDays" value="<%=customAppt.getNumDays()%>"></input>
	
	<br /> <br /> <input type="submit" name="request" value="Request" />
</form>
<%
	
%>

<%@include file="/footer.jsp"%>
