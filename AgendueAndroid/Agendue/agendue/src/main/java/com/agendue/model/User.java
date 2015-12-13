package com.agendue.model;

import android.graphics.Color;

import com.agendue.web.AgendueJSONParser;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents an Agendue task.
 * @author Alec Li
 * @author Alec Lombardo
 *
 */
public class User implements Serializable {

    /**
     * First name of user.
     */
    private String firstname;
    /**
     * Last name of user.
     */
    private String lastname;
    /**
     * Facebook ID.
     */
    private String facebook;
    /**
     * User name (email address).
     */
    private String name;
    /**
     * User password.
     */
    private String password;
    /**
     * List of the projects a user has.
     */
    private List<Project> projects;

    private boolean hasCustomColors;

    private int primaryColor, secondaryColor, tertiaryColor;

    /**
     * Full args constructor to create a User.
     * @param firstname The first name of the user.
     * @param lastname The last name of the user.
     * @param facebook The Facebook ID of the user.
     * @param name The user name (email address).
     * @param password The password of the user.
     * @param projects An arrayList of projects for the user.
     */
    public User(String firstname, String lastname, String facebook,
                String name, String password, List<Project> projects, int primaryColor, int secondaryColor, int tertiaryColor) {
        super();
        this.firstname = firstname;
        this.lastname = lastname;
        this.facebook = facebook;
        this.name = name;
        this.password= password;
        this.projects = projects;
        this.primaryColor = primaryColor;
        this.secondaryColor = secondaryColor;
        this.tertiaryColor = tertiaryColor;
        this.hasCustomColors = false;

    }

    public boolean hasCustomColors() {
        if (primaryColor != Color.parseColor("#3692d5")) {
            return true;
        }
        if (secondaryColor != Color.parseColor("#ffab26")) {
            return true;
        }
        if (tertiaryColor != Color.parseColor("#f7931e")) {
            return true;
        }
        return false;
    }

    public User(String firstname, String lastname, String facebook,
                String name, String password, List<Project> projects) {
        this(firstname, lastname, facebook, name, password, projects, Color.parseColor("#3692d5"), Color.parseColor("#ffab26"), Color.parseColor("#ffffff"));

    }
    /**
     * Full args constructor minus projects to create a User.
     * @param firstname The first name of the user.
     * @param lastname The last name of the user.
     * @param facebook The Facebook ID of the user.
     * @param name The user name (email address).
     * @param password The password of the user.
     */
    public User(String firstname, String lastname, String facebook,
                String name, String password) {
        this(firstname, lastname, facebook, name, password, new ArrayList<Project>());
    }

    /**
     * Full args constructor minus projects & Facebook ID to create a User.
     * @param firstname The first name of the user.
     * @param lastname The last name of the user.
     * @param name The user name (email address).
     * @param password The password of the user.
     */
    public User(String firstname, String lastname,
                String name, String password) {
        this(firstname, lastname, "", name, password, new ArrayList<Project>());
    }

    /**
     * Creates a user with just username and password
     * @param name Username
     * @param password Password
     */
    public User(String name, String password) {
        this("","", "", name, password, new ArrayList<Project>());
    }

    /**
     * Creates a user with just a username.
     * @param name The user name (email address).
     */
    public User(String name) {
        this("","", "", name, "", new ArrayList<Project>());
    }

    /**
     * No-args constructor for empty user.
     */
    public User() {
        this("","", "", "", "", new ArrayList<Project>());
    }


    /**
     * Gets first name of user.
     * @return The first name of user.
     */
    public String getFirstname() {
        return firstname;
    }

    /**
     * Sets first name of user.
     * @param firstname The first name of the user.
     */
    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    /**
     * Gets the last name of the user.
     * @return The last name of the user.
     */
	public String getLastname() {
		return lastname;
	}

    /**
     * Sets the last name of the user.
     * @param lastname The last name of the user.
     */
    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    /**
     * Gets the user's Facebook ID.
     * @return The Facebook ID.
     */
    public String getFacebook() {
        return facebook;
    }

