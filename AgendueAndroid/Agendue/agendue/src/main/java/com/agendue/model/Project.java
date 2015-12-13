package com.agendue.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents an Agendue project
 * @author Alec Lombardo
 * @author Alec Li
 */
public class Project implements Serializable {

	/**
	 * Web id of the project.
	 */
	private String id;
	/**
	 * Name of the project.
	 */
	private String name;
	/**
	 * The tasks that the project contains.
	 */
	private List<Task> tasks;
	/**
	 * The shares that the project contains.
	 */
	private List<Share> shares;

    /**
     * The messages for the project
     */
    private List<Message> messages;

	/**
     * Full args constructor to create a Project.
     * @param id The web id of the project.
     * @param name The name of the project.
     * @param tasks The tasks contained in the project.
     * @param shares The people with whom the project is shared.
     * @param messages The messages for the project
     */
    public Project(String id, String name, List<Task> tasks,
                   List<Share> shares, List<Message> messages) {
        super();
        this.id = id;
        this.name = name;
        this.tasks = tasks;
        this.shares = shares;
        this.messages = messages;
    }

    /**
     * Full args constructor to create a Project.
     * @param id The web id of the project.
     * @param name The name of the project.
     * @param tasks The tasks contained in the project.
     * @param shares The people with whom the project is shared.
     */
    public Project(String id, String name, List<Task> tasks,
                   List<Share> shares) {
        this(id, name, tasks, shares, new ArrayList<Message>());
    }

	/**
	 * Creates a project with just a name and id.
	 * @param id The web id of the project.
	 * @param name The name of the project.
	 */
	public Project(String id, String name) {
		this(id, name, new ArrayList<Task>(), new ArrayList<Share>());
	}

    public Project(String name) {
        this("", name);
    }
	
	/**
	 * No-args constructor for empty project.
	 */
	public Project() {
		this("", "", new ArrayList<Task>(), new ArrayList<Share>());
	}

	/**
	 * Gets the web id of the project.
	 * @return Web id of project.
	 */
	public String getId() {
		return id;
	}

	/**
	 * Sets the web id of the project.
	 * @param id The web id of the project.
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * Gets the name of the project.
	 * @return The name of the project.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name of the project.
	 * @param name The name of the project.
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Gets tasks for the project.
	 * @return The tasks for the project.
	 */
	public List<Task> getTasks() {
		return tasks;
	}

	/**
	 * Sets all the tasks for the project (not adding).
	 * @param tasks All the tasks for the project.
	 */
	public void setTasks(List<Task> tasks) {
		this.tasks = tasks;
	}

	/**
	 * Adds the given task to the list of tasks.
	 * @param task The task to add.
	 */
	public void addTask(Task task) {
		tasks.add(task);
	}
	
	/**
	 * Adds the given tasks to the list of all tasks.
	 * @param newTasks The new tasks to add.
	 */
	public void addAllTasks(List<Task> newTasks) {
		tasks.addAll(newTasks);
	}
	
	/**
	 * Gets all the shares for the project.
	 * @return The shares for the project.
	 */
	public List<Share> getShares() {
		return shares;
	}

	/**
	 * Sets all the shares for the project.
	 * @param shares All the shares for the project.
	 */
	public void setShares(List<Share> shares) {
		this.shares = shares;
	}

    /**
     * Adds the given share to the list of shares.
     * @param share The share to add.
     */
    public void addShare(Share share) {
        shares.add(share);
    }

    /**
     * Adds the given shares to the list of all shares.
     * @param newShares The new shares to add.
     */
    public void addAllShares(List<Share> newShares) {
        shares.addAll(newShares);
    }

    /**
     * Outputs all of the project's data (Project ID, project name, a list of the tasks,
     * and a list of the shares) in debug format.
     * @return String containing all of the project data.
     */
    public String debugToString() {
        StringBuilder builder = new StringBuilder();
        builder.append("Project: ");
        builder.append(id);
        builder.append(" Name: ");
        builder.append(name);
        builder.append(" Tasks: ");
        for (Task task : tasks) {
            builder.append(task.getName());
            builder.append(", ");
        }
        builder.append(" Shares: ");
        for (Share share : shares) {
            builder.append(share.getName());
            builder.append(", ");
        }
        return builder.toString();
    }


    @Override
	public String toString() {
        return name;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((shares == null) ? 0 : shares.hashCode());
		result = prime * result + ((tasks == null) ? 0 : tasks.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;

		Project other = (Project) obj;
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
		if (shares == null) {
			if (other.shares != null)
				return false;
		} else if (!shares.equals(other.shares))
			return false;
		if (tasks == null) {
			if (other.tasks != null)
				return false;
		} else if (!tasks.equals(other.tasks))
			return false;
		return true;
	}

	
}
