package com.agendue.web;

import android.graphics.Color;

import com.agendue.agendue.PersonalTasksListFragment;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * Created by alec on 11/13/14.
 */
public class AgendueJSONParser {

    public static int darkenColor(int color) {
        int a = Color.alpha(color);
        int r = Color.red(color);
        int g = Color.green(color);
        int b = Color.blue(color);
        float factor = 0.7f;
        return Color.argb( a,
                Math.max( (int)(r * factor), 0 ),
                Math.max( (int)(g * factor), 0 ),
                Math.max( (int)(b * factor), 0 ) );
    }
    public static List<Project> getProjects(String json) throws JSONException {
        JSONArray jArray = new JSONArray(json);
        List<Project> list = new ArrayList<Project>(jArray.length());
        for (int i = 0; i < jArray.length(); i++) {
            JSONObject currentProject = jArray.getJSONObject(i);
            String name = currentProject.getString("name");
            String id = currentProject.getString("id");
            Project project = new Project(id, name);
            list.add(project);
        }
        return list;
    }

    public static List<Share> getShares(String json) throws JSONException {
        List<Share> list = new ArrayList<Share>();
        JSONArray jsonArray = new JSONArray(json);
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            String name = jsonObject.getString("name");
            String facebook = jsonObject.getString("facebook");
            String google = jsonObject.getString("google_picture");
            String userid = jsonObject.getString("userid");
            Share share = new Share(name);
            share.setId(userid);
            share.setGoogle(google);
            share.setFacebook(facebook);
            list.add(share);
        }

        return list;
    }


    public static List<Task> getTasks(String json) throws JSONException {
        List<Task> list = new ArrayList<Task>();
        JSONArray jArray = new JSONArray(json);
        for (int i = 0; i < jArray.length(); i++) {
            JSONObject jsonObject = jArray.getJSONObject(i);
            String id = jsonObject.getString("id");
            String name = "";
            if (jsonObject.has("name")) {
                name = jsonObject.getString("name");
            } else if (jsonObject.has("title")) {
                name = jsonObject.getString("title");
            }
            String description = jsonObject.getString("description");
            String assignedto = jsonObject.getString("assignedto");
            String sDueDate = jsonObject.getString("duedate");
            int label;
            try {
                label = jsonObject.getInt("label");
            } catch (Exception e) {
                try {
                    label = Integer.parseInt(jsonObject.getString("label"));
                } catch (Exception e1) {
                    label = 0;
                }
            }
            GregorianCalendar duedate;
            if (sDueDate != null  && AgendueDateHandler.validFormat(sDueDate)) {
                duedate =
                        AgendueDateHandler.getGregorianDate(sDueDate);
            } else {
                duedate = null;
            }
            boolean complete;
            if (jsonObject.get("complete") == null || jsonObject.getString("complete").equals("null")) {
                complete = false;
            } else {
                complete = jsonObject.getBoolean("complete");
            }
            String projectid = jsonObject.getString("projectid");
            Task task = new Task(id, name, description, assignedto, duedate, complete, projectid, label);
            if (jsonObject.has("start")) {
                GregorianCalendar start;
                String sStart = jsonObject.getString("start");
                if (sStart != null  && AgendueDateHandler.validFormat(sStart)) {
                    start =
                            AgendueDateHandler.getGregorianDate(sStart);
                } else {
                    start = null;
                }
                task.setCalendarDate(start);
            }
            if (jsonObject.has("personal")) {
                task.setIsPersonal(jsonObject.getBoolean("personal"));
            } else {
                task.setIsPersonal(false);
            }
            list.add(task);
        }


        return list;
    }

    public static List<Task> getPersonalTasks(String json) throws JSONException {
        List<Task> list = new ArrayList<Task>();
        JSONArray jArray = new JSONArray(json);
        for (int i = 0; i < jArray.length(); i++) {
            JSONObject jsonObject = jArray.getJSONObject(i);
            String id = jsonObject.getString("id");
            String name = "";
            if (jsonObject.has("name")) {
                name = jsonObject.getString("name");
            } else if (jsonObject.has("title")) {
                name = jsonObject.getString("title");
            }
            String description = jsonObject.getString("description");
            String sDueDate = jsonObject.getString("duedate");
            int label;
            try {
                label = jsonObject.getInt("label");
            } catch (Exception e) {
                label = Integer.parseInt(jsonObject.getString("label"));
            }
            GregorianCalendar duedate;
            if (sDueDate != null  && AgendueDateHandler.validFormat(sDueDate)) {
                duedate =
                        AgendueDateHandler.getGregorianDate(sDueDate);
            } else {
                duedate = null;
            }
            boolean complete;
            if (jsonObject.get("complete") == null || jsonObject.getString("complete").equals("null")) {
                complete = false;
            } else {
                complete = jsonObject.getBoolean("complete");
            }
            Task task = new Task();
            task.setName(name);
            task.setDuedate(duedate);
            task.setDescription(description);
            task.setComplete(complete);
            task.setLabel(label);
            task.setId(id);
            task.setIsPersonal(true);
            if (jsonObject.has("start")) {
                GregorianCalendar start;
                String sStart = jsonObject.getString("start");
                if (sStart != null  && AgendueDateHandler.validFormat(sStart)) {
                    start =
                            AgendueDateHandler.getGregorianDate(sStart);
                } else {
                    start = null;
                }
                task.setCalendarDate(start);
            }
            list.add(task);
        }


        return list;
    }
 }
