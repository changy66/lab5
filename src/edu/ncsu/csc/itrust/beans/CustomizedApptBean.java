package edu.ncsu.csc.itrust.beans;

public class CustomizedApptBean extends CustomizedApptAbstract {
	private static final long serialVersionUID = -6474182977342257877L;
	
	public CustomizedApptBean () {
		numShow = numShowDefault;
		numDays = numDaysDefault;
	}
	
	public CustomizedApptBean (Integer show_in, Integer days_in) {
		numShow = show_in;
		numDays = days_in;
	}
	
	// Set the fields normally
	final void setNumShow(Integer in) { numShow = in; }
	final void setNumDays(Integer in) { numDays = in; }
}