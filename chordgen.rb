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

class Chord
  #def initialize(keys, result, result_is_kc)
  def initialize(left_hand, right_hand)
    if result_is_kc
      @result_id = result
    else
      @result_id = result.hash.to_s
    end

    @combo_event_id = "combo_event_#{@result_id}"
    @combo_array_id = "combo_array_#{@result_id}"
    @keys = keys

    if result_is_kc
      @result = "tap_code16(#{result});\n"
    else
      @result = result
    end
  end

  def combo_event; "  #{@combo_event_id},\n"; end
  def combo_array
    "const uint16_t PROGMEM #{@combo_array_id}[] = {
    #{@keys.join(',')}, COMBO_END
    };\n"
  end
  def combo_key
    "[#{@combo_event_id}] = COMBO_ACTION(#{@combo_array_id}),\n"
  end
  def case_expr
    <<-EOK
    case #{@combo_event_id}:
      if (pressed) {
        #{@result}
      }
      break;
EOK
  end
end

class Layer
  def initialize(name, chords, is_any_layer)
    @name = name
    @chords = chords
  end

  def combo_events; @chords.map(&:combo_event).join; end
  def combo_arrays; @chords.map(&:combo_array).join; end
  def combo_keys;   @chords.map(&:combo_key)  .join; end
  def combo_switch
    if is_any_layer
      "  {"
    else
      "  if (layer_state & (1 << #{@name})) {"
    end +
      <<-EOK
    switch (combo_index) {
    #{@chords.map(&:case_expr).join}
    }
  }
EOK
  end
end

class ChordedKeeb
  def initialize(layers)
    @layers = layers
  end

  def combo_events_enum
    <<-EOK
enum combo_events {
  #{@layers.map(&:combo_events).join}
}
EOK
  end

  def combo_arrays_declataion
    @layers.map(&:combo_arrays).join
  end

  def combo_keys_array
    <<-EOK
combo_t key_combos[COMBO_COUNT] = {
  #{@layers.map(&:combo_keys).join}
};
EOK
  end

  def process_combo_event
    <<-EOK
void process_combo_event(uint8_t combo_index, bool pressed) {
  #{@layers.map(&:combo_switch).join}
}
EOK
  end

  def as_string
    combo_events_enum
    + combo_arrays_declaration
    + combo_keys_array
    + process_combo_event
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
