include_attribute "ohai"

default["ohai"]["plugins"]["cloudformation"] = "ohai_plugins"

default["cloudformation"]["sent_signals"] = []
