package com.agendue.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.agendue.agendue.R;
import com.agendue.model.Message;
import com.agendue.model.Task;
import com.agendue.web.AgendueDateHandler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static com.agendue.agendue.R.color;

/**
 * Created by alec on 7/20/14.
 */
public class BulletinAdapter extends BaseAdapter {
    private LayoutInflater mInflater = null;
    private List<Message> bulletins;
    private Context mContext;
    private static SimpleDateFormat fmt = new SimpleDateFormat("MMM dd, yyyy");


    private final class ViewHolder {
        TextView contentView;
        TextView senderView;
    }

    private ViewHolder mHolder = null;

    public BulletinAdapter(List<Message> bulletins, Context context) {
        mContext = context;
        this.bulletins = bulletins;
        if (bulletins.size() == 0) {
            Message message = new Message("", context.getString(R.string.no_bulletins), null, null);
            bulletins.add(message);
        }
        mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return bulletins.size();
    }

    @Override
    public Object getItem(int position) {
        return bulletins.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null) {
            mHolder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.bulletincell, null);
            convertView.setTag(mHolder);
        } else {
            mHolder = (ViewHolder)convertView.getTag();
        }

        mHolder.contentView = (TextView)convertView.findViewById(R.id.bulletin_content);
        mHolder.senderView = (TextView)convertView.findViewById(R.id.bulletin_sender);
        Message bulletin = bulletins.get(position);
        mHolder.contentView.setText(bulletin.getContent());
        if (bulletin.getDateCreated() != null) {
            fmt.setCalendar(bulletin.getDateCreated());
            String date = fmt.format(bulletin.getDateCreated().getTime());
            mHolder.senderView.setText(bulletin.getUser() + " - " + date);

        }


        return convertView;
    }

    @Override
    public boolean areAllItemsEnabled() {
        if (bulletins.size() == 1 && bulletins.get(0).getContent()==mContext.getString(R.string.no_bulletins)) {
            return false;
        } else {
            return false;
        }
    }

    @Override
    public boolean isEnabled(int position) {
        if (bulletins.size() == 1 && bulletins.get(position).getContent()==mContext.getString(R.string.no_bulletins)) {
            return false;
        } else {
            return false;
        }
    }
}
