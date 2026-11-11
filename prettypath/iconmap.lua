-- references:
-- 1. Linguist: https://github.com/github/linguist
-- 2. coc-explorer: https://github.com/weirongxu/coc-explorer/blob/59bd41f8fffdc871fbd77ac443548426bd31d2c3/src/icons.nerdfont.json#L2
-- 3. chad-tree: https://github.com/ms-jpq/chadtree/blob/f9f333c062/artifacts/icons.json
-- jquery = {
--   icon = "",
--   color = "#1B75BB"
-- },
-- angular = {
--   icon = "",
--   color = "#E23237"
-- },
-- backbone = {
--   icon = "",
--   color = "#0071B5"
-- },
-- requirejs = {
--   icon = "",
--   color = "#F44A41"
-- },
-- materialize = {
--   icon = "",
--   color = "#EE6E73"
-- },
-- mootools = {
--   icon = "",
--   color = "#ECECEC"
-- },
-- puppet = {
--   icon = "",
--   color = "#ffa61a"
-- },

-- When adding new icons, remember to add an entry to the `filetypes` table, if applicable.

local icons = {
  ["/"] = {
    icon = "",
    color = "#4d70aa",
    name = "Directory",
  },
  [""] = {
    icon = "",
    color = "#6d8086",
    name = "Default",
  },
  [".babelrc"] = {
    icon = "ﬥ",
    color = "#cbcb41",
    name = "Babelrc",
  },
  [".bash_profile"] = {
    icon = "",
    color = "#89e051",
    name = "BashProfile",
  },
  [".bashrc"] = {
    icon = "",
    color = "#89e051",
    name = "Bashrc",
  },
  [".DS_Store"] = {
    icon = "",
    color = "#41535b",
    name = "DsStore",
  },
  [".gitattributes"] = {
    icon = "",
    color = "#41535b",
    name = "GitAttributes",
  },
  [".gitconfig"] = {
    icon = "",
    color = "#41535b",
    name = "GitConfig",
  },
  [".gitignore"] = {
    icon = "",
    color = "#41535b",
    name = "GitIgnore",
  },
  [".gitlab-ci.yml"] = {
    icon = "",
    color = "#e24329",
    name = "GitlabCI",
  },
  [".gitmodules"] = {
    icon = "",
    color = "#41535b",
    name = "GitModules",
  },
  [".gvimrc"] = {
    icon = "",
    color = "#019833",
    name = "Gvimrc",
  },
  [".npmignore"] = {
    icon = "",
    color = "#E8274B",
    name = "NPMIgnore",
  },
  [".npmrc"] = {
    icon = "",
    color = "#E8274B",
    name = "NPMrc",
  },
  [".settings.json"] = {
    icon = "",
    color = "#854CC7",
    name = "SettingsJson",
  },
  [".vimrc"] = {
    icon = "",
    color = "#019833",
    name = "Vimrc",
  },
  [".zprofile"] = {
    icon = "",
    color = "#89e051",
    name = "Zshprofile",
  },
  [".zshenv"] = {
    icon = "",
    color = "#89e051",
    name = "Zshenv",
  },
  [".zshrc"] = {
    icon = "",
    color = "#89e051",
    name = "Zshrc",
  },
  ["Brewfile"] = {
    icon = "",
    color = "#701516",
    name = "Brewfile",
  },
  ["CMakeLists.txt"] = {
    icon = "",
    color = "#6d8086",
    name = "CMakeLists",
  },
  ["COMMIT_EDITMSG"] = {
    icon = "",
    color = "#41535b",
    name = "GitCommit",
  },
  ["COPYING"] = {
    icon = "",
    color = "#cbcb41",
    name = "License",
  },
  ["COPYING.LESSER"] = {
    icon = "",
    color = "#cbcb41",
    name = "License",
  },
  ["Dockerfile"] = {
    icon = "",
    color = "#384d54",
    name = "Dockerfile",
  },
  ["Gemfile$"] = {
    icon = "",
    color = "#701516",
    name = "Gemfile",
  },
  ["LICENSE"] = {
    icon = "",
    color = "#d0bf41",
    name = "License",
  },
  ["R"] = {
    icon = "ﳒ",
    color = "#358a5b",
    name = "R",
  },
  ["Rmd"] = {
    icon = "",
    color = "#519aba",
    name = "Rmd",
  },
  ["Vagrantfile$"] = {
    icon = "",
    color = "#1563FF",
    name = "Vagrantfile",
  },
  ["_gvimrc"] = {
    icon = "",
    color = "#019833",
    name = "Gvimrc",
  },
  ["_vimrc"] = {
    icon = "",
    color = "#019833",
    name = "Vimrc",
  },
  ["ai"] = {
    icon = "",
    color = "#cbcb41",
    name = "Ai",
  },
  ["awk"] = {
    icon = "",
    color = "#4d5a5e",
    name = "Awk",
  },
  ["bash"] = {
    icon = "",
    color = "#89e051",
    name = "Bash",
  },
  ["bat"] = {
    icon = "",
    color = "#C1F12E",
    name = "Bat",
  },
  ["bmp"] = {
    icon = "",
    color = "#a074c4",
    name = "Bmp",
  },
  ["c"] = {
    icon = "",
    color = "#599eff",
    name = "C",
  },
  ["c++"] = {
    icon = "",
    color = "#f34b7d",
    name = "CPlusPlus",
  },
  ["cbl"] = {
    icon = "⚙",
    color = "#005ca5",
    name = "Cobol",
  },
  ["cc"] = {
    icon = "",
    color = "#f34b7d",
    name = "CPlusPlus",
  },
  ["cfg"] = {
    icon = "",
    color = "#ECECEC",
    name = "Configuration",
  },
  ["clj"] = {
    icon = "",
    color = "#8dc149",
    name = "Clojure",
  },
  ["cljc"] = {
    icon = "",
    color = "#8dc149",
    name = "ClojureC",
  },
  ["cljs"] = {
    icon = "",
    color = "#519aba",
    name = "ClojureJS",
  },
  ["cljd"] = {
    icon = "",
    color = "#519aba",
    name = "ClojureDart",
  },
  ["cmake"] = {
    icon = "",
    color = "#6d8086",
    name = "CMake",
  },
  ["cob"] = {
    icon = "⚙",
    color = "#005ca5",
    name = "Cobol",
  },
  ["cobol"] = {
    icon = "⚙",
    color = "#005ca5",
    name = "Cobol",
  },
  ["coffee"] = {
    icon = "",
    color = "#cbcb41",
    name = "Coffee",
  },
  ["conf"] = {
    icon = "",
    color = "#6d8086",
    name = "Conf",
  },
  ["config.ru"] = {
    icon = "",
    color = "#701516",
    name = "ConfigRu",
  },
  ["cp"] = {
    icon = "",
    color = "#519aba",
    name = "Cp",
  },
  ["cpp"] = {
    icon = "",
    color = "#519aba",
    name = "Cpp",
  },
  ["cpy"] = {
    icon = "⚙",
    color = "#005ca5",
    name = "Cobol",
  },
  ["cr"] = {
    icon = "",
    color = "#000000",
    name = "Crystal",
  },
  ["cs"] = {
    icon = "",
    color = "#596706",
    name = "Cs",
  },
  ["csh"] = {
    icon = "",
    color = "#4d5a5e",
    name = "Csh",
  },
  ["cson"] = {
    icon = "",
    color = "#cbcb41",
    name = "Cson",
  },
  ["css"] = {
    icon = "",
    color = "#42a5f5",
    name = "Css",
  },
  ["csv"] = {
    icon = "",
    color = "#89e051",
    name = "Csv",
  },
  ["cxx"] = {
    icon = "",
    color = "#519aba",
    name = "Cxx",
  },
  ["d"] = {
    icon = "",
    color = "#427819",
    name = "D",
  },
  ["dart"] = {
    icon = "",
    color = "#03589C",
    name = "Dart",
  },
  ["db"] = {
    icon = "",
    color = "#dad8d8",
    name = "Db",
  },
  ["desktop"] = {
    icon = "",
    color = "#563d7c",
    name = "DesktopEntry",
  },
  ["diff"] = {
    icon = "",
    color = "#41535b",
    name = "Diff",
  },
  ["doc"] = {
    icon = "",
    color = "#185abd",
    name = "Doc",
  },
  ["dockerfile"] = {
    icon = "",
    color = "#384d54",
    name = "Dockerfile",
  },
  ["drl"] = {
    icon = "",
    color = "#ffafaf",
    name = "Drools",
  },
  ["dropbox"] = {
    icon = "",
    color = "#0061FE",
    name = "Dropbox",
  },
  ["dump"] = {
    icon = "",
    color = "#dad8d8",
    name = "Dump",
  },
  ["edn"] = {
    icon = "",
    color = "#519aba",
    name = "Edn",
  },
  ["eex"] = {
    icon = "",
    color = "#a074c4",
    name = "Eex",
  },
  ["ejs"] = {
    icon = "",
    color = "#cbcb41",
    name = "Ejs",
  },
  ["elm"] = {
    icon = "",
    color = "#519aba",
    name = "Elm",
  },
  ["epp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Epp",
  },
  ["erb"] = {
    icon = "",
    color = "#701516",
    name = "Erb",
  },
  ["erl"] = {
    icon = "",
    color = "#B83998",
    name = "Erl",
  },
  ["ex"] = {
    icon = "",
    color = "#a074c4",
    name = "Ex",
  },
  ["exs"] = {
    icon = "",
    color = "#a074c4",
    name = "Exs",
  },
  ["f#"] = {
    icon = "",
    color = "#519aba",
    name = "Fsharp",
  },
  ["favicon.ico"] = {
    icon = "",
    color = "#cbcb41",
    name = "Favicon",
  },
  ["fnl"] = {
    color = "#fff3d7",
    icon = "🌜",
    name = "Fennel"
  },
  ["fish"] = {
    icon = "",
    color = "#4d5a5e",
    name = "Fish",
  },
  ["fs"] = {
    icon = "",
    color = "#519aba",
    name = "Fs",
  },
  ["fsi"] = {
    icon = "",
    color = "#519aba",
    name = "Fsi",
  },
  ["fsscript"] = {
    icon = "",
    color = "#519aba",
    name = "Fsscript",
  },
  ["fsx"] = {
    icon = "",
    color = "#519aba",
    name = "Fsx",
  },
  ["gd"] = {
    icon = "",
    color = "#6d8086",
    name = "GDScript",
  },
  ["gemspec"] = {
    icon = "",
    color = "#701516",
    name = "Gemspec",
  },
  ["gif"] = {
    icon = "",
    color = "#a074c4",
    name = "Gif",
  },
  ["git"] = {
    icon = "",
    color = "#F14C28",
    name = "GitLogo",
  },
  ["glb"] = {
    icon = "",
    color = "#FFB13B",
    name = "BinaryGLTF",
  },
  ["go"] = {
    icon = "",
    color = "#519aba",
    name = "Go",
  },
  ["godot"] = {
    icon = "",
    color = "#6d8086",
    name = "GodotProject",
  },
  ["gruntfile"] = {
    icon = "",
    color = "#e37933",
    name = "Gruntfile",
  },
  ["gulpfile"] = {
    icon = "",
    color = "#cc3e44",
    name = "Gulpfile",
  },
  ["h"] = {
    icon = "",
    color = "#a074c4",
    name = "H",
  },
  ["haml"] = {
    icon = "",
    color = "#eaeae1",
    name = "Haml",
  },
  ["hbs"] = {
    icon = "",
    color = "#f0772b",
    name = "Hbs",
  },
  ["heex"] = {
    icon = "",
    color = "#a074c4",
    name = "Heex",
  },
  ["hh"] = {
    icon = "",
    color = "#a074c4",
    name = "Hh",
  },
  ["hpp"] = {
    icon = "",
    color = "#a074c4",
    name = "Hpp",
  },
  ["hrl"] = {
    icon = "",
    color = "#B83998",
    name = "Hrl",
  },
  ["hs"] = {
    icon = "",
    color = "#a074c4",
    name = "Hs",
  },
  ["htm"] = {
    icon = "",
    color = "#e34c26",
    name = "Htm",
  },
  ["html"] = {
    icon = "",
    color = "#e44d26",
    name = "Html",
  },
  ["hxx"] = {
    icon = "",
    color = "#a074c4",
    name = "Hxx",
  },
  ["ico"] = {
    icon = "",
    color = "#cbcb41",
    name = "Ico",
  },
  ["import"] = {
    icon = "",
    color = "#ECECEC",
    name = "ImportConfiguration",
  },
  ["ini"] = {
    icon = "",
    color = "#6d8086",
    name = "Ini",
  },
  ["java"] = {
    icon = "",
    color = "#cc3e44",
    name = "Java",
  },
  ["jl"] = {
    icon = "",
    color = "#a270ba",
    name = "Jl",
  },
  ["jpeg"] = {
    icon = "",
    color = "#a074c4",
    name = "Jpeg",
  },
  ["jpg"] = {
    icon = "",
    color = "#a074c4",
    name = "Jpg",
  },
  ["js"] = {
    icon = "",
    color = "#cbcb41",
    name = "Js",
  },
  ["json"] = {
    icon = "",
    color = "#cbcb41",
    name = "Json",
  },
  ["jsx"] = {
    icon = "",
    color = "#519aba",
    name = "Jsx",
  },
  ["ksh"] = {
    icon = "",
    color = "#4d5a5e",
    name = "Ksh",
  },
  ["kt"] = {
    icon = "𝙆",
    color = "#F88A02",
    name = "Kotlin",
  },
  ["kts"] = {
    icon = "𝙆",
    color = "#F88A02",
    name = "KotlinScript",
  },
  ["leex"] = {
    icon = "",
    color = "#a074c4",
    name = "Leex",
  },
  ["less"] = {
    icon = "",
    color = "#563d7c",
    name = "Less",
  },
  ["lhs"] = {
    icon = "",
    color = "#a074c4",
    name = "Lhs",
  },
  ["license"] = {
    icon = "",
    color = "#cbcb41",
    name = "License",
  },
  ["lua"] = {
    icon = "",
    color = "#51a0cf",
    name = "Lua",
  },
  ["makefile"] = {
    icon = "",
    color = "#6d8086",
    name = "Makefile",
  },
  ["markdown"] = {
    icon = "",
    color = "#519aba",
    name = "Markdown",
  },
  ["material"] = {
    icon = "",
    color = "#B83998",
    name = "Material",
  },
  ["md"] = {
    icon = "",
    color = "#ffffff",
    name = "Md",
  },
  ["mdx"] = {
    icon = "",
    color = "#519aba",
    name = "Mdx",
  },
  ["mint"] = {
    icon = "",
    color = "#87c095",
    name = "Mint",
  },
  ["mix.lock"] = {
    icon = "",
    color = "#a074c4",
    name = "MixLock",
  },
  ["mjs"] = {
    icon = "",
    color = "#f1e05a",
    name = "Mjs",
  },
  ["ml"] = {
    icon = "λ",
    color = "#e37933",
    name = "Ml",
  },
  ["mli"] = {
    icon = "λ",
    color = "#e37933",
    name = "Mli",
  },
  ["mo"] = {
    icon = "∞",
    color = "#9772FB",
    name = "Motoko",
  },
  ["mustache"] = {
    icon = "",
    color = "#e37933",
    name = "Mustache",
  },
  ["nim"] = {
    icon = "👑",
    color = "#f3d400",
    name = "Nim",
  },
  ["nix"] = {
    icon = "",
    color = "#7ebae4",
    name = "Nix",
  },
  ["node_modules"] = {
    icon = "",
    color = "#E8274B",
    name = "NodeModules",
  },
  ["opus"] = {
    icon = "",
    color = "#F88A02",
    name = "OPUS",
  },
  ["otf"] = {
    icon = "",
    color = "#ECECEC",
    name = "OpenTypeFont",
  },
  ['package.json'] = {
    icon = "",
    color = "#e8274b",
    name = "PackageJson"
  },
  ['package-lock.json'] = {
    icon = "",
    color = "#7a0d21",
    name = "PackageLockJson"
  },
  ["pck"] = {
    icon = "",
    color = "#6d8086",
    name = "PackedResource",
  },
  ["pdf"] = {
    icon = "",
    color = "#b30b00",
    name = "Pdf",
  },
  ["php"] = {
    icon = "",
    color = "#a074c4",
    name = "Php",
  },
  ["pl"] = {
    icon = "",
    color = "#519aba",
    name = "Pl",
  },
  ["pm"] = {
    icon = "",
    color = "#519aba",
    name = "Pm",
  },
  ["png"] = {
    icon = "",
    color = "#a074c4",
    name = "Png",
  },
  ["pp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Pp",
  },
  ["ppt"] = {
    icon = "",
    color = "#cb4a32",
    name = "Ppt",
  },
  ["pro"] = {
    icon = "",
    color = "#e4b854",
    name = "Prolog",
  },
  ["Procfile"] = {
    icon = "",
    color = "#a074c4",
    name = "Procfile",
  },
  ["ps1"] = {
    icon = "",
    color = "#4d5a5e",
    name = "PromptPs1",
  },
  ["psb"] = {
    icon = "",
    color = "#519aba",
    name = "Psb",
  },
  ["psd"] = {
    icon = "",
    color = "#519aba",
    name = "Psd",
  },
  ["py"] = {
    icon = "",
    color = "#ffbc03",
    name = "Py",
  },
  ["pyc"] = {
    icon = "",
    color = "#ffe291",
    name = "Pyc",
  },
  ["pyd"] = {
    icon = "",
    color = "#ffe291",
    name = "Pyd",
  },
  ["pyo"] = {
    icon = "",
    color = "#ffe291",
    name = "Pyo",
  },
  ["r"] = {
    icon = "ﳒ",
    color = "#358a5b",
    name = "R",
  },
  ["rake"] = {
    icon = "",
    color = "#701516",
    name = "Rake",
  },
  ["rakefile"] = {
    icon = "",
    color = "#701516",
    name = "Rakefile",
  },
  ["rb"] = {
    icon = "",
    color = "#701516",
    name = "Rb",
  },
  ["rlib"] = {
    icon = "",
    color = "#dea584",
    name = "Rlib",
  },
  ["rmd"] = {
    icon = "",
    color = "#519aba",
    name = "Rmd",
  },
  ["rproj"] = {
    icon = "鉶",
    color = "#358a5b",
    name = "Rproj",
    double = true
  },
  ["rs"] = {
    icon = "",
    color = "#dea584",
    name = "Rs",
  },
  ["rss"] = {
    icon = "",
    color = "#FB9D3B",
    name = "Rss",
  },
  ["sass"] = {
    icon = "",
    color = "#f55385",
    name = "Sass",
  },
  ["scala"] = {
    icon = "",
    color = "#cc3e44",
    name = "Scala",
  },
  ["scss"] = {
    icon = "",
    color = "#f55385",
    name = "Scss",
  },
  ["sh"] = {
    icon = "",
    color = "#4d5a5e",
    name = "Sh",
  },
  ["sig"] = {
    icon = "λ",
    color = "#e37933",
    name = "Sig",
  },
  ["slim"] = {
    icon = "",
    color = "#e34c26",
    name = "Slim",
  },
  ["sln"] = {
    icon = "",
    color = "#854CC7",
    name = "Sln",
  },
  ["sml"] = {
    icon = "λ",
    color = "#e37933",
    name = "Sml",
  },
  ["sql"] = {
    icon = "",
    color = "#dad8d8",
    name = "Sql",
  },
  ["sqlite"] = {
    icon = "",
    color = "#dad8d8",
    name = "Sql",
  },
  ["sqlite3"] = {
    icon = "",
    color = "#dad8d8",
    name = "Sql",
  },
  ["styl"] = {
    icon = "",
    color = "#8dc149",
    name = "Styl",
  },
  ["sublime"] = {
    icon = "",
    color = "#e37933",
    name = "Suo",
  },
  ["suo"] = {
    icon = "",
    color = "#854CC7",
    name = "Suo",
  },
  ["sv"] = {
    icon = "",
    color = "#019833",
    name = "SystemVerilog",
  },
  ["svelte"] = {
    icon = "",
    color = "#ff3e00",
    name = "Svelte",
  },
  ["svh"] = {
    icon = "",
    color = "#019833",
    name = "SystemVerilog",
  },
  ["svg"] = {
    icon = "ﰟ",
    color = "#FFB13B",
    name = "Svg",
  },
  ["swift"] = {
    icon = "",
    color = "#e37933",
    name = "Swift",
  },
  ["t"] = {
    icon = "",
    color = "#519aba",
    name = "Tor",
  },
  ["tbc"] = {
    icon = "﯑",
    color = "#1e5cb3",
    name = "Tcl",
  },
  ["tcl"] = {
    icon = "﯑",
    color = "#1e5cb3",
    name = "Tcl",
  },
  ["terminal"] = {
    icon = "",
    color = "#31B53E",
    name = "Terminal",
  },
  ["tex"] = {
    icon = "ﭨ",
    color = "#3D6117",
    name = "Tex",
  },
  ["toml"] = {
    icon = "",
    color = "#6d8086",
    name = "Toml",
  },
  ["tres"] = {
    icon = "",
    color = "#cbcb41",
    name = "TextResource",
  },
  ["ts"] = {
    icon = "",
    color = "#519aba",
    name = "Ts",
  },
  ["tscn"] = {
    icon = "",
    color = "#a074c4",
    name = "TextScene",
  },
  ["tsx"] = {
    icon = "",
    color = "#519aba",
    name = "Tsx",
  },
  ["twig"] = {
    icon = "",
    color = "#8dc149",
    name = "Twig",
  },
  ["txt"] = {
    icon = "",
    color = "#89e051",
    name = "Txt",
  },
  ["v"] = {
    icon = "",
    color = "#019833",
    name = "Verilog",
  },
  ["vh"] = {
    icon = "",
    color = "#019833",
    name = "Verilog",
  },
  ["vhd"] = {
    icon = "",
    color = "#019833",
    name = "VHDL",
  },
  ["vhdl"] = {
    icon = "",
    color = "#019833",
    name = "VHDL",
  },
  ["vim"] = {
    icon = "",
    color = "#019833",
    name = "Vim",
  },
  ["vue"] = {
    icon = "﵂",
    color = "#8dc149",
    name = "Vue",
  },
  ["webmanifest"] = {
    icon = "",
    color = "#f1e05a",
    name = "Webmanifest",
  },
  ["webp"] = {
    icon = "",
    color = "#a074c4",
    name = "Webp",
  },
  ["webpack"] = {
    icon = "ﰩ",
    color = "#519aba",
    name = "Webpack",
  },
  ["xcplayground"] = {
    icon = "",
    color = "#e37933",
    name = "XcPlayground",
  },
  ["xls"] = {
    icon = "",
    color = "#207245",
    name = "Xls",
  },
  ["xml"] = {
    icon = "謹",
    color = "#e37933",
    name = "Xml",
    double = true,
  },
  ["xul"] = {
    icon = "",
    color = "#e37933",
    name = "Xul",
  },
  ["yaml"] = {
    icon = "",
    color = "#6d8086",
    name = "Yaml",
  },
  ["yml"] = {
    icon = "",
    color = "#6d8086",
    name = "Yml",
  },
  ["zig"] = {
    icon = "",
    color = "#f69a1b",
    name = "Zig",
  },
  ["zsh"] = {
    icon = "",
    color = "#89e051",
    name = "Zsh",
  },
  ["sol"] = {
    icon = "ﲹ",
    color = "#519aba",
    name = "Solidity",
  },
  [".env"] = {
    icon = "",
    color = "#faf743",
    name = "Env",
  },
  ["prisma"] = {
    icon = "卑",
    color = "#ffffff",
    name = "Prisma",
  },
  ["lock"] = {
    icon = "",
    color = "#bbbbbb",
    name = "Lock",
  },
  ["log"] = {
    icon = "",
    color = "#ffffff",
    name = "Log",
  },
}

