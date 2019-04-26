package edu.ncsu.csc.itrust.beans;
import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;

public class CustomizedApptFacadeBean implements Serializable  {
	private static final long serialVersionUID = -6474182977342257877L;
	private CustomizedApptAbstract a;

	public Integer getNumShow () { return a.getNumShow(); }
	public Integer getNumDays () { return a.getNumDays(); }
	public Timestamp getLastDay (Date d_start) { return a.getLastDay(d_start); }


	// Simply set values; do not worry about contents
	public void setNumShow (Integer show_in) {
		a.setNumShow(show_in);
	}
	public void setNumDays (Integer days_in) {
		a.setNumDays(days_in);
	}

	// Take in strings and parse them into their proper locations
	// If there is some issue, revert them to their previous values
	public void parseNumShowStr(String show_in) {
		Integer oldVal = getNumShow();

		// Test for non-numbers
		try {
			setNumShow(Integer.valueOf(show_in));
		} catch (NumberFormatException e) {
			setNumShow(oldVal);
		}

		// Test for negative numbers
		if (getNumShow() < 0) {
			setNumShow(oldVal);
		}
	}

	public void parseNumDaysStr(String days_in) {
		Integer oldVal = getNumDays();

		// Test for non-numbers
		try {
			setNumDays(Integer.valueOf(days_in));
		} catch (NumberFormatException e) {
			setNumDays(oldVal);
		}

		// Test for negative numbers
		if (getNumDays() < 0) {
			setNumDays(oldVal);
		}
	}
}