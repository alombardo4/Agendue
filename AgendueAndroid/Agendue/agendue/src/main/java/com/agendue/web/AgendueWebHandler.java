package com.agendue.web;

import android.util.Log;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.params.ClientPNames;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.cookie.Cookie;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HTTP;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Message;
import com.agendue.model.Task;
/**
 * Handles all web requests so they are centralized
 * @author Alec Lombardo
 *
 */
public class AgendueWebHandler implements Serializable {
    private static AgendueWebHandler singletonWebHandler;

    private static String baseURL = "https://www.agendue.com/";
	private static final long serialVersionUID = 1L;
	private final String LOGIN_URL = "login";
    private final String LANDING_URL = "landing";
    private final String PRODUCTIVITY_SCORE = "landing/score";
    private final String INCOMPLETE_COUNT = "landing/incomplete_count";
	private final String PROJECTS_URL = "projects";
    private final String PROJECT_DETAILS_URL = "projects/";
    private final String WIKI_URL = "wiki";
	private final String TASKS_LIST_URL = "projects/";
	private final String TASK_DETAIL_URL = "tasks/";
	private final String TASKS_URL = "tasks";
	private final String SHARE_URL = "projects/";
    private final String COMPLETE = "complete";
    private final String INCOMPLETE = "incomplete";
	private final String CREATENEWURL = "users/new";
    private final String SHARES = "shares";
	private final String CREATEURL = "users";
    private final String USER_URL = "user";
    private final String TASKS_ASSIGNED_URL = "tasks/assigned";
    private final String MESSAGES_URL = "messages";
    private final String PUSH_URL = "devices";
    private final String CALENDAR = "calendar";
    private final String PERSONAL_TASKS_URL = "personal_tasks";
	private static String authenticityToken;
	private static HttpContext context;
	private static CookieStore cookiestore;
	private static HttpClient httpclient;
	private static AtomicInteger requestCounter;
	
	/**
	 * Constructor for AgendueWebHandler. Call only when you want a new session
	 */
	private AgendueWebHandler() {
		if (context == null) {
			context = new BasicHttpContext();
		}
		if (cookiestore == null) {
			cookiestore = new BasicCookieStore();
			context.setAttribute(ClientContext.COOKIE_STORE, cookiestore);
		}
		if (httpclient == null) {
			httpclient = createHttpClient();
		}
		if (requestCounter == null) {
			requestCounter = new AtomicInteger(0);
		}
	}

    public static AgendueWebHandler getInstance() {
        if (singletonWebHandler == null) {
            singletonWebHandler = new AgendueWebHandler();
        }
        return singletonWebHandler;
    }

    public static CookieStore getCookiestore() {
        return cookiestore;
    }


    public void setDevEnvironment() {
        baseURL = "http://dev.agendue.com/";
    }

    public void setDevHTTPSEnvironemnt() {
        baseURL = "https://dev.agendue.com/";
    }

    public void setDevIPEnvironment(String ipurl) {
        baseURL = ipurl;
    }

