date=`date +y_m_d_s_%Y_%m_%d_%S`




############################ BEGIN Items to change per folder to migrate
current_dir=`pwd`

# Volume to work on relative to FS root

path_above_volume="8a38c8df-cfcd-4d8c-bee5-ad121dcc50b3"
#path_above_volume="pi"

volume="pi"
#volume="8a38c8df-cfcd-4d8c-bee5-ad121dcc50b3"





# Target directory root

backupDir="/z/carina-pi"





# Source Directory



path_above_root="/mnt/pi"



path_just_above_volume="$path_above_root/$path_above_volume"

path="$path_above_root/$path_above_volume/$volume"



workdirRoot=/z/backup-scripts





# How deep to search for folders

folder_depth=3



# how many sequntial rsync jobs per batch job

split_count=80





############################ END Items to change per folder to migrate








workDir="$workdirRoot/$path_above_volume/$volume"

mkdir -p $workDir/logs/previous 2> /dev/null

mkdir -p $workDir/batches 2> /dev/null

list="list_of_"$volume"_dirs"

cd $workDir



folder_depth_minus_one=$folder_depth

folder_depth_minus_one=$((folder_depth_minus_one-1))

rm -f  $workDir/list_of_"$volume"_dirs

while [[ $folder_depth_minus_one -gt 0 && $folder_depth_minus_one -lt $folder_depth ]]

do

                      find $path -maxdepth $folder_depth_minus_one -mindepth $folder_depth_minus_one -type f  | sed  "s~$path_just_above_volume/~~g"| sort -R  >> $list

                                        ((folder_depth_minus_one--))

                                                  done

                                                            find $path -maxdepth $folder_depth -mindepth $folder_depth -type d  | sed  "s~$path_just_above_volume/~~g"| sort -R  >> $list





                                                                      rm -f $workDir/batches/*

                                                                                split -l $split_count -a 4 -d ."/"$list $workDir/batches/batch_

                                                                                          batch_list=`find $workDir/batches -mindepth 1 -maxdepth 1 -type f -name "batch_*"`



                                                                                                    echo > $workDir/run_this_to_copy_files_$volume.sh



                                                                                                              for i in $batch_list;do

                                                                                                                                        line="${i/.\//}"

                                                              chop_line_to_batch_id=${line: -10}

# I need to remove part of the path name ($volume) in this case as the source folder has a path name that we do not want on the backup location
sed -i "s~$volume/~~g" $workDir/batches/batch_*
# Exclude wwygal directory as it hangs any operation against it
#sed -i '/wwygal/d' $workDir/batches/batch_*

# I have to append the volume name on the source rsync path ($volume). Like this:  $path/ $backupDir
# In other user cases it would look like this: $path_just_above_volume/ $backupDir
                                                              echo "rsync --partial --numeric-ids --sparse --progress -H  -Arav  --stats --delete --files-from=$line --log-file=\"$workDir/logs/$date-$chop_line_to_batch_id.log\" $path/ $backupDir &> \"$workDir/logs/$date-$chop_line_to_batch_id.log.stdout\" &" >> $workDir/run_this_to_copy_files_$volume.sh
                                                              #echo "rsync  --dry-run --partial --numeric-ids --sparse --progress -H  -Arav  --stats --delete --files-from=$line --log-file=\"$workDir/logs/$date-$chop_line_to_batch_id.log\" $path/ $backupDir &> \"$workDir/logs/$date-$chop_line_to_batch_id.log.stdout\" &" >> $workDir/run_this_to_copy_files_$volume.sh

                                                                                                                                                               #echo "rsync  -Arav  --stats --delete --files-from=$line --log-file=\"$workDir/logs/$date-$chop_line_to_batch_id.log\" $path_just_above_volume/ $backupDir &> \"$workDir/logs/$date-$chop_line_to_batch_id.log.stdout\" &" >> $workDir/run_this_to_copy_files_$volumes.sh




                                                                                                                                                         done

                                                                                                                                                   chmod 700 $workDir/run_this_to_copy_files_$volume.sh
                                                                                                                                                     ln -s $workDir/run_this_to_copy_files_$volume.sh $current_dir/ 2>/dev/null

                                                                                                                                                       #find $workDir/logs -mtime +30 -exec rm {} \;

                                                                                                                                                         find $workDir/logs -maxdepth 1 -mindepth 1 -type f -exec mv {} $workDir/logs/previous/ \;
