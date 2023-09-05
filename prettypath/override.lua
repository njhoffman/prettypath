local icons =
  {
    --- custom icons ---
  ['rockspec'] = {
    icon = '',
    color = '#f34436',
    cterm_color = '203',
    name = 'rockspec',
  },
  ['mp3'] = {
    icon = '',
    color = '#404bad',
    cterm_color = '104',
    name = 'mp3',
  },
  ['m4a'] = {
    icon = '',
    color = '#804b4d',
    cterm_color = '216',
    name = 'm4a',
  },
  ['flac'] = {
    icon = '',
    color = '#408b8d',
    cterm_color = '36',
    name = 'flac',
  },
  ['wav'] = {
    icon = '',
    color = '#605BFD',
    cterm_color = '27',
    name = 'wav',
  },
  ['pgsql'] = {
    icon = '',
    color = '#dad8d8',
    cterm_color = '188',
    name = 'Sql',
  },
  ['Gemfile$'] = {
    icon = '',
    color = '#701516',
    name = 'Gemfile',
    cterm_color = '1',
  },
  ['txt'] = {
    icon = '',
    color = '#407b81',
    cterm_color = '36',
    name = 'Text.file',
  },
  ['dic'] = {
    icon = '',
    color = '#cbcb41',
    cterm_color = '142',
    name = 'Metafont',
  },
  ['socket'] = {
    icon = '',
    color = '#303588',
    cterm_color = '104',
    name = 'Socket',
  },
  ['service'] = {
    icon = '⏻',
    color = '#701588',
    cterm_color = '133',
    name = 'SystemD.Service',
  },
  ['Makefile'] = {
    icon = '',
    color = '#185abd',
    cterm_color = '31',
    name = 'Makefile',
  },
  ['Kconfig'] = {
    icon = '',
    cterm_color = '142',
    color = '#cbcb41',
    name = 'Kernel.config',
  },
  ['Kbuild'] = {
    icon = '',
    color = '#e37933',
    name = 'Kernel.compile',
    cterm_color = '208',
  },
  ['gz'] = {
    icon = '',
    color = '#6d80c6',
    cterm_color = '75',
    name = 'Gzip',
  },
  ['zip'] = {
    icon = '',
    color = '#6d8086',
    cterm_color = '240',
    name = 'Zip',
  },
  ['tar'] = {
    icon = '',
    color = '#9d8086',
    cterm_color = '104',
    name = 'Tar',
  },
  ['scm'] = {
    icon = '',
    color = '#27a79a',
    cterm_color = '36',
    name = 'Scm',
  },

  ['sh'] = {
    icon = '',
    color = '#27a79a',
    cterm_color = '36',
    name = 'Sh',
  },
  ['zsh'] = {
    icon = '',
    color = '#428850',
    cterm_color = '65',
    name = 'Zsh',
  },
}
    -- .jq, bz2, rst, README.*, .so, .lang, .cache
    --- override icons ---
    Brewfile = {
      color = '#701516',
      cterm_color = '1',
      icon = '',
      name = 'Brewfile',
    },
    COMMIT_EDITMSG = {
      color = '#41535b',
      cterm_color = '239',
      icon = '󰜙',
      name = 'GitCommit',
    },
    COPYING = {
      color = '#cbcb41',
      cterm_color = '185',
      icon = '',
      name = 'License',
    },
    Dockerfile = {
      color = '#0087c9',
      cterm_color = '32',
      icon = '',
      name = 'Dockerfile',
    },
    LICENSE = {
      color = '#ff5722',
      cterm_color = '202',
      icon = '',
      name = 'License',
    },
    Procfile = {
      color = '#a074c4',
      cterm_color = '140',
      icon = '',
      name = 'Procfile',
    },
    R = {
      color = '#358a5b',
      cterm_color = '65',
      icon = '',
      name = 'R',
    },
    Rmd = {
      color = '#519aba',
      cterm_color = '67',
      icon = '',
      name = 'Rmd',
    },
    ['.DS_Store'] = {
      color = '#41535b',
      cterm_color = '239',
      icon = '',
      name = 'DsStore',
    },
    ['.prettierrc.js'] = {
      color = '#ea5e5e',
      cterm_color = '167',
      icon = '󰏣',
      name = 'Prettier',
    },
    ['.prettierrc.json'] = {
      color = '#ea5e5e',
      cterm_color = '167',
      icon = '󰏣',
      name = 'Prettier',
    },
    ['.prettierrc.toml'] = {
      color = '#ea5e5e',
      cterm_color = '167',
      icon = '󰏣',
      name = 'Prettier',
    },
    ['.prettierrc.yaml'] = {
      color = '#ea5e5e',
      cterm_color = '167',
      icon = '󰏣',
      name = 'Prettier',
    },
    ['.prettierrc.yml'] = {
      color = '#ea5e5e',
      cterm_color = '167',
      icon = '󰏣',
      name = 'Prettier',
    },
    ['.svgrrc'] = {
      color = '#ffb300',
      cterm_color = '214',
      icon = '󰜈',
      name = 'Svgrrc',
    },
    ['CMakeLists.txt'] = {
      color = '#42a5f4',
      cterm_color = '66',
      icon = '',
      name = 'CMakeLists',
    },
    ['CONTRIBUTING.md'] = {
      color = '#ffca28',
      cterm_color = '220',
      icon = '󰅍',
      name = 'CONTRIBUTING.md',
    },
    ['COPYING.LESSER'] = {
      color = '#cbcb41',
      cterm_color = '185',
      icon = '',
      name = 'License',
    },
    ['Gemfile$'] = {
      color = '#701516',
      cterm_color = '1',
      icon = '',
      name = 'Gemfile',
    },
    ['README.md'] = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '',
      name = 'README.md',
    },
    ['Vagrantfile$'] = {
      color = '#1563FF',
      cterm_color = '27',
      icon = '',
      name = 'Vagrantfile',
    },
    ['babel.config.js'] = {
      color = '#fdd835',
      cterm_color = '221',
      icon = '',
      name = 'BabelConfig',
    },
    ['nuxt.config.js'] = {
      color = '#00e676',
      cterm_color = '42',
      icon = '󱄆',
      name = 'nuxt.config.js',
    },
    ['pug.config.js'] = {
      color = '#efcba3',
      cterm_color = '223',
      icon = '',
      name = 'pug',
    },
    ['pug.config.json'] = {
      color = '#efcba3',
      cterm_color = '223',
      icon = '',
      name = 'pug',
    },
    ['robots.txt'] = {
      color = '#ff5252',
      cterm_color = '203',
      icon = '󱙺',
      name = 'Robots',
    },
    ['vite.config.js'] = {
      color = '#ffab00',
      cterm_color = '214',
      icon = '󰉁',
      name = 'vite.config.js',
    },
    ['windi.config.js'] = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '󰖝',
      name = 'windi.config.js',
    },
    ['windi.config.ts'] = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '󰖝',
      name = 'windi.config.ts',
    },
    ['yarn-error.log'] = {
      color = '#0288d1',
      cterm_color = '32',
      icon = '',
      name = 'YarnError',
    },
    ['yarn.lock'] = {
      color = '#0288d1',
      cterm_color = '32',
      icon = '',
      name = 'YarnLock',
    },
    abc = {
      color = '#ff5722',
      cterm_color = '202',
      icon = '󰽰',
      name = 'Abc',
    },
    ada = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '󱗆',
      name = 'ada',
    },
    adb = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '󱗆',
      name = 'ada',
    },
    ads = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '󱗆',
      name = 'ada',
    },
    aea = {
      color = '#fe6e3f',
      cterm_color = '203',
      icon = '󰘨',
      name = 'aea',
    },
    agc = {
      color = '#fe6e3f',
      cterm_color = '203',
      icon = '󰘨',
      name = 'agc',
    },
    ags = {
      color = '#fe6e3f',
      cterm_color = '203',
      icon = '󰘨',
      name = 'ags',
    },
    ahk = {
      color = '#4caf50',
      cterm_color = '71',
      icon = '󰬏',
      name = 'ahk',
    },
    ali = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '󱗆',
      name = 'ada',
    },
    ami = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'ami',
    },
    amx = {
      color = '#ef6c00',
      cterm_color = '202',
      icon = '󰡙',
      name = 'amx',
    },
    apk = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '',
      name = 'apk',
    },
    apx = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'apx',
    },
    asc = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰌆',
      name = 'asc',
    },
    ase = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'ase',
    },
    asm = {
      color = '#ff6e40',
      cterm_color = '203',
      icon = '󰘨',
      name = 'Asm',
    },
    asp = {
      color = '#e44d27',
      cterm_color = '166',
      icon = '',
      name = 'asp',
    },
    avi = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'avi',
    },
    bas = {
      color = '#ab46bc',
      cterm_color = '133',
      icon = '󰘐',
      name = 'bas',
    },
    bf = {
      color = '#ff4081',
      cterm_color = '204',
      icon = '',
      name = 'Bf',
    },
    bin = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '',
      name = 'Bin',
    },
    bpg = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'bpg',
    },
    brk = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'brk',
    },
    brs = {
      color = '#ab46bc',
      cterm_color = '133',
      icon = '󰘐',
      name = 'brs',
    },
    cake = {
      color = '#ff7043',
      cterm_color = '203',
      icon = '',
      name = 'cake',
    },
    cbx = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'cbx',
    },
    cff = {
      color = '#ff5252',
      cterm_color = '203',
      icon = '󰧮',
      name = 'cff',
    },
    class = {
      color = '#1e88e5',
      cterm_color = '32',
      icon = '󰛊',
      name = 'JavaClass',
    },
    cls = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'cls',
    },
    cmx = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '',
      name = 'cmx',
    },
    cpt = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'cpt',
    },
    csl = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'csl',
    },
    csx = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '󰌛',
      name = 'csx',
    },
    ctp = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '󰌟',
      name = 'ctp',
    },
    cts = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '󰛦',
      name = 'cts',
    },
    ctx = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'ctx',
    },
    cuh = {
      color = '#76b900',
      cterm_color = '106',
      icon = '',
      name = 'cuh',
    },
    cur = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'cur',
    },
    dat = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '',
      name = 'Dat',
    },
    dds = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'dds',
    },
    deb = {
      color = '#ff0283',
      cterm_color = '198',
      icon = '',
      name = 'Deb',
    },
    dex = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '',
      name = 'dex',
    },
    djt = {
      color = '#43a047',
      cterm_color = '71',
      icon = '',
      name = 'djt',
    },
    dlc = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'dlc',
    },
    dll = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'dll',
    },
    dmn = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'dmn',
    },
    dng = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'dng',
    },
    dsc = {
      color = '#fed64e',
      cterm_color = '221',
      icon = '',
      name = 'dsc',
    },
    dtd = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'dtd',
    },
    dtx = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'dtx',
    },
    ent = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'ent',
    },
    eot = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'eot',
    },
    esp = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'esp',
    },
    esx = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '󰌞',
      name = 'esx',
    },
    exe = {
      color = '#e64a19',
      cterm_color = '166',
      icon = '',
      name = 'Exe',
    },
    exp = {
      color = '#fe7043',
      cterm_color = '203',
      icon = '',
      name = 'exp',
    },
    fbx = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'Fbx',
    },
    fen = {
      color = '#cfd8db',
      cterm_color = '188',
      icon = '󰡗',
      name = 'fen',
    },
    flv = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'flv',
    },
    fnt = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'fnt',
    },
    fpx = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'fpx',
    },
    gbr = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'gbr',
    },
    gcp = {
      color = '#f44336',
      cterm_color = '203',
      icon = '󱇶',
      name = 'google_cloud',
    },
    gemini = {
      color = '#81c784',
      cterm_color = '114',
      icon = '󰖟',
      name = 'gemini',
    },
    gmi = {
      color = '#81c784',
      cterm_color = '114',
      icon = '󰖟',
      name = 'gmi',
    },
    gmni = {
      color = '#81c784',
      cterm_color = '114',
      icon = '󰖟',
      name = 'gmni',
    },
    graphqls = {
      color = '#ec417a',
      cterm_color = '204',
      icon = '󰡷',
      name = 'graphql',
    },
    gyp = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'gyp',
    },
    har = {
      color = '#fbc02d',
      cterm_color = '214',
      icon = '󰘦',
      name = 'har',
    },
    hex = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '',
      name = 'Hex',
    },
    hjs = {
      color = '#fe7043',
      cterm_color = '203',
      icon = '󱗞',
      name = 'hjs',
    },
    http = {
      color = '#e53935',
      cterm_color = '167',
      icon = '󰖟',
      name = 'http',
    },
    ibc = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰛓',
      name = 'ibc',
    },
    ibs = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'ibs',
    },
    idr = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰛓',
      name = 'idr',
    },
    iml = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'iml',
    },
    inc = {
      color = '#fe6e3f',
      cterm_color = '203',
      icon = '󰘨',
      name = 'inc',
    },
    inl = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '',
      name = 'inl',
    },
    ino = {
      color = '#00979c',
      cterm_color = '31',
      icon = '',
      name = 'Arduino',
    },
    ipa = {
      color = '#cfd8db',
      cterm_color = '188',
      icon = '',
      name = 'ipa',
    },
    ipp = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '',
      name = 'ipp',
    },
    ipy = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'ipy',
    },
    iso = {
      color = '#b1bec5',
      cterm_color = '250',
      icon = '󰗮',
      name = 'iso',
    },
    ixx = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '',
      name = 'ixx',
    },
    jar = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰅶',
      name = 'Jar',
    },
    jav = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰅶',
      name = 'jav',
    },
    jmx = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'jmx',
    },
    jng = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'jng',
    },
    jsp = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰅶',
      name = 'jsp',
    },
    jxr = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'jxr',
    },
    key = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '󰌆',
      name = 'Key',
    },
    kra = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'kra',
    },
    lib = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '',
      name = 'Lib',
    },
    lol = {
      color = '#ee534f',
      cterm_color = '203',
      icon = '󰄛',
      name = 'lol',
    },
    ltx = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'ltx',
    },
    mak = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'mak',
    },
    mca = {
      color = '#4caf50',
      cterm_color = '71',
      icon = '󰍳',
      name = 'mca',
    },
    mcr = {
      color = '#4caf50',
      cterm_color = '71',
      icon = '󰍳',
      name = 'mcr',
    },
    mdb = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '',
      name = 'mdb',
    },
    mdp = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'mdp',
    },
    mii = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '',
      name = 'mii',
    },
    mkd = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'mkd',
    },
    mkv = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'mkv',
    },
    mod = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'mod',
    },
    mov = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'mov',
    },
    mp3 = {
      color = '#ee534f',
      cterm_color = '203',
      icon = '󰎆',
      name = 'Mp3',
    },
    mp4 = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'Mp4',
    },
    mpe = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'mpe',
    },
    mpg = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'mpg',
    },
    mpv = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'mpv',
    },
    mqo = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'mqo',
    },
    mrf = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'mrf',
    },
    msi = {
      color = '#e64a19',
      cterm_color = '166',
      icon = '',
      name = 'msi',
    },
    mts = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '󰛦',
      name = 'mts',
    },
    mus = {
      color = '#4caf50',
      cterm_color = '71',
      icon = '󰍳',
      name = 'mus',
    },
    njk = {
      color = '#388e3c',
      cterm_color = '65',
      icon = '',
      name = 'njk',
    },
    nqp = {
      color = '#9575cd',
      cterm_color = '104',
      icon = '',
      name = 'nqp',
    },
    ntf = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'ntf',
    },
    obj = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'Obj',
    },
    odp = {
      color = '#d04423',
      cterm_color = '166',
      icon = '󰈧',
      name = 'odp',
    },
    ods = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈛',
      name = 'ods',
    },
    odt = {
      color = '#00589b',
      cterm_color = '25',
      icon = '󰈬',
      name = 'odt',
    },
    ogg = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'ogg',
    },
    ogv = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'ogv',
    },
    ora = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'ora',
    },
    owl = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'owl',
    },
    p = {
      color = '#e4b854',
      cterm_color = '179',
      icon = '󰏒',
      name = 'P',
    },
    pac = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '󰌞',
      name = 'pac',
    },
    pas = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '󰏣',
      name = 'pas',
    },
    pbm = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pbm',
    },
    pdb = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '',
      name = 'pdb',
    },
    pdn = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pdn',
    },
    pem = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰌆',
      name = 'pem',
    },
    pgf = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pgf',
    },
    pgm = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pgm',
    },
    pgn = {
      color = '#cfd8db',
      cterm_color = '188',
      icon = '󰡗',
      name = 'pgn',
    },
    pic = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pic',
    },
    pkb = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '',
      name = 'pkb',
    },
    pks = {
      color = '#ffc927',
      cterm_color = '220',
      icon = '',
      name = 'pks',
    },
    pmd = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'pmd',
    },
    pmx = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'pmx',
    },
    pnm = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'pnm',
    },
    pod = {
      color = '#9575cd',
      cterm_color = '104',
      icon = '',
      name = 'pod',
    },
    pot = {
      color = '#7985cb',
      cterm_color = '104',
      icon = '󰗊',
      name = 'pot',
    },
    ppa = {
      color = '#d04423',
      cterm_color = '166',
      icon = '󰈧',
      name = 'ppa',
    },
    ppm = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'ppm',
    },
    pptx = {
      color = '#d14524',
      cterm_color = '166',
      icon = '',
      name = 'Pptx',
    },
    psv = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈛',
      name = 'psv',
    },
    pub = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰌆',
      name = 'pub',
    },
    pwn = {
      color = '#ef6c00',
      cterm_color = '202',
      icon = '󰡙',
      name = 'pwn',
    },
    pyi = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'pyi',
    },
    pyt = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'pyt',
    },
    pyw = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'pyw',
    },
    rar = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '󰗄',
      name = 'Rar',
    },
    raw = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'raw',
    },
    razor = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '',
      name = 'razor',
    },
    rbi = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰴭',
      name = 'rbi',
    },
    rbs = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰴭',
      name = 'rbs',
    },
    rbx = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰴭',
      name = 'rbx',
    },
    rdf = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'rdf',
    },
    reb = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'reb',
    },
    rei = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'rei',
    },
    rjs = {
      color = '#f34436',
      cterm_color = '203',
      icon = '󰴭',
      name = 'rjs',
    },
    rng = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'rng',
    },
    robot = {
      color = '#00bfa5',
      cterm_color = '37',
      icon = '󰚩',
      name = 'Robot',
    },
    ron = {
      color = '#ff7043',
      cterm_color = '203',
      icon = '',
      name = 'ron',
    },
    rpm = {
      color = '#f44336',
      cterm_color = '203',
      icon = '',
      name = 'Rpm',
    },
    rpy = {
      color = '#fdd736',
      cterm_color = '221',
      icon = '',
      name = 'rpy',
    },
    rst = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'rst',
    },
    rtf = {
      color = '#89e051',
      cterm_color = '113',
      icon = '󰈙',
      name = 'Rtf',
    },
    sai = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'sai',
    },
    sc = {
      color = '#f44336',
      cterm_color = '203',
      icon = '',
      name = 'sc',
    },
    skp = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'skp',
    },
    stl = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'stl',
    },
    stp = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'stp',
    },
    sty = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'sty',
    },
    sui = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'sui',
    },
    svx = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'svx',
    },
    tab = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈛',
      name = 'tab',
    },
    tar = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '󰗄',
      name = 'tar',
    },
    tcc = {
      color = '#0277bd',
      cterm_color = '31',
      icon = '',
      name = 'tcc',
    },
    tga = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'tga',
    },
    tgz = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '󰗄',
      name = 'tgz',
    },
    tif = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'Tif',
    },
    tiff = {
      color = '#26a69a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'Tiff',
    },
    tld = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'tld',
    },
    tmx = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'tmx',
    },
    todo = {
      color = '#7cb342',
      cterm_color = '107',
      icon = '',
      name = 'todo',
    },
    tsv = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈛',
      name = 'tsv',
    },
    ttc = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'ttc',
    },
    ttf = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'Ttf',
    },
    txx = {
      color = '#0188d1',
      cterm_color = '32',
      icon = '',
      name = 'txx',
    },
    txz = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '󰗄',
      name = 'txz',
    },
    typ = {
      color = '#0097a6',
      cterm_color = '31',
      icon = '',
      name = 'typ',
    },
    url = {
      color = '#42a5f4',
      cterm_color = '75',
      icon = '',
      name = 'url',
    },
    vac = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'vac',
    },
    vba = {
      color = '#ab46bc',
      cterm_color = '133',
      icon = '󰘐',
      name = 'vba',
    },
    vbs = {
      color = '#ab46bc',
      cterm_color = '133',
      icon = '󰘐',
      name = 'vbs',
    },
    vdi = {
      color = '#069ce5',
      cterm_color = '38',
      icon = '',
      name = 'vdi',
    },
    vdp = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'vdp',
    },
    vob = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'vob',
    },
    vox = {
      color = '#2cb5f6',
      cterm_color = '39',
      icon = '',
      name = 'vox',
    },
    wav = {
      color = '#ee534f',
      cterm_color = '203',
      icon = '󰈣',
      name = 'Wav',
    },
    wma = {
      color = '#ee534f',
      cterm_color = '203',
      icon = '󰎆',
      name = 'wma',
    },
    wmv = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'wmv',
    },
    woff = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'WebOpenFontFormat',
    },
    woff2 = {
      color = '#f34436',
      cterm_color = '203',
      icon = '',
      name = 'WebOpenFontFormat',
    },
    wxi = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'wxi',
    },
    wxl = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'wxl',
    },
    wxs = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'wxs',
    },
    xaml = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '󰙳',
      name = 'xaml',
    },
    xbl = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'xbl',
    },
    xcf = {
      color = '#27a79a',
      cterm_color = '36',
      icon = '󰈟',
      name = 'xcf',
    },
    xht = {
      color = '#e44d27',
      cterm_color = '166',
      icon = '',
      name = 'xht',
    },
    xib = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'xib',
    },
    xlf = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'xlf',
    },
    xsd = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'xsd',
    },
    xsl = {
      color = '#8bc34a',
      cterm_color = '113',
      icon = '󰈮',
      name = 'xsl',
    },
    xz = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '',
      name = 'Xz',
    },
    yang = {
      color = '#42a5f5',
      cterm_color = '75',
      icon = '󰚀',
      name = 'Yang',
    },
    yuv = {
      color = '#ff9800',
      cterm_color = '208',
      icon = '󰎁',
      name = 'yuv',
    },
    zip = {
      color = '#afb42b',
      cterm_color = '142',
      icon = '',
      name = 'Zip',
    },
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

return {
  icons = icons,
}
