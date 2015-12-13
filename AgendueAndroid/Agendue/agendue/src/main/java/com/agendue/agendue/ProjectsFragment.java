package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.TextView;
import android.widget.Toast;


import com.agendue.agendue.dummy.DummyContent;
import com.agendue.model.Project;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.agendue.model.Share;
import com.melnykov.fab.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * A fragment representing a list of Items.
 *
 * Large screen devices (such as tablets) are supported by replacing the ListView
 * with a GridView.
 *
 * Activities containing this fragment MUST implement the callbacks
 * interface.
 */
public class ProjectsFragment extends Fragment implements AbsListView.OnItemClickListener {

    private FloatingActionButton fab;

    private OnFragmentInteractionListener mListener;

    /**
     * The fragment's ListView/GridView.
     */
    private AbsListView mListView;

    /**
     * The Adapter which will be used to populate the ListView/GridView with
     * Views.
     */
    private ListAdapter mAdapter;

    protected static Menu bottomMenu;

    /**
     * The arraylist of a user's projects
     */
    private List<Project> projects;

    // TODO: Rename and change types of parameters
    public static ProjectsFragment newInstance() {
        ProjectsFragment fragment = new ProjectsFragment();
        return fragment;
    }

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public ProjectsFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_project_list, container, false);

        // Set the adapter
        mListView = (AbsListView) view.findViewById(android.R.id.list);

        // Set OnItemClickListener so we can be notified on item clicks
        mListView.setOnItemClickListener(this);
        ProjectsTask projects = new ProjectsTask();
        projects.execute();
        mListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            public boolean onItemLongClick(AdapterView parent, View view, int position, long id) {
                Project project;
                project = (Project) mAdapter.getItem(position);
                FragmentManager fm = getFragmentManager();
                EditProjectDialogFragment editor = EditProjectDialogFragment.newInstance(project);
                editor.show(fm, getString(R.string.edit_project));
                return true;
            }
        });
        fab = (FloatingActionButton) view.findViewById(R.id.add_project_fab);
        fab.setVisibility(View.VISIBLE);
        fab.setColorNormal(MainActivity.user.getSecondaryColor());
        fab.setColorPressed(MainActivity.user.getDarkerSecondaryColor());
        fab.setColorRipple(MainActivity.user.getDarkerSecondaryColor());
        fab.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                FragmentManager fm = getFragmentManager();
                AddProjectDialogFragment adder = new AddProjectDialogFragment();
                adder.show(fm, getString(R.string.add_project));
            }
        });
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.projects, menu);
        bottomMenu = menu;
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.add_project) {
            FragmentManager fm = getFragmentManager();
            AddProjectDialogFragment adder = new AddProjectDialogFragment();
            adder.show(fm, getString(R.string.add_project));
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


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (null != mListener) {
            // Notify the active callbacks interface (the activity, if the
            // fragment is attached to one) that an item has been selected.
            mListener.onFragmentInteraction(DummyContent.ITEMS.get(position).id);

        }
        FragmentTransaction ft = this.getFragmentManager().beginTransaction();
        ft.replace(R.id.container, TasksForProjectFragment.newInstance(projects.get(position)), "TasksForProject").addToBackStack("TasksForProject").commit();
//        ft.replace(R.id.container, new TaskFragment());
//        ft.commit();
    }



    /**
     * The default content for this Fragment has a TextView that is shown when
     * the list is empty. If you would like to change the text, call this method
     * to supply the text it should use.
     */
    public void setEmptyText(CharSequence emptyText) {
        View emptyView = mListView.getEmptyView();

        if (emptyText instanceof TextView) {
            ((TextView) emptyView).setText(emptyText);
        }
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
                    projects = AgendueJSONParser.getProjects(results);
                    mAdapter = new ArrayAdapter<Project>(getActivity(),
                            android.R.layout.simple_list_item_1, android.R.id.text1, projects);
                    ((AdapterView<ListAdapter>) mListView).setAdapter(mAdapter);
                } catch (Exception e) {
                    if(results.contains("shares")) {
                    } else {
                        e.printStackTrace();
                    }
                }


            }
        }
    }
}
