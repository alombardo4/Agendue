package com.agendue.web;

import java.util.GregorianCalendar;

/**
 * Contains many helper methods for dealing with dates to be sent to and from the Agendue server.
 * @author Alec Lombardo
 *
 */
public class AgendueDateHandler {
	/**
	 * Turns a GregorianCalendar object into a String suitable for
	 * a post request to the Agendue web service
	 * @param date The GregorianCalendar formatted date
	 * @return The String formatted date
	 */
	public static String toJSONDateFormat(GregorianCalendar date) {
		String retVal = "";
		retVal += date.get(GregorianCalendar.YEAR);
		retVal += "-";
		retVal += date.get(GregorianCalendar.MONTH);
		retVal += "-";
		retVal += date.get(GregorianCalendar.DATE);		
		return retVal;
	}
	/**
	 * Turns a String JSON attribute into a GregorianCalendar object
	 * suitable for use in the Agendue Android app
	 * @param date The String representation of the date
	 * @return The GregorianCalendar formatted date
	 */
	public static String toStringDate(String date){
		String[] split = date.split("-");
		String retVal = "";
		if (Integer.parseInt(split[2]) < 10) {
			retVal+= split[2].substring(1);
		}
		else {
			retVal += split[2];
		}
		retVal += "/";
		if (Integer.parseInt(split[1]) < 10) {
			retVal+= split[1].substring(1);
		}
		else {
			retVal += split[1];
		}
		retVal += "/";
		retVal += split[0];
		retVal = split[1] + "/" + split[2] + "/" + split[0];
		return retVal;
	}
	/**
	* Gets the date
	* @param date date
	* @return returns date array as y/m/d
	*/
	public static int[] getDate(String date) {
		String[] split = date.split("-");
		int[] ret = new int[3];
		ret[0] = Integer.parseInt(split[0]);//year
		ret[1] = Integer.parseInt(split[1]) - 1;//month
        if (split[2].contains("T")) {
            split[2] = split[2].split("T")[0];
        }
		ret[2] = Integer.parseInt(split[2]);//day
		return ret;
	}

    /**
     * Gets GregorianCalendar date from int array from getDate(String date).
     * @param date int array containing a date
     * @return Gregorian Calendar date
     */
    public static GregorianCalendar getGregorianDate(int[] date) {
        return new GregorianCalendar(date[0], date[1], date[2]);
    }

    /**
     * Gets Gregorian Calendar object from String date
     * @param date String formatted date
     * @return Gregorian Calendar date
     */
    public static GregorianCalendar getGregorianDate(String date) {
        int[] idate = getDate(date);
        return getGregorianDate(idate);
    }
	
	/**
	* Checks date format
	* @param date date
	* @return returns validity indicator
	*/
	public static boolean validFormat(String date) {
		date = date.replaceAll("/", "-");
//		if (date.length() > 12) return false;
//		if (date.length() < 8) return false;
        if(date.matches("\\d{4}-\\d{2}-\\d{2}")) return true;
//        2014-07-17T23:26:03.000Z
        else {
            String[] parts = date.split("T");
            if (parts.length == 2) {
                if (parts[0].matches("\\d{4}-\\d{2}-\\d{2}")) {
                    return true;
                }
            }
            return false;
        }
//		if (date.matches("\\d{2}-\\d{2}-\\d{4}")) return true;
//		else if (date.matches("\\d{1}-\\d{1}-\\d{4}")) return true;
//		else if (date.matches("\\d{1}-\\d{2}-\\d{4}")) return true;
//		else if (date.matches("\\d{2}-\\d{1}-\\d{4}")) return true;
//		else return false;
	}


    public static String sanitizeDate(GregorianCalendar date) {
        if(date==null) {
            return "null";
        }
        return sanitizeDate(date.get(GregorianCalendar.YEAR), date.get(GregorianCalendar.MONTH),
                date.get(GregorianCalendar.DATE));
    }
	/**
	* Appropriately formats date
	* @param year year
	* @param month month
	* @param day day
	* @return correctly formatted date
	*/
	public static String sanitizeDate(int year, int month, int day) {
		String retVal = "";
		month++;
		retVal += year + "-";
		if (month < 10) {
			retVal += "0" + month;
		}
		else {
			retVal += month;
		}
		retVal += "-";
		if (day < 10) {
			retVal += "0" + day;
		}
		else {
			retVal += day;
		}
		
		return retVal;
	}

    public static boolean areDatesEqual(GregorianCalendar date, int month, int day, int year) {
        boolean returnVal = true;

        returnVal = date.get(GregorianCalendar.DAY_OF_MONTH) == day ? returnVal : false;
        returnVal = date.get(GregorianCalendar.MONTH) == month ? returnVal : false;
        returnVal = date.get(GregorianCalendar.YEAR) == year ? returnVal : false;

        return returnVal;
    }
}
