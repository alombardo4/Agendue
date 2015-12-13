package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
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
import android.webkit.WebView;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.web.AgendueWebHandler;

import org.json.JSONObject;

import java.io.IOException;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link WhiteboardFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link WhiteboardFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class WhiteboardFragment extends Fragment {
    private OnFragmentInteractionListener mListener;

    private View view;

    private WebView webView;

    private Project project;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment WhiteboardFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static WhiteboardFragment newInstance(Project project) {
        WhiteboardFragment fragment = new WhiteboardFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }
    public WhiteboardFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        view = inflater.inflate(R.layout.fragment_whiteboard, container, false);
        view = attachGUI(view);
        GetWhiteboardTask task = new GetWhiteboardTask();
        task.execute();
        setHasOptionsMenu(true);
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.whiteboard, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.edit_notebook_button) {
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.replace(R.id.container, EditWhiteboardFragment.newInstance(project), "EditWhiteboar").addToBackStack("EditWhiteboard").commit();
        }
        return super.onOptionsItemSelected(item);
    }

    private View attachGUI(View view) {
        webView = (WebView) view.findViewById(R.id.whiteboard_webview);

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


    private class GetWhiteboardTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                String results = wh.getWikiForProject(project);
                return results;
            } catch (IOException e) {
                return "error";
            }
        }

        protected void onPostExecute(String results) {
            if(results!=null && results.equals("error")) {
                Toast.makeText(getActivity(),getString(R.string.connection_error), Toast.LENGTH_SHORT).show();
            } else {
                try {
                    JSONObject object = new JSONObject(results);
                    String html = object.getString("wiki");
                    if (html.equals("null")) {
                        html = getString(R.string.no_notebook_here);
                    }
                    webView.loadData(html, "text/html", "UTF-8");
                } catch (Exception e) {
                    webView.loadData("An error occurred", "text/html", "UTF-8");
                }
            }
        }
    }
}