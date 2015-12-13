package com.agendue.agendue;


import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.PorterDuff;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CalendarView;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.adapters.TaskForProjectsAdapter;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueJSONParser;
import com.agendue.web.AgendueWebHandler;
import com.google.android.gms.plus.model.people.Person;

import org.json.JSONException;
import org.w3c.dom.Text;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.EditTaskDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class EditTaskDialogFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {


    private EditText taskName;
    private EditText taskDescription;
    private Spinner assignedSpinner;
    private EditText dueDateField;
    private TextView assignedText;
    private CheckBox complete;
    private Project project;
    private Button deleteButton;
    private Task task;
    private DatePickerDialog datePickerDialog;
    private Context baseContext;
    private FragmentManager fm;
    private String previousScreen; //1 is Tasks for Project, 2 is Your Tasks, 3 is All Tasks, 4 is for Complete Tasks Fragment, 5 tasks for project, 6 for landing, 7 for calendar, 8 is for Personal Tasks
    private static EditTaskDialogFragment fragment;
    private static boolean waittoclose = true;
    private static AlertDialog dialogReference;
    private List<String> labels;
    private List<Share> shares;
    private Spinner labelSpinner;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment EditProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static EditTaskDialogFragment newInstance(Project project, Task task, String previousScreen) {
        waittoclose = true;
        fragment = new EditTaskDialogFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        args.putSerializable("task", task);
        args.putSerializable(("previousScreen"), previousScreen);
        fragment.setArguments(args);
        return fragment;
    }
    public EditTaskDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

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
            task = (Task) getArguments().getSerializable("task");
            previousScreen = (String) getArguments().getSerializable("previousScreen");
        }
        if (!previousScreen.equals("8")) {
            GetShares getShares = new GetShares();
            getShares.execute();
            GetProject getProject = new GetProject();
            getProject.execute();
        }


        final AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.edit_task))
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
        View view = inflater.inflate(R.layout.fragment_edit_task_dialog, null);
        if(!previousScreen.equals("5")) {
            TaskDetails.bottomMenu.setGroupVisible(0,false);
        }
        taskName = (EditText) view.findViewById(R.id.edit_task_name);
        taskName.setText(task.getName());
        complete = (CheckBox) view.findViewById((R.id.edit_task_complete_checkbox));
        complete.setChecked(task.getComplete());
        assignedText = (TextView) view.findViewById(R.id.edit_task_assign_text);
        taskDescription = (EditText) view.findViewById(R.id.edit_task_description);
        taskDescription.setText(task.getDescription());
        dueDateField = (EditText) view.findViewById(R.id.edit_task_duedate);
        labelSpinner = (Spinner) view.findViewById(R.id.edit_task_label_spinner);
        if(task.getDuedate()!=null) {
            dueDateField.setText(AgendueDateHandler.sanitizeDate(task.getDuedate()));
        }
        assignedSpinner = (Spinner) view.findViewById(R.id.edit_task_assign_spinner);

        Calendar cal = Calendar.getInstance();
        datePickerDialog = new DatePickerDialog(getActivity(), this, cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        datePickerDialog = new DatePickerDialog(getActivity(), this, cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        if (task.getDuedate() != null) {
            datePickerDialog.getDatePicker().init(task.getDuedate().get(GregorianCalendar.YEAR),
                    task.getDuedate().get(GregorianCalendar.MONTH), task.getDuedate().get(GregorianCalendar.DAY_OF_MONTH), new DatePicker.OnDateChangedListener() {
                        @Override
                        public void onDateChanged(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                            dueDateField.setText(AgendueDateHandler.sanitizeDate(year, monthOfYear, dayOfMonth));

                        }
                    });
        } else
        {
            datePickerDialog.getDatePicker().init(cal.get(Calendar.YEAR),
                    cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), new DatePicker.OnDateChangedListener() {
                        @Override
                        public void onDateChanged(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                            dueDateField.setText(AgendueDateHandler.sanitizeDate(year, monthOfYear, dayOfMonth));

                        }
                    });
        }

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


        if (previousScreen.equals("8") || task.isPersonal() == true) {
            assignedSpinner.setVisibility(View.GONE);
            assignedText.setVisibility(View.GONE);
        }
        deleteButton = (Button) view.findViewById(R.id.edit_task_delete);
//        deleteButton.getBackground().setColorFilter(0xFFFF0000, PorterDuff.Mode.MULTIPLY);
        deleteButton.setOnClickListener(new View.OnClickListener()
        {
            public void onClick(View v)
            {
                new AlertDialog.Builder(v.getContext())
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .setTitle(R.string.delete_task)
                        .setMessage(R.string.delete_task_confirmation)
                        .setPositiveButton(getString(R.string.yes), new DialogInterface.OnClickListener()
                        {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                DeleteTaskTask deleteTaskTask = new DeleteTaskTask();
                                deleteTaskTask.execute();

                            }

                        })
                        .setNegativeButton(getString(R.string.no), null)
                        .show();
            }
        });




        ArrayAdapter<String> labelsAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, (List<String>) labels);
        labelsAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        labelSpinner.setAdapter(labelsAdapter);
        labelSpinner.setSelection(task.getLabel());

        //TODO: Perhpas this is a bad way of picking shares?


        taskName.requestFocus();

        builder.setView(view);
        dialogReference = builder.create();
        return dialogReference;
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if(!previousScreen.equals("5")) {
            TaskDetails.bottomMenu.setGroupVisible(0,true);
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
                return wh.getSharesForProjectID(task.getProjectid());
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

                Share assigned = new Share(task.getAssignedto());
                int index = shares.indexOf(assigned);
                assignedSpinner.setSelection(index);

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
                    if (pr.getId().equals(task.getProjectid())) {
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
                task.setName(taskName.getText().toString().trim());
                if (!previousScreen.equals("8") && task.isPersonal() != true) {
                    task.setAssignedto(assignedSpinner.getSelectedItem().toString());
                }
                task.setDescription(taskDescription.getText().toString().trim());
                task.setComplete(complete.isChecked());
                task.setLabel(labelSpinner.getSelectedItemPosition());
                if (dueDateField.getText().toString() != null && !dueDateField.getText().toString().trim().equals("")) {
                    task.setDuedate(AgendueDateHandler.getGregorianDate(dueDateField.getText().toString()));
                }
                if (previousScreen.equals("8") || task.isPersonal() == true) {
                    return wh.editPersonalTask(task);
                } else {
                    return wh.editTask(task);
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            System.out.println(results);
            if (results != null && results.equals("error")) {
                //TODO: Handle error
            } else {
                if (previousScreen.equals("1")) {
                    fm.popBackStack();
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, TasksForProjectFragment.newInstance(project), "TasksForProject").addToBackStack("TasksForProject").commit();
                } else if (previousScreen.equals("2")) {
                    fm.popBackStack("AllTasks", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    fm.beginTransaction()
                            .replace(R.id.container, AllTasksFragment.newInstance(), "AllTasks").addToBackStack("AllTasks").commit();
                } else if (previousScreen.equals("3")) {
                    fm.popBackStack("YourTasks", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    fm.beginTransaction()
                            .replace(R.id.container, YourTasksFragment.newInstance(), "YourTasks").addToBackStack("YourTasks").commit();

                } else if (previousScreen.equals("4")) {
                    fm.popBackStack("CompleteTasks", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    fm.beginTransaction()
                            .replace(R.id.container, CompleteTasksFragment.newInstance(project), "CompleteTasks").addToBackStack("CompleteTasks").commit();
                } else if (previousScreen.equals("5")) {

                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, TasksForProjectFragment.newInstance(project), "TasksForProject").addToBackStack("TasksForProject").commit();

                } else if (previousScreen.equals("6")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
                } else if (previousScreen.equals("7")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, CalendarFragment.newInstance(), "Calendar").addToBackStack("Calendar").commit();
                } else if (previousScreen.equals("8")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, PersonalTasksListFragment.newInstance(), "PersonalTasks").addToBackStack("PersonalTasks").commit();
                } else if (previousScreen.equals("9")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
                }
            }
        }
    }

    private class DeleteTaskTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();

            try {
                if (previousScreen.equals("8") || task.isPersonal() == true) {
                    return wh.deletePersonalTask(task);
                } else {
                    return wh.deleteTask(task);
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            if (results != null && results.equals("error")) {
                //TODO: Handle Error
            } else {
                if(previousScreen.equals("1")) {
                    fm.popBackStack();
                    fm.popBackStack();
                } else if (previousScreen.equals("2")) {
                    fm.popBackStack("AllTasks", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    fm.beginTransaction()
                            .replace(R.id.container, AllTasksFragment.newInstance(), "AllTasks").addToBackStack("AllTasks").commit();
                } else if (previousScreen.equals("3")) {
                    fm.popBackStack("YourTasks", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    fm.beginTransaction()
                            .replace(R.id.container, YourTasksFragment.newInstance(), "YourTasks").addToBackStack("YourTasks").commit();

                } else if (previousScreen.equals("5")) {

                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, TasksForProjectFragment.newInstance(project), "TasksForProject").addToBackStack("TasksForProject").commit();
                } else if (previousScreen.equals("6")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
                } else if (previousScreen.equals("7")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, CalendarFragment.newInstance(), "Calendar").addToBackStack("Calendar").commit();
                } else if (previousScreen.equals("8")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, PersonalTasksListFragment.newInstance(), "PersonalTasks").addToBackStack("PersonalTasks").commit();
                } else if (previousScreen.equals("9")) {
                    fm.popBackStack();
                    fm.beginTransaction()
                            .replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
                }
                dialogReference.dismiss();

            }
        }
    }

}
