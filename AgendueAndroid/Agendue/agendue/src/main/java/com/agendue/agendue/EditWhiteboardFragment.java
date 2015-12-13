package com.agendue.agendue;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.FragmentManager;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Fragment;
import android.os.SystemClock;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.agendue.model.Project;
import com.agendue.web.AgendueWebHandler;
import com.melnykov.fab.FloatingActionButton;

import org.apache.http.cookie.Cookie;

import java.io.IOException;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Use the {@link EditWhiteboardFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class EditWhiteboardFragment extends Fragment {
    private static Project project;

    private static WebView webView;
    private static FloatingActionButton saveFab;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param project The project's data
     * @return A new instance of fragment EditWhiteboardFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static EditWhiteboardFragment newInstance(Project project) {
        EditWhiteboardFragment fragment = new EditWhiteboardFragment();
        Bundle args = new Bundle();
        args.putSerializable("Project", project);
        fragment.setArguments(args);
        return fragment;
    }

    public EditWhiteboardFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            project = (Project) getArguments().getSerializable("Project");
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_edit_whiteboard, container, false);
        webView = (WebView) view.findViewById(R.id.edit_whiteboard_webview);
        webView.setWebViewClient(new WebViewClient() {


            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // Here put your code
                if (!url.equals(buildURL())) {
                    getFragmentManager().popBackStack();

                }
                // return true; //Indicates WebView to NOT load the url;
                return false; //Allow WebView to load url
            }
        });
        new WebViewTask().execute();


        return view;
    }

    private class WebViewTask extends AsyncTask<Void, Void, Boolean> {
        String sessionCookie;
        CookieManager cookieManager;

        @Override
        protected void onPreExecute() {
            CookieSyncManager.createInstance(getActivity());
            cookieManager = CookieManager.getInstance();
            AgendueWebHandler wh = AgendueWebHandler.getInstance();

            if (sessionCookie != null) {
                                /* delete old cookies */
                cookieManager.removeSessionCookie();
            }
            sessionCookie = "_Agendue_session="+ wh.getCookiestore().getCookies().get(0).getValue();

            super.onPreExecute();
        }
        protected Boolean doInBackground(Void... param) {
                        /* this is very important - THIS IS THE HACK */
            SystemClock.sleep(400);
            return false;
        }
        @Override
        protected void onPostExecute(Boolean result) {
            if (sessionCookie != null) {
                cookieManager.setCookie(AgendueWebHandler.getDomain(), sessionCookie);
                CookieSyncManager.getInstance().sync();
            }
            WebSettings webSettings = webView.getSettings();
            webSettings.setJavaScriptEnabled(true);

            webView.loadUrl(buildURL());
        }
    }

    private String buildURL() {
        return AgendueWebHandler.getDomain() + "/projects/" + project.getId() + "/empty_wiki";
    }
}
