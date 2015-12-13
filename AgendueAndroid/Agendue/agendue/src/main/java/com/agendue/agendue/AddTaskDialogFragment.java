package com.agendue.agendue;



import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CalendarView;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.DatePicker;

import com.agendue.adapters.TaskForProjectsAdapter;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;

import org.json.JSONException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.AddTaskDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class AddTaskDialogFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {


    private EditText taskName;
    private EditText taskDescription;
    private Spinner assignedSpinner;
    private Spinner labelSpinner;
    private EditText dueDateField;
    private Project project;
    private DatePickerDialog datePickerDialog;
    private FragmentManager fm;
    private Context baseContext;
    private Task task;
    private List<String> labels;
    private List<Share> shares;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     * @param project The project the task goes with
     * @return A new instance of fragment AddProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddTaskDialogFragment newInstance(Project project) {
        AddTaskDialogFragment fragment = new AddTaskDialogFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }
    public AddTaskDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
        if (project != null) {
            TasksForProjectFragment.bottomMenu.setGroupVisible(0,false);
        }
        baseContext = getActivity().getBaseContext();
        fm = getFragmentManager();
        labels = new ArrayList<String>(5);
        labels.add(getString(R.string.none));
        labels.add(getString(R.string.red));
        labels.add(getString(R.string.green));
        labels.add(getString(R.string.blue));
        labels.add(getString(R.string.yellow));
    }


//    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
        if (project != null) {
            GetShares getShares = new GetShares();
            getShares.execute();
            GetProject getProject = new GetProject();
            getProject.execute();
        }


        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.add_task))
                .setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        if (taskName.getText().toString().trim().equals("")) {
                            Toast.makeText(getActivity().getBaseContext(),
                                    getString(R.string.error_no_task_name),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            SaveNewTaskTask task = new SaveNewTaskTask();
                            task.execute();
                        }
                    }
                })
                .setNegativeButton(getString(R.string.cancel), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.fragment_add_task_dialog, null);

        taskName = (EditText) view.findViewById(R.id.add_task_name);
        taskDescription = (EditText) view.findViewById(R.id.add_task_description);
        dueDateField = (EditText) view.findViewById(R.id.add_task_duedate);
        assignedSpinner = (Spinner) view.findViewById(R.id.add_task_assign_spinner);

        if (project == null) {
            TextView assignedText = (TextView) view.findViewById(R.id.add_task_assign_text);
            assignedSpinner.setVisibility(View.GONE);
            assignedText.setVisibility(View.GONE);
        }
        labelSpinner = (Spinner) view.findViewById(R.id.add_task_label_spinner);
        Calendar cal = Calendar.getInstance();

        datePickerDialog = new DatePickerDialog(getActivity(), this, cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        datePickerDialog.getDatePicker().init(cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), new DatePicker.OnDateChangedListener() {
                    @Override
                    public void onDateChanged(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        dueDateField.setText(AgendueDateHandler.sanitizeDate(year, monthOfYear, dayOfMonth));

                    }
                });
        dueDateField.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {
                datePickerDialog.show();
            }
        });
        dueDateField.setOnFocusChangeListener(new View.OnFocusChangeListener() {

            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    datePickerDialog.show();
                }
            }
        });
        if (project != null) {
            List<Share> shareList = project.getShares();
            if (!shareList.contains(new Share(getString(R.string.none)))) {
                shareList.add(0, new Share(getString(R.string.none)));
            }

            ArrayAdapter<Share> shares = new ArrayAdapter<Share>(getActivity(), android.R.layout.simple_spinner_item, shareList);
            shares.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            assignedSpinner.setAdapter(shares);
            assignedSpinner.setSelection(shareList.indexOf(new Share(getString(R.string.none))));
        }

        ArrayAdapter<String> labelsAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, (List<String>) labels);
        labelsAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        labelSpinner.setAdapter(labelsAdapter);
        labelSpinner.setSelection(0);
        taskName.requestFocus();

        builder.setView(view);
        return builder.create();
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if (project != null) {
            TasksForProjectFragment.bottomMenu.setGroupVisible(0,true);
        }
        super.onDismiss(dialog);
    }

    @Override
    public void onDateSet(DatePicker dp, int y, int m, int d) {
        dueDateField.setText(datePickerDialog.getDatePicker().getYear() + "-" + (datePickerDialog.getDatePicker().getMonth()+1)+ "-" + datePickerDialog.getDatePicker().getDayOfMonth());
    }
    private class GetShares extends AsyncTask<String, String, String> {


        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.getSharesForProjectID(project.getId());
            } catch (IOException e) {
                e.printStackTrace();
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            try {
                shares = AgendueJSONParser.getShares(results);
                shares.add(0, new Share("None"));
                ArrayAdapter<Share> shareAdapter = new ArrayAdapter<Share>(getActivity(), android.R.layout.simple_spinner_item, shares);

                shareAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                assignedSpinner.setAdapter(shareAdapter);

                assignedSpinner.setSelection(0);

            } catch (JSONException e) {
                e.printStackTrace();
                shares = new ArrayList<Share>();
            }
        }
    }


    private class GetProject extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.getProjects();
            } catch (IOException e) {
                return "error";
            }

        }

        @Override
        protected void onPostExecute(String results) {
            try {
                List<Project> list = AgendueJSONParser.getProjects(results);
                for (Project pr : list) {
                    if (pr.getId().equals(project.getId())) {
                        project = pr;
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private class SaveNewTaskTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();

            try {
                task = new Task();
                task.setName(taskName.getText().toString().trim());
                if (project != null) {
                    task.setAssignedto(assignedSpinner.getSelectedItem().toString());
                }
                task.setDescription(taskDescription.getText().toString().trim());
                task.setComplete(false);
                task.setLabel(labelSpinner.getSelectedItemPosition());
                if (dueDateField.getText().toString() != null && !dueDateField.getText().toString().trim().equals("")) {
                    task.setDuedate(AgendueDateHandler.getGregorianDate(dueDateField.getText().toString()));
                }
                if (project == null) {
                    return wh.addPersonalTask(task);
                } else {
                    return wh.addTask(task, project);
                }
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
                if (project == null) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, PersonalTasksListFragment.newInstance()).addToBackStack("PersonalTasks").commit();
                } else {
                    TasksForProjectFragment.project.addTask(task);
                    TasksForProjectFragment.arrayAdapter = new TaskForProjectsAdapter(project.getTasks(), baseContext, false);
                    TasksForProjectFragment.arrayAdapter.notifyDataSetChanged();
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, TasksForProjectFragment.newInstance(project)).addToBackStack("TasksForProject").commit();
                }

            }
        }
    }

}
