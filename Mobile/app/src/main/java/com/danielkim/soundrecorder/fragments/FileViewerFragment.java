package com.danielkim.soundrecorder.fragments;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.FileObserver;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.danielkim.soundrecorder.R;
import com.danielkim.soundrecorder.adapters.FileViewerAdapter;

import java.util.ArrayList;

import static com.danielkim.soundrecorder.OrderBy.ALPHABETICAL;
import static com.danielkim.soundrecorder.OrderBy.DURATION;
import static com.danielkim.soundrecorder.OrderBy.FAVOURITE;
import static com.danielkim.soundrecorder.OrderBy.THUMBNAIL;
import static com.danielkim.soundrecorder.OrderBy.TIME;

/**
 * Created by Daniel on 12/23/2014.
 */
public class FileViewerFragment extends Fragment{
    private static final String ARG_POSITION = "position";
    private static final String LOG_TAG = "FileViewerFragment";

    private int position;
    private FileViewerAdapter mFileViewerAdapter;

    public static FileViewerFragment newInstance(int position) {
        FileViewerFragment f = new FileViewerFragment();
        Bundle b = new Bundle();
        b.putInt(ARG_POSITION, position);
        f.setArguments(b);

        return f;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        position = getArguments().getInt(ARG_POSITION);
        observer.startWatching();
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_file_viewer, container, false);

        RecyclerView mRecyclerView = (RecyclerView) v.findViewById(R.id.recyclerView);
        mRecyclerView.setHasFixedSize(true);
        LinearLayoutManager llm = new LinearLayoutManager(getActivity());
        llm.setOrientation(LinearLayoutManager.VERTICAL);

        mRecyclerView.setLayoutManager(llm);
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());

        mFileViewerAdapter = new FileViewerAdapter(getActivity(), llm);
        mRecyclerView.setAdapter(mFileViewerAdapter);

        return v;
    }

    FileObserver observer =
            new FileObserver(android.os.Environment.getExternalStorageDirectory().toString()
                    + "/SoundRecorder") {
                // set up a file observer to watch this directory on sd card
                @Override
                public void onEvent(int event, String file) {
                    if(event == FileObserver.DELETE){
                        // user deletes a recording file out of the app

                        String filePath = android.os.Environment.getExternalStorageDirectory().toString()
                                + "/SoundRecorder" + file + "]";

                        Log.d(LOG_TAG, "File deleted ["
                                + android.os.Environment.getExternalStorageDirectory().toString()
                                + "/SoundRecorder" + file + "]");

                        // remove file from database and recyclerview
                        mFileViewerAdapter.removeOutOfApp(filePath);
                    }
                }
            };

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_filter:
                showFilterWindow();
                break;
            case R.id.action_multi_delete:
                mFileViewerAdapter.deleteSelected();
                break;
            default:
                super.onOptionsItemSelected(item);
        }
        return false;
    }

    private void showFilterWindow() {
        Context context = getActivity();
        ArrayList<String> entrys = new ArrayList<>();
        entrys.add(context.getString(R.string.dialog_filter_ascending));
        entrys.add(context.getString(R.string.dialog_filter_descending));
        entrys.add(context.getString(R.string.dialog_filter_alphabetical));
        entrys.add(context.getString(R.string.dialog_filter_alphabetical_reverse));
        entrys.add(context.getString(R.string.dialog_filter_duration));
        entrys.add(context.getString(R.string.dialog_filter_duration_reverse));
        entrys.add(context.getString(R.string.dialog_filter_image));
        entrys.add(context.getString(R.string.dialog_filter_image_none));
        entrys.add(context.getString(R.string.dialog_filter_favourite));

        final CharSequence[] items = entrys.toArray(new CharSequence[entrys.size()]);

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(context.getString(R.string.dialog_title_filter));
        builder.setItems(items, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int item) {
                if (item == 0) {
                    mFileViewerAdapter.filterDB(" DESC", TIME);
                } if (item == 1) {
                    mFileViewerAdapter.filterDB(" ASC", TIME);
                } if (item == 2) {
                    mFileViewerAdapter.filterDB(" ASC", ALPHABETICAL);
                } if (item == 3) {
                    mFileViewerAdapter.filterDB(" DESC", ALPHABETICAL);
                }  if (item == 4) {
                    mFileViewerAdapter.filterDB(" ASC", DURATION);
                } if (item == 5) {
                    mFileViewerAdapter.filterDB(" DESC", DURATION);
                } if (item == 6) {
                    mFileViewerAdapter.filterDB(" DESC", THUMBNAIL);
                } if (item == 7) {
                    mFileViewerAdapter.filterDB(" ASC", THUMBNAIL);
                } if (item == 8) {
                    mFileViewerAdapter.filterDB(" DESC", FAVOURITE);
                }
            }
        });
        builder.setCancelable(true);
        builder.setNegativeButton(context.getString(R.string.dialog_action_cancel),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });

        AlertDialog alert = builder.create();
        alert.show();
    }
}




