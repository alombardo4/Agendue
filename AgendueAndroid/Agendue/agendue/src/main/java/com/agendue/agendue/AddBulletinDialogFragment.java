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
import android.os.SystemClock;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.CalendarView;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.agendue.model.Message;
import com.agendue.model.Project;
import com.agendue.model.Share;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;
import com.agendue.web.AgendueWebHandler;

import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.AddBulletinDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class AddBulletinDialogFragment extends DialogFragment {

    private EditText bulletinContent;
    private Project project;
    private FragmentManager fm;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     * @param project The project the task goes with
     * @return A new instance of fragment AddProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddBulletinDialogFragment newInstance(Project project) {
        System.out.println(project.debugToString());
        AddBulletinDialogFragment fragment = new AddBulletinDialogFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }
    public AddBulletinDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        BulletinsFragment.bottomMenu.setGroupVisible(0,false);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
        fm = getFragmentManager();
    }


//    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.add_bulletin))
                .setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        if (bulletinContent.getText().toString().trim().equals("")) {
                            Toast.makeText(getActivity().getBaseContext(),
                                    getString(R.string.error_no_bulletin_content),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            SaveNewBulletinTask task = new SaveNewBulletinTask();
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
        View view = inflater.inflate(R.layout.fragment_add_bulletin_dialog, null);

        bulletinContent = (EditText) view.findViewById(R.id.add_bulletin_content);

        builder.setView(view);
        return builder.create();
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        BulletinsFragment.bottomMenu.setGroupVisible(0,true);
        super.onDismiss(dialog);
    }

    private class SaveNewBulletinTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                Message message = new Message(bulletinContent.getText().toString());
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
                fm.popBackStack();
                fm.beginTransaction()
                        .replace(R.id.container, BulletinsFragment.newInstance(project)).addToBackStack("Bulletins").commit();
            }
        }
    }

}
