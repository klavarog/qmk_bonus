should_count_chords = false
config_path = "./chords.ini"

should_ignore_next_elem_for_config_path = false
ARGV.each do |arg|
  if should_ignore_next_elem_for_config_path
    config_path = arg
    should_ignore_next_elem_for_config_path = false
  end
  if %w[-c --count-chords].include? arg
    should_count_chords = true
  elsif %w[-p --config-path].include? arg
    should_ignore_next_elem_for_config_path = true
  end
end

class String
  def ini_header?
    self.match? /^\[(.*)\]$/
  end

  def as_ini_header
    /^\[(.*)\]$/.match(self)[1]
  end

  def empty_line?
    self.strip == ""
  end
end

read_result = []
current_header = nil
current_assignments = []
(File.readlines(config_path) << "[this is workaround]").each do |line|
  next if line.empty_line?

  if line.ini_header?
    if current_header
      read_result << [current_header, current_assignments]
    end
    current_header = line.as_ini_header
    current_assignments = []
  else
    tmp = line.split("=")
    current_assignments << [tmp[0..-2].join("="), tmp[-1].strip]
  end
end

p read_result
