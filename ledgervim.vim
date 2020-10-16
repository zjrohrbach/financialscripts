"tell vim this is a ledger file
:set filetype=ledger
:comp ledger

"ledger-vim options
let g:ledger_extra_options = '--pedantic --explicit' 

"folding
:setlocal foldmethod=marker

"for aligning recently imported currency amounts
:nnoremap . :LedgerAlign<cr>j

"for changing the title of a transaction
:nnoremap , c$

"once you're happy with the title of the transaction, press <cr> to edit the
"expense account
    ":nnoremap <cr> j04lcf<space>
    "for when Expense line comes first
    :nnoremap <cr> jj04lc$
    "for when Expense line comes second

"when you're done entering the new expense account, press <cr> to align the
"currency and then continue
    ":inoremap <cr> <esc>:LedgerAlign<cr>/expenses\\|income<cr>kf<space>l 
    "for when Expense line comes first
    :inoremap <cr> <esc>j:LedgerAlign<cr>/expenses\\|income<cr>kkf<space>l 
    "for when Expense line comes second

"use ] and [ to move between transactions
:nnoremap ] /^\d<cr>11l
:nnoremap [ k?^\d<cr>11l

"easier access to omni-complete
:inoremap <tab> <c-x><c-o>

"have indentation match the indentation of hledger
:set sw=4

"map ; to :
:inoremap ; :
:inoremap : ;

"calling the bulk import
:command! -nargs=1 -complete=file BulkImport :mark r | exe 'r ! ~/.financialscripts/BulkImport.sh <args>' | :normal `r
:command! -nargs=1 -complete=file SpBulkImport :new | BulkImport <args>

"setting transactions as cleared
:nnoremap * :call ledger#transaction_state_set(line('.'), '*')<cr>

"abbreviations for quick compliling and checking
:inorea priunk account expenses:unknown<cr>account income:unknown<cr>

"Set Pound-Sign Headers---------------{{{

:function! PoundSigns() 
:	exe ":normal i;#############################################################"
:endfunction

:nnoremap ## O<esc>:call PoundSigns()<cr>jo<esc>:call PoundSigns()<cr><esc>k0i <esc>A <esc>:s/ /_/g<cr>:center 62<cr>:s/\t/        /g<cr>:s/ /#/g<cr>35A#<esc>062ld$:s/_/ /g<cr>0c ;<esc>j
"}}}

"Set Folding Headers--------------{{{

:nnoremap == $a------------------------------------------------------------------------------------------<esc>059ld$A{{{<esc>o<cr>;}}}<esc>k
"}}}

"Turning off mappings--------------{{{

:function! TurnOffMappings() 
:	nnoremap <cr> <cr>
:	inoremap <cr> <cr>
:	inoremap <tab> <tab>
:	inoremap ; ;
:	inoremap : :
:endfunction

:nnoremap <leader>em :call TurnOffMappings()<cr>
:nnoremap <leader>sm :source ~/.financialscripts/ledgervim.vim<cr>

"}}}
