#!/usr/bin/env ruby

require 'json'
require_relative '../lib/karabiner.rb'

def main
  puts JSON.pretty_generate(
    "title" => "QMK like keyboard",
    "rules" => [
      {
        "description" => "Upper Key mode",
        "manipulators" => generate_upper_layer(),
        # If you want to use other trigger keys for vi mode, just change this above line and run
        #
        # $ make
        #
        # in Terminal to generate your new JSON file at public/json/vi_mode.json.
        #
        # Copy it to ~/.config/karabiner/assets/complex_modifications then you can enable it in Karabiner-Elements.
        #
        # Modifier keys such as "command", "option" or "control" cannot be used here.
      },
    ],
  )
end

def generate_upper_layer()
  [
    # generate_upper_key_on_hold("left_shift"),
    generate_upper_key_on_hold("right_gui"),
    # generate_upper_key("left_gui", "spacebar"),
    generate_upper_keybind("q", "1", []),
    generate_upper_keybind("w", "2", []),
    generate_upper_keybind("e", "3", []),
    generate_upper_keybind("r", "4", []),
    generate_upper_keybind("t", "5", []),
    generate_upper_keybind("y", "6", []),
    generate_upper_keybind("u", "7", []),
    generate_upper_keybind("i", "8", []),
    generate_upper_keybind("o", "9", []),
    generate_upper_keybind("p", "0", []),
    generate_upper_keybind("open_bracket", "delete_or_backspace", []),
    generate_upper_keybind("close_bracket", "delete_or_backspace", []),
    generate_upper_keybind("s", "escape", []),
    generate_upper_keybind("d", "grave_accent_and_tilde", []),
    generate_upper_keybind("f", "backslash", []),
    generate_upper_keybind("h", "hyphen", []),
    generate_upper_keybind("j", "open_bracket", []),
    generate_upper_keybind("k", "close_bracket", []),
    generate_upper_keybind("l", "equal_sign", []),
  ].flatten
end

def generate_upper_keybind(from_key_code, to_key_code, to_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => { "optional" => ["any"] },
      },
      "to" => [
        {
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array
        },
      ],
      "conditions" => [
        Karabiner.variable_if("upper_layer", 1),
      ]
    }
  ]
end

def generate_upper_key(trigger_key, key_code)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code": key_code,
        "modifiers" => { "mandatory" => [trigger_key] },
      },
      "to" => [
        Karabiner.set_variable("upper_layer", 1),
      ],
      "conditions" => [
        Karabiner.variable_if("upper_layer", 0),
      ]
    },
    {
      "type" => "basic",
      "from" => {
        "key_code": key_code,
        "modifiers" => { "mandatory" => [trigger_key] },
      },
      "to" => [
        Karabiner.set_variable("upper_layer", 0),
      ],
      "conditions" => [
        Karabiner.variable_if("upper_layer", 1),
      ]
    },
  ]
end

def generate_upper_key_on_hold(trigger_key)
  [
    {
      "type" => "basic",
      "from" => {
        "simultaneous" => [
          { "key_code" => trigger_key },
        ],
        "simultaneous_options" => {
          "key_down_order" => "strict",
          "key_up_order" => "strict_inverse",
          "detect_key_down_uninterruptedly" => true,
          "to_after_key_up" => [
            Karabiner.set_variable("upper_layer", 0),
          ],
        },
        "modifiers" => { "optional" => ["any"] },
      },
      "to" => [
        Karabiner.set_variable("upper_layer", 1),
      ],
      "conditions" => [
        Karabiner.variable_if("upper_layer", 0),
      ]
    },
  ]
end

main()
