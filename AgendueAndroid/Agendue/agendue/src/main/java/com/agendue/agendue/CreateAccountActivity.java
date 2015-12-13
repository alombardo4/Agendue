package com.agendue.agendue;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.agendue.agendue.R;
import com.agendue.model.User;
import com.agendue.web.AgendueWebHandler;
import com.agendue.web.EmailFormatChecker;

import java.io.IOException;

public class CreateAccountActivity extends Activity {

    private EditText firstName, lastName, email, password, passwordConfirm;
    private static Button createButton;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account);
        attachGUI();
    }





    public void attachGUI() {
        firstName = (EditText) findViewById(R.id.create_account_firstname);
        lastName = (EditText) findViewById(R.id.create_account_lastname);
        email = (EditText) findViewById(R.id.create_account_email);
        password = (EditText) findViewById(R.id.create_account_password);
        passwordConfirm = (EditText) findViewById(R.id.create_account_password);
        createButton = (Button) findViewById(R.id.create_acct_button);
        createButton.setOnClickListener(new CreateOnClickListener());
    }




    @Override
    public void onBackPressed() {
        Intent i = new Intent(getBaseContext(), AgendueLogin.class);
        startActivity(i);
        finish();
    }


    private class CreateAccountTask extends AsyncTask<String, String, String> {
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
    //        wh.setDevEnvironment();
            String results;
            try {
                results = wh.createAccount(email.getText().toString().trim(),
                        firstName.getText().toString().trim(), lastName.getText().toString().trim(),
                        password.getText().toString(), passwordConfirm.getText().toString());
            } catch (IOException e) {
                e.printStackTrace();
                results = "error";
            }
            return results;
        }

        protected void onPostExecute(String results) {
            if (!results.equals("error")) {
                SharedPreferences prefs;
                prefs = getApplication().getSharedPreferences("agendue", Context.MODE_PRIVATE);
                SharedPreferences.Editor e = prefs.edit();
                e.remove("username");
                e.putString("username", email.getText().toString().trim());
                e.remove("password");
                e.putString("password", password.getText().toString());
                e.commit();

                User user = new User();
                user.setFirstname(firstName.getText().toString().trim());
                user.setLastname(lastName.getText().toString().trim());
                user.setName(email.getText().toString().trim());
                user.setPassword(password.getText().toString());
                Intent i = new Intent(getBaseContext(), MainActivity.class);
                Bundle b = new Bundle();
                b.putSerializable("user", user);
                i.putExtras(b);
                startActivity(i);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
            } else {
                Toast.makeText(getBaseContext(), getString(R.string.error_invalid_account_info),
                        Toast.LENGTH_SHORT).show();
            }
        }

    }

    private class CreateOnClickListener implements View.OnClickListener {
        @Override
        public void onClick(View view) {
            createButton.setEnabled(false);

            if (firstName.getText().toString().trim().equals("") ||
                    lastName.getText().toString().trim().equals("") ||
                    email.getText().toString().trim().equals("") ||
                    password.getText().toString().trim().equals("") ||
                    passwordConfirm.getText().toString().trim().equals("") ||
                    !passwordConfirm.getText().toString().equals(password.getText().toString()) ||
                    !EmailFormatChecker.isValid(email.getText().toString())) {
                createButton.setEnabled(true);
                Toast.makeText(getBaseContext(), getString(R.string.error_invalid_account_info),
                        Toast.LENGTH_SHORT).show();
            } else {
                CreateAccountTask task = new CreateAccountTask();
                task.execute();
            }
        }
    }
}
