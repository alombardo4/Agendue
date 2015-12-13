package com.agendue.model;

import java.io.Serializable;

/**
 * A person with whom an Agendue project is shared.
 * @author Alec Li
 * @author Alec Lombardo
 *
 */
public class Share implements Serializable {

	/**
	 * The name of the person the project is shared with.
	 */
	private String name;

    private String facebook;

    private String google;

    private String id;

    private String premium;

    public String getFacebook() {
        return facebook;
    }

    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }

    public String getGoogle() {
        return google;
    }

    public void setGoogle(String google) {
        this.google = google;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPremium() {
        return premium;
    }

    public void setPremium(String premium) {
        this.premium = premium;
    }

    /**
	 * Creates a Share object.
	 * @param name The name of the person for the share.
	 */
	public Share(String name) {
		super();
		this.name = name;
	}

	/**
	 * Gets the name of the person the project is shared with.
	 * @return name.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name of the person the project is shared with.
	 * @param name Name of the person.
	 */
	public void setName(String name) {
        this.name = name;
	}


    @Override
    public String toString() {
        return name;
    }

    /**
     * Outputs the user name that is shared with.
     * @return String containing user shared with in debug format.
     */
    public String debugToString() {
        return "Shared with user name: " + name;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        Share other = (Share) obj;
        if (name == null) {
            if (other.name != null)
                return false;
        } else if (!name.equals(other.name))
            return false;
       return true;
    }


}
