local icons = {
  ["mp3"] = {
    icon = " ",
    color = "#404bad",
    name = "mp3",
    double = true,
  },
  ["m4a"] = {
    icon = " ",
    color = "#804b4d",
    name = "m4a",
    double = true,
  },
  ["flac"] = {
    icon = " ",
    color = "#408b8d",
    name = "flac",
    double = true,
  },
  ["wav"] = {
    icon = " ",
    color = "#605BFD",
    name = "wav",
    double = true,
  },
  ["pgsql"] = {
    icon = "",
    color = "#dad8d8",
    name = "Sql",
  },
  ["Gemfile$"] = {
    icon = " ",
    color = "#701516",
    name = "Gemfile",
    double = true,
  },
  ["txt"] = {
    icon = " ",
    color = "#407b81",
    name = "Text file",
    double = true,
  },
  ["dic"] = {
    icon = " ",
    color = "#cbcb41",
    name = "Metafont",
    double = true,
  },
  ["socket"] = {
    icon = "",
    color = "#303588",
    name = "Socket",
    double = true,
  },
  ["service"] = {
    icon = "⏻",
    color = "#701588",
    name = "SystemD Service",
    double = true,
  },
  ["Makefile"] = {
    icon = "",
    color = "#185abd",
    name = "Makefile",
  },
  ["Kconfig"] = {
    icon = "",
    color = "#cbcb41",
    name = "Kernel config",
  },
  ["Kbuild"] = {
    icon = "",
    color = "#e37933",
    name = "Kernel compile",
  },
  ["gz"] = {
    icon = "",
    color = "#6d80c6",
    name = "Gzip",
  },
  ["zip"] = {
    icon = "",
    color = "#6d8086",
    name = "Zip",
  },
  ["tar"] = {
    icon = "",
    color = "#9d8086",
    name = "Tar",
  },
  -- bz2, rst, README.*, .so, .lang, .cache

  -- ["gruntfile"] = {
  --   icon = "",
  --   color = "#e37933",
  --   name = "Gruntfile"
  -- },
  -- ["gulpfile"] = {
  --   icon = "",
  --   color = "#cc3e44",
  --   name = "Gulpfile"
  -- },
  -- ["dropbox"] = {
  --   icon = "",
  --   color = "#0061FE",
  --   name = "Dropbox"
  -- },
  -- ["xls"] = {
  --   icon = "",
  --   color = "#207245",
  --   name = "Xls"
  -- },
  -- ["doc"] = {
  --   icon = "",
  --   color = "#185abd",
  --   name = "Doc"
  -- },
  -- ["ppt"] = {
  --   icon = "",
  --   color = "#cb4a32",
  --   name = "Ppt"
  -- },
  -- ["xml"] = {
  --   icon = "謹",
  --   color = "#e37933",
  --   name = "Xml"
  -- },
  -- ["webpack"] = {
  --   icon = "ﰩ",
  --   color = "#519aba",
  --   name = "Webpack"
  -- },
  -- [".settings.json"] = {
  --   icon = "",
  --   color = "#854CC7",
  --   name = "SettingsJson"
  -- },
  -- ["cs"] = {
  --   icon = "",
  --   color = "#596706",
  --   name = "Cs"
  -- },
  -- ["procfile"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Procfile"
  -- },
  -- [".bashprofile"] = {
  --   icon = "",
  --   color = "#89e051",
  --   name = "BashProfile"
  -- },
  -- [".bashrc"] = {
  --   icon = "",
  --   color = "#89e051",
  --   name = "Bashrc"
  -- },
  -- [".babelrc"] = {
  --   icon = "ﬥ",
  --   color = "#cbcb41",
  --   name = "Babelrc"
  -- },
  -- [".ds_store"] = {
  --   icon = "",
  --   color = "#41535b",
  --   name = "DsStore"
  -- },
  -- ["COMMIT_EDITMSG"] = {
  --   icon = "",
  --   color = "#41535b",
  --   name = "GitCommit"
  -- },
  -- [".gitlab-ci.yml"] = {
  --   icon = "",
  --   color = "#e24329",
  --   name = "GitlabCI"
  -- },
  -- ["Vagrantfile$"] = {
  --   icon = "",
  --   color = "#1563FF",
  --   name = "Vagrantfile"
  -- },
  -- ["_gvimrc"] = {
  --   icon = "",
  --   color = "#019833",
  --   name = "Gvimrc"
  -- },
  -- ["_vimrc"] = {
  --   icon = "",
  --   color = "#019833",
  --   name = "Vimrc"
  -- },
  -- ["ai"] = {
  --   icon = "",
  --   color = "#cbcb41",
  --   name = "Ai"
  -- },
  -- ["awk"] = {
  --   icon = "",
  --   color = "#4d5a5e",
  --   name = "Awk"
  -- },
  -- ["bat"] = {
  --   icon = "",
  --   color = "#C1F12E",
  --   name = "Bat"
  -- },
  -- ["bmp"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Bmp"
  -- },
  -- ["clj"] = {
  --   icon = "",
  --   color = "#8dc149",
  --   name = "Clojure"
  -- },
  -- ["cljc"] = {
  --   icon = "",
  --   color = "#8dc149",
  --   name = "ClojureC"
  -- },
  -- ["cljs"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "ClojureJS"
  -- },
  -- ["cmakelists.txt"] = {
  --   icon = "",
  --   color = "#6d8086",
  --   name = "CmakeLists"
  -- },
  -- ["coffee"] = {
  --   icon = "",
  --   color = "#cbcb41",
  --   name = "Coffee"
  -- },
  -- ["config.ru"] = {
  --   icon = "",
  --   color = "#701516",
  --   name = "ConfigRu"
  -- },
  -- ["csh"] = {
  --   icon = "",
  --   color = "#4d5a5e",
  --   name = "Csh"
  -- },
  -- ["cxx"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Cxx"
  -- },
  -- ["d"] = {
  --   icon = "",
  --   color = "#427819",
  --   name = "D"
  -- },
  -- ["diff"] = {
  --   icon = "",
  --   color = "#41535b",
  --   name = "Diff"
  -- },
  -- ["dump"] = {
  --   icon = "",
  --   color = "#dad8d8",
  --   name = "Dump"
  -- },
  -- ["edn"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Edn"
  -- },
  -- ["eex"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Eex"
  -- },
  -- ["ejs"] = {
  --   icon = "",
  --   color = "#cbcb41",
  --   name = "Ejs"
  -- },
  -- ["elm"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Elm"
  -- },
  -- ["erl"] = {
  --   icon = "",
  --   color = "#B83998",
  --   name = "Erl"
  -- },
  -- ["ex"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Ex"
  -- },
  -- ["exs"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Exs"
  -- },
  -- ["f#"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Fsharp"
  -- },
  -- ["favicon.ico"] = {
  --   icon = "",
  --   color = "#cbcb41",
  --   name = "Favicon"
  -- },
  -- ["fs"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Fs"
  -- },
  -- ["fsi"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Fsi"
  -- },
  -- ["fsscript"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Fsscript"
  -- },
  -- ["fsx"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Fsx"
  -- },
  -- ["gemspec"] = {
  --   icon = "",
  --   color = "#701516",
  --   name = "Gemspec"
  -- },
  -- ["gif"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Gif"
  -- },
  -- ["h"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "H"
  -- },
  -- ["haml"] = {
  --   icon = "",
  --   color = "#eaeae1",
  --   name = "Haml"
  -- },
  -- ["hbs"] = {
  --   icon = "",
  --   color = "#f0772b",
  --   name = "Hbs"
  -- },
  -- ["hh"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Hh"
  -- },
  -- ["hpp"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Hpp"
  -- },
  -- ["hrl"] = {
  --   icon = "",
  --   color = "#B83998",
  --   name = "Hrl"
  -- },
  -- ["hs"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Hs"
  -- },
  -- ["hxx"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Hxx"
  -- },
  -- ["ini"] = {
  --   icon = "",
  --   color = "#6d8086",
  --   name = "Ini"
  -- },
  -- ["jl"] = {
  --   icon = "",
  --   color = "#a270ba",
  --   name = "Jl"
  -- },
  -- ["ksh"] = {
  --   icon = "",
  --   color = "#4d5a5e",
  --   name = "Ksh"
  -- },
  -- ["leex"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Leex"
  -- },
  -- ["less"] = {
  --   icon = "",
  --   color = "#563d7c",
  --   name = "Less"
  -- },
  -- ["lhs"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "Lhs"
  -- },
  -- ["mix.lock"] = {
  --   icon = "",
  --   color = "#a074c4",
  --   name = "MixLock"
  -- },
  -- ["mjs"] = {
  --   icon = "",
  --   color = "#f1e05a",
  --   name = "Mjs"
  -- },
  -- ["ml"] = {
  --   icon = "λ",
  --   color = "#e37933",
  --   name = "Ml"
  -- },
  -- ["mli"] = {
  --   icon = "λ",
  --   color = "#e37933",
  --   name = "Mli"
  -- },
  -- ["mustache"] = {
  --   icon = "",
  --   color = "#e37933",
  --   name = "Mustache"
  -- },
  -- ["nix"] = {
  --   icon = "",
  --   color = "#7ebae4",
  --   name = "Nix"
  -- },
  -- ["pm"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Pm"
  -- },
  -- ["pp"] = {
  --   icon = "",
  --   color = "#302B6D",
  --   name = "Pp"
  -- },
  -- ["ps1"] = {
  --   icon = "",
  --   color = "#4d5a5e",
  --   name = "PromptPs1"
  -- },
  -- ["psb"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Psb"
  -- },
  -- ["psd"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Psd"
  -- },
  -- ["rlib"] = {
  --   icon = "",
  --   color = "#dea584",
  --   name = "Rlib"
  -- },
  -- ["rmd"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Rmd"
  -- },
  -- ["rproj"] = {
  --   icon = "鉶",
  --   color = "#358a5b",
  --   name = "Rproj"
  -- },
  -- ["sass"] = {
  --   icon = "",
  --   color = "#f55385",
  --   name = "Sass"
  -- },
  -- ["scss"] = {
  --   icon = "",
  --   color = "#f55385",
  --   name = "Scss"
  -- },
  -- ["slim"] = {
  --   icon = "",
  --   color = "#e34c26",
  --   name = "Slim"
  -- },
  -- ["sln"] = {
  --   icon = "",
  --   color = "#854CC7",
  --   name = "Sln"
  -- },
  -- ["styl"] = {
  --   icon = "",
  --   color = "#8dc149",
  --   name = "Styl"
  -- },
  -- ["suo"] = {
  --   icon = "",
  --   color = "#854CC7",
  --   name = "Suo"
  -- },
  -- ["t"] = {
  --   icon = "",
  --   color = "#519aba",
  --   name = "Tor"
  -- },
  -- ["tex"] = {
  --   icon = "ﭨ",
  --   color = "#3D6117",
  --   name = "Tex"
  -- },
  -- ["twig"] = {
  --   icon = "",
  --   color = "#8dc149",
  --   name = "Twig"
  -- },
  -- ["webmanifest"] = {
  --   icon = "",
  --   color = "#f1e05a",
  --   name = "Webmanifest"
  -- },
  -- ["xcplayground"] = {
  --   icon = "",
  --   color = "#e37933",
  --   name = "XcPlayground"
  -- },
  -- ["xul"] = {
  --   icon = "",
  --   color = "#e37933",
  --   name = "Xul"
  -- },
  -- ["pdf"] = {
  --   icon = "",
  --   color = "#b30b00",
  --   name = "Pdf"
  -- },
  -- ["kt"] = {
  --   icon = "𝙆",
  --   color = "#F88A02",
  --   name = "Kotlin"
  -- }
}

return { icons = icons }
