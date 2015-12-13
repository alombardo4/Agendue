package com.agendue.agendue;

import android.annotation.TargetApi;
import android.app.Activity;

import android.app.Fragment;
import android.app.FragmentManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.agendue.model.User;

import java.lang.reflect.Field;

public class MainActivity extends ActionBarActivity {

    private DrawerLayout navigationDrawer;
    private ListView navigationDrawerList;
    private LinearLayout navigationDrawerContainer;
    private ActionBarDrawerToggle toggle;
    private TextView navigationNameView;
    private ImageView navigationDrawerImageView;
    private Toolbar toolbar;
    /**
     * Used to store the last screen title. For use in {@link #restoreActionBar()}.
     */
    private CharSequence mTitle;

    private String projectId;

    private String taskId;

    protected static User user;

    protected static Menu menu;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        user = (User) getIntent().getSerializableExtra("user");
//        mNavigationDrawerFragment = (NavigationDrawerFragment)
//                getFragmentManager().findFragmentById(R.id.navigation_drawer);
        mTitle = getString(R.string.app_name);

        // Set up the drawer.
//        mNavigationDrawerFragment.setUp(
//                R.id.navigation_drawer,
//                (DrawerLayout) findViewById(R.id.drawer_layout));
        navigationDrawer = (DrawerLayout) findViewById(R.id.activity_main);
        navigationDrawerContainer = (LinearLayout) findViewById(R.id.drawer_container);
        navigationDrawerList = (ListView) findViewById(R.id.navigation_drawer_list);
        navigationNameView = (TextView) findViewById(R.id.nav_user_text);
        navigationDrawerImageView = (ImageView) findViewById(R.id.nav_bg_image);
        toolbar = (Toolbar) findViewById(R.id.agendue_toolbar);
        toolbar.setTitleTextColor(Color.WHITE);
        toolbar.setSubtitleTextColor(Color.WHITE);
        toolbar.setBackgroundColor(user.getPrimaryColor());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(user.getDarkerPrimaryColor());
            getWindow().setNavigationBarColor(user.getPrimaryColor());
        }

        setSupportActionBar(toolbar);

        toggle = new ActionBarDrawerToggle(this, navigationDrawer, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        navigationNameView.setText(user.getName());
        navigationDrawer.setDrawerListener(toggle);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);
        toggle.syncState();
        if (MainActivity.user.hasCustomColors()) {
            Drawable background = getResources().getDrawable(R.drawable.ic_nav_bg);
            background.setColorFilter(user.getTertiaryColor(), PorterDuff.Mode.SRC_OVER);
            navigationDrawerImageView.setImageDrawable(background);
        } else {
            navigationDrawerImageView.setImageDrawable(getResources().getDrawable(R.drawable.ic_nav_bg));
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.drawer_list_item,
                new String[]{
                        getString(R.string.title_landing),
                        getString(R.string.title_projects),
                        getString(R.string.all_tasks),
                        getString(R.string.your_tasks),
                        getString(R.string.calendar),
                        getString(R.string.personal_tasks),
                        getString(R.string.settings)
                });

        navigationDrawerList.setAdapter(adapter);
        navigationDrawerList.setOnItemClickListener(new DrawerItemClickListener());
        navigationItemSelected(0);

    }

    @Override
    public void onBackPressed() {
        FragmentManager fm = getFragmentManager();
        Fragment landing = fm.findFragmentByTag("Landing");
        Fragment projects = fm.findFragmentByTag("Projects");
        Fragment alltasks = fm.findFragmentByTag("AllTasks");
        Fragment yourtasks = fm.findFragmentByTag("YourTasks");
        Fragment settings = fm.findFragmentByTag("Settings");
        Fragment calendar = fm.findFragmentByTag("Calendar");
        Fragment personalTasks = fm.findFragmentByTag("PersonalTasks");
        if (navigationDrawer.isDrawerOpen(navigationDrawerContainer)) {
            navigationDrawer.closeDrawer(navigationDrawerContainer);
        } else {
            if(landing!=null && landing.isVisible()) {
                finish();
            } else if (alltasks!=null && alltasks.isVisible()) {
                navigationItemSelected(0);
                //super.onOptionsItemSelected(item);
            } else if (yourtasks!=null && yourtasks.isVisible()) {
                fm.beginTransaction().replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
                navigationItemSelected(0);
            } else if (projects!= null && projects.isVisible()) {
                navigationItemSelected(0);
            } else if (settings != null && settings.isVisible()) {
                navigationItemSelected(0);
            } else if (calendar != null && calendar.isVisible()) {
                navigationItemSelected(0);
            } else if (personalTasks != null && personalTasks.isVisible()) {
                navigationItemSelected(0);
            } else {
                fm.popBackStack();
            }
        }

    }

    public void onSectionAttached(int number) {
        switch (number) {
            case 1:
                mTitle = getString(R.string.title_landing);
                break;
            case 2:
                mTitle = getString(R.string.title_projects);
                break;
            case 3:
                mTitle = getString(R.string.all_tasks);
                break;
            case 4:
                mTitle = getString(R.string.your_tasks);
                break;
            case 5:
                mTitle = getString(R.string.calendar);
            case 6:
                mTitle = getString(R.string.personal_tasks);
            case 7:
                mTitle = getString(R.string.settings);
                break;
        }
    }

    public void restoreActionBar() {
        ActionBar actionBar = getSupportActionBar();
//        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD);
        actionBar.setDisplayShowTitleEnabled(true);


        FragmentManager fm = getFragmentManager();
        Fragment projects = fm.findFragmentByTag("Projects");
        Fragment alltasks = fm.findFragmentByTag("AllTasks");
        Fragment yourtasks = fm.findFragmentByTag("YourTasks");
        Fragment tasksforproject = fm.findFragmentByTag("TasksForProject");
        Fragment bulletins = fm.findFragmentByTag("Bulletins");
        Fragment completetasks = fm.findFragmentByTag("CompleteTasks");
        Fragment projectshares = fm.findFragmentByTag("ProjectShares");
        Fragment taskdetails = fm.findFragmentByTag("TaskDetails");
        Fragment whiteboard= fm.findFragmentByTag("Whiteboard");
        Fragment addproject= fm.findFragmentByTag(getString(R.string.add_project));
        Fragment editproject = fm.findFragmentByTag(getString(R.string.edit_project));
        Fragment settings = fm.findFragmentByTag("Settings");
        Fragment landing = fm.findFragmentByTag("Landing");
        Fragment calendar = fm.findFragmentByTag("Calendar");
        Fragment personalTasks = fm.findFragmentByTag("PersonalTasks");
        if (projects != null && projects.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.title_projects));
        } else if (alltasks != null && alltasks.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.all_tasks));
        } else if (yourtasks != null && yourtasks.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.your_tasks));
        } else if (tasksforproject != null && tasksforproject.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.project_tasks));
        } else if (bulletins!= null && bulletins.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.bulletins));
        } else if (completetasks != null && completetasks.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.completed_tasks));
        } else if (projectshares!= null && projectshares.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.project_shares));
        } else if (taskdetails!= null && taskdetails.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.task_details));
        } else if (whiteboard!= null && whiteboard.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.whiteboard));
        } else if (addproject!= null && addproject.isVisible()) {
            //ProjectsFragment.bottomMenu.setGroupVisible(0,true);
        } else if (landing != null && landing.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.app_name));
        } else if (settings != null && settings.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.settings));
        } else if (calendar != null && calendar.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.calendar));
        } else if (personalTasks != null && personalTasks.isVisible()) {
            getSupportActionBar().setTitle(getString(R.string.personal_tasks));
        }
    }



    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        this.menu = menu;
        return super.onCreateOptionsMenu(menu);
    }

    public static Menu getMenu() {
        return menu;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        //restoreActionBar();
        //TODO: this? ^^
        if (item.getItemId() == android.R.id.home) {
            if (navigationDrawer.isDrawerOpen(navigationDrawerContainer)) {
                navigationDrawer.closeDrawer(navigationDrawerContainer);
            } else {
                navigationDrawer.openDrawer(navigationDrawerContainer);
            }
            return true;
        }

        return super.onOptionsItemSelected(item);

    }

    void getOverflowMenu() {

        try {
            ViewConfiguration config = ViewConfiguration.get(this);
            Field menuKeyField = ViewConfiguration.class.getDeclaredField("sHasPermanentMenuKey");
            if(menuKeyField != null) {
                menuKeyField.setAccessible(true);
                menuKeyField.setBoolean(config, false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private class DrawerItemClickListener implements ListView.OnItemClickListener {
        public void onItemClick(AdapterView parent, View view, int position, long id) {
            navigationItemSelected(position);
        }
    }

    private void navigationItemSelected(int position) {
        // update the main content by replacing fragments
        navigationDrawerList.setItemChecked(position, true);
        navigationDrawer.closeDrawer(navigationDrawerContainer);
        FragmentManager fragmentManager = getFragmentManager();
        if (position == 0) { //landing
            fragmentManager.beginTransaction().replace(R.id.container, Landing.newInstance(), "Landing").addToBackStack("Landing").commit();
        } else if (position == 1) { //projects
            fragmentManager.beginTransaction().replace(R.id.container, ProjectsFragment.newInstance(), "Projects").addToBackStack("Projects").commit();
        } else if (position == 2) {
            fragmentManager.beginTransaction().replace(R.id.container, AllTasksFragment.newInstance(), "AllTasks").addToBackStack("AllTasks").commit();
        } else if (position == 3) {
            fragmentManager.beginTransaction().replace(R.id.container, YourTasksFragment.newInstance(), "YourTasks").addToBackStack("YourTasks").commit();
        } else if (position == 4) {
            fragmentManager.beginTransaction().replace(R.id.container, CalendarFragment.newInstance(), "Calendar").addToBackStack("Calendar").commit();
        } else if (position == 5) {
            fragmentManager.beginTransaction().replace(R.id.container, PersonalTasksListFragment.newInstance(), "PersonalTasks").addToBackStack("PersonalTasks").commit();
        } else if (position == 6) {
            fragmentManager.beginTransaction().replace(R.id.container, SettingsFragment.newInstance(), "Settings").addToBackStack("Settings").commit();
        }

    }

}
