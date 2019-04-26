package edu.ncsu.csc.itrust.beans;

public class CustomizedApptNullBean extends CustomizedApptAbstract {
    private static final long serialVersionUID = -6474182977342257877L;

    public CustomizedApptNullBean () {
        numShow = numShowDefault;
        numDays = numDaysDefault;
    }

    // Since this is the null bean, just do nothing if something is set
    final void setNumShow(Integer in) {}
    final void setNumDays(Integer in) {}
}