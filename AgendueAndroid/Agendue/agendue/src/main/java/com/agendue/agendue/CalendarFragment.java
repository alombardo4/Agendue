package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CalendarView;
import android.widget.ListView;
import android.widget.Toast;

import com.agendue.adapters.AllTasksAdapter;
import com.agendue.adapters.TaskForProjectsAdapter;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.ListIterator;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link CalendarFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link CalendarFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CalendarFragment extends Fragment {

    private OnFragmentInteractionListener mListener;
    private List<Task> allTasks;
    private List<Task> daysTasks;
    private ListView calendarList;
    private CalendarView calendarView;
    private View view;
    private List<Project> projects;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CalendarFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static CalendarFragment newInstance() {
        CalendarFragment fragment = new CalendarFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    public CalendarFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        setHasOptionsMenu(true);
        view = inflater.inflate(R.layout.fragment_calendar, container, false);
        calendarList = (ListView) view.findViewById(R.id.calendar_listview);
        calendarView = (CalendarView) view.findViewById(R.id.calendar_calendar);
//        calendarView.setEnabled(false);
        GetCalendarTasks task = new GetCalendarTasks();
        task.execute();

        calendarView.setDate(System.currentTimeMillis());
        calendarView.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            public void onSelectedDayChange(CalendarView view, int year, int month, int dayOfMonth) {
                setDate(month, dayOfMonth, year);
            }
        });

        calendarList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                FragmentTransaction ft = getFragmentManager().beginTransaction();
                Project p = getProject(daysTasks.get(position).getProjectid());
                ft.replace(R.id.container, TaskDetails.newInstance(daysTasks.get(position), "7"), "TaskDetails").addToBackStack("TaskDetails").commit();
            }
        });

        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.calendar, menu);
        super.onCreateOptionsMenu(menu,inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();
        if (id == R.id.today_button) {
            calendarView.setDate(System.currentTimeMillis());
            GregorianCalendar today = new GregorianCalendar();
            today.setTimeInMillis(System.currentTimeMillis());
            setDate(today.get(GregorianCalendar.MONTH), today.get(GregorianCalendar.DAY_OF_MONTH), today.get(GregorianCalendar.YEAR));
        }
        return super.onOptionsItemSelected(item);
    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);

    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(Uri uri);
    }

    private void setDate(int month, int day, int year) {
        if (allTasks != null) {
            daysTasks = new ArrayList<Task>();
            for (Task task : allTasks) {
                if (task.getCalendarDate() != null && AgendueDateHandler.areDatesEqual(task.getCalendarDate(), month, day, year)) {
                    daysTasks.add(task);
                }
            }
            calendarList.setAdapter(new AllTasksAdapter(daysTasks, getActivity().getBaseContext()));
        }
    }
    private class GetCalendarTasks extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.getCalendar();
            } catch (IOException e) {
                e.printStackTrace();
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            ProjectsTask projectsTask= new ProjectsTask();
            projectsTask.execute();
            if (results!=null && results.equals("error")) {
                Toast.makeText(getActivity(), getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else try {

                allTasks = AgendueJSONParser.getTasks(results);
                calendarView.setEnabled(true);
                calendarView.setDate(System.currentTimeMillis());
                GregorianCalendar today = new GregorianCalendar();
                today.setTimeInMillis(System.currentTimeMillis());
                setDate(today.get(GregorianCalendar.MONTH), today.get(GregorianCalendar.DAY_OF_MONTH), today.get(GregorianCalendar.YEAR));
//                arrayAdapter = new TaskForProjectsAdapter(project.getTasks(), baseContext,false);
//                setListAdapter(arrayAdapter);
//                arrayAdapter.notifyDataSetChanged();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private class ProjectsTask extends AsyncTask<String, String, String> {
        protected String doInBackground(String... params) {

            AgendueWebHandler webHandler = AgendueWebHandler.getInstance();
            try {
                return webHandler.getProjects();
            } catch (Exception e) {
                return "error";
            }
        }

        protected void onPostExecute(String results) {
            if (results!=null && results.equals("error")) {
                Toast.makeText(getActivity(),getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else {
                try {
                    JSONArray jArray = new JSONArray(results);
                    projects = new ArrayList<Project>(jArray.length());
                    for (int i = 0; i < jArray.length(); i++) {
                        JSONObject currentProject = jArray.getJSONObject(i);
                        String name = currentProject.getString("name");
                        String id = currentProject.getString("id");
                        String allshares = currentProject.getString("allshares");
                        List<Share> shares = new ArrayList<Share>();
                        if (shares != null) {
                            String[] stringshares = allshares.split(",");
                            for (String shr : stringshares) {
                                if (!shr.trim().equals("")) {
                                    shares.add(new Share(shr.trim()));
                                }
                            }
                        }
                        Project project = new Project(id, name);
                        project.addAllShares(shares);
                        projects.add(project);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }


    /**
     * Gets project given a project id
     * @param projectid the project ID
     * @return the project
     */
    private Project getProject(String projectid) {

        ListIterator<Project> it = projects.listIterator();
        while(it.hasNext()) {
            Project p = it.next();
            System.out.println(p.getId());
            if(p.getId().equals(projectid)) {
                return p;
            }
        }
        return null;
    }
}
