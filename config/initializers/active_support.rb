module ActiveSupport
 module Cache
   class FileStore < Store
     UNESCAPE_FILENAME_CHARS = /%([0-9A-F]{2})/

   private

     # Translate a file path into a key.
     def file_path_key(path)
       fname = path[cache_path.size, path.size].split(File::SEPARATOR, 4).last
       fname.gsub(UNESCAPE_FILENAME_CHARS){|match| $1.to_i(16).chr}
     end

   end
 end
end
