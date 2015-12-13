package com.agendue.agendue;


import android.app.Fragment;
import android.app.FragmentManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CalendarView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.agendue.model.Message;
import com.agendue.model.Project;
import com.agendue.model.Task;
import com.agendue.web.AgendueWebHandler;

import java.util.GregorianCalendar;


/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.BulletinDetails#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class BulletinDetails extends Fragment {

    private String contentString;

    private String userString;

    private View view;

    private TextView content, user;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param message Message to display details of
     * @return A new instance of fragment TaskDetails.
     */




    public static BulletinDetails newInstance(Message message) {
        BulletinDetails fragment = new BulletinDetails();
        Bundle args = new Bundle();
        if(message.getContent()!=null) {
            args.putSerializable("content", message.getContent());
        }
        if(message.getUser()!=null) {
            args.putSerializable("user", message.getUser());
        }
        fragment.setArguments(args);
        return fragment;
    }
    public BulletinDetails() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        if (getArguments() != null) {
            try {
                contentString = (String) getArguments().getSerializable("content");
                userString = (String) getArguments().getSerializable("user");
            } catch (Exception e) {

            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        view = inflater.inflate(R.layout.fragment_bulletin_details, container, false);
        view = attachGUI(view);
        return view;

    }



    private View attachGUI(View view) {

        content = (TextView) view.findViewById(R.id.bulletin_details_content);
        user = (TextView) view.findViewById(R.id.bulletin_details_user);
        populateFields();
        return view;
    }

    //Populates fields with bulletin data
    protected void populateFields() {
        try {
            content.setText(contentString);
            user.setText(userString);
        } catch (Exception e) {

        }

    }


}
