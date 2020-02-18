package com.danielkim.soundrecorder.adapters;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.FileProvider;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.danielkim.soundrecorder.DBHelper;
import com.danielkim.soundrecorder.OrderBy;
import com.danielkim.soundrecorder.R;
import com.danielkim.soundrecorder.RecordingItem;
import com.danielkim.soundrecorder.fragments.PlaybackFragment;
import com.danielkim.soundrecorder.listeners.OnDatabaseChangedListener;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

import static com.danielkim.soundrecorder.OrderBy.TIME;

/**
 * Created by Daniel on 12/29/2014.
 */
public class FileViewerAdapter extends RecyclerView.Adapter<FileViewerAdapter.RecordingsViewHolder>
    implements OnDatabaseChangedListener{

    private static final String LOG_TAG = "FileViewerAdapter";

    private DBHelper mDatabase;
    public String order = " DESC";
    public OrderBy orderby = TIME;

    RecordingItem item;
    Context mContext;
    LinearLayoutManager llm;
    ArrayList<Integer> selectedItems;

    public FileViewerAdapter(Context context, LinearLayoutManager linearLayoutManager) {
        super();
        mContext = context;
        mDatabase = new DBHelper(mContext);
        mDatabase.setOnDatabaseChangedListener(this);
        llm = linearLayoutManager;
        selectedItems = new ArrayList<>();
    }

    @Override
    public void onBindViewHolder(final RecordingsViewHolder holder, final int position) {

        item = getItem(position);
        long itemDuration = item.getLength();

        long minutes = TimeUnit.MILLISECONDS.toMinutes(itemDuration);
        long seconds = TimeUnit.MILLISECONDS.toSeconds(itemDuration)
                - TimeUnit.MINUTES.toSeconds(minutes);

        holder.vName.setText(item.getName());
        holder.vLength.setText(String.format("%02d:%02d", minutes, seconds));
        holder.cardView.setBackgroundColor(Color.WHITE);

        File imageFile = new File(item.getImagePath());
        ImageView image = (ImageView) holder.vImage.findViewById(R.id.file_image);
        if (imageFile.getPath().length() > 0 && imageFile.exists()) {
            setPic(holder, imageFile.getPath());
        } else {
            image.setImageResource(R.drawable.ic_fileviewer);
        }

        ImageView star = (ImageView) holder.favouriteStar.findViewById(R.id.file_favourite);
        if(getItem(holder.getPosition()).getFav() == true){
            star.setImageResource(R.drawable.ic_star_black_24dp);
        } else{
            star.setImageResource(R.drawable.ic_star_border_black_24dp);
        }
        holder.vDateAdded.setText(
            DateUtils.formatDateTime(
                mContext,
                item.getTime(),
                DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_NUMERIC_DATE | DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_YEAR
            )
        );

        // define an on click listener to open PlaybackFragment
        holder.cardView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    PlaybackFragment playbackFragment =
                            new PlaybackFragment().newInstance(getItem(holder.getPosition()));

                    FragmentTransaction transaction = ((FragmentActivity) mContext)
                            .getSupportFragmentManager()
                            .beginTransaction();

                    playbackFragment.show(transaction, "dialog_playback");

                } catch (Exception e) {
                    Log.e(LOG_TAG, "exception", e);
                }
            }
        });

        holder.cardView.setOnLongClickListener(new View.OnLongClickListener() {

            @Override
            public boolean onLongClick(View view) {
                if (!selectedItems.contains(holder.getPosition())) {
                    selectedItems.add(holder.getPosition());
                    holder.cardView.setBackgroundColor(Color.GRAY);
                } else {
                    selectedItems.remove(Integer.valueOf(holder.getPosition()));
                    holder.cardView.setBackgroundColor(Color.WHITE);
                }

                return true;
            }
        });

        holder.ellipsis.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ArrayList<String> entrys = new ArrayList<String>();
                entrys.add(mContext.getString(R.string.dialog_file_share));
                entrys.add(mContext.getString(R.string.dialog_file_rename));
                entrys.add(mContext.getString(R.string.dialog_file_delete));
                entrys.add(mContext.getString(R.string.dialog_choose_photo));
                entrys.add(mContext.getString(R.string.dialog_take_photo));

                final CharSequence[] items = entrys.toArray(new CharSequence[entrys.size()]);


                // File delete confirm
                AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
                builder.setTitle(mContext.getString(R.string.dialog_title_options));
                builder.setItems(items, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int item) {
                        if (item == 0) {
                            shareFileDialog(holder.getPosition());
                        } else if (item == 1) {
                            renameFileDialog(holder.getPosition());
                        } else if (item == 2) {
                            deleteFileDialog(holder.getPosition());
                        } else if (item == 3) {
                            chooseImageIntent(holder.getPosition());
                        } else if (item == 4) {
                            imageCaptureIntent(holder.getPosition());
                        }
                    }
                });
                builder.setCancelable(true);
                builder.setNegativeButton(mContext.getString(R.string.dialog_action_cancel),
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.cancel();
                            }
                        });

                AlertDialog alert = builder.create();
                alert.show();
            }
        });


        holder.favouriteStar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ImageView star = (ImageView)v.findViewById(R.id.file_favourite);
             if(getItem(holder.getPosition()).getFav() == true){
                 getItem(holder.getPosition()).setFav(false);
                 mDatabase.favouriteItem(getItem(position), false, getItem(position).getFilePath());
                 notifyDataSetChanged();
                 star.setImageResource(R.drawable.ic_star_border_black_24dp);
             }
             else if(getItem(holder.getPosition()).getFav() == false){
                 getItem(holder.getPosition()).setFav(true);
                 mDatabase.favouriteItem(getItem(position), true, getItem(position).getFilePath());
                 notifyDataSetChanged();
                 star.setImageResource(R.drawable.ic_star_black_24dp);

             }

            }
        });

    }

    @Override
    public RecordingsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View itemView = LayoutInflater.
                from(parent.getContext()).
                inflate(R.layout.card_view, parent, false);

        mContext = parent.getContext();

        return new RecordingsViewHolder(itemView);
    }

    public static class RecordingsViewHolder extends RecyclerView.ViewHolder {
        protected TextView vName;
        protected TextView vLength;
        protected TextView vDateAdded;
        protected ImageView vImage;
        protected View cardView;
        protected View ellipsis;
        protected View favouriteStar;

        public RecordingsViewHolder(View v) {
            super(v);
            vName = (TextView) v.findViewById(R.id.file_name_text);
            vLength = (TextView) v.findViewById(R.id.file_length_text);
            vDateAdded = (TextView) v.findViewById(R.id.file_date_added_text);
            vImage = (ImageView) v.findViewById(R.id.file_image);
            cardView = v.findViewById(R.id.card_view);
            ellipsis = v.findViewById(R.id.file_setting);
            favouriteStar = v.findViewById(R.id.file_favourite);
        }
    }

    @Override
    public int getItemCount() {
        return mDatabase.getCount();
    }

    public RecordingItem getItem(int position) {
        return mDatabase.getItemAt(position, order, orderby);
    }

    @Override
    public void onNewDatabaseEntryAdded() {
        //item added to top of the list
        notifyDataSetChanged();
        if (order.equals(" ASC")) {
            llm.scrollToPosition(getItemCount() - 1);
        } else {
            llm.scrollToPosition(0);
        }

    }

    @Override
    public void filterDB(String order, OrderBy orderBy) {
        this.order = order;
        this.orderby = orderBy;
        selectedItems.clear();
        notifyDataSetChanged();
        llm.scrollToPosition(0);
    }

    @Override
    //TODO
    public void onDatabaseEntryRenamed() {

    }

    public void remove(int position) {
        //remove item from database, recyclerview and storage

        //delete file from storage
        File file = new File(getItem(position).getFilePath());
        file.delete();

        Toast.makeText(
            mContext,
            String.format(
                mContext.getString(R.string.toast_file_delete),
                getItem(position).getName()
            ),
            Toast.LENGTH_SHORT
        ).show();

        mDatabase.removeItemWithId(getItem(position).getId());
        selectedItems.clear();
        notifyDataSetChanged();
    }

    public void remove(String filePath, String name, Integer id) {
        File file = new File(filePath);
        file.delete();

        Toast.makeText(
                mContext,
                String.format(
                        mContext.getString(R.string.toast_file_delete),
                        name
                ),
                Toast.LENGTH_SHORT
        ).show();

        mDatabase.removeItemWithId(id);
        notifyDataSetChanged();
    }

    //TODO
    public void removeOutOfApp(String filePath) {
        //user deletes a saved recording out of the application through another application
    }

    private Boolean nameCheck(String name) {
        if (name.length() > 20 || name.length() < 1) {
            return false;
        }
        for (int i = 0; i < name.length(); i++) {
            if (!Character.isDigit(name.charAt(i)) && !Character.isLetter(name.charAt(i))) return false;
        }
        return true;
    }

    public void rename(int position, String name) {
        //rename a file
        String mFilePath = Environment.getExternalStorageDirectory().getAbsolutePath();
        mFilePath += "/SoundRecorder/" + name;
        File f = new File(mFilePath);

        if (f.exists() && !f.isDirectory()) {
            //file name is not unique, cannot rename file.
            Toast.makeText(mContext,
                    String.format(mContext.getString(R.string.toast_file_exists), name),
                    Toast.LENGTH_SHORT).show();

        } else if (!nameCheck(name.substring(0, name.length()-4))) {
            Toast.makeText(mContext,
                    String.format(mContext.getString(R.string.toast_file_invalid_name), name),
                    Toast.LENGTH_LONG).show();
        } else {
            //file name is unique and safe, rename file
            File oldFilePath = new File(getItem(position).getFilePath());
            oldFilePath.renameTo(f);
            mDatabase.renameItem(getItem(position), name, mFilePath);
            notifyDataSetChanged();
        }
    }

    public void shareFileDialog(int position) {
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(new File(getItem(position).getFilePath())));
        shareIntent.setType("audio/mp4");
        mContext.startActivity(Intent.createChooser(shareIntent, mContext.getText(R.string.send_to)));
    }

    public void renameFileDialog (final int position) {
        // File rename dialog
        AlertDialog.Builder renameFileBuilder = new AlertDialog.Builder(mContext);

        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.dialog_rename_file, null);

        final EditText input = (EditText) view.findViewById(R.id.new_name);

        renameFileBuilder.setTitle(mContext.getString(R.string.dialog_title_rename));
        renameFileBuilder.setCancelable(true);
        renameFileBuilder.setPositiveButton(mContext.getString(R.string.dialog_action_ok),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        try {
                            String value = input.getText().toString().trim() + ".mp4";
                            rename(position, value);

                        } catch (Exception e) {
                            Log.e(LOG_TAG, "exception", e);
                        }

                        dialog.cancel();
                    }
                });
        renameFileBuilder.setNegativeButton(mContext.getString(R.string.dialog_action_cancel),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });

        renameFileBuilder.setView(view);
        AlertDialog alert = renameFileBuilder.create();
        alert.show();
    }

    public void deleteFileDialog (final int position) {
        // File delete confirm
        AlertDialog.Builder confirmDelete = new AlertDialog.Builder(mContext);
        confirmDelete.setTitle(mContext.getString(R.string.dialog_title_delete));
        confirmDelete.setMessage(mContext.getString(R.string.dialog_text_delete));
        confirmDelete.setCancelable(true);
        confirmDelete.setPositiveButton(mContext.getString(R.string.dialog_action_yes),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        try {
                            //remove item from database, recyclerview, and storage
                            remove(position);

                        } catch (Exception e) {
                            Log.e(LOG_TAG, "exception", e);
                        }

                        dialog.cancel();
                    }
                });
        confirmDelete.setNegativeButton(mContext.getString(R.string.dialog_action_no),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });

        AlertDialog alert = confirmDelete.create();
        alert.show();
    }

    public void chooseImageIntent(int position) {
        //create a promise on the db for a value
        String path = mDatabase.getItemAt(position, order, orderby).getImagePath();
        mDatabase.changeImage(getItem(position), "PROMISE "+path);
        //start new intent and return
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        intent.setType("image/*");
        if (mContext instanceof Activity) {
            ((Activity) mContext).startActivityForResult(intent, 1);
        } else {
            Log.e("Contect", "Context is not an instance of Activity");
        }
    }

    public void imageCaptureIntent(int position) {
        // Switching to camera mode
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (intent.resolveActivity(mContext.getPackageManager()) != null) {
            File photoFile = null;
            try {
                photoFile = createImageFile(position);
            } catch (IOException ioe) {
                Log.e(LOG_TAG, "ioexception", ioe);
            }
            if (photoFile != null) {
                Uri photoURI = FileProvider.getUriForFile(mContext, "com.danielkim.soundrecorder.fileprovider", photoFile); // get content:// path
                intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                mDatabase.changeImage(getItem(position), getItem(position).getImagePath() + "|" + photoFile.getPath());
                if (mContext instanceof Activity) {
                    ((Activity) mContext).startActivityForResult(intent, 2);
                } else {
                    Log.e(LOG_TAG, "mContext needs to be an instanceof Activity");
                }
            }
        }
    }

    private File createImageFile(final int position) throws IOException {
        // Create an image file name
        item = getItem(position);
        String imageFileName = item.getName().substring(0, item.getName().length()-4) + "_image.jpg";
        String storageDir = Environment.getExternalStorageDirectory().getAbsolutePath() + "/SoundRecorder/" + imageFileName; // set directory to file path
        File image = new File(storageDir);
        return image;
    }

    private void setPic(RecordingsViewHolder holder, String savedImage) {
        int targetW = 120;
        int targetH = 120;

        BitmapFactory.Options opts = new BitmapFactory.Options();
        opts.inJustDecodeBounds = true; // set to true so we can grab image dimensions
        BitmapFactory.decodeFile(savedImage, opts);
        int imageW = opts.outWidth;
        int imageH = opts.outHeight;

        opts.inJustDecodeBounds = false;
        opts.inSampleSize = Math.min(imageW/targetW, imageH/targetH);
        opts.inPurgeable = true;

        holder.vImage.setImageBitmap(BitmapFactory.decodeFile(savedImage, opts));
    }

    public void deleteSelected() {
        if (selectedItems.isEmpty()) {
            Toast.makeText(
                    mContext,
                    String.format(
                            mContext.getString(R.string.toast_file_delete_failed)
                    ),
                    Toast.LENGTH_SHORT
            ).show();
        }
        ArrayList<String> names = new ArrayList<>();
        ArrayList<String> paths = new ArrayList<>();
        ArrayList<Integer> ids =  new ArrayList<>();

        //Get the info for the files to be deleted
        for (int i=0; i < selectedItems.size(); i++) {
            RecordingItem item = getItem(selectedItems.get(i));
            names.add(item.getName());
            paths.add(item.getFilePath());
            ids.add(item.getId());
        }
        //De-select the files in the View
        selectedItems.clear();

        //Remove files from db and View
        for (int i=0; i < names.size(); i++) {
            remove(paths.get(i), names.get(i), ids.get(i));
        }
    }
}
