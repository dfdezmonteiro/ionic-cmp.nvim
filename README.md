# ionic-cmp.nvim

A lightweight Neovim completion source for Ionic Angular projects using [`blink.cmp`](https://github.com/Saghen/blink.cmp).

`ionic-cmp.nvim` adds completion suggestions for Ionic components and common Ionic/Angular template attributes inside HTML files.

## Features

- Ionic component completion in HTML templates.
- Ionic attribute completion inside Ionic opening tags.
- Angular template attribute completion commonly used in Ionic projects.
- Native `blink.cmp` provider.
- No dependency on `nvim-cmp`.
- Small, static, fast, and easy to extend.

## Preview

Typing:

```html
<
```

suggests Ionic components such as:

```html
ion-app ion-content ion-header ion-toolbar ion-button ion-card ion-input
ion-item ion-list ion-modal
```

Typing inside an Ionic tag:

```html
<ion-button
```

suggests attributes such as:

```html
color fill expand shape disabled routerLink routerDirection (click) *ngIf *ngFor
```

## Requirements

- Neovim 0.10+
- [`blink.cmp`](https://github.com/Saghen/blink.cmp)

Recommended for Ionic Angular projects:

- Angular Language Server
- TypeScript LSP
- HTML LSP

## Installation

### lazy.nvim

```lua
{
  "dfdezmonteiro/ionic-cmp.nvim",
  dependencies = {
    "saghen/blink.cmp",
  },
}
```

## Configuration

Register the provider in your `blink.cmp` configuration:

```lua
{
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "ionic",
      },

      providers = {
        ionic = {
          name = "Ionic",
          module = "ionic-cmp.blink",
          score_offset = 100,
        },
      },
    },
  },
}
```

Full LazyVim example:

```lua
return {
  {
    "your-github-user/ionic-cmp.nvim",
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {
        "lsp",
        "path",
        "snippets",
        "buffer",
      }

      if not vim.tbl_contains(opts.sources.default, "ionic") then
        table.insert(opts.sources.default, "ionic")
      end

      opts.sources.providers = opts.sources.providers or {}

      opts.sources.providers.ionic = {
        name = "Ionic",
        module = "ionic-cmp.blink",
        score_offset = 100,
      }

      return opts
    end,
  },
}
```

## Supported files

The provider currently activates in:

- `html`
- `angular`
- files ending in `.html`

## Completion behavior

### Component completion

When the cursor is after an opening `<`, the source suggests Ionic components:

```html
<
```

Example suggestions:

```html
ion-content ion-header ion-toolbar ion-button ion-card ion-input
```

### Attribute completion

When the cursor is inside an Ionic opening tag, the source suggests Ionic and Angular attributes:

```html
<ion-item
```

Example suggestions:

```html
color slot lines routerLink formControlName [(ngModel)] (click) *ngIf *ngFor
```

## Project structure

```text
ionic-cmp.nvim/
├── README.md
└── lua/
    └── ionic-cmp/
        ├── init.lua
        ├── blink.lua
        └── data.lua
```

## File responsibilities

### `lua/ionic-cmp/init.lua`

Plugin entry point.

Currently minimal because the completion source is registered from the `blink.cmp` configuration.

### `lua/ionic-cmp/blink.lua`

`blink.cmp` provider.

Responsible for:

- detecting template files
- detecting whether the cursor is after `<`
- detecting whether the cursor is inside an Ionic opening tag
- returning completion items

### `lua/ionic-cmp/data.lua`

Static completion data.

Contains:

- Ionic component names
- Ionic attributes
- Angular template attributes commonly used in Ionic templates

## Design

`ionic-cmp.nvim` does not call `blink.setup()` internally.

The intended architecture is:

```text
blink.cmp config
└── registers provider: ionic-cmp.blink

ionic-cmp.nvim
└── exposes provider and completion data
```

This keeps the plugin decoupled from the user's completion configuration and avoids overriding existing `blink.cmp` settings.

## Limitations

This plugin is not a language server.

It does not currently validate:

- Ionic component imports
- Angular standalone component imports
- Angular modules
- Ionic version compatibility
- component-specific input/output validity
- project-specific custom components
- TypeScript symbols
- template type checking

It only provides completion candidates.

For semantic validation and diagnostics, use Angular Language Server and TypeScript LSP.

## Roadmap

Possible future improvements:

- component-specific attribute filtering
- Ionic event completions
- Ionic slot value completions
- Ionic color value completions
- Ionic size/fill/shape value completions
- snippets for common Ionic page layouts
- snippets for Ionic forms
- snippets for Ionic modals, alerts, and toasts
- Capacitor API completions
- Ionic project-root detection through `ionic.config.json`
- enable completion only inside Ionic projects
- links to official Ionic documentation
- support for project-specific custom components

## Contributing

Contributions are welcome.

## License

MIT