	/**
	 * Logs the user in
	 * @param username Username
	 * @param password Password
	 * @return String results
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String logIn(String username, String password)
			throws ClientProtocolException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
		HttpPost httppost = new HttpPost(baseURL + LOGIN_URL);
		HttpGet httpget = new HttpGet(baseURL + LOGIN_URL);
		httpget.setHeader("accept", "text/html");
		HttpResponse response = httpclient.execute(httpget, context);
		String results = EntityUtils.toString(response.getEntity());
		authenticityToken = getToken(results);
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(3);
	    nameValuePairs.add(new BasicNameValuePair("name", username));
	    nameValuePairs.add(new BasicNameValuePair("password", password));
	    nameValuePairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
	    httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
        httppost.addHeader("accept", "application/json");
	    httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
	    response = httpclient.execute(httppost, context);
	    requestCounter.decrementAndGet();
        results = EntityUtils.toString(response.getEntity());
        return results;
	}


    /**
     * Adds the user's device to the push list
     * @param deviceToken The GCM token from the device
     * @return String results
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String addDeviceForGCM(String deviceToken)
            throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpPost httppost = new HttpPost(baseURL + PUSH_URL);
        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
        nameValuePairs.add(new BasicNameValuePair("device[os]", "android"));
        nameValuePairs.add(new BasicNameValuePair("device[token]", deviceToken));
        httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
        httppost.addHeader("accept", "application/json");
        httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
        HttpResponse response = httpclient.execute(httppost, context);
        requestCounter.decrementAndGet();
        String results = EntityUtils.toString(response.getEntity());
        return results;
    }

    /**
     * Gets the list of upcoming tasks in JSON
     * @return JSON tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getLandingUpcoming() throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + LANDING_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }


    /**
     * Gets the list of personal landing tasks in JSON
     * @return JSON tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getLandingPersonal() throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + LANDING_URL + "/personal.json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    public String getCalendar() throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + CALENDAR + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    public String getSharesForProjectID(String projectID) throws IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PROJECT_DETAILS_URL + projectID + "/shares" + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets the productivity score
     * @return JSON score
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getProductivityScore() throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PRODUCTIVITY_SCORE + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

	/**
	 * Gets the list of projects in JSON
	 * @return JSON projects
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String getProjects() throws ClientProtocolException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();	
	    HttpGet httpGet = new HttpGet(baseURL + PROJECTS_URL);
	    httpGet.addHeader("Accept", "application/json");
	    HttpResponse response = httpclient.execute(httpGet, context);
	    requestCounter.decrementAndGet();
	    //Read results of HTTP get
	    String str = EntityUtils.toString(response.getEntity());
        return str;
	}

    /**
     * Gets the list of personal tasks as JSON
     * @return personal tasks as JSON
     * @throws IOException
     */
    public String getPersonalTasks() throws IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PERSONAL_TASKS_URL + "/all/incomplete");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }


    /**
     * Gets the list of personal tasks as JSON
     * @return personal tasks as JSON
     * @throws IOException
     */
    public String getCompletePersonalTasks() throws IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PERSONAL_TASKS_URL + "/all/complete");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }

    /**
     * Gets the number of incomplete tasks
     * @return Incomplete tasks as JSON "count"
     * @throws IOException
     */
    public String getLandingIncompleteCount() throws IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + INCOMPLETE_COUNT);
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }

	/**
	 * Gets task list as JSON
	 * @param webUrl taskID
	 * @return JSON tasks
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String getTasks(String webUrl)
		throws ClientProtocolException, IOException {
		    //Execute HTTP get
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
	    HttpGet httpGet = new HttpGet(baseURL + TASKS_LIST_URL + webUrl);
	    httpGet.addHeader("Accept", "application/json");
	    HttpResponse response = httpclient.execute(httpGet, context);
	    requestCounter.decrementAndGet();
	    //Read results of HTTP get
	    String str = EntityUtils.toString(response.getEntity());
        return str;
	}

    public String getCanShare(Project project)
        throws ClientProtocolException, IOException {

            int i = 0;
            while(requestCounter.get() >= 2) {
                i++;
            }
            requestCounter.incrementAndGet();
            StringBuilder url = new StringBuilder(baseURL);
            url.append(PROJECT_DETAILS_URL);
            url.append(project.getId());
            url.append("/");
            url.append("shares/canshare");
            url.append(".json");
            HttpGet httpGet = new HttpGet(url.toString());
            httpGet.addHeader("Accept", "application/json");
            HttpResponse response = httpclient.execute(httpGet, context);
            requestCounter.decrementAndGet();
            //Read results of HTTP get
            String str = EntityUtils.toString(response.getEntity());
            return str;

    }

    public String getCompletedTasksForProject(Project project)
            throws ClientProtocolException, IOException {

        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        StringBuilder url = new StringBuilder(baseURL);
        url.append(PROJECT_DETAILS_URL);
        url.append(project.getId());
        url.append("/");
        url.append(TASK_DETAIL_URL);
        url.append(COMPLETE);
        url.append(".json");
        HttpGet httpGet = new HttpGet(url.toString());
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;

    }

    public String getInccompleteTasksForProject(Project project)
            throws ClientProtocolException, IOException {

        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        StringBuilder url = new StringBuilder(baseURL);
        url.append(PROJECT_DETAILS_URL);
        url.append(project.getId());
        url.append("/");
        url.append(TASK_DETAIL_URL);
        url.append(INCOMPLETE);
        url.append(".json");
        HttpGet httpGet = new HttpGet(url.toString());
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;

    }

    /**
     * Gets task list as JSON
     * @return JSON tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getUser()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + USER_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

	/**
	 * Deletes the specified project
	 * @param webUrl ProjectID to delete
	 * @return String results
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String deleteProject(String webUrl) throws ClientProtocolException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
		HttpDelete httpDelete = new HttpDelete(baseURL + TASKS_LIST_URL + webUrl + ".json");
	    httpclient.execute(httpDelete, context);
	    requestCounter.decrementAndGet();
	    return "done";
	}
	
	/**
	 * Gets a specific task
	 * @param task Task with the proper taskID
	 * @return JSON Task object
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String getTask(Task task) throws ClientProtocolException, IOException {
			int i = 0;
			while(requestCounter.get() >= 2) {
				i++;
			}
			requestCounter.incrementAndGet();
		    HttpGet httpGet = new HttpGet(baseURL + TASK_DETAIL_URL + task.getId() + ".json");
		    httpGet.addHeader("Accept", "application/json");
		    HttpResponse response = httpclient.execute(httpGet, context);
		    requestCounter.decrementAndGet();
		    return EntityUtils.toString(response.getEntity());
	}
	
	/**
	 * Deletes the specified task
	 * @param task Task to delete
	 * @return String results
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String deleteTask(Task task) throws ClientProtocolException, IOException {
			int i = 0;
			while(requestCounter.get() >= 2) {
				i++;
			}
			requestCounter.incrementAndGet();
		    HttpDelete httpDelete = new HttpDelete(baseURL + TASK_DETAIL_URL + task.getId() + ".json");
		    httpclient.execute(httpDelete, context);
		    requestCounter.decrementAndGet();
		    return "done";
	}

    /**
     * Deletes the specified task
     * @param task Personal Task to delete
     * @return String results
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String deletePersonalTask(Task task) throws ClientProtocolException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpDelete httpDelete = new HttpDelete(baseURL + PERSONAL_TASKS_URL + "/" + task.getId() + ".json");
        httpclient.execute(httpDelete, context);
        requestCounter.decrementAndGet();
        return "done";
    }
	/**
	 * Adds a project
	 * @param project The project with name to add
	 * @return String results
	 * @throws JSONException
	 * @throws ParseException
	 * @throws IOException
	 */
	public String addProject(Project project) throws JSONException, ParseException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
	    JSONObject postParams = new JSONObject();
	    postParams.put("name", project.getName().trim());
	    postParams.put("authenticity_token", authenticityToken);
	    StringEntity entity = new StringEntity(postParams.toString());
	    //Execute post
	    HttpPost httppost = new HttpPost(baseURL + PROJECTS_URL);
	    httppost.addHeader("Content-Type", "application/json");
	    httppost.setEntity(entity);
	    
	    HttpResponse response = httpclient.execute(httppost, context);		
	    requestCounter.decrementAndGet();
	    return EntityUtils.toString(response.getEntity());
	}

    /**
     * Adds a message
     * @param message The message with content to add
     * @return String results
     * @throws JSONException
     * @throws ParseException
     * @throws IOException
     */
    public String addMessage(Message message) throws JSONException, ParseException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        //Execute post
        HttpPost httppost = new HttpPost(baseURL + MESSAGES_URL);
        List<NameValuePair> pairs = new ArrayList<NameValuePair>(2);
        pairs.add(new BasicNameValuePair("message[content]", message.getContent()));
        pairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
        httppost.setEntity(new UrlEncodedFormEntity(pairs));
        httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
        httppost.setHeader("Content-Type", "application/x-www-form-urlencoded");
        HttpResponse response = httpclient.execute(httppost, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }

	/**
	 * Adds the specified task
	 * @param task The task to add
     * @param project The project to add it to
	 * @return String results
	 * @throws ParseException
	 * @throws IOException
	 * @throws JSONException
	 */
	public String addTask(Task task, Project project)
			throws ParseException, IOException, JSONException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
	    JSONObject postParams = new JSONObject();
	    postParams.put("name", task.getName());
	    postParams.put("description", task.getDescription());
	    postParams.put("authenticity_token", authenticityToken);
        if (task.getDuedate() == null) {
            postParams.put("duedate", "null");
        } else {
            postParams.put("duedate", AgendueDateHandler.sanitizeDate(task.getDuedate()));
        }
	    postParams.put("personalduedate", "null");
	    postParams.put("complete", false);
	    postParams.put("assignedto", task.getAssignedto());
        postParams.put("label", task.getLabel());
	    StringEntity entity = new StringEntity(postParams.toString());
	    //Execute post
	    HttpPost httppost = new HttpPost(baseURL + TASKS_URL);
	    httppost.addHeader("Content-Type", "application/json");
	    httppost.addHeader("accept", "application/json");
	    httppost.setEntity(entity);
	    
	    HttpResponse response = httpclient.execute(httppost, context);
	    requestCounter.decrementAndGet();
	    return EntityUtils.toString(response.getEntity());
	}

    /**
     * Adds the specified task
     * @param task The task to add
     * @return String results
     * @throws ParseException
     * @throws IOException
     * @throws JSONException
     */
    public String addPersonalTask(Task task)
            throws ParseException, IOException, JSONException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        JSONObject postParams = new JSONObject();
        postParams.put("title", task.getName());
        postParams.put("description", task.getDescription());
        postParams.put("authenticity_token", authenticityToken);
        if (task.getDuedate() == null) {
            postParams.put("duedate", "null");
        } else {
            postParams.put("duedate", AgendueDateHandler.sanitizeDate(task.getDuedate()));
        }
        postParams.put("complete", false);
        postParams.put("label", task.getLabel());
        StringEntity entity = new StringEntity(postParams.toString());
        //Execute post
        HttpPost httppost = new HttpPost(baseURL + PERSONAL_TASKS_URL);
        httppost.addHeader("Content-Type", "application/json");
        httppost.addHeader("accept", "application/json");
        httppost.setEntity(entity);

        HttpResponse response = httpclient.execute(httppost, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }

	/**
	 * Edits the specified project
	 * @param project The project to edit
	 * @return String result
	 * @throws ParseException
	 * @throws IOException
	 */
	public String editProject(Project project)
			throws ParseException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
	    HttpPut putter = new HttpPut(baseURL + PROJECTS_URL + "/" + project.getId() + ".json");
	    List<NameValuePair> pairs = new ArrayList<NameValuePair>(2);
	    pairs.add(new BasicNameValuePair("project[name]", project.getName()));
	    pairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
	    putter.setEntity(new UrlEncodedFormEntity(pairs));
	    httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
	    putter.setHeader("Content-Type", "application/x-www-form-urlencoded");
	    HttpResponse response = httpclient.execute(putter, context);
	    requestCounter.decrementAndGet();
	    return EntityUtils.toString(response.getEntity());
	}
	
	/**
	 * Edits the specified taskr
	 * @param newTask The task to save.
	 * @return String results
	 * @throws ParseException
	 * @throws IOException
	 * @throws JSONException
	 */
	public String editTask(Task newTask) throws ParseException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
	    List<NameValuePair> pairs = new ArrayList<NameValuePair>(7);
	    pairs.add(new BasicNameValuePair("task[name]", newTask.getName()));
	    pairs.add(new BasicNameValuePair("task[description]",newTask.getDescription()));
        if (newTask.getDuedate() != null) {
            pairs.add(new BasicNameValuePair("task[duedate]",
                    AgendueDateHandler.sanitizeDate(newTask.getDuedate())));
        }
	    pairs.add(new BasicNameValuePair("task[complete]", Boolean.toString(newTask.getComplete())));
	    pairs.add(new BasicNameValuePair("task[assignedto]", newTask.getAssignedto()));
        pairs.add(new BasicNameValuePair("task[label]", Integer.toString(newTask.getLabel())));
        pairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
	    HttpPut putter = new HttpPut(baseURL + TASK_DETAIL_URL + newTask.getId());
	    putter.setEntity(new UrlEncodedFormEntity(pairs));
	    httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
	    putter.setHeader("Content-Type", "application/x-www-form-urlencoded");
        putter.setHeader("Accept", "application/json");
	    HttpResponse response = httpclient.execute(putter, context);
	    requestCounter.decrementAndGet();
	    return "";
	}

    /**
     * Edits the specified taskr
     * @param newTask The task to save.
     * @return String results
     * @throws ParseException
     * @throws IOException
     * @throws JSONException
     */
    public String editPersonalTask(Task newTask) throws ParseException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        List<NameValuePair> pairs = new ArrayList<NameValuePair>(7);
        pairs.add(new BasicNameValuePair("personal_task[title]", newTask.getName()));
        pairs.add(new BasicNameValuePair("personal_task[description]",newTask.getDescription()));
        if (newTask.getDuedate() != null) {
            pairs.add(new BasicNameValuePair("personal_task[duedate]",
                    AgendueDateHandler.sanitizeDate(newTask.getDuedate())));
        }
        pairs.add(new BasicNameValuePair("personal_task[complete]", Boolean.toString(newTask.getComplete())));
        pairs.add(new BasicNameValuePair("personal_task[label]", Integer.toString(newTask.getLabel())));
        pairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
        HttpPut putter = new HttpPut(baseURL + PERSONAL_TASKS_URL + "/" + newTask.getId());
        putter.setEntity(new UrlEncodedFormEntity(pairs));
        httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);
        putter.setHeader("Content-Type", "application/x-www-form-urlencoded");
        putter.setHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(putter, context);
        requestCounter.decrementAndGet();
        return "";
    }

    /**
	 * Shares the specified project
	 * @param project the project to add a share to
	 * @param shareWith Email to share with
	 * @return String results
	 * @throws ParseException
	 * @throws IOException
	 */
	public String shareProject(Project project, Share shareWith)
			throws ParseException, IOException {
			int i = 0;
			while(requestCounter.get() >= 2) {
				i++;
			}
			requestCounter.incrementAndGet();
		    HttpPut patch = new HttpPut(baseURL + SHARE_URL + project.getId());
		    //Add project data			   
		    List<NameValuePair> pairs = new ArrayList<NameValuePair>(2);
		    pairs.add(new BasicNameValuePair("project[shares]", shareWith.getName()));
		    pairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
		    patch.setEntity(new UrlEncodedFormEntity(pairs));
		    //Execute post
		    HttpResponse response = httpclient.execute(patch, context);
		    requestCounter.decrementAndGet();
		    return EntityUtils.toString(response.getEntity());
	}
	
	/**
	 * Get users the project is shared with
	 * @return JSON projects objects
	 * @throws ParseException
	 * @throws IOException
	 */
	public String getShares() throws ParseException, IOException {
			int i = 0;
			while(requestCounter.get() >= 2) {
				i++;
			}
			requestCounter.incrementAndGet();
		    HttpGet httpGet = new HttpGet(baseURL + PROJECTS_URL);
		    httpGet.addHeader("Accept", "application/json");
		    HttpResponse response = httpclient.execute(httpGet, context);
		    requestCounter.decrementAndGet();
		    return EntityUtils.toString(response.getEntity());
	}

    /**
     * Gets the users on a project
     * @param project The project to get users for
     * @return The JSON user objects
     * @throws ParseException
     * @throws IOException
     */
    public String getSharesForProject(Project project) throws ParseException, IOException {
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        StringBuilder builder = new StringBuilder();
        builder.append(baseURL);
        builder.append(PROJECT_DETAILS_URL);
        builder.append(project.getId());
        builder.append("/");
        builder.append(SHARES);
        HttpGet httpGet = new HttpGet(builder.toString());
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
    }

	/**
	 * Creates a new account
	 * @param email Email address
	 * @param firstname First name
	 * @param lastname Last name
	 * @param password Password
	 * @param passwordconfirm Confirmed password
	 * @return String results
	 * @throws ParseException
	 * @throws IOException
	 */
	public String createAccount(String email, String firstname, String lastname,
			String password, String passwordconfirm)
			throws ParseException, IOException {
		int i = 0;
		while(requestCounter.get() >= 2) {
			i++;
		}
		requestCounter.incrementAndGet();
		HttpPost httppost = new HttpPost(baseURL + CREATEURL);
		HttpGet httpget = new HttpGet(baseURL + CREATENEWURL);

		HttpResponse response = httpclient.execute(httpget, context);
		String results = EntityUtils.toString(response.getEntity());
		authenticityToken = getToken(results);
	    // Add your data
	    List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(6);
	    nameValuePairs.add(new BasicNameValuePair("user[name]", email));
	    nameValuePairs.add(new BasicNameValuePair("user[firstname]", firstname));
	    nameValuePairs.add(new BasicNameValuePair("user[lastname]", lastname));
	    nameValuePairs.add(new BasicNameValuePair("user[password]", password));
	    nameValuePairs.add(new BasicNameValuePair("user[password_confirmation]", passwordconfirm));
	    httppost.addHeader("accept", "application/json");
	    nameValuePairs.add(new BasicNameValuePair("authenticity_token", authenticityToken));
	    httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
	    httpclient.getParams().setParameter(ClientPNames.ALLOW_CIRCULAR_REDIRECTS, true);

	    // Execute HTTP Post Request
	    response = httpclient.execute(httppost, context);
	    requestCounter.decrementAndGet();
        return EntityUtils.toString(response.getEntity());
	}

    /**
     * Gets a project wiki as JSON (in HTML)
     * @param project the project to find info for
     * @return JSON wiki
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getWikiForProject(Project project)
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PROJECT_DETAILS_URL + project.getId()
                + "/" + WIKI_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets a project message list in JSON
     * @param project the project to find info for
     * @return JSON messages
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getMessagesForProject(Project project)
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PROJECT_DETAILS_URL + project.getId()
                + "/" + MESSAGES_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }


    /**
     * Gets all the tasks for a user: host/tasks.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getAllTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets all the incomplete tasks for a user: host/tasks.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getAllIncompleteTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_URL + "/incomplete" + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets all the complete tasks for a user: host/tasks.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getAllCompleteTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_URL + "/complete" + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }


    /**
     * Gets all the assigned tasks for a user: host/tasks/assigned.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getYourTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_ASSIGNED_URL + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets all completed assigned tasks for a user: host/tasks/assigned.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getYourCompleteTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_ASSIGNED_URL + "/complete" + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    /**
     * Gets all the incomplete assigned tasks for a user: host/tasks/assigned.json
     * @return JSON representation of all tasks
     * @throws ClientProtocolException
     * @throws IOException
     */
    public String getYourIncompleteTasks()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while(requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + TASKS_ASSIGNED_URL + "/incomplete" + ".json");
        httpGet.addHeader("Accept", "application/json");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

    public String getEmptyWikiEditor()
            throws ClientProtocolException, IOException {
        //Execute HTTP get
        int i = 0;
        while (requestCounter.get() >= 2) {
            i++;
        }
        requestCounter.incrementAndGet();
        HttpGet httpGet = new HttpGet(baseURL + PROJECT_DETAILS_URL + "empty_wiki");
        HttpResponse response = httpclient.execute(httpGet, context);
        requestCounter.decrementAndGet();
        //Read results of HTTP get
        String str = EntityUtils.toString(response.getEntity());
        return str;
    }

	/**
	 * Sets up the HTTPClient to communicate over HTTPS
	 * @return set up HTTPClient
	 */
	private static HttpClient createHttpClient() {
	    HttpParams params = new BasicHttpParams();
	    HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
	    HttpProtocolParams.setContentCharset(params, HTTP.DEFAULT_CONTENT_CHARSET);
	    HttpProtocolParams.setUseExpectContinue(params, true);
	    HttpConnectionParams.setConnectionTimeout(params, 5000);
	    HttpConnectionParams.setSoTimeout(params, 5000);

	    SchemeRegistry schReg = new SchemeRegistry();
	    schReg.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
	    schReg.register(new Scheme("https", SSLSocketFactory.getSocketFactory(), 443));
	    ClientConnectionManager conMgr = new ThreadSafeClientConnManager(params, schReg);
	    return new DefaultHttpClient(conMgr, params);
	}
	
	/**
	 * Gets the AuthenticityToken out of a webpage
	 * @param webpage The full HTML (non-JSON) webpage
	 * @return the authenticity token
	 */
	private static String getToken(String webpage) {
		webpage = webpage.split("meta content=\"")[2];
		webpage = webpage.split("\" name=")[0];
		webpage = webpage.trim();
		return webpage;
	}



    public static String getDomain() {
        return baseURL;
    }
}
