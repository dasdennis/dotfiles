# 1. History config (XDG Base Directory compliant)
IRB.conf[:SAVE_HISTORY] = 5000
require 'fileutils'
history_file = File.expand_path("~/.local/state/irb_history")
FileUtils.mkdir_p(File.dirname(history_file))
IRB.conf[:HISTORY_FILE] = history_file

# 2. Prompt definition
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "rb(main):%03n> ",
  :PROMPT_N => "rb(main):%03n+ ",
  :PROMPT_S => "rb(main):%03n%q ",
  :PROMPT_C => "rb(main):%03n* ",
  :RETURN   => "  => %s\n"
}

# 3. Ruby 3.3 Integration Features
IRB.conf[:MEASURE] = true

# 4. Behavior and debug
IRB.conf[:BACK_TRACE_LIMIT] = 10
IRB.conf[:IGNORE_SIGINT] = true
IRB.conf[:INSPECT_MODE] = true

# 5. Environment
def reload!
  exec $0
end
