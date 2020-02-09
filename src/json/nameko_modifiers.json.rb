#!/usr/bin/env ruby

require 'json'
require_relative '../lib/karabiner.rb'

def main
  puts JSON.pretty_generate(
    "title" => "Nameko key modifiers",
    "rules" => [
      {
        "description" => "Key Modifier",
        "manipulators" => key_modifier(),
      },
      {
        "description" => "Send Escape and JP_EISUU when Ctrl + [",
        "manipulators" => [
          escape_and_eisuu_only_terminal("open_bracket", ["control"]),
          escape_and_eisuu_only_terminal("delete_or_backspace", ["control"]),
        ].flatten
      },
      {
        "description" => "S and S",
        "manipulators" => [
          sands("spacebar", "left_shift"),
        ].flatten
      }
    ],
  )
end

def key_modifier()
  [
    switch_key("right_alt", "right_gui", [], [], []),
    switch_key("i", "tab", ["left_control"], [], []),
    switch_key("h", "left_arrow", ["left_control"], [], ["terminal", "vi"]),
    switch_key("j", "down_arrow", ["left_control"], [], ["terminal", "vi"]),
    switch_key("k", "up_arrow", ["left_control"], [], ["terminal", "vi"]),
    switch_key("l", "right_arrow", ["left_control"], [], ["terminal", "vi"]),
    change_to_delete("open_bracket", []),
    escape_and_eisuu_only_terminal("open_bracket", ["control"]),
    escape_and_eisuu_only_terminal("delete_or_backspace", ["control"]),
  ].flatten
end

def escape_and_eisuu_only_terminal(from_key_code, from_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "mandatory" => from_modifier_key_code_array
        },
      },
      "to" => [
        {
          "key_code": "open_bracket",
          "modifiers" => "control"
        },
        # {
        #   "key_code": "japanese_eisuu"
        # }
      ],
      "conditions" => [
        Karabiner.frontmost_application_if(["terminal"]),
      ]
    }
  ]
end

def sands(from_key_code, to_key_code)
  sands_if_delay(from_key_code, to_key_code)
end

def sands_if_held(from_key_code, to_key_code)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "optional" => ["any"]
        },
      },
      "to_if_alone" => [
        {
         "key_code" => from_key_code,
        },
      ],
      "to_if_held_down" => [
        {
         "key_code" => to_key_code,
        },
      ],
      "conditions" => [
        Karabiner.frontmost_application_unless(["alfred"]),
      ]
    }
  ]
end

def sands_if_delay(from_key_code, to_key_code)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "optional" => ["any"]
        },
      },
      "to_delayed_action" => {
       "to_if_invoked" =>[
         "key_code" => from_key_code,
       ],
      },
      "to" => [
        {
         "key_code" => to_key_code,
         "lazy" => true,
        },
      ],
      "conditions" => [
        Karabiner.frontmost_application_unless(["alfred"]),
      ],
    }
  ]
end

def sands_if_alone(from_key_code, to_key_code)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "optional" => ["any"]
        },
      },
      "to_if_alone" => [
        {
          "key_code" => from_key_code,
        },
      ],
      "to" => [
        {
         "key_code" => to_key_code,
         "lazy" => true,
        },
      ],
      "conditions" => [
        Karabiner.frontmost_application_unless(["alfred"]),
      ],
    }
  ]
end

def switch_key(from_key_code, to_key_code, from_modifier_key_code_array, to_modifier_key_code_array, unless_application)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "mandatory" => from_modifier_key_code_array,
          "optional" => ["any"],
        },
      },
      "to" => [
        {
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array,
        },
      ],
      "conditions" => [
        Karabiner.frontmost_application_unless(unless_application),
        Karabiner.default_mac_keyboard_if(),
        # {
        #     "type" => "device_if",
        #     "identifiers" =>[
        #         {
        #             "vendor_id" => 1452,
        #             "product_id" => 630,
        #             "description" => "default keyboard",
        #         }
        #     ]
        # },
      ]
    }
  ]
end

def change_to_delete(from_key_code, from_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => {
          "mandatory" => from_modifier_key_code_array,
          "optional" => ["any"]
        },
      },
      "to" => [
        {
          "key_code" => "delete_or_backspace",
        },
      ],
      "conditions" => [
        Karabiner.default_mac_keyboard_if(),
      ]
    }
  ]
end

main()
