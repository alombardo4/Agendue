package com.agendue.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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
public class YourTasksAdapter extends BaseAdapter {
    private LayoutInflater mInflater = null;
    private List<Task> taskList;
    private Context mContext;

    private final class ViewHolder {
        TextView titleView;
        TextView assignedToView;
        TextView duedateView;
        CheckBox checkBox;
    }

    private ViewHolder mHolder = null;

    public YourTasksAdapter(List<Task> tasks, Context context) {
        mContext = context;
        taskList = tasks;
        if (tasks.size() == 0) {
            Task task = new Task();
            task.setId("-1");
            task.setName(context.getString(R.string.no_tasks_swipe_from_left));
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
            convertView = mInflater.inflate(R.layout.yourtaskscell, null);
            convertView.setTag(mHolder);
        } else {
            mHolder = (ViewHolder)convertView.getTag();
        }

        mHolder.titleView = (TextView)convertView.findViewById(R.id.your_task_cell_title);
        mHolder.duedateView = (TextView)convertView.findViewById(R.id.your_task_cell_duedate);
        mHolder.checkBox = (CheckBox) convertView.findViewById(R.id.your_task_cell_checkbox);

        mHolder.titleView.setText(taskList.get(position).getName());
        mHolder.checkBox.setChecked(taskList.get(position).getComplete());
        mHolder.checkBox.setVisibility(View.VISIBLE);
        if (taskList.get(position).getDuedate() != null) {
            mHolder.duedateView.setText(AgendueDateHandler.sanitizeDate(taskList.get(position).getDuedate()));
        } else {
            if(!taskList.get(position).getId().equals("-1") && !taskList.get(position).getName().equals(mContext.getString(R.string.no_tasks_here))) {
                mHolder.duedateView.setText(mContext.getString(R.string.no_due_date));
                mHolder.duedateView.setTextColor(color.cccc);
            }

        }


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
