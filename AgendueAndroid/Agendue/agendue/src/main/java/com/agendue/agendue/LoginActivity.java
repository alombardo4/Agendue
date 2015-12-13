package com.agendue.agendue;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.app.NotificationManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.media.Image;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.content.Intent;
import android.net.NetworkInfo;

import com.agendue.model.Project;
import com.agendue.model.User;
import com.agendue.web.AgendueWebHandler;
import com.agendue.web.EmailFormatChecker;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

public class LoginActivity extends Activity {

    /**
     * Button marked "Login" in the view
     */
    private static Button loginButton;
    /**
     * Button marked "Create an Account" in the view
     */
    private static View createAccountButton;
    /**
     * Field for email address
     */
    private static EditText emailAddress;
    /**
     * Field for password
     */
    private static EditText password;
    /**
     * Button marked "Try Again" in the view
     */
    private static Button tryAgainButton;

    private static View agendueIcon;

    private static View welcomeText;
    /**
     * Shared preferences for the app.
     */
    private SharedPreferences prefs;

    /**
     * Agendue user to use for the app.
     */
    private User user;

    /*
     * Boolean to determine if preferences should be updated (i.e. password changed)
     */
    private boolean shouldUpdatePrefs = false;

    private final String TAG = "Agendue";

    private String regid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        prefs = getApplication().getSharedPreferences("agendue", Context.MODE_PRIVATE);
        user = new User(prefs.getString("username", ""), prefs.getString("password", ""));
        attachToGUI();
        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancelAll();
        checkConnectionAndLogin();
    }

    /**
     * Connects the view's XML to the activity's objects
     */
    private void attachToGUI() {
        loginButton = (Button) this.findViewById(R.id.login_button);
        createAccountButton = (View) this.findViewById(R.id.login_create_button);
        emailAddress = (EditText) this.findViewById(R.id.login_email);
        password = (EditText) this.findViewById(R.id.login_password);
        tryAgainButton = (Button) this.findViewById(R.id.login_try_again);
        agendueIcon= (View) this.findViewById(R.id.login_agendueicon);
        welcomeText= (View) this.findViewById(R.id.login_welcome);

        loginButton.setOnClickListener(new LoginOnClickListener());
        createAccountButton.setOnClickListener(new AccountOnClickListener());

        tryAgainButton.setOnClickListener(new TryAgainOnClickListener());
    }

    /**
     * Checks network connection; if online and credentials are saved and correct, logs in
     * If credentials wrong, prompts to enter them
     *
     */
    private void checkConnectionAndLogin() {
        if(isOnline()) {
            // Check device for Play Services APK.
            if (checkPlayServices()) {
                GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
                regid = getRegistrationId(getBaseContext());
                if (regid.isEmpty()) {
                    registerInBackground();
                } else {
                }
            }
            if(user==null) {
                user = new User(prefs.getString("username", ""), prefs.getString("password", ""));
            }
            if (!(user.getName().equals("") || user.getPassword().equals(""))) {
                LoginAsyncTask loginTask = new LoginAsyncTask();
                String[] args = {user.getName(), user.getPassword()};
                loginTask.execute(args);
            } else {
                showLoginFields();

            }
        } else {
            View b = findViewById(R.id.login_connectionerror);
            b.setVisibility(View.VISIBLE);
            b = findViewById(R.id.login_try_again);
            b.setVisibility(View.VISIBLE);
            b = findViewById(R.id.imageView);
            b.setVisibility(View.VISIBLE);
            tryAgainButton.setEnabled(true);
            View check = (View) this.findViewById(R.id.login_agendueicon);
            View text = (View) this.findViewById(R.id.login_welcome);
            check.setVisibility(View.VISIBLE);
            text.setVisibility(View.VISIBLE);

        }
    }

    private void showLoginFields() {
        //getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        agendueIcon.setVisibility(View.VISIBLE);
        welcomeText.setVisibility(View.VISIBLE);
        View b = findViewById(R.id.login_email);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.imageView);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_password);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_button);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_create_button);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_connectionerror);
        b.setVisibility(View.INVISIBLE);
        b = findViewById(R.id.login_transp_background2);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_transp_background);
        b.setVisibility(View.VISIBLE);
        b = findViewById(R.id.login_try_again);
        b.setVisibility(View.INVISIBLE);
        loginButton.setEnabled(true);

    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        return super.onOptionsItemSelected(item);
    }

    /**
     * OnClick listener for the Login button.
     */
    private class LoginOnClickListener implements View.OnClickListener {
        @Override
        public void onClick(View view) {
            shouldUpdatePrefs = true;
            InputMethodManager inputManager = (InputMethodManager)
                    getSystemService(Context.INPUT_METHOD_SERVICE);
            inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
                    InputMethodManager.HIDE_NOT_ALWAYS);
            Toast.makeText(getApplicationContext(), getString(R.string.logging_in),
                    Toast.LENGTH_SHORT).show();

            loginButton.setEnabled(false);
            if (emailAddress.getText().toString().equals("")
                    || password.getText().toString().equals("")) {
                loginButton.setEnabled(true);
                Toast.makeText(getApplicationContext(), R.string.error_fields_required,
                        Toast.LENGTH_SHORT).show();
                if (password.getText().toString().equals("")) {
                    password.setText("");
                }
            } else {
                if (!EmailFormatChecker.isValid(emailAddress.getText().toString())) {
                    loginButton.setEnabled(true);
                    password.setText("");


                    Toast.makeText(getApplicationContext(), R.string.error_incorrect_credentials,
                            Toast.LENGTH_SHORT).show();
                } else {
                    LoginAsyncTask loginTask = new LoginAsyncTask();
                    loginTask.execute();
                    loginButton.setEnabled(true);
                }
            }
        }
    }
    /**
     * OnClick listener for the Try Again button.
     */
    private class TryAgainOnClickListener implements View.OnClickListener {
        @Override
        public void onClick(View view) {
            tryAgainButton.setEnabled(false);
            checkConnectionAndLogin();
        }
    }
    /**
     * OnClick listener for the Create Account button
     */
    private class AccountOnClickListener implements View.OnClickListener {
        @Override
        public void onClick(View view) {
            Intent i = new Intent(getBaseContext(), CreateAccountActivity.class);
            startActivity(i);
            finish();
        }
    }


    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     * @return if the device has play services
     */
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
//                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
//                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Gets the current registration ID for application on GCM service.
     * <p>
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     *         registration ID.
     */
    private String getRegistrationId(Context context) {
        final SharedPreferences prefs = getGCMPreferences(context);
        String registrationId = prefs.getString("GCMRegid", "");
        if (registrationId.isEmpty()) {
            Log.i(TAG, "Registration not found.");
            return "";
        }
        // Check if app was updated; if so, it must clear the registration ID
        // since the existing regID is not guaranteed to work with the new
        // app version.
        int registeredVersion = 0;
        try {
            registeredVersion = prefs.getInt("APPVERSIONCODE", Integer.MIN_VALUE);
        } catch (Exception e) {

        }
        int currentVersion = getAppVersion(context);
        if (registeredVersion != currentVersion) {
            Log.i(TAG, "App version changed.");
            return "";
        }
        return registrationId;
    }

    /**
     * Stores the registration ID and the app versionCode in the application's
     * {@code SharedPreferences}.
     *
     * @param context application's context.
     * @param regId registration ID
     */
    private void storeRegistrationId(Context context, String regId) {
        final SharedPreferences prefs = getGcmPreferences(context);
        int appVersion = getAppVersion(context);
        Log.i(TAG, "Saving regId on app version " + appVersion);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString("GCMRegid", regId);
        editor.putInt("APPVERSIONCODE", appVersion);
        editor.commit();
    }


    /**
     * @return Application's {@code SharedPreferences}.
     */
    private SharedPreferences getGcmPreferences(Context context) {
        // This sample app persists the registration ID in shared preferences, but
        // how you store the regID in your app is up to you.
        return getSharedPreferences(LoginActivity.class.getSimpleName(),
                Context.MODE_PRIVATE);
    }

    /**
     * @return Application's version code from the {@code PackageManager}.
     */
    private static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    /**
     * @return Application's {@code SharedPreferences}.
     */
    private SharedPreferences getGCMPreferences(Context context) {
        // This sample app persists the registration ID in shared preferences, but
        // how you store the regID in your app is up to you.
        return getSharedPreferences(LoginActivity.class.getSimpleName(),
                Context.MODE_PRIVATE);
    }

    private class LoginAsyncTask extends AsyncTask<String, String, String> {
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
//            wh.setDevEnvironment();
//            wh.setDevIPEnvironment("http://192.168.1.77:3000/");
            try {
                if (params.length == 2) {
                    return wh.logIn(params[0], params[1]);
                }
                return wh.logIn(emailAddress.getText().toString(), password.getText().toString());
            } catch (Exception e) {
                e.printStackTrace();
                return "error";
            }
        }

        protected void onPostExecute(String result) {
            if (result.contains("shares") || result.contains("tour")) {
                    if(prefs.getString("username", "")=="" || prefs.getString("password", "")=="" || shouldUpdatePrefs) {
                        user = new User(emailAddress.getText().toString(), password.getText().toString());
                        SharedPreferences.Editor e = prefs.edit();
                        e.remove("username");
                        e.putString("username", user.getName());
                        e.remove("password");
                        e.putString("password", user.getPassword());
                        e.commit();
                        shouldUpdatePrefs = false;
                    }

                GetUserInfoTask task = new GetUserInfoTask();
                task.execute();

            } else if (result.equals("error")) {
                loginButton.setEnabled(true);
                Toast.makeText(getApplicationContext(), R.string.connection_error,
                        Toast.LENGTH_SHORT).show();
                View b = findViewById(R.id.login_connectionerror);
                b.setVisibility(View.VISIBLE);
                b = findViewById(R.id.imageView);
                b.setVisibility(View.VISIBLE);
                b = findViewById(R.id.login_try_again);
                b.setVisibility(View.VISIBLE);
                b = findViewById(R.id.login_create_button);
                b.setVisibility(View.INVISIBLE);
                agendueIcon.setVisibility(View.VISIBLE);
                welcomeText.setVisibility(View.VISIBLE);


            } else {
                loginButton.setEnabled(true);
                Toast.makeText(getApplicationContext(), R.string.error_incorrect_credentials,
                        Toast.LENGTH_SHORT).show();

                SharedPreferences.Editor e = prefs.edit();
                e.remove("username");
                e.remove("password");
                e.commit();
                showLoginFields();
                password.setText("");
            }
        }
    }

    private class GetUserInfoTask extends AsyncTask<String, String, String> {
        protected String doInBackground(String... params) {
            AgendueWebHandler wh = AgendueWebHandler.getInstance();
            try {
                return wh.getUser();
            } catch (Exception e) {
                showLoginFields();
                return "error";
            }
        }

        protected void onPostExecute(String result) {

            if (result.contains("name")) {
                try {
                    JSONObject jUser = new JSONObject(result);
                    user.setFacebook(jUser.getString("facebook"));
                    user.setFirstname(jUser.getString("firstname"));
                    user.setLastname(jUser.getString("lastname"));
                    if(result.contains("primary_color")) {
                        int color1 = Color.parseColor(jUser.getString("primary_color"));
                        int color2 = Color.parseColor(jUser.getString("secondary_color"));
                        int color3 = Color.parseColor(jUser.getString("tertiary_color"));
                        int agendueBlue = Color.parseColor("#3692d5");
                        int agendueOrange = Color.parseColor("#ffab26");
                        int agendueDarkOrange = Color.parseColor("#f7931e");
                        int white = Color.WHITE;
                        if (color1 == agendueBlue && color2 == agendueBlue && color3 == agendueBlue) { //user does not have custom colors
                            user.setPrimaryColor(agendueBlue);
                            user.setSecondaryColor(agendueOrange);
                            user.setTertiaryColor(agendueDarkOrange);
                        } else {
                            if (color1 == white && color2 != white) {
                                user.setPrimaryColor(color2);
                            } else if (color1 == white && color2 == white) {
                                user.setPrimaryColor(color3);
                            } else {
                                user.setPrimaryColor(color1);
                            }
                            if (color2 == white && color3 != white) {
                                user.setSecondaryColor(color3);
                            } else if (color2 == white && color3 == white) {
                                user.setSecondaryColor(color1);
                            } else {
                                user.setSecondaryColor(color2);
                            }
                            user.setTertiaryColor(color3);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                Intent i = new Intent(getBaseContext(), MainActivity.class);
                Bundle b = new Bundle();
                b.putSerializable("user", user);
                i.putExtras(b);
                startActivity(i);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                sendRegistrationIdToBackend();


            } else if (result.equals("error")) {
                showLoginFields();
            } else {
                showLoginFields();
            }
        }
    }
    private boolean isOnline() {
        ConnectivityManager cm =
                (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        if (netInfo != null && netInfo.isConnectedOrConnecting()) {
            return true;
        }
        return false;
    }

    /**
     * Registers the application with GCM servers asynchronously.
     * <p>
     * Stores the registration ID and app versionCode in the application's
     * shared preferences.
     */
    private void registerInBackground() {
        new AsyncTask<Void, String, String>() {
            @Override
            protected String doInBackground(Void... params) {
                String msg = "";
                try {
                    //System.out.println("Attempting to register for GCM");
                    GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(getBaseContext());

                    regid = gcm.register("11463801251");
                    //System.out.println("Regid: " + regid);
                    msg = "Device registered, registration ID=" + regid;

                    // You should send the registration ID to your server over HTTP,
                    // so it can use GCM/HTTP or CCS to send messages to your app.
                    // The request to your server should be authenticated if your app
                    // is using accounts.

                    // For this demo: we don't need to send it because the device
                    // will send upstream messages to a server that echo back the
                    // message using the 'from' address in the message.

                    // Persist the regID - no need to register again.
                    storeRegistrationId(getBaseContext(), regid);
                    //System.out.println(regid);
                } catch (IOException ex) {
                    msg = "Error :" + ex.getMessage();
                    // If there is an error, don't just keep trying to register.
                    // Require the user to click a button again, or perform
                    // exponential back-off.
                }
                return msg;
            }

            @Override
            protected void onPostExecute(String msg) {
            }
        }.execute(null, null, null);
    }

    /**
     * Sends the registration ID to your server over HTTP, so it can use GCM/HTTP or CCS to send
     * messages to your app. Not needed for this demo since the device sends upstream messages
     * to a server that echoes back the message using the 'from' address in the message.
     */
    private void sendRegistrationIdToBackend() {
        new AsyncTask<Void, String, String>() {
            @Override
            protected String doInBackground(Void... params) {
                AgendueWebHandler wh = AgendueWebHandler.getInstance();
                try {
                    return wh.addDeviceForGCM(regid);
                } catch (IOException e) {
                    return "error";
                }
            }
        }.execute(null,null,null);
    }

    @Override
    public void onBackPressed() {
        finish();

    }
}
