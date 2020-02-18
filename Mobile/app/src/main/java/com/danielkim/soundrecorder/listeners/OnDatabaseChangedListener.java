package com.danielkim.soundrecorder.listeners;

import com.danielkim.soundrecorder.OrderBy;

/**
 * Created by Daniel on 1/3/2015.
 * Listen for add/rename items in database
 */
public interface OnDatabaseChangedListener{
    void onNewDatabaseEntryAdded();
    void onDatabaseEntryRenamed();
    void filterDB(String order, OrderBy orderBy);
}