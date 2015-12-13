package com.agendue.model;

import java.util.GregorianCalendar;

/**
 * Represents a Message for Agendue. Also known to users as a Bulletin
 * Created by Alec on 7/12/2014.
 */
public class Message {
    /**
     * The user who sent the message
     */
    private String user;

    /**
     * The content of the message
     */
    private String content;

    /**
     * The subject of the message
     */
    private String subject;

    /**
     * The date the message was created
     */
    private GregorianCalendar dateCreated;

    /**
     * Full constructor
     * @param user The user who said it
     * @param tcontent The content of the message
     * @param tsubject The subject of the message
     * @param tdateCreated The date the message was created
     */
    public Message(String user, String tcontent, String tsubject, GregorianCalendar tdateCreated) {
        this.user = user;
        this.content = tcontent;
        this.subject = tsubject;
        this.dateCreated = tdateCreated;
    }

    /**
     * Smaller constructor
     * @param tmessage The message content
     * @param tsubject The message subject
     */
    public Message(String tmessage, String tsubject) {
        this(null, tmessage, tsubject, null);
    }

    /**
     * Base constructor
     * @param tmessage The message content
     */
    public Message(String tmessage) {
        this(null, tmessage, null, null);
    }

    /**
     * Returns the user
     * @return user
     */
    public String getUser() {
        return user;
    }

    /**
     * Sets the user
     * @param user the user
     */
    public void setUser(String user) {
        this.user = user;
    }

    /**
     * Gets the message content
     * @return Message content
     */
    public String getContent() {
        return content;
    }

    /**
     * Sets the message content
     * @param content The message content
     */
    public void setContent(String content) {
        this.content = content;
    }

    /**
     * Gets the message subject
     * @return Message subject
     */
    public String getSubject() {
        return subject;
    }

    /**
     * Sets the message subject
     * @param subject Message subject
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }

    /**
     * Gets the date created
     * @return Date the message was created
     */
    public GregorianCalendar getDateCreated() {
        return dateCreated;
    }

    /**
     * Sets the date created
     * @param dateCreated The date the message was created
     */
    public void setDateCreated(GregorianCalendar dateCreated) {
        this.dateCreated = dateCreated;
    }
    @Override
    public String toString() {
        return content;
    }
}
