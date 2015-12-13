package com.agendue.agendue;



import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.web.AgendueWebHandler;

import java.io.IOException;


/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.EditProjectDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class EditProjectDialogFragment extends DialogFragment {


    private EditText projectName;
    private TextView projectText;
    private FragmentManager fm;
    private Button deleteButton;
    private Project project;
    private static AlertDialog dialogReference;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment AddProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static EditProjectDialogFragment newInstance(Project project) {
        EditProjectDialogFragment fragment = new EditProjectDialogFragment();
        Bundle args = new Bundle();
        args.putSerializable("project", project);
        fragment.setArguments(args);
        return fragment;
    }
    public EditProjectDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        fm = getFragmentManager();
        project = (Project) getArguments().getSerializable("project");
    }


//    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        ProjectsFragment.bottomMenu.setGroupVisible(0,false);
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.edit_project))
                .setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        if (projectName.getText().toString().trim().equals("")) {
                            Toast.makeText(getActivity().getBaseContext(),
                                    getString(R.string.error_no_project_name),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            SaveProjectTask task = new SaveProjectTask();
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
        View view = inflater.inflate(R.layout.fragment_edit_project_dialog, null);

        projectName = (EditText) view.findViewById(R.id.edit_project_name);
        projectText = (TextView) view.findViewById(R.id.edit_project_text);
        deleteButton = (Button) view.findViewById(R.id.edit_project_delete);
        deleteButton.setOnClickListener(new View.OnClickListener()
        {
            public void onClick(View v)
            {
                new AlertDialog.Builder(v.getContext())
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .setTitle(R.string.delete_project)
                        .setMessage(R.string.delete_project_confirmation)
                        .setPositiveButton(getString(R.string.yes), new DialogInterface.OnClickListener()
                        {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                DeleteProjectTask deleteProjectTask = new DeleteProjectTask();
                                deleteProjectTask.execute();

                            }

                        })
                        .setNegativeButton(getString(R.string.no), null)
                        .show();
            }
        });
        projectName.setText(project.getName());
        projectName.requestFocus();
        builder.setView(view);
        dialogReference = builder.create();
        return dialogReference;
    }
    @Override
    public void onDismiss(DialogInterface dialog) {
        ProjectsFragment.bottomMenu.setGroupVisible(0,true);
        super.onDismiss(dialog);
    }

    private class SaveProjectTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                project.setName(projectName.getText().toString().trim());
                return wh.editProject(project);
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            if (results!=null && results.equals("error")) {
                //TODO: Handle Error
            }
        }
    }

    private class DeleteProjectTask extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.deleteProject(project.getId());
            } catch (IOException e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            dialogReference.dismiss();

            fm.popBackStack();
            fm.beginTransaction().replace(R.id.container, ProjectsFragment.newInstance(), "Projects").addToBackStack("Projects").commit();
        }
    }

}
