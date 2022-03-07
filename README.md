<div id='section-id-1'/>

# BuildTask.nvim

Neovim Plugin to use build tasks similar to VScode

# Table of Contents

- [BuildTask.nvim](#section-id-1)
  - [Features](#section-id-5)
  - [Requirements](#section-id-12)
  - [Installation](#section-id-16)
  - [Config](#section-id-27)
    - [Fields and values](#section-id-84)
  - [Usage](#section-id-103)
  - [Feature Plan](#section-id-107)
  - [Contributing](#section-id-111)

<div id='section-id-5'/>

## Features

**Note: this plugin is still in development and there might be some breaking changes**

- Reads taks from a json file
- Very similar to VScode's `task.json`
- Runs default build task in terminal
- Written in Lua, configured in Lua

<div id='section-id-12'/>

## Requirements

- Neovim v0.6.0+ or nightly build

<div id='section-id-16'/>

## Installation

Recommended is to use [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
    'Arjun31415/BuildTask.nvim',
    requires="rcarriga/nvim-notify"
    })
```

<div id='section-id-27'/>

## Config

The plugin config with default values-

```lua
require('buildtask').setup({default_shell = "$SHELL", default_task_file="task.json"})

```

`<default_task_file>.json` config-

This file must be present in the working directory and must adhere to strict json format.
An example file is given below-

```json
{
  "tasks": [
    {
      "type": "python run",
      "label": "Python run active file",
      "command": "/usr/bin/python",
      "args": ["${file}"],
      "options": {
        "cwd": "${fileDirname}"
      },
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "detail": "interpreter: /usr/bin/python"
    },

    {
      "type": "cppbuild",
      "label": "C/C++: g++-11 build active file",
      "command": "/bin/g++",
      "args": [
        "-g",
        "${file}",
        "-std=c++20",
        "-o",
        "${fileDirname}/${fileBasenameNoExtension}"
      ],
      "options": {
        "cwd": "${fileDirname}"
      },
      "problemMatcher": ["$gcc"],
      "group": {
        "kind": "build",
        "isDefault": false
      },
      "detail": "compiler: /bin/g++"
    }
  ]
}
```

<div id='section-id-84'/>

### Fields and values

| Field   | Value                                                                                                                  | Type     |
| ------- | ---------------------------------------------------------------------------------------------------------------------- | -------- |
| tasks   | An array of tasks to perform                                                                                           | Required |
| type    | The type of task it is                                                                                                 | Optional |
| label   | label given to this task                                                                                               | Optional |
| command | the command/executable which runs this task                                                                            | Required |
| args    | the space separated command line arguments <br> array to give to the executable specified <br> in the `command` field. | Required |
| group   | As of now it must contain a isDefault field which <br> specifies if it is the default task or not                      | Required |
| detail  | Any additional comments or details                                                                                     | Optional |

Any additional field are just ignored and not used. <br>
It currently supports 3 variables in the json file -

1. `${file}` - it is substituted for the file name in the active buffer
2. `${fileDirname}` - the current directory of the file (Note: The task.json file must be present in this directory )
3. `${fileBasenameNoExtension}` - the file name with the extension removed

<div id='section-id-103'/>

## Usage

As of now it provides a single command `:BtBuildDefault` which runs the default build task

<div id='section-id-107'/>

## Feature Plan

- [ ] Command to run other tasks apart from default tasks

<div id='section-id-111'/>

## Contributing

Contributions are welcome, If you find any issues please create a new issue in Github
