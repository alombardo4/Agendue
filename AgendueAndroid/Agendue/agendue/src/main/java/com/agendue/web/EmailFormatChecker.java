package com.agendue.web;
/**
* Checks email format
* @author AlecLombardo
* @version 1.0
*/
public class EmailFormatChecker {
	/**
	* Checks email validity
	* @param str email address to be checked 
	*/
	private static final String EMAIL_PATTERN = 
			"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
			+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
	
	public static boolean isValid(String str) {
		return str.matches(EMAIL_PATTERN);
	}
}
