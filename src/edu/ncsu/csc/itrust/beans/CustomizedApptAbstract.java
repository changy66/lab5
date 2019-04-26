package edu.ncsu.csc.itrust.beans;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

public abstract class CustomizedApptAbstract implements Serializable {
	private static final long serialVersionUID = -6474182977342257877L;
	private final int msInDay = 60 * 60 * 24 * 1000;
	
	// The default values to set implementations to
	protected final Integer numShowDefault = 3;
	protected final Integer numDaysDefault = 3;
	
	// The variables to be accessed/changed
	protected Integer numShow;
	protected Integer numDays;
	
	// Basic getters that will not change
	public Integer getNumShow() { return numShow; }
	public Integer getNumDays() { return numDays; }
	
	// Setters to be set depending on implementation
	abstract void setNumShow(Integer in);
	abstract void setNumDays(Integer in);
	
	// Util function to get the last day possible for this custom appt
	// Values converted to long to avoid bugs (as warned by Eclipse)
	public Timestamp getLastDay(Date d_start) {
		long numDaysLong = Long.valueOf(numDays);
		long msInDayLong = Long.valueOf(msInDay);
		return new Timestamp(d_start.getTime() + numDaysLong * msInDayLong);
	}
}
