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
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.web.AgendueWebHandler;
import com.agendue.model.Share;
import com.agendue.web.EmailFormatChecker;


/**
 * A simple {@link android.app.Fragment} subclass.
 * Use the {@link com.agendue.agendue.AddShareDialogFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class AddShareDialogFragment extends DialogFragment {


    private EditText shareEmail;
    private TextView shareText;
    private FragmentManager fm;
    private Project project;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment AddProjectDialogFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddShareDialogFragment newInstance(Project project) {
        AddShareDialogFragment fragment = new AddShareDialogFragment();
        Bundle b = new Bundle();
        b.putSerializable("project", project);
        fragment.setArguments(b);
        return fragment;
    }
    public AddShareDialogFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ProjectSharesFragment.bottomMenu.setGroupVisible(0,false);
        fm = getFragmentManager();
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("project");
        }
    }


//    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.share_project))
                .setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        if (!EmailFormatChecker.isValid(shareEmail.getText().toString().trim())) {
                            Toast.makeText(getActivity().getBaseContext(),
                                    getString(R.string.error_invalid_email),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            SaveShareTask task = new SaveShareTask();
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
        View view = inflater.inflate(R.layout.fragment_add_share_dialog, null);

        shareEmail = (EditText) view.findViewById(R.id.add_share_email);
        shareText = (TextView) view.findViewById(R.id.add_share_text);
        shareText.requestFocus();
        builder.setView(view);
        return builder.create();
    }

    public void onDismiss(DialogInterface dialog) {
        ProjectSharesFragment.bottomMenu.setGroupVisible(0,true);
        super.onDismiss(dialog);
    }

    private class SaveShareTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                Share share = new Share(shareEmail.getText().toString().trim());
                project.addShare(share);
                return wh.shareProject(project, share);
            } catch (Exception e) {
                return "error";
            }
        }

        @Override
        protected void onPostExecute(String results) {
            System.out.println(results);
            if (results.equals("error")) {
                Toast.makeText(getActivity().getBaseContext(), getString(R.string.connection_error),
                        Toast.LENGTH_SHORT).show();
            } else {
                ProjectSharesFragment.arrayAdapter.notifyDataSetChanged();
                fm.popBackStack();
                fm.beginTransaction()
                        .replace(R.id.container, ProjectSharesFragment.newInstance(project)).addToBackStack("ProjectShares").commit();
            }
        }
    }

}
