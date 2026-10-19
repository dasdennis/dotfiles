require "fileutils"

# History: XDG state dir, owner-only permissions (history may contain secrets)
state_dir = File.join(ENV.fetch("XDG_STATE_HOME", File.expand_path("~/.local/state")), "irb")
FileUtils.mkdir_p(state_dir, mode: 0o700)
history_file = File.join(state_dir, "history")
File.open(history_file, File::CREAT, 0o600) {} # pre-create so perms are 0600, not umask-derived
IRB.conf[:HISTORY_FILE] = history_file
IRB.conf[:SAVE_HISTORY] = 5000

IRB.conf[:BACK_TRACE_LIMIT] = 10
# IRB.conf[:COMPLETOR] = :regexp  # lighter than :type; enable if completion lags in large Rails apps

# Lazy-load: zero startup cost, real load errors surface on first use
autoload :JSON, "json"
autoload :YAML, "yaml"

# Prompt: keep Rails' own prompt (shows the environment)
unless defined?(Rails)
  IRB.conf[:PROMPT][:CUSTOM] = {
    PROMPT_I: "rb(%m):%03n> ",
    PROMPT_N: "rb(%m):%03n+ ",
    PROMPT_S: "rb(%m):%03n%l ",
    PROMPT_C: "rb(%m):%03n* ",
    RETURN:   "  => %s\n"
  }
  IRB.conf[:PROMPT_MODE] = :CUSTOM
end
