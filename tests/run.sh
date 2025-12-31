#!/bin/bash

fzf_cmd='fzf --with-nth=2.. --nth=2 --delimiter=" " --accept-nth=1'

cat all-score.txt | sort -rn | ../bin/prettypath.lua --format='%path% %score% %icon% %dir%%name%' | ${fzf_cmd}
cat file-score.txt | sort -rn | ../bin/prettypath.lua --format='%path% %score% %icon% %dir%%name%' | ${fzf_cmd}
cat dir-score.txt | sort -rn | ../bin/prettypath.lua --format='%path% %score% %icon% %dir%%name%' | ${fzf_cmd}

cat all.txt | sort -rn | ../bin/prettypath.lua --format='%path% %icon% %dir%%name%' | ${fzf_cmd}
cat file.txt | sort -rn | ../bin/prettypath.lua --format='%path% %icon% %dir%%name%' | ${fzf_cmd}
cat dir.txt | sort -rn | ../bin/prettypath.lua --format='%path% %icon% %dir%%name%' | ${fzf_cmd}
