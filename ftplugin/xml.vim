" XML-specific vimscript

" entities
imap <leader>> &gt;
imap <leader>< &lt;

"=============docbook map=============

" header
" plugin/xml.vim will add '<?xml version="1.0" encoding="utf-8"?>' automatically
 
imap <leader>art <article xmlns="http://docbook.org/ns/docbook" version="5.0" xml:lang="zh-CN"<CR>
            \xmlns:xlink="http://www.w3.org/1999/xlink"><CR></article><ESC>O
imap <leader>bk <book xmlns="http://docbook.org/ns/docbook" version="5.0" xml:lang="zh-CN"<CR>
            \xmlns:xlink="http://www.w3.org/1999/xlink"><CR></book><ESC>O



" skip ahead to after next tag without leaving insert mode
imap <leader>e <ESC>/><CR>:nohlsearch<CR>a

" common tags that start a new text block
imap<leader>s <section><CR></section><ESC>O
"imap<leader>sn <section id=""><CR><para><ESC>jo</section><ESC>O
imap<leader>sn  <section><CR><para></para><CR></section><ESC>k0f>a
imap<leader>p <para><CR></para><ESC>O
imap<leader>il <itemizedlist><CR></itemizedlist><ESC>O
imap<leader>ol <orderedlist><CR></orderedlist><ESC>O
imap<leader>li <listitem><CR></listitem><ESC>O
imap<leader>i <info><CR></info><ESC>O
imap<leader>eg <epigraph><CR></epigraph><ESC>O
imap<leader>bq <blockquote><CR></blockquote><ESC>O
imap<leader>fg <figure><CR></figure><ESC>O
imap<leader>mo <mediaobject><CR></mediaobject><ESC>O
imap<leader>io <imageobject><CR></imageobject><ESC>O
imap<leader>to <textobject><CR></textobject><ESC>O
imap<leader>eg <example><CR></example><ESC>O
imap<leader>ieg <informalexample><CR></informalexample><ESC>O
imap<leader>eq <equation><CR></equation><ESC>O
imap<leader>pl <programlisting><![CDATA[<CR>]]></programlisting><ESC>O<ESC>0i
imap<leader>sc <screen><![CDATA[<CR>]]></screen><ESC>O<ESC>0i
imap<leader>tbl <table><CR></table><ESC>O
imap<leader>th <thead><CR></thead><ESC>O
imap<leader>tb <tbody><CR></tbody><ESC>O
imap<leader>tf <tfoot><CR></tfoot><ESC>O
imap<leader>tr <tr><CR></tr><ESC>O
imap<leader>tg <tgroup cols=""><CR></tgroup><ESC>O
imap<leader>row <row><CR></row><ESC>O

" common tags that are placed inline
" use <ESC>F>a
imap<leader>td <td></td><ESC>F>a
imap<leader>ent <entry></entry><ESC>F>a
imap<leader>sp <simpara></simpara><ESC>F>a
imap<leader>cd <code></code><ESC>F>a
imap<leader>phr <phrase></phrase><ESC>F>a
imap<leader>mph <mathphrase></mathphrase><ESC>F>a
imap<leader>t <title></title><ESC>F>a
imap<leader>st <subtitle></subtitle><ESC>F>a
imap<leader>em <emphasis></emphasis><ESC>F>a
imap<leader>str <emphasis role="strong"></emphasis><ESC>F>a
imap<leader>tm <emphasis role="term"></emphasis><ESC>F>a
imap<leader>as <abstract></abstract><ESC>F>a
imap<leader>kw <keyword></keyword><ESC>F>a
imap<leader>sup <superscript></superscript><ESC>F>a
imap<leader>sub <subscript></subscript><ESC>F>a
imap<leader>lt <literal></literal><ESC>F>a
"imap<leader>ul <ulink url=""></ulink><ESC>F>a
imap<leader>lx <link xlink:href=""></link><ESC>F>a
imap<leader>ln <link linkend=""></link><ESC>F>a
imap<leader>l1 <link linkend="note1"><superscript>[1]</superscript></link>
imap<leader>l2 <link linkend="note2"><superscript>[2]</superscript></link>
imap<leader>l3 <link linkend="note3"><superscript>[3]</superscript></link>
imap<leader>l4 <link linkend="note4"><superscript>[4]</superscript></link>
imap<leader>l5 <link linkend="note5"><superscript>[5]</superscript></link>
imap<leader>l6 <link linkend="note6"><superscript>[6]</superscript></link>
imap<leader>l7 <link linkend="note7"><superscript>[7]</superscript></link>
imap<leader>l8 <link linkend="note8"><superscript>[8]</superscript></link>
imap<leader>l9 <link linkend="note9"><superscript>[9]</superscript></link>
imap<leader>imd <imagedata fileref="" /><ESC>F"i
imap<leader>cm <command></command><ESC>F>a
imap<leader>pm <parameter></parameter><ESC>F>a
imap<leader>ieq <inlineequation></inlineequation><ESC>F>a
imap<leader>fi <filename></filename><ESC>F>a

imap<leader>en <envar></envar><ESC>F>a
imap<leader>re <replaceable></replaceable><ESC>F>a
imap<leader>ui <userinput></userinput><ESC>F>a
imap<leader>si <systemitem></systemitem><ESC>F>a
imap<leader>us <systemitem class="username"></systemitem><ESC>F>a
imap<leader>sy <systemitem class="systemname"></systemitem><ESC>F>a
