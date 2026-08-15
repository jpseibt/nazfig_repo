" Vim syntax file
" Language:    Memvwr
" Maintainer:  J. Paulo Seibt <jpseibt@gmail.com>
" Last Change: 2026 Aug 15

" quit when a syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match memvwrAddr         "^0x[a-z0-9]\{16}\>:"
syn match memvwrByteValDec   " \zs[ 0-9]\{2}[0-9]\>\ze "
syn match memvwrByteValHex   " \zs\<[a-f0-9]\{2}\>\ze "
syn match memvwrByteValBin   " \zs\<[0-1]\{8}\>\ze "
syn match memvwrByteValFall  " \zs\<0x[a-f0-9]\{2}\>\ze "
syn match memvwrAsciiPreview "  \zs\S\+\s*$"

hi def link memvwrAddr         Number
hi def link memvwrByteValDec   CursorLine
hi def link memvwrByteValHex   CursorLine
hi def link memvwrByteValBin   CursorLine
hi def link memvwrByteValFall  CursorLine
hi def link memvwrAsciiPreview Character

let b:current_syntax = 'memvwr'

let &cpo = s:cpo_save
unlet s:cpo_save
