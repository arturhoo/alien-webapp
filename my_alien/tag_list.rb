module MyAlien

  class TagList

    def self.retrieve()
      r = Alien::AlienReader.new
      begin
        r.open(MyAlien.reader_addr)
        taglist_string = r.taglist
        lines = taglist_string.split "\r\n"
        r.close
      # rescue
      #   return ['Could not retrieve tags from reader']
      end
      tl = Array.new
      lines.each { |line| tl.push Alien::AlienTag.new(line) }
      tl
    end
  end
end