-- Map of filetypes -> icon names
local filetypes = {
  ["ada"] = "ada",
  ["arduino"] = "ino",
  ["asm"] = "asm",
  ["awk"] = "awk",
  ["c"] = "c",
  ["cfg"] = "cfg",
  ["clojure"] = "clj",
  ["cmake"] = "cmake",
  ["cobol"] = "cbl",
  ["conf"] = "conf",
  ["cpp"] = "cpp",
  ["crystal"] = "cr",
  ["cs"] = "cs",
  ["csh"] = "csh",
  ["css"] = "css",
  ["csv"] = "csv",
  ["cuda"] = "cuh",
  ["d"] = "d",
  ["dart"] = "dart",
  ["desktop"] = "desktop",
  ["diff"] = "diff",
  ["dockerfile"] = "dockerfile",
  ["dosbatch"] = "bat",
  ["dosini"] = "ini",
  ["eelixir"] = "eex",
  ["elixir"] = "ex",
  ["elm"] = "elm",
  ["env"] = ".env",
  ["epuppet"] = "epp",
  ["erlang"] = "erl",
  ["eruby"] = "erb",
  ["faust"] = "lib",
  ["fennel"] = "fnl",
  ["fish"] = "fish",
  ["forth"] = "fs",
  ["fsharp"] = "fs",
  ["gdmo"] = "mo",
  ["gdresource"] = "tres",
  ["gdscript"] = "gd",
  ["git"] = "git",
  ["gitattributes"] = ".gitattributes",
  ["gitconfig"] = ".gitconfig",
  ["gitignore"] = ".gitignore",
  ["go"] = "go",
  ["haml"] = "haml",
  ["handlebars"] = "hbs",
  ["haskell"] = "hs",
  ["heex"] = "heex",
  ["hex"] = "hex",
  ["html"] = "html",
  ["http"] = "http",
  ["idlang"] = "pro",
  ["java"] = "java",
  ["javascript"] = "js",
  ["javascriptreact"] = "jsx",
  ["json"] = "json",
  ["julia"] = "jl",
  ["kotlin"] = "kt",
  ["leex"] = "leex",
  ["less"] = "less",
  ["lhaskell"] = "lhs",
  ["log"] = "log",
  ["lprolog"] = "sig",
  ["lua"] = "lua",
  ["make"] = "makefile",
  ["markdown"] = "markdown",
  ["mustache"] = "mustache",
  ["nim"] = "nim",
  ["nix"] = "nix",
  ["obj"] = "obj",
  ["ocaml"] = "ml",
  ["pdf"] = "pdf",
  ["perl"] = "pl",
  ["php"] = "php",
  ["plaintex"] = "tex",
  ["po"] = "pot",
  ["postscr"] = "ai",
  ["prisma"] = "prisma",
  ["ps1"] = "ps1",
  ["puppet"] = "pp",
  ["python"] = "py",
  ["r"] = "r",
  ["razor"] = "razor",
  ["rmd"] = "rmd",
  ["ruby"] = "rb",
  ["rust"] = "rs",
  ["sass"] = "sass",
  ["scala"] = "scala",
  ["scheme"] = "scm",
  ["scss"] = "scss",
  ["sh"] = "sh",
  ["sml"] = "sml",
  ["solidity"] = "sol",
  ["solution"] = "sln",
  ["sql"] = "sql",
  ["stp"] = "stp",
  ["stylus"] = "styl",
  ["svelte"] = "svelte",
  ["svg"] = "svg",
  ["swift"] = "swift",
  ["systemverilog"] = "sv",
  ["tads"] = "t",
  ["tcl"] = "tcl",
  ["text"] = "txt",
  ["toml"] = "toml",
  ["twig"] = "twig",
  ["typescript"] = "ts",
  ["typescriptreact"] = "tsx",
  ["typst"] = "typ",
  ["v"] = "v",
  ["verilog"] = "v",
  ["vhdl"] = "vhdl",
  ["vim"] = "vim",
  ["vue"] = "vue",
  ["xml"] = "xml",
  ["yaml"] = "yaml",
  ["zig"] = "zig",
  ["zsh"] = "zsh",
}


return {
  filetypes      = filetypes,
  icons          = icons,
}
