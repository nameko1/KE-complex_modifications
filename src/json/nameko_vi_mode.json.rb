#!/usr/bin/env ruby

require 'json'
require_relative '../lib/karabiner.rb'

def main
  puts JSON.pretty_generate(
    "title" => "Nameko Vi Mode (rev 5)",
    "rules" => [
      {
        "description" => "Nameko Vi Mode",
        "manipulators" => generate_vi_mode(),
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

def generate_vi_mode()
  [
    generate_vi_insert_mode("i", []),
    generate_vi_normal_mode("open_bracket", ["left_control"]),
    generate_vi_normal_mode_key(),
    generate_vi_visual_mode("v", []),
    generate_vi_visual_mode_key(),
  ].flatten
end

def generate_vi_visual_mode_key()
  [
    no_key_code("q", "vi_visual_mode"),
    generate_vi_visual_mode_single_rule("w", "right_arrow", [], ["left_shift", "left_option"]),
    no_key_code("e", "vi_visual_mode"),
    no_key_code("r", "vi_visual_mode"),
    no_key_code("t", "vi_visual_mode"),
    generate_vi_visual_mode_exit_rule("y", "c", ["left_command"]),
    no_key_code("u", "vi_visual_mode"),
    no_key_code("i", "vi_visual_mode"),
    no_key_code("o", "vi_visual_mode"),
    no_key_code("p", "vi_visual_mode"),
    no_key_code("a", "vi_visual_mode"),
    no_key_code("s", "vi_visual_mode"),
    no_key_code("d", "vi_visual_mode"),
    no_key_code("f", "vi_visual_mode"),
    no_key_code("g", "vi_visual_mode"),
    generate_vi_visual_mode_single_rule("g", "down_arrow", [], ["left_shift"]),
    generate_vi_visual_mode_single_rule("h", "left_arrow", [], ["left_shift"]),
    generate_vi_visual_mode_single_rule("j", "down_arrow", [], ["left_shift"]),
    generate_vi_visual_mode_single_rule("k", "up_arrow", [], ["left_shift"]),
    generate_vi_visual_mode_single_rule("l", "right_arrow", [], ["left_shift"]),
    no_key_code("z", "vi_visual_mode"),
    no_key_code("x", "vi_visual_mode"),
    no_key_code("c", "vi_visual_mode"),
    generate_vi_visual_mode_exit_rule("v", "left_arrow", []),
    generate_vi_visual_mode_single_rule("b", "left_arrow", [], ["left_shift", "left_option"]),
    no_key_code("n", "vi_visual_mode"),
    no_key_code("m", "vi_visual_mode"),
    generate_vi_visual_mode_single_rule("0", "left_arrow", [], ["left_shift", "left_command"]),
    generate_vi_visual_mode_single_rule("4", "right_arrow", [], ["left_shift", "left_command"]),
  ].flatten
end

def generate_vi_normal_mode_key()
  [
    no_key_code("q", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("w", "right_arrow", ["left_option"]),
    no_key_code("e", "vi_normal_mode"),
    no_key_code("r", "vi_normal_mode"),
    no_key_code("t", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("y", "c", ["left_command"]),
    generate_vi_normal_mode_single_rule("u", "z", ["left_command"]),
    no_key_code("i", "vi_normal_mode"),
    no_key_code("o", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("p", "v", ["left_command"]),
    no_key_code("a", "vi_normal_mode"),
    no_key_code("s", "vi_normal_mode"),
    no_key_code("d", "vi_normal_mode"),
    no_key_code("f", "vi_normal_mode"),
    no_key_code("g", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("h", "left_arrow", []),
    generate_vi_normal_mode_single_rule("j", "down_arrow", []),
    generate_vi_normal_mode_single_rule("k", "up_arrow", []),
    generate_vi_normal_mode_single_rule("l", "right_arrow", []),
    no_key_code("z", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("x", "d", ["left_control"]),
    no_key_code("c", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("b", "left_arrow", ["left_option"]),
    no_key_code("n", "vi_normal_mode"),
    no_key_code("m", "vi_normal_mode"),
    generate_vi_normal_mode_single_rule("0", "left_arrow", ["left_command"]),
    generate_vi_normal_mode_single_rule("4", "right_arrow", ["left_command"]),
    # generate_vi_normal_mode_double_tap("y", "c", ["left_command"], "pressed_y"),
    # generate_vi_normal_mode_double_tap("d", "delete_or_backspace", [], "pressed_d"),
  ].flatten
end

def no_key_code(key_code, mode)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => key_code,
        "modifiers" => { "optional" => ["any"] },
      },
      "to" => [
      ],
      "conditions" => [
        Karabiner.variable_if(mode, 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

# def generate_vi_normal_mode_double_tap(from_key_code, to_key_code, to_modifier_key_code_array, variable_name)
#   [
#     {
#       "type" => "basic",
#       "from" => {
#        "key_code" => from_key_code,
#       },
#       "to" => [
#         {
#          "key_code" => "right_arrow",
#          "modifiers" => ["left_command"]
#         },
#         {
#          "key_code" => "left_arrow",
#          "modifiers" => ["left_command", "left_shift"]
#         },
#         {
#          "key_code" => to_key_code,
#          "modifiers" => to_modifier_key_code_array
#         },
#       ],
#       "conditions" => [
#         Karabiner.variable_if("variable_name", 1),
#         Karabiner.frontmost_application_unless(["terminal", "vi"]),
#       ]
#     },
#     {
#       "type" => "basic",
#       "from" => {
#        "key_code" => from_key_code,
#         "modifiers" => { "optional" => ["any"] },
#       },
#       "to" => [
#           Karabiner.set_variable(variable_name, 1),
#       ],
#       "conditions" => [
#         Karabiner.variable_if("vi_normal_mode", 1),
#         Karabiner.frontmost_application_unless(["terminal", "vi"]),
#       ],
#       "to_delayed_action" => {
#         "to_if_invoked" => [
#           Karabiner.set_variable(variable_name, 0),
#         ],
#         "to_if_canceled" => [
#           Karabiner.set_variable(variable_name, 0),
#         ]
#       },
#     }
#   ]
# end

def generate_vi_normal_mode_single_rule(from_key_code, to_key_code, to_modifier_key_code_array)
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
        Karabiner.variable_if("vi_normal_mode", 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

def generate_vi_normal_mode(from_key_code, to_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => { "mandatory" => to_modifier_key_code_array },
      },
      "to" => [
        Karabiner.set_variable("vi_normal_mode", 1),
        Karabiner.set_variable("vi_visual_mode", 0),
      ],
      "conditions" => [
        Karabiner.variable_if("vi_normal_mode", 0),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

def generate_vi_visual_mode(from_key_code, to_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => { "mandatory" => to_modifier_key_code_array },
      },
      "to" => [
        Karabiner.set_variable("vi_visual_mode", 1),
        Karabiner.set_variable("vi_normal_mode", 0),
      ],
      "conditions" => [
        Karabiner.variable_if("vi_visual_mode", 0),
        Karabiner.variable_if("vi_normal_mode", 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

def generate_vi_insert_mode(from_key_code, to_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => { "mandatory" => to_modifier_key_code_array },
      },
      "to" => [
        Karabiner.set_variable("vi_visual_mode", 0),
        Karabiner.set_variable("vi_normal_mode", 0),
      ],
      "conditions" => [
        Karabiner.variable_if("vi_visual_mode", 0),
        Karabiner.variable_if("vi_normal_mode", 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

def generate_vi_visual_mode_single_rule(from_key_code, to_key_code, from_modifier_key_code_array, to_modifier_key_code_array)
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
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array
        },
      ],
      "conditions" => [
        Karabiner.variable_if("vi_visual_mode", 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

def generate_vi_visual_mode_exit_rule(from_key_code, to_key_code, to_modifier_key_code_array)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => from_key_code,
        "modifiers" => { "optional" => ["any"] },
      },
      "to" => [
        Karabiner.set_variable("vi_visual_mode", 0),
        Karabiner.set_variable("vi_normal_mode", 1),
        {
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array
        },
      ],
      "conditions" => [
        Karabiner.variable_if("vi_visual_mode", 1),
        Karabiner.frontmost_application_if(["my_editor"]),
      ]
    }
  ]
end

main()
