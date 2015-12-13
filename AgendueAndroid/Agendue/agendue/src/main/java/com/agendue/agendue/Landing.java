package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.adapters.AllTasksAdapter;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.ListIterator;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link Landing.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link Landing#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class Landing extends Fragment {

    private List<Task> tasks, personalTasks;
    private List<Project> projects;

    private OnFragmentInteractionListener mListener;
    private ListView listView, personalListView;
    private TextView incompleteTasksTextView;
    private AllTasksAdapter adapter, personalAdapter;
    private View view;
    private TabHost tabHost;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment Landing.
     */
    // TODO: Rename and change types and number of parameters
    public static Landing newInstance() {
        Landing fragment = new Landing();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }
    public Landing() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {

        }

    }


    @Override
    public void onResume() {
        super.onResume();

    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        view = inflater.inflate(R.layout.fragment_landing, container, false);

        view = attachGUI(view);
        return view;
    }

    private View attachGUI(View view) {
        listView = (ListView) view.findViewById(R.id.upcoming_tasks_listview);
        personalListView = (ListView) view.findViewById(R.id.landing_personal_tasks_listview);
        incompleteTasksTextView = (TextView) view.findViewById(R.id.incomplete_count_textview);
        tabHost = (TabHost) view.findViewById(R.id.landing_tabHost);
        tabHost.setup();
        TabHost.TabSpec projectsTab = tabHost.newTabSpec("Projects");
        projectsTab.setIndicator("Projects");
        projectsTab.setContent(R.id.upcoming_tasks_listview);
        TabHost.TabSpec personalTab = tabHost.newTabSpec("Personal");
        personalTab.setIndicator("Personal");
        personalTab.setContent(R.id.landing_personal_tasks_listview);
        tabHost.addTab(projectsTab);
        tabHost.addTab(personalTab);
//        productivityScore.getSettings().setJavaScriptEnabled(true);
//        productivityScore.getSettings().setBuiltInZoomControls(false);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {

                FragmentTransaction ft = getFragmentManager().beginTransaction();
                Project p = getProject(tasks.get(position).getProjectid());
                ft.replace(R.id.container, TaskDetails.newInstance(tasks.get(position), "6"), "TaskDetails").addToBackStack("TaskDetails").commit();

            }
        });
        personalListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {

                FragmentTransaction ft = getFragmentManager().beginTransaction();
                ft.replace(R.id.container, TaskDetails.newInstance(personalTasks.get(position), "9"), "TaskDetails").addToBackStack("TaskDetails").commit();

            }
        });
        if (listView == null || listView.getAdapter() == null || listView.getAdapter().getCount() < 1) {
            GetTasksTask getTasksTask = new GetTasksTask();
            getTasksTask.execute();
        }
        if (personalAdapter == null || personalListView.getAdapter() == null || personalListView.getAdapter().getCount() < 1) {
            GetPersonalTasks personalTasksGet = new GetPersonalTasks();
            personalTasksGet.execute();
        }
        GetIncompleteCountTask task = new GetIncompleteCountTask();
        task.execute();
        return view;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
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
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(Uri uri);
    }


    private class GetIncompleteCountTask extends  AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                return wh.getLandingIncompleteCount();
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            if (results != null && results.equals("error")) {
                Toast.makeText(getActivity(), getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else {
                try {
                    JSONObject object = new JSONObject(results);
                    int count = object.getInt("count");
                    if (count == 0) {
                        incompleteTasksTextView.setText(getString(R.string.no_incomplete_tasks));
                    } else if (count == 1) {
                        incompleteTasksTextView.setText(getString(R.string.you_have) + " " + count + " " + getString(R.string.incomplete_task));
                    } else {
                        incompleteTasksTextView.setText(getString(R.string.you_have) + " " + count + " " + getString(R.string.incomplete_tasks));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        }
    }

    private class GetPersonalTasks extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                return wh.getLandingPersonal();
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            if (results != null && results.equals("error")) {
                Toast.makeText(getActivity(), getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else {
                try {
                    personalTasks = AgendueJSONParser.getPersonalTasks(results);
                    personalAdapter = new AllTasksAdapter(personalTasks, getActivity().getBaseContext());
                    personalListView.setAdapter(personalAdapter);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    private class GetTasksTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                return wh.getLandingUpcoming();
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            if (results != null && results.equals("error")) {
                Toast.makeText(getActivity(), getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else try {
                ProjectsTask projectsTask= new ProjectsTask();
                projectsTask.execute();
                JSONArray jArray = new JSONArray(results);
                tasks = AgendueJSONParser.getTasks(results);

                if (tasks.size() == 2) {
                    if (tasks.get(0).getId() == "-1" && tasks.get(0).getName() == getString(R.string.no_tasks_swipe_from_left)) {
                        tasks.remove(0);
                    }
                }

                adapter = new AllTasksAdapter(tasks, getActivity().getBaseContext());
                listView.setAdapter(adapter);
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
