" C/C++-specific vimscript

" Define some abbreviations to draw comments.
ia #d   #define
ia #i   #include
ia #b         /********************************************************
ia #m   <Space>*                                                      *
ia #e   <Space>********************************************************/ 
ia #l         /*------------------------------------------------------*/ 

set si           "smart indent

set fdm=syntax   "fold based on syntax

"set fo=croql
set cindent
set comments=sr:/*,mb:*,ex:*/,://

let c_space_errors = 1 " show redundant spaces
