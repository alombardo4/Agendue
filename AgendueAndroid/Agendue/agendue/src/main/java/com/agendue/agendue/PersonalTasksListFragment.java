package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.ListFragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;


import com.agendue.adapters.AllTasksAdapter;
import com.agendue.agendue.dummy.DummyContent;
import com.agendue.model.Task;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.melnykov.fab.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;

/**
 * A fragment representing a list of Items.
 * <p/>
 * <p/>
 * interface.
 */
public class PersonalTasksListFragment extends ListFragment {

    private List<Task> tasks;
    private AllTasksAdapter adapter;
    private boolean isIncompleteList;
    private FloatingActionButton fab;

    // TODO: Rename and change types of parameters
    public static PersonalTasksListFragment newInstance() {
        PersonalTasksListFragment fragment = new PersonalTasksListFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public PersonalTasksListFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getListAdapter() == null || getListAdapter().getCount() < 1) {
            GetPersonalTasksTask getTasksTask = new GetPersonalTasksTask();
            getTasksTask.execute();
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        isIncompleteList = true;
        setHasOptionsMenu(true);
        View view = inflater.inflate(R.layout.fragment_tasks_list, container, false);

        fab = (FloatingActionButton) view.findViewById(R.id.add_task_fab);
        fab.setVisibility(View.VISIBLE);
        fab.setColorNormal(MainActivity.user.getSecondaryColor());
        fab.setColorPressed(MainActivity.user.getDarkerSecondaryColor());
        fab.setColorRipple(MainActivity.user.getDarkerSecondaryColor());
        fab.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                FragmentManager fm = getFragmentManager();
                AddTaskDialogFragment adder = AddTaskDialogFragment.newInstance(null);
                adder.show(fm, getString(R.string.add_task));
            }
        });
        setHasOptionsMenu(true);
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.personaltasks, menu);
        super.onCreateOptionsMenu(menu,inflater);
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();
        if (id == R.id.completed_tasks_button) {
            isIncompleteList = !isIncompleteList;
            if(isIncompleteList == true) {
                item.setTitle(getString(R.string.show_complete_tasks));
            } else {
                item.setTitle(getString(R.string.show_incomplete_tasks));
            }
            GetPersonalTasksTask getTasksTask = new GetPersonalTasksTask();
            getTasksTask.execute();
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
    }


    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);
        FragmentTransaction ft = this.getFragmentManager().beginTransaction();
        ft.replace(R.id.container, TaskDetails.newInstance(tasks.get(position), "8"), "TaskDetails").addToBackStack("TaskDetails").commit();
    }

    private class GetPersonalTasksTask extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                if (isIncompleteList) {
                    return wh.getPersonalTasks();
                } else {
                    return wh.getCompletePersonalTasks();
                }
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            System.out.println(results);
            try {
                tasks = AgendueJSONParser.getPersonalTasks(results);
                for (Task task : tasks) {
                    System.out.println(task.getLabelColor());
                }
                if (tasks.size() == 2) {
                    if (tasks.get(0).getId() == "-1" && tasks.get(0).getName() == getString(R.string.no_tasks_swipe_from_left)) {
                        tasks.remove(0);
                    }
                }
                setListAdapter(new AllTasksAdapter(tasks, getActivity().getBaseContext()));
            } catch (JSONException e) {
                Toast.makeText(getActivity(), getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
                e.printStackTrace();
            }
        }
    }

}
