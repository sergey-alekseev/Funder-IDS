class Time
  def to_hash(options={})
    hash = {}
    fields =  (options[:only].nil? ? [:day, :year, :month, :hour, :min, :sec] : options[:only]).uniq
    fields.each{|f| hash[f]=self.send(f)}
    hash
  end
end