    /**
     * Sets the user's Facebook ID.
     * @param facebook The Facebook ID to set.
     */
    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }

    /**
     * Gets user's email address (name).
     * @return User's email address (name).
     */
    public String getName() {
        return name;
    }

    /**
     * Sets user's email address (name).
     * @param name The email address (name) to be set.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Gets the user's password.
     * @return The password.
     */
    public String getPassword() {
        return password;
    }

    /**
     * Sets user's password.
     * @param password The password to set.
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Gets all the projects for the user.
     * @return The projects for the user.
     */
    public List<Project> getProjects() {
        return projects;
    }

    /**
     * Sets all the projects for the users.
     * @param projects All the projects for the user.
     */
    public void setProjects(List<Project> projects) {
        this.projects= projects;
    }

    /**
     * Adds the given project to the list of projects.
     * @param project The project to add.
     */
    public void addProject(Project project) {
        projects.add(project);
    }

    /**
     * Returns firstname + " " + lastname
     * @return firstname + " " + lastname
     */
    public String getFullName() {
        return firstname + " " + lastname;
    }

    /**
     * Adds the given projects to the list of all projects .
     * @param newProjects The new projects to add.
     */
    public void addAllProjects(List<Project> newProjects) {
        projects.addAll(newProjects);
    }

    /**
     * Outputs all of the user's data (First name, last name, facebook ID, email address, password).
     * @return String containing all the member variables of user.
     */
    public String debugToString() {
        StringBuilder builder = new StringBuilder();
        builder.append("First Name: ");
        builder.append(firstname);
        builder.append(" Last Name: ");
        builder.append(lastname);
        builder.append(" Facebook ID: ");
        builder.append(facebook);
        builder.append(" Name (email address): ");
        builder.append(name);
        builder.append(" Password: ");
        builder.append(password);
        builder.append(" Projects: ");
        for (Project project : projects) {
            builder.append(project.getName());
            builder.append(", ");
        }
        return builder.toString();
    }

    public String toString() {
        return firstname + " " + lastname;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((firstname == null) ? 0 : firstname.hashCode());
        result = prime * result + ((lastname == null) ? 0 : lastname.hashCode());
        result = prime * result + ((facebook == null) ? 0 : facebook.hashCode());
        result = prime * result + ((name== null) ? 0 : name.hashCode());
        result = prime * result + ((password== null) ? 0 : password.hashCode());
        result = prime * result + ((projects== null) ? 0 : projects.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        User other = (User) obj;
        if (firstname == null) {
            if (other.firstname!= null)
                return false;
        } else if (!firstname.equals(other.firstname))
            return false;
        if (lastname == null) {
            if (other.lastname != null)
                return false;
        } else if (!lastname.equals(other.lastname))
            return false;
        if (facebook == null) {
            if (other.facebook!= null)
                return false;
        } else if (!facebook.equals(other.facebook))
            return false;
        if (name== null) {
            if (other.name!= null)
                return false;
        } else if (!name.equals(other.name))
            return false;
        if (password== null) {
            if (other.password!= null)
                return false;
        } else if (!password.equals(other.password))
            return false;
        if (projects== null) {
            if (other.projects!= null)
                return false;
        } else if (!projects.equals(other.projects))
            return false;
        return true;
    }

    public void setPrimaryColor(String color) {
        setPrimaryColor(((Color.parseColor(color))));
    }
    public int getPrimaryColor() {
        return primaryColor;
    }

    public int getDarkerPrimaryColor() {
        return AgendueJSONParser.darkenColor(primaryColor);
    }

    public int getDarkerSecondaryColor() {
        return AgendueJSONParser.darkenColor(secondaryColor);

    }

    public int getDarkerTertiaryColor() {
        return AgendueJSONParser.darkenColor(tertiaryColor);

    }



    public void setPrimaryColor(int primaryColor) {
        this.primaryColor = primaryColor;
    }

    public int getSecondaryColor() {
        return secondaryColor;
    }

    public void setSecondaryColor(String color) {
        setSecondaryColor(((Color.parseColor(color))));
    }
    public void setSecondaryColor(int secondaryColor) {
        this.secondaryColor = secondaryColor;
    }

    public int getTertiaryColor() {
        return tertiaryColor;
    }

    public void setTertiaryColor(String color) {
        setTertiaryColor(((Color.parseColor(color))));
    }
    public void setTertiaryColor(int tertiaryColor) {
        this.tertiaryColor = tertiaryColor;
    }
}
