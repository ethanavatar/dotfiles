let src_path = $env.FILE_PWD | path join init.fnl;
let out_path = $env.FILE_PWD | path join init.lua;

let out = fennel --compile $src_path | str join;
$out | save $out_path --force;

print $'Saved updated Neovim config to ($out_path)';
