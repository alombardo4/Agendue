package com.agendue.agendue;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.app.Fragment;

import com.agendue.model.User;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import static com.agendue.agendue.R.id.container;


public class AgendueLogin extends Activity {
    /**
     * Shared preferences for the app.
     */
    private SharedPreferences prefs;

    /**
     * Agendue user to use for the app.
     */
    private User user;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_agendue_login);
        prefs = getApplication().getSharedPreferences("agendue", Context.MODE_PRIVATE);
        String username = prefs.getString("username", "");
        if (username == null || username.length() == 0) {
            if (savedInstanceState == null) {
                getFragmentManager().beginTransaction()
                        .add(container, LoginSwitchFragment.newInstance())
                        .commit();
            }
        } else {
            Intent i = new Intent(getBaseContext(), LoginActivity.class);
            startActivity(i);
            finish();
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_agendue_login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


}
