package com.agendue.agendue;

import android.app.ActionBar;
import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.ListFragment;
import android.view.LayoutInflater;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.view.Menu;
import android.widget.Toast;

import com.agendue.adapters.TaskForProjectsAdapter;
import com.agendue.model.Project;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.melnykov.fab.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * A fragment representing a list of Items.
 * <p />
 * <p />
 * Activities containing this fragment MUST implement the callbacks
 * interface.
 */
public class TasksForProjectFragment extends ListFragment {

    protected static Project project;

    private OnFragmentInteractionListener mListener;

    private Context baseContext;

    private FloatingActionButton fab;

    protected static TaskForProjectsAdapter arrayAdapter;

    protected static Menu bottomMenu;

    public static TasksForProjectFragment newInstance(Project project) {
        TasksForProjectFragment fragment = new TasksForProjectFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public TasksForProjectFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_tasks_list, container, false);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");

        }
        baseContext = this.getActivity().getBaseContext();
        fab = (FloatingActionButton) view.findViewById(R.id.add_task_fab);
        fab.setVisibility(View.VISIBLE);
        fab.setColorNormal(MainActivity.user.getSecondaryColor());
        fab.setColorPressed(MainActivity.user.getDarkerSecondaryColor());
        fab.setColorRipple(MainActivity.user.getDarkerSecondaryColor());
        fab.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                FragmentManager fm = getFragmentManager();
                AddTaskDialogFragment adder = AddTaskDialogFragment.newInstance(project);
                adder.show(fm, getString(R.string.add_task));
            }
        });
        setHasOptionsMenu(true);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        GetTasksTask getTasksTask = new GetTasksTask();
        getTasksTask.execute();
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();
        if (id == R.id.sharing) {
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.replace(R.id.container, ProjectSharesFragment.newInstance(project), "ProjectShares").addToBackStack("ProjectShares").commit();
        } else if(id==R.id.bulletins_button) {
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.replace(R.id.container, BulletinsFragment.newInstance(project), "Bulletins").addToBackStack("Bulletins").commit();
        } else if(id==R.id.whiteboard_button) {
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.replace(R.id.container, WhiteboardFragment.newInstance(project), "Whiteboard").addToBackStack("Whiteboard").commit();
        } else if(id==R.id.completed_tasks_button) {
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.replace(R.id.container, CompleteTasksFragment.newInstance(project), "CompleteTasks").addToBackStack("CompleteTasks").commit();
        } else if (id==R.id.edit_project_button) {
            FragmentManager fm = getFragmentManager();
            EditProjectDialogFragment editor = EditProjectDialogFragment.newInstance(project);
            editor.show(fm, getString(R.string.edit_project));
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // If the drawer is open, show the global app actions in the action bar. See also
        // showGlobalContextActionBar, which controls the top-left area of the action bar.
        inflater.inflate(R.menu.tasksforprojects, menu);
        bottomMenu = menu;
        super.onCreateOptionsMenu(menu, inflater);
    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
//        try {
//            mListener = (OnFragmentInteractionListener) activity;
//        } catch (ClassCastException e) {
//            throw new ClassCastException(activity.toString()
//                + " must implement OnFragmentInteractionListener");
//        }


    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }



    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        FragmentTransaction ft = this.getFragmentManager().beginTransaction();
        ft.replace(R.id.container, TaskDetails.newInstance(project.getTasks().get(position), "1"), "TaskDetails").addToBackStack("TaskDetails").commit();
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
        public void onFragmentInteraction(String id);
    }


    private class GetTasksTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                String results = wh.getInccompleteTasksForProject(project);
                return results;
            } catch (IOException e) {
                return "error";
            }
        }

        protected void onPostExecute(String results) {
            if (results!=null && results.equals("error")) {
                Toast.makeText(getActivity(),getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else try {

                project.setTasks(AgendueJSONParser.getTasks(results));

                if(project.getTasks().size()==2) {
                    if(project.getTasks().get(0).getId()=="-1" && project.getTasks().get(0).getName()==getString(R.string.no_tasks_here)) {
                        project.getTasks().remove(0);
                    }
                }
                arrayAdapter = new TaskForProjectsAdapter(project.getTasks(), baseContext,false);
                setListAdapter(arrayAdapter);
                arrayAdapter.notifyDataSetChanged();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
