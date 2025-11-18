" Vim syntax file for YAML with Jinja2 templates
" Language: YAML with Jinja2
" Maintainer: Custom

if exists("b:current_syntax")
  finish
endif

" Load YAML syntax first
runtime! syntax/yaml.vim
unlet! b:current_syntax

" Load Jinja2 syntax
runtime! syntax/jinja.vim
unlet! b:current_syntax

let b:current_syntax = "yaml_jinja2"
