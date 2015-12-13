package com.agendue.model;

import android.graphics.Color;

import java.io.Serializable;
import java.util.GregorianCalendar;

/**
 * Represents an Agendue task.
 * @author Alec Li
 * @author Alec Lombardo
 *
 */
public class Task implements Serializable {

    /**
     * Web id of the task.
     */
    private String id;
    /**
     * Name of the task.
     */
    private String name;
    /**
     * Description of the task.
     */
    private String description;
    /**
     * User task is assigned to.
     */
    private String assignedto;
    /**
     * Duedate of the task in Gregorian Calendar form.
     */
    private GregorianCalendar duedate;
    /**
     * Boolean indicating if task is complete.
     */
    private boolean complete;

    /**
     * ID of project that the task belongs to
     */
    private String projectid;

    /**
     * The task's label from 0 to 4 (NRGBY)
     */
    private int label;

    /**
     * Whether the task is personal or not
     */
    private boolean isPersonal;

    public GregorianCalendar getCalendarDate() {
        return calendarDate;
    }

    public void setCalendarDate(GregorianCalendar calendarDate) {
        this.calendarDate = calendarDate;
    }

    /**
     * The date the web decides to put the task on the calendar

     */
    private GregorianCalendar calendarDate;

    /**
     * Full args constructor to create a Task.
     * @param id The ID of the task.
     * @param name The name of the task.
     * @param description The description of the task.
     * @param assignedto The user the task is assigned to.
     * @param duedate The date the task is due.
     * @param complete Boolean indicating if task is complete.
     * @param projectid String containing the ID of the project the task is associated with
     * @param label int for the label from 0 to 4 NRGBY
     */
    public Task(String id, String name, String description,
                String assignedto, GregorianCalendar duedate, boolean complete, String projectid, int label) {
        super();
        this.id = id;
        this.name = name;
        this.description = description;
        this.assignedto = assignedto;
        this.duedate = duedate;
        this.complete = complete;
        this.projectid = projectid;
        this.label = label;
    }

    /**
     * No args constructor to create a Task.
     */
    public Task() {
        this("", "", "", "", null, false, "", 0);
    }

    /**
     * Gets web ID for the task.
     * @return web ID of task.
     */
    public String getId() {
        return id;
    }

    /**
     * Sets task id.
     * @param id The web id to add.
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Gets name of the task.
     * @return name of task.
     */
	public String getName() {
		return name;
	}

    /**
     * Sets task name.
     * @param name The task name to set.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Gets description of the task.
     * @return description of task.
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets description of the task.
     * @param description The task description to add.
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Gets user the task is assigned to.
     * @return user the task is assigned to.
     */
    public String getAssignedto() {
        return assignedto;
    }

    /**
     * Sets what user the task is assigned to.
     * @param assignedto The user the task should be assigned to.
     */
    public void setAssignedto(String assignedto) {
        this.assignedto = assignedto;
    }

    /**
     * Gets due date for the task.
     * @return due date of task.
     */
    public GregorianCalendar getDuedate() {
        return duedate;
    }

    /**
     * Sets due date.
     * @param duedate The duedate to set.
     */
    public void setDuedate( GregorianCalendar duedate) {
        this.duedate = duedate;
    }

    /**
     * Gets whether or not the task is complete.
     * @return boolean showing if completed.
     */
    public boolean getComplete() {
        return complete;
    }

    /**
     * Sets whether the task is completed.
     * @param complete The completed status to set the task.
     */
    public  void setComplete(boolean complete) {
        this.complete = complete;
    }

    /**
     * Sets the project id
     * @param projectid String containing the ID of the project the task is associated with
     */
    public void setProjectid(String projectid) {
        this.projectid = projectid;
    }

    /**
     * Gets the project ID
     * @return the project ID
     */
    public  String getProjectid() {
        return projectid;
    }

    /**
     * Returns the int representation of the label
     * @return label from 0 - 4 (NRGBY)
     */
    public int getLabel() {
        return label;
    }

    /**
     * Sets the label to the inputted parameter
     * @param label The label to be set (0-4 NRGBY)
     */
    public void setLabel(int label) {
        this.label = label;
    }

    /**
     * Gets the label's Android.Graphics.Color
     * @return an Android.Graphics.Color represented as an int
     */
    public int getLabelColor() {
        switch (label) {
            case 0:
                return Color.WHITE;
            case 1:
                return Color.RED;
            case 2:
                return Color.GREEN;
            case 3:
                return Color.BLUE;
            case 4:
                return Color.YELLOW;
            default:
                return Color.WHITE;

        }
    }

    /**
     * Returns whether the task is personal or not
     * @return boolean yes if the task is personal
     */
    public boolean isPersonal() {
        return isPersonal;
    }

    /**
     * Sets whether the task is personal or not
     * @param isPersonal boolean is personal value
     */
    public void setIsPersonal(boolean isPersonal) {
        this.isPersonal = isPersonal;
    }

    @Override
    public String toString() {
        return name;
    }

    /**
     * Outputs all the details of the task (Task ID, name, description, assigned to, due date,
     * and whether or not it's completed) in debug format.
     * @return String containing the task's details.
     */
    public String debugToString() {
        StringBuilder builder = new StringBuilder();
        builder.append("Task: ");
        builder.append(id);
        builder.append(" Name: ");
        builder.append(name);
        builder.append(" Description: ");
        builder.append(description);
        builder.append(" Assigned to: ");
        builder.append(assignedto);
        builder.append(" Due Date: ");
        if(duedate!=null) {
            builder.append(duedate.toString());
        }
        builder.append(" Completed: ");
        if (complete)
            builder.append("True");
        else
            builder.append("False");
        return builder.toString();
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        result = prime * result + ((description == null) ? 0 : description.hashCode());
        result = prime * result + ((assignedto== null) ? 0 : assignedto.hashCode());
        result = prime * result + ((duedate == null) ? 0 : duedate.hashCode());
        result = prime * result + (complete ? 1321 : 1433);
        result = prime * result + (label);
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        Task other = (Task) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (name == null) {
            if (other.name != null)
                return false;
        } else if (!name.equals(other.name))
            return false;
        if (assignedto == null) {
            if (other.assignedto!= null)
                return false;
        } else if (!assignedto.equals(other.assignedto))
            return false;
        if (duedate == null) {
            if (other.duedate!= null)
                return false;
        } else if (!duedate.equals(other.duedate))
            return false;
        if(duedate!=other.duedate)
            return false;
        if(label!=other.label)
            return false;
        return true;
    }

}
