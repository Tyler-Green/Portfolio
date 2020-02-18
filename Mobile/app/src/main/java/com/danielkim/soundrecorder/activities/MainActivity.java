package com.danielkim.soundrecorder.activities;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.astuetz.PagerSlidingTabStrip;
import com.danielkim.soundrecorder.DBHelper;
import com.danielkim.soundrecorder.R;
import com.danielkim.soundrecorder.fragments.FileViewerFragment;
import com.danielkim.soundrecorder.fragments.RecordFragment;

import static com.danielkim.soundrecorder.OrderBy.TIME;


public class MainActivity extends ActionBarActivity{

    private static final String LOG_TAG = MainActivity.class.getSimpleName();

    private PagerSlidingTabStrip tabs;
    private ViewPager pager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        pager = (ViewPager) findViewById(R.id.pager);
        pager.setAdapter(new MyAdapter(getSupportFragmentManager()));
        tabs = (PagerSlidingTabStrip) findViewById(R.id.tabs);
        tabs.setViewPager(pager);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setPopupTheme(R.style.ThemeOverlay_AppCompat_Light);
        if (toolbar != null) {
            setSupportActionBar(toolbar);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        // Handle presses on the action bar items
        switch (item.getItemId()) {
            case R.id.action_settings:
                if (RecordFragment.mStartRecording) {
                    Intent i = new Intent(this, SettingsActivity.class);
                    startActivity(i);
                }
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public class MyAdapter extends FragmentPagerAdapter {
        private String[] titles = { getString(R.string.tab_title_record),
                getString(R.string.tab_title_saved_recordings) };

        public MyAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0: {
                    return RecordFragment.newInstance(position);
                }
                case 1: {
                    return FileViewerFragment.newInstance(position);
                }
            }
            return null;
        }

        @Override
        public int getCount() {
            return titles.length;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return titles[position];
        }
    }

    public MainActivity() {
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1) { // chosen photo from gallery
            // update promise on DB
            DBHelper mDatabase = new DBHelper(this);
            for (int i = 0; i < mDatabase.getCount(); i++) {
                String path = mDatabase.getItemAt(i, " DESC", TIME).getImagePath();
                Log.e("Contect", path);
                if (path.indexOf("PROMISE") == 0) {
                    if (resultCode == RESULT_OK) {
                        Uri selectedImage = data.getData();
                        String src = getRealPathFromURI(selectedImage); // get path
                        mDatabase.changeImage(mDatabase.getItemAt(i, " DESC", TIME), src);
                    } else {
                        mDatabase.changeImage(mDatabase.getItemAt(i, " DESC", TIME), path.substring(8));
                    }
                }
            }
            mDatabase.close();
            pager.setAdapter(new MyAdapter(getSupportFragmentManager())); // used to update the saved recordings tab
            pager.setCurrentItem(1, false); // used to return to the saved recordings tab after updating
        } else if (requestCode == 2) {
            // update recording icon with picture from camera
            DBHelper mDatabase = new DBHelper(this);
            for (int i = 0; i < mDatabase.getCount(); i++) {
                String imagePath = mDatabase.getItemAt(i, " DESC", TIME).getImagePath();
                int separator = imagePath.indexOf("|");
                if (separator >= 0) {
                    if (resultCode == RESULT_OK) {
                        mDatabase.changeImage(mDatabase.getItemAt(i, " DESC", TIME), imagePath.substring(separator + 1));
                    } else {
                        mDatabase.changeImage(mDatabase.getItemAt(i, " DESC", TIME), imagePath.substring(0, separator));
                    }
                }
            }
            mDatabase.close();
            pager.setAdapter(new MyAdapter(getSupportFragmentManager()));
            pager.setCurrentItem(1, false);
        }
    }

    private String getRealPathFromURI(Uri contentUri) {
        String[] proj = { MediaStore.Video.Media.DATA };
        Cursor cursor = managedQuery(contentUri, proj, null, null, null);
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        return cursor.getString(column_index);
    }
}

