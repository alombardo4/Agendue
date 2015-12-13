package com.agendue.agendue;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.agendue.web.AgendueJSONParser;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link LoginSwitchFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link LoginSwitchFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class LoginSwitchFragment extends Fragment {

    private OnFragmentInteractionListener mListener;
    private TextView loginText, signupText;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment LoginSwitchFragment.
     */
    public static LoginSwitchFragment newInstance() {
        LoginSwitchFragment fragment = new LoginSwitchFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    public LoginSwitchFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {

        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_login_switch, container, false);
        loginText = (TextView) view.findViewById(R.id.login_button_textview);
        loginText.setOnClickListener(new LoginButtonTextViewOnClickListener());
        signupText = (TextView) view.findViewById(R.id.signup_button_textview);
        signupText.setOnClickListener(new SignupButtonTextViewOnClickListener());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getActivity().getWindow().setStatusBarColor(AgendueJSONParser.darkenColor(Color.parseColor("#3692d5")));
            getActivity().getWindow().setNavigationBarColor(Color.parseColor("#3692d5"));
        }

        return view;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    private class SignupButtonTextViewOnClickListener implements View.OnClickListener {

        @Override
        public void onClick(View v) {
            Intent i = new Intent(getActivity().getBaseContext(), CreateAccountActivity.class);
            startActivity(i);
            getActivity().finish();
        }
    }

    private class LoginButtonTextViewOnClickListener implements View.OnClickListener {

        @Override
        public void onClick(View v) {
            Intent i = new Intent(getActivity().getBaseContext(), LoginActivity.class);
            startActivity(i);
            getActivity().finish();
        }
    }

}
