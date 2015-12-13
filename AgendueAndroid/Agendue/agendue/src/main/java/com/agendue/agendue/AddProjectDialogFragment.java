package com.agendue.agendue;



import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.web.AgendueWebHandler;


/**
 * A simple {@link Fragment} subclass.
 * Use the {@link AddProjectDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class AddProjectDialogFragment extends DialogFragment {


    private EditText projectName;
    private TextView projectText;
    private FragmentManager fm;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment AddProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddProjectDialogFragment newInstance() {
        AddProjectDialogFragment fragment = new AddProjectDialogFragment();

        return fragment;
    }
    public AddProjectDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        fm = getFragmentManager();
    }


//    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        ProjectsFragment.bottomMenu.setGroupVisible(0,false);
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.add_project))
                .setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        if (projectName.getText().toString().trim().equals("")) {
                            Toast.makeText(getActivity().getBaseContext(),
                                    getString(R.string.error_no_project_name),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            SaveNewProjectTask task = new SaveNewProjectTask();
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
        View view = inflater.inflate(R.layout.fragment_add_project_dialog, null);

        projectName = (EditText) view.findViewById(R.id.add_project_name);
        projectText = (TextView) view.findViewById(R.id.add_project_text);
        projectName.requestFocus();
        builder.setView(view);
        return builder.create();
    }
    @Override
    public void onDismiss(DialogInterface dialog) {
        ProjectsFragment.bottomMenu.setGroupVisible(0,true);
        super.onDismiss(dialog);
    }

    private class SaveNewProjectTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.addProject(new Project(projectName.getText().toString().trim()));
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
                        .replace(R.id.container, ProjectsFragment.newInstance()).addToBackStack("Projects").commit();
            }
        }
    }

}
