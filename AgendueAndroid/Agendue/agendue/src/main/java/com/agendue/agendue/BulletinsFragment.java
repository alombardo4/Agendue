package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ListFragment;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.agendue.adapters.BulletinAdapter;
import com.agendue.model.Message;
import com.agendue.model.Project;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueWebHandler;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * A fragment representing a list of Items.
 * <p />
 * <p />
 * Activities containing this fragment MUST implement the callbacks
 * interface.
 */
public class BulletinsFragment extends ListFragment {

    private Project project;

    private EditText messageContent;

    private Button sendButton;
    private OnFragmentInteractionListener mListener;

    private BulletinAdapter adapter;

    private List<Message> messages;

    protected static Menu bottomMenu;


    public static BulletinsFragment newInstance(Project project) {
        BulletinsFragment fragment = new BulletinsFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public BulletinsFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_bulletins_list, container, false);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");

        }
        sendButton = (Button) view.findViewById(R.id.message_send);
        messageContent = (EditText) view.findViewById(R.id.message_send_content);
        sendButton.setOnClickListener(new SendButtonClickListner());
        if (getListAdapter() == null || getListAdapter().getCount() < 1) {
            GetBulletinsTask getBulletinsTask = new GetBulletinsTask();
            getBulletinsTask.execute();
        }
        //setHasOptionsMenu(true);

        return view;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();
        if (id == R.id.add_bulletin_button) {
            FragmentManager fm = getFragmentManager();
            AddBulletinDialogFragment adder = AddBulletinDialogFragment.newInstance(project);
            adder.show(fm, getString(R.string.add_task));

        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // If the drawer is open, show the global app actions in the action bar. See also
        // showGlobalContextActionBar, which controls the top-left area of the action bar.
        inflater.inflate(R.menu.bulletins, menu);
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

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);
        FragmentTransaction ft = this.getFragmentManager().beginTransaction();

        ft.replace(R.id.container, BulletinDetails.newInstance(messages.get(position)), "BulletinDetails").addToBackStack("BulletinDetails").commit();
    }

    private class SendButtonClickListner implements View.OnClickListener {

        @Override
        public void onClick(View v) {
            if (messageContent.getText().toString().equals("")) {
                Toast.makeText(getActivity().getBaseContext(), getString(R.string.error_no_bulletin_content), Toast.LENGTH_SHORT).show();
            } else {
                SaveNewBulletinTask task = new SaveNewBulletinTask();
                task.execute();
            }


        }

        private class SaveNewBulletinTask extends AsyncTask<String, String, String> {
            @Override
            protected String doInBackground(String... params) {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                try {
                    Message message = new Message(messageContent.getText().toString());
                    return wh.addMessage(message);
                } catch (Exception e) {
                    return "error";
                }
            }

            @Override
            protected void onPostExecute(String results) {
                if (results.equals("error")) {
                    Toast.makeText(getActivity().getBaseContext(), getString(R.string.connection_error),
                            Toast.LENGTH_SHORT).show();
                } else {
                    messageContent.getText().clear();

                    GetBulletinsTask getBulletinsTask = new GetBulletinsTask();
                    getBulletinsTask.execute();
                }
            }
        }
    }

    private class GetBulletinsTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            try {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                String results = wh.getMessagesForProject(project);
                return results;
            } catch (IOException e) {
                return "error";
            }
        }

        protected void onPostExecute(String results) {
            if (results.equals("error")) {
                System.out.println("error");
            } else try {
                JSONArray jArray = new JSONArray(results);
                messages = new ArrayList<Message>(jArray.length());
                for (int i = 0; i < jArray.length(); i++) {
                    JSONObject jsonObject = jArray.getJSONObject(i);
                    String user = jsonObject.getString("user");
                    String subject = jsonObject.getString("subject");
                    String content = jsonObject.getString("content");
                    String screated = jsonObject.getString("created_at");
                    GregorianCalendar created;
                    if (screated!= null  && AgendueDateHandler.validFormat(screated)) {
                        created =
                                AgendueDateHandler.getGregorianDate(screated);
                    } else {
                        created= null;
                    }
                    messages.add(new Message(user, content, subject, created));

                }

                if(messages.size()==2) {
                    if(messages.get(0).getUser()=="" && messages.get(0).getContent()==getString(R.string.no_bulletins))
                    {
                        messages.remove(0);
                    }
                }
                Collections.reverse(messages);
                adapter = new BulletinAdapter(messages, getActivity().getBaseContext());
                setListAdapter(adapter);

                getListView().setSelection(adapter.getCount() - 1);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
