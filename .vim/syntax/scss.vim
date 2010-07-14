" Vim syntax file
" Language:     Scss
" Maintainer:   
" Filenames:    *.scss

if exists("b:current_syntax")
  finish
endif

runtime! syntax/css.vim

syn case ignore

syn cluster scssCssProperties contains=cssFontProp,cssFontDescriptorProp,cssColorProp,cssTextProp,cssBoxProp,cssGeneratedContentProp,cssPagingProp,cssUIProp,cssRenderProp,cssAuralProp,cssTableProp
syn cluster scssCssAttributes contains=css.*Attr,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssRenderProp,scssComment
syn cluster scssValue contains=cssValue.*,cssColor,cssUrl,cssStringQ,cssStringQQ,scssVariable

syn cluster scssDefinitionItems contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssTagName,cssPseudoClass,scssDefinition,scssInclude,scssExtend,scssControlLine,scssInterpolation,scssMixing,scssCssComment,scssComment,scssEscape,scssIdChar,scssId,scssClassChar,scssClass,scssAmpersand,scssProperty,scssVariable,scssVariableAssignment
syn region scssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=@scssDefinitionItems fold

syn match scssProperty "\s\%([[:alnum:]-]\+:\|:[[:alnum:]-]\+\)"hs=s+1 contains=css.*Prop skipwhite nextgroup=scssDefinition,scssCssAttribute
syn match scssProperty "\s\%(:\=[[:alnum:]-]\+\s*=\)"hs=s+1 contains=css.*Prop skipwhite nextgroup=scssScript
syn cluster scssAttributeItems contains=@scssCssAttributes,scssVariable,scssInterpolation,@scssFunction,scssDefinition,scssDefault
"syn match scssCssAttribute ".\{-}\ze}" contained contains=@scssAttributeItems
syn match scssCssAttribute ".\{-}\(;\|$\)" contained contains=@scssAttributeItems
syn match scssScript ".\{-};" contained contains=@scssCssAttributes,scssVariable,scssInterpolation,@scssFunction,scssDefault
syn match scssVariable "[$][[:alnum:]_-]\+" nextgroup=scssVariableAssignment skipwhite
syn match scssVariableAssignment "\%([$][[:alnum:]_-]\+\s*\)\@<=\%(||\)\=:" skipwhite nextgroup=scssScript

syn match scssRgbFunction "\<\%(rgb\|rgba\|red\|green\|blue\|mix\)\>(\@=" contained nextgroup=scssFunctionArgs
syn match scssHslFunction "\<\%(hsl\|hsla\|hue\|saturation\|lightness\|adjust-hue\|lighten\|darken\|saturate\|desaturate\|grayscale\|complement\)\>(\@=" contained nextgroup=scssFunctionArgs
syn match scssOpacityFunction "\<\%(alpha\|opacity\|opacify\|fade-in\|transparentize\|fade-out\)\>(\@=" contained nextgroup=scssFunctionArgs
syn match scssStringFunction "\<\%(unquote\|quote\)\>(\@=" contained nextgroup=scssFunctionArgs
syn match scssNumberFunction "\<\%(percentage\|round\|ceil\|floor\|abs\)\>(\@=" contained nextgroup=scssFunctionArgs
syn match scssIntrospectionFunction "\<\%(type_of\|unit\|unitless\|comparable\)\>(\@=" contained nextgroup=scssFunctionArgs
syn cluster scssFunction contains=scss.\+Function
syn region scssFunctionArgs start="(" end=")" contained contains=@scssValue,@scssFunction

syn match scssMixin  "^\s*=\ze[[:alnum:]_-]\+" nextgroup=scssMixinName
syn match scssMixin "^\s*@mixin" nextgroup=scssMixinName skipwhite
syn match scssMixinName "[[:alnum:]_-]\+" contained nextgroup=scssDefinition,scssMixinArgs
syn region scssMixinArgs matchgroup=scssMixingArgsDelimiter start="(" end=")" contained contains=@scssValue nextgroup=scssDefinition
syn match scssInclude "+" nextgroup=scssMixinName
syn match scssInclude "@include" nextgroup=scssMixinName skipwhite
syn match scssExtend "@extend" skipwhite nextgroup=cssTagName,cssPseudoClass,scssIdChar,scssClassChar

syn match scssDefault contained "!\s*default\>"

syn match scssEscape     "^\s*\zs\\"
syn match scssIdChar     "#[[:alnum:]_-]\@=" nextgroup=scssId
syn match scssId         "[[:alnum:]_-]\+" contained
syn match scssClassChar  "\.[[:alnum:]_-]\@=" nextgroup=scssClass
syn match scssClass      "[[:alnum:]_-]\+" contained
syn match scssAmpersand  "&" nextgroup=cssPseudoClass

" TODO: Attribute namespaces
" TODO: Arithmetic (including strings and concatenation)

syn region scssInclude start="@import" end=";\|$" contains=cssComment,cssURL,cssUnicodeEscape,cssMediaType
syn match scssWarn "@warn"
syn region scssDebugLine matchgroup=scssDebug start="@debug\>" end="$" end=";"he=s-1 contains=@scssCssAttributes,scssVariable
syn region scssControlLine matchgroup=scssControl start="@\%(if\|else\%(\s\+if\)\=\|while\|for\)\>" end="{"re=e-1,me=e-1 end="$" contains=scssFor,@scssCssAttributes,scssVariable nextgroup=scssDefinition
syn keyword scssFor from to through contained

syn region scssInterpolation matchgroup=scssInterpolationDelimiter start="#{" end="}" contains=@scssValue containedin=cssStringQQ,cssStringQ

syn keyword scssTodo        FIXME NOTE TODO OPTIMIZE XXX contained
syn match   scssComment     "//.*$" contains=scssTodo
syn region  scssCssComment  start="^\z(\s*\)/\*" end="^\%(\z1 \)\@!" contains=scssTodo

hi def link scssCssComment              scssComment
hi def link scssComment                 Comment
hi def link scssVariable                Identifier
hi def link scssMixin                   Macro
hi def link scssMixinName               Function
hi def link scssMixing                  Macro
hi def link scssTodo                    Todo
hi def link scssExtend                  Include
hi def link scssInclude                 Include
hi def link scssDebug                   Debug
hi def link scssControl                 Conditional
hi def link scssFor                     Repeat
hi def link scssEscape                  Special
hi def link scssIdChar                  Special
hi def link scssClassChar               Special
hi def link scssDefault                 cssImportant
hi def link scssInterpolationDelimiter  Delimiter
hi def link scssAmpersand               SpecialChar
hi def link scssId                      Identifier
hi def link scssClass                   Type
hi def link scssRgbFunction             scssFunction
hi def link scssHslFunction             scssFunction
hi def link scssOpacityFunction         scssFunction
hi def link scssStringFunction          scssFunction
hi def link scssNumberFunction          scssFunction
hi def link scssFunction                Function

let b:current_syntax = "scss"

" vim:set sw=2:
