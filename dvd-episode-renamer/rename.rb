### Rename utility for stuff backed up off DVDs to have Plex-compatible file names.

season_directory = ARGV[0]
show_name = ARGV[1]
dryrun = ARGV[2]

if show_name.nil? or show_name.empty?
  raise "Show name is required!\n\nUsage: `ruby rename.rb /mnt/transmogrifier_video/WIP/Chuck/CHUCK\ SEASON\ 2/ \"Chuck\" dryrun`"
end

files = Dir[season_directory + "/*"]

files_to_rename = files.filter { |filename| filename[/\d+[-\.]\d+ ?[-\.] \w+/] }
filename_parts = files_to_rename.map do |filename|
  first_split = File.basename(filename).split(/[-\.]/, 2)
  season_number = first_split[0].strip
  second_split = first_split[1].split(/[-\.]/)
  episode_number = second_split[0].strip
  episode_name = second_split[1].split('%')[0].strip
  {
      original_name: filename,
      season_number: season_number.to_i,
      episode_number: episode_number.to_i,
      episode_name: episode_name
  }
end
filename_parts.each do |fileinfo|
  dirname = File.dirname(fileinfo[:original_name])
  ext = File.extname(fileinfo[:original_name])
  newname = "#{dirname}/#{show_name} - #{'s%02de%02d' % [fileinfo[:season_number], fileinfo[:episode_number]]} - #{fileinfo[:episode_name]}#{ext}"
  if dryrun
    puts "Will rename #{fileinfo[:original_name]} to #{newname}"
  else
    File.rename(fileinfo[:original_name], newname)
  end
end