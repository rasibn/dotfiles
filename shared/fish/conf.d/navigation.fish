# Expand `...` -> ../.., `....` -> ../../.., etc.
# `--position anywhere` lets them expand as arguments (ls ...), not just commands.
abbr --add ... --position anywhere '../..'
abbr --add .... --position anywhere '../../..'
abbr --add ..... --position anywhere '../../../..'
abbr --add ...... --position anywhere '../../../../..'
