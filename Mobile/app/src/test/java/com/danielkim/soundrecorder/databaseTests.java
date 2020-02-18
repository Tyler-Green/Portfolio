package com.danielkim.soundrecorder;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

import androidx.test.core.app.ApplicationProvider;

import static com.danielkim.soundrecorder.OrderBy.TIME;
import static com.google.common.truth.Truth.assertThat;

@RunWith(RobolectricTestRunner.class)
public class databaseTests {

    private DBHelper dbHelper;

    @Before
    public void setup() {
        dbHelper = new DBHelper(ApplicationProvider.getApplicationContext());
    }

    @After
    public void tearDown() {
        dbHelper = null;
    }

    @Test
    public void testAddingItemToDB() {
        dbHelper.addRecording("test", "/filePath/here", 12L);

        int count = dbHelper.getCount();
        assertThat(count).isEqualTo(1);
    }

    @Test
    public void testRemovingItemFromDB() {
        dbHelper.addRecording("test", "/filePath/here", 12L);
        int count = dbHelper.getCount();
        assertThat(count).isEqualTo(1);

        RecordingItem item = dbHelper.getItemAt(0, " DESC", TIME);
        dbHelper.removeItemWithId(item.getId());

        count = dbHelper.getCount();
        assertThat(count).isEqualTo(0);
    }

    @Test
    public void testRenamingItem() {
        dbHelper.addRecording("test", "/filePath/here", 12L);
        RecordingItem item = dbHelper.getItemAt(0, " DESC", TIME);
        dbHelper.renameItem(item, "newName", item.getFilePath());

        RecordingItem updatedItem = dbHelper.getItemAt(0, " DESC", TIME);
        assertThat(updatedItem.getName()).isEqualTo("newName");
        assertThat(dbHelper.getCount()).isEqualTo(1);
    }

    @Test
    public void testFavouriteItem() {
        dbHelper.addRecording("test", "/filePath/here", 12L);
        RecordingItem item = dbHelper.getItemAt(0, " DESC", TIME);
        dbHelper.favouriteItem(item, true, item.getFilePath());

        RecordingItem updatedItem = dbHelper.getItemAt(0, " DESC", TIME);
        assertThat(updatedItem.getFav()).isTrue();
    }

    @Test
    public void testUnfavouritedItem() {
        dbHelper.addRecording("test", "/filePath/here", 12L);
        RecordingItem item = dbHelper.getItemAt(0, " DESC", TIME);
        dbHelper.favouriteItem(item, true, item.getFilePath());
        RecordingItem updatedItem = dbHelper.getItemAt(0, " DESC", TIME);
        assertThat(updatedItem.getFav()).isTrue();


        dbHelper.favouriteItem(item, false, item.getFilePath());
        updatedItem = dbHelper.getItemAt(0, " DESC", TIME);
        assertThat(updatedItem.getFav()).isFalse();
    }

    @Test
    public void testChangeImage() {
        dbHelper.addRecording("test", "/filePath/here", 12L);
        RecordingItem item = dbHelper.getItemAt(0, " DESC", TIME);

        dbHelper.changeImage(item, "someimage/path");
        RecordingItem updatedItem = dbHelper.getItemAt(0, " DESC", TIME);
        assertThat(updatedItem.getImagePath()).isEqualTo("someimage/path");
    }
}
