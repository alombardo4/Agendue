package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentManager;
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


import com.agendue.agendue.dummy.DummyContent;
import com.agendue.model.Project;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.agendue.model.Share;

import org.json.JSONException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * A fragment representing a list of Items.
 * <p />
 * <p />
 * Activities containing this fragment MUST implement the callbacks
 * interface.
 */
public class ProjectSharesFragment extends ListFragment {

    private OnFragmentInteractionListener mListener;

    private Project project;

    protected static ArrayAdapter<Share> arrayAdapter;

    private View view;

    protected static Menu bottomMenu;

    public static ProjectSharesFragment newInstance(Project project) {
        ProjectSharesFragment fragment = new ProjectSharesFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }
    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public ProjectSharesFragment() {
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_shares_list, container, false);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");

        }
        setHasOptionsMenu(true);
        GetSharesTask task = new GetSharesTask();
        task.execute();
        return view;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();

        if (id == R.id.add_share) {
            FragmentManager fm = getFragmentManager();
            AddShareDialogFragment adder = AddShareDialogFragment.newInstance(project);
            adder.show(fm, getString(R.string.share_project));

        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // If the drawer is open, show the global app actions in the action bar. See also
        // showGlobalContextActionBar, which controls the top-left area of the action bar.
        inflater.inflate(R.menu.sharing, menu);
        bottomMenu = menu;
        super.onCreateOptionsMenu(menu, inflater);
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

    private class GetSharesTask extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.getSharesForProjectID(project.getId());
            } catch (IOException e) {
                return "error";
            }

        }

        @Override
        protected void onPostExecute(String results) {
            System.out.println("results: " + results);
            List<Share> shares = null;
            try {
                shares = AgendueJSONParser.getShares(results);
            } catch (JSONException e) {
                shares = new ArrayList<Share>();
            }
            for(int i = 0; i< shares.size(); i++) {
                if(shares.get(i).getName().equals(getString(R.string.none))) {
                    shares.remove(i);
                }
            }

            arrayAdapter = new ArrayAdapter<Share>(getActivity(),
                    android.R.layout.simple_list_item_1, android.R.id.text1, shares);
            setListAdapter(arrayAdapter);

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
}
