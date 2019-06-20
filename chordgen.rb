should_count_chords = false
config_path = "./chords.ini"

syms = {}

('a'..'z').each { |ch| syms[ch] = "KC_#{ch.upcase}" }
('0'..'9').each { |ch| syms[ch] = "KC_#{ch}" }


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


def brace_expr(title, block)
  <<-EOK
#{title} {
  #{block}
}
EOK
end

# TODO: implement kc
def kc(k); k; end

class Chord
  attr_reader :combo_event, :combo_array, :combo_key, :case_expr
  def initialize(left_hand, right_hand)
    result_is_kc = left_hand[0] == '(' and left_hand[1] == ')'

    result    = result_is_kc ?
                  "tap_code16(#{kc left_hand});\n" :
                  left_hand[1..-2]
    result_id = result_is_kc ? result : result.hash.to_s

    combo_event_id = "combo_event_#{result_id}"
    combo_array_id = "combo_array_#{result_id}"
    keys = right_hand.split.map { |k| kc k }

    @combo_event = "  #{combo_event_id},\n"
    @combo_array = brace_expr("const uint16_t PROGMEM #{combo_array_id}[] =",
                              "#{keys.join(',')}, COMBO_END") + ";\n"
    @combo_key   = "[#{combo_event_id}] = COMBO_ACTION(#{combo_array_id}),\n"
    @case_expr = <<-EOK
    case #{@combo_event_id}:
      if (pressed) {
        #{@result}
      }
      break;
EOK
  end
end

class Layer
  attr_reader :combo_events, :combo_arrays, :combo_keys, :combo_switch
  def initialize(name, chords)
    @combo_events = chords.map(&:combo_event).join
    @combo_arrays = chords.map(&:combo_array).join
    @combo_keys   = chords.map(&:combo_key)  .join
    @combo_switch =
      brace_expr(name == 'any' ? "" : "if (layer_state & (1 << #{name}))",
                 brace_expr('switch (combo_index)',
                            chords.map(&:case_expr).join))
  end
end

end
class ChordedKeeb
  def initialize(layers)
    @combo_events_enum =
      brace_expr("enum combo_events", layers.map(&:combo_events).join)

    @combo_arrays_declaration =
      layers.map(&:combo_arrays).join

    @combo_keys_array =
      brace_expr("combo_t key_combos[COMBO_COUNT] =",
                 layers.map(&:combo_keys).join)

    @process_combo_event =
      brace_expr('void process_combo_event(uint8_t combo_index, bool pressed)',
                 layers.map(&:combo_switch).join)
  end

  def as_string
    @combo_events_enum
    + @combo_arrays_declaration
    + @combo_keys_array
    + @process_combo_event
  end
end


read_result = []
curr_section = {:header => nil, :contents => []}

File.open(config_path) do |f|
  while f.gets
    next if $_.empty_line?

    if $_.ini_header?
      read_result << curr_section
      curr_section = {header: $_.as_ini_header, contents: []}
    else
      tmp = $_.strip.split('=')
      curr_section[:contents] << [tmp[0..-2].join("="), tmp[-1]]
    end
  end
end

overrides = read_result.select { |rr| rr[0] == 'override'}
layers = (read_result - overrides).map do |rr|
  Layer.new(rr[:header],
            rr[:contents].map { |c| Chord.new(c[0], c[1])})
end

ChordedKeeb.new(layers).as_string
