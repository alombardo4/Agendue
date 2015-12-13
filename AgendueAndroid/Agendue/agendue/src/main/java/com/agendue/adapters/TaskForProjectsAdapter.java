package com.agendue.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.agendue.agendue.R;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;

import java.util.ArrayList;
import java.util.List;

import static com.agendue.agendue.R.color;

/**
 * Created by alec on 7/20/14.
 */
public class TaskForProjectsAdapter extends BaseAdapter {
    private LayoutInflater mInflater = null;
    private List<Task> taskList;
    private Context mContext;

    private final class ViewHolder {
        TextView titleView;
        TextView assignedToView;
        TextView duedateView;
        CheckBox checkboxView;
        WebView labelView;
    }

    private ViewHolder mHolder = null;

    public TaskForProjectsAdapter(List<Task> tasks, Context context, boolean completedtasks) {
        mContext = context;
        taskList = tasks;
        if (tasks.size() == 0) {
            Task task = new Task();
            task.setId("-1");
            if(completedtasks) {
                task.setName(context.getString(R.string.no_completed_tasks));
            } else {
                task.setName(context.getString(R.string.no_tasks_here));
            }
            taskList.add(task);
        }
        mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return taskList.size();
    }

    @Override
    public Object getItem(int position) {
        return taskList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null) {
            mHolder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.taskforprojectcell, null);
            convertView.setTag(mHolder);
        } else {
            mHolder = (ViewHolder)convertView.getTag();
        }

        mHolder.titleView = (TextView)convertView.findViewById(R.id.project_task_cell_title);
        mHolder.duedateView = (TextView)convertView.findViewById(R.id.project_task_cell_duedate);
        mHolder.assignedToView = (TextView) convertView.findViewById(R.id.project_task_cell_assignedto);
        mHolder.checkboxView = (CheckBox) convertView.findViewById(R.id.task_for_projects_checkbox);
//        mHolder.labelView = (WebView) convertView.findViewById(R.id.project_task_cell_label);

        mHolder.titleView.setText(taskList.get(position).getName());
        if (taskList.get(position).getDuedate() != null) {
            mHolder.duedateView.setText(AgendueDateHandler.sanitizeDate(taskList.get(position).getDuedate()));
        } else {
            mHolder.duedateView.setText(mContext.getString(R.string.no_due_date));
            mHolder.duedateView.setTextColor(color.cccc);
        }
        if (taskList.get(position).getAssignedto().equals("None")) {
            mHolder.assignedToView.setTextColor(color.cccc);
            mHolder.assignedToView.setText(mContext.getString(R.string.unassigned));
        } else {
            mHolder.assignedToView.setText(taskList.get(position).getAssignedto());
        }
        if (taskList.get(position).getComplete() == true) {
            mHolder.checkboxView.setChecked(true);
        } else {
            mHolder.checkboxView.setChecked(false);
        }
        if (taskList.get(position).getId().equals("-1")) {
            convertView.setClickable(false);
            mHolder.duedateView.setText("");


        } else {
            mHolder.checkboxView.setVisibility(View.VISIBLE);
        }

//        mHolder.labelView.setBackgroundColor(taskList.get(position).getLabelColor());
//        mHolder.labelView.setHorizontalScrollBarEnabled(false);
//        mHolder.labelView.setVerticalScrollBarEnabled(false);
        return convertView;
    }

    @Override
    public boolean areAllItemsEnabled() {
        if (taskList.size() == 1 && taskList.get(0).getId().equals("-1")) {
            return false;
        } else {
            return true;
        }
    }

    @Override
    public boolean isEnabled(int position) {
        if (taskList.size() == 1 && taskList.get(position).getId().equals("-1")) {
            return false;
        } else {
            return true;
        }
    }

}
