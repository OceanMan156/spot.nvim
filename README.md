# spot.nvim

Spotify in neovim

## What is Spot?

`spot.nvim` allows you to browse, play and pause your spotify music
directly from your neovim instance.

## Table of contents

* [Requirements](*requirements)
* [Features](*features)
* [Planed Features](*planed)
* [Installation](*installation)
* [Setup](*setup)
* [Usage](*usage)

## Requirements

1. [Telescope](https://github.com/nvim-telescope/telescope.nvim)
2. [Plenary](https://github.com/nvim-lua/plenary.nvim)
3. Spotify for developer account
    - A client refresh token

## Features

- Ability to browse user playlist
- Ability to browse songs in playlist
- Ability play/pause
- Ability to skip song

### Planed Features

- Ability to choose playback device
- Ability to view current queue
- Ability to add songs to queue
- Properly handle pagination with playlist with over 100 songs

## Installation

```vim
Plug 'OceanMan156/spot.nvim'
```

### Setup

`spot.nvim` utilizes the spotify api to get information about the
current users playlist and playback method. A spotify developer account
and app need to have been created and a refresh token is needed for the 
plugin to properly work. Information on how to obtain a refresh token 
can be found at the [Spotify API Docs](https://developer.spotify.com/documentation/web-api)

Once you have a refresh token export it to the env as `clientRefreshToken`.


```bash
export clientRefreshToken=<token>
```

## Usage

By default the following keybinds are set by default

```lua
-- Default mappings
vim.keymap.set('n', '<space>sl', require("spot.display").display_playlist)
vim.keymap.set('n', '<space>sps', require("spot.commands").play)
vim.keymap.set('n', '<space>spp', require("spot.commands").pause)
vim.keymap.set('n', '<space>spn', require("spot.commands").next)
```
