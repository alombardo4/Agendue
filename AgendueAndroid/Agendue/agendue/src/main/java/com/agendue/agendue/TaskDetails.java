package com.agendue.agendue;



import android.app.FragmentManager;
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
import android.widget.CalendarView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.model.Task;
import com.agendue.web.AgendueWebHandler;

import org.w3c.dom.Text;

import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link TaskDetails#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class TaskDetails extends Fragment {

    private Task task;

    private Project project;

    private View view;

    private CalendarView calendar;

    private TextView assignedTo, description, name, assignedToText;

    private View assignedToLine;

    private CheckBox checkBox;

    private TextView dueDate;

    private WebView label;

    protected static Menu bottomMenu;

    private boolean iscomplete;

    private String previousScreen;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param task Task to display details of
     * @return A new instance of fragment TaskDetails.
     */




    public static TaskDetails newInstance(Task task, String previousScreen) {
        TaskDetails fragment = new TaskDetails();
        Bundle args = new Bundle();
        args.putSerializable("task", task);
        args.putSerializable("previousScreen", previousScreen);
        fragment.setArguments(args);
        return fragment;
    }
    public TaskDetails() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        if (getArguments() != null) {
            task = (Task) getArguments().getSerializable("task");
            previousScreen = (String) getArguments().getSerializable("previousScreen");
        }


    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        view = inflater.inflate(R.layout.fragment_task_details, container, false);
        view = attachGUI(view);
        return view;

    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.editfortasks, menu);
        bottomMenu = menu;

        super.onCreateOptionsMenu(menu, inflater);

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();
        if (id == R.id.edit_task_button) {
            FragmentManager fm = getFragmentManager();
            EditTaskDialogFragment editor = EditTaskDialogFragment.newInstance(project, task, previousScreen);
            editor.show(fm, getString(R.string.edit_task));

        }

        return super.onOptionsItemSelected(item);
    }

    private View attachGUI(View view) {
        calendar = (CalendarView) view.findViewById(R.id.task_details_calendar);
        calendar.setEnabled(false);

        description = (TextView) view.findViewById(R.id.task_details_description);

        assignedTo = (TextView) view.findViewById(R.id.task_details_assigned);
        dueDate = (TextView) view.findViewById(R.id.task_details_duedate);
        name = (TextView) view.findViewById(R.id.task_details_title);
        checkBox= (CheckBox) view.findViewById(R.id.task_details_checkbox);
        checkBox.setOnCheckedChangeListener(
                new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        if(!checkBox.isChecked()) {
                            iscomplete = true;
                            checkBox.setEnabled(false);
                            updateCompleted();
                        } else {
                            iscomplete = false;
                            checkBox.setEnabled(false);
                            updateCompleted();
                        }
                    }
                }
        );
        label = (WebView) view.findViewById(R.id.task_details_label);
        label.setVerticalScrollBarEnabled(false);
        label.setHorizontalScrollBarEnabled(false);
        populateFields(task);
        assignedToLine = (View) view.findViewById(R.id.task_details_assigned_line);
        assignedToText = (TextView) view.findViewById(R.id.task_details_assigned_title);
        if (previousScreen.equals("8") || task.isPersonal() == true) {
            assignedTo.setVisibility(View.GONE);
            assignedToLine.setVisibility(View.GONE);
            assignedToText.setVisibility(View.GONE);
        }
        return view;
    }

    //Populates fields with task data
    protected void populateFields(Task t) {

        if(t.getComplete()) {
            checkBox.setChecked(true);
        } else {
            checkBox.setChecked(false);
        }

        description.setText(t.getDescription());

        if(t.getDescription()==null || t.getDescription().equals("")) {
            description.setVisibility(view.INVISIBLE);
            View description_line = (View) view.findViewById(R.id.task_details_description_line);
            description_line.setVisibility(view.INVISIBLE);
            TextView description_title = (TextView) view.findViewById(R.id.task_details_description1);
            description_title.setVisibility(view.INVISIBLE);

            RelativeLayout.LayoutParams p = (RelativeLayout.LayoutParams)dueDate.getLayoutParams();
            p.addRule(RelativeLayout.BELOW, R.id.task_details_assigned);
            dueDate.setLayoutParams(p);

        }

        if (t.getDuedate() == null) {
            calendar.setVisibility(View.INVISIBLE);
            dueDate.setVisibility(View.INVISIBLE);
            View duedate_line= (View) view.findViewById(R.id.task_details_duedate_line);
            duedate_line.setVisibility(view.INVISIBLE);
        } else {
            calendar.setDate(t.getDuedate().getTimeInMillis());
            GregorianCalendar cal2 = new GregorianCalendar();
            cal2.setTimeInMillis(t.getDuedate().getTimeInMillis());
            cal2.set(GregorianCalendar.DATE, cal2.getActualMaximum(GregorianCalendar.DATE));
            calendar.setMaxDate(cal2.getTimeInMillis());
            cal2.set(GregorianCalendar.DATE, 1);
            calendar.setMinDate(cal2.getTimeInMillis());
        }


        name.setText(t.getName());
        if (t.getAssignedto() == null || t.getAssignedto().equals("null")) {
            assignedTo.setText("");
        } else {
            assignedTo.setText(t.getAssignedto());
        }
        if (t.getLabel() != 0) {
            label.setBackgroundColor(t.getLabelColor());
        } else {
            label.setVisibility(View.INVISIBLE);
        }
    }
    public void updateCompleted() {
        UpdateCompleteTask uct = new UpdateCompleteTask();
        uct.execute();
    }

    private class UpdateCompleteTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                if(iscomplete) {
                    task.setComplete(false);
                    iscomplete = false;
                } else {
                    task.setComplete(true);
                    iscomplete = true;
                }
                if (previousScreen.equals("8") || task.isPersonal() == true) {
                    return wh.editPersonalTask(task);
                } else {
                    return wh.editTask(task);
                }
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            checkBox.setEnabled(true);
            if (results != null && results.equals("error")) {
                if(iscomplete) {
                    checkBox.setChecked(true);
                    task.setComplete(true);
                } else {
                    checkBox.setChecked(false);
                    task.setComplete(false);
                }
                Toast.makeText(getActivity(),getString(R.string.connection_error),Toast.LENGTH_SHORT).show();
            }
        }
    }

}
