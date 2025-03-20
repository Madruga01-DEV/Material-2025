fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"

lua54 "yes"

files {
  "init.lua",
  "modules/**.lua",
	"html/dist/**.html",
	"html/dist/**.js",
	"html/dist/**.css",
	"html/dist/**.ttf",
	"html/dist/**.png",
	"html/dist/**.mp3",
	"html/dist/**.gif",
	"nui/**/**.html",
	"nui/**/**.js",
	"nui/**/**.css",
	"nui/**/**.ttf",
	"nui/**/**.png",
	"nui/**/**.mp3",
	"nui/**/**.gif",
}

shared_scripts {
	'init.lua'
}

escrow_ignore {
	"modules/**.lua",
	"html/dist/**.html",
	"html/dist/**.js",
	"html/dist/**.css",
	"html/dist/**.ttf",
	"html/dist/**.png",
	"html/dist/**.mp3",
	"html/dist/**.gif",
	"nui/**/**.html",
	"nui/**/**.js",
	"nui/**/**.css",
	"nui/**/**.ttf",
	"nui/**/**.png",
	"nui/**/**.mp3",
	"nui/**/**.gif",
}
dependency '/assetpacks'