#!/bin/bash

# Cria a estrutura de diretórios para categorizar as extensões dos temas
mkdir -p Themes-File-Extension-Lists/{Images,Code,Documents,Compressed,Media,Fonts,Other}

# Processa o arquivo de entrada e organiza as extensões nas respectivas categorias
awk '
BEGIN {
  # Define extensões para cada categoria
  split("png jpg jpeg gif bmp webp svg ico tif tiff heic jfif ai avif bpg cr2 cr3 dcm dng exr hdr heif iiq jp2 jxl nef pbm pcd pct pcx pdn pgf pict ppm psd raf raw rw2 tga xcf x3f cur eps wmf emf apng gif-- jpg~head jpg_old jpg_original j2c jps svg_ svgz djvu icns pgn xd -1png gif_16_feb gif_17_feb fbx czi miff mie mrw sgi", images_ext, " ")
  for (i=1; i<=length(images_ext); i++) images[images_ext[i]] = "Images"
  
  split("php js css html py java c cpp h ts jsx vue sql sh rb abap ada asm asp aspx bat cbl cfc cfm cgi clj coffee dart ejs elm erb fs go groovy haml hbs hh hpp hs jade jsp lasso less lisp lua m matlab mjs ml pas perl phps phtml pl pug r rs sass scala scss slim svelte swift tcl vala vbs xaml yaml yml json mo po pot xml mustache twig xsd tpl htm y map swf proto xslt wsdl tsx class inc phpt latte scssc feature expected rng wasm am as ascx as3proj babelrc bash bithoundrc bowerrc browserlistrc browserslistrc broserlistrc bs c9search_results cc cf cjs clang-format closure-compiler codekit codekit3 coffee2 command cs cscfg csdef cshtml csproj cts dcproj doxy doxyfile eex el erl esformatter eslintcache eslintignore eslintrc esprima ex fish flowconfig ftl gbs gcode glsl graphql gyp gypi handlebars hex hhc hhk hhi htc hx jack javascript jhintrc jison jl jq jscsrc jsdtscope jshintignore jshintrc json5 lean lessinc liquid lsl m4 mel mjml mli modernizr-server moon neon node pegjs postcss postcssrc prettierignore prettierrc pxd py-js rhtml sassc sjs smarty soy spc spec splinecode sts sty stylelintrc sublime-project sublime-workspace svgrrc tsbuildinfo vcl vcxproj webidl workerjs xhtml xq xsl xsx xtpl zep csst cssx htaccess gitignore gitkeep editorconfig npmrc yarnrc dockerignore env travis circleci gitlab-ci makefile procfile gemfile rakefile gruntfile gulpfile package-lock composer-lock", code_ext, " ")
  for (i=1; i<=length(code_ext); i++) code[code_ext[i]] = "Code"
  
  split("pdf doc docx xls xlsx txt md rst csv mdx ods odt xlsm xlt fdf mdown tsv asciidoc bib bnf chm docheader dotm dtd grammar md~ mkd mkdn nfo notes numbers odt# ott ppt pptx readme rtf text textile txt- txt~ txt_old txt# txt_ txt-e txte txt-out md-dist md-nobuild accdb data diff _docu ged geojson ics info jekyll-metadata kml listing mdb mobileconfig name org patch praat rdf ref rss srt tab texinfo todo vcf vtt wiki wkb wkt xmp xspf zh_cn zh_tw pdf.link", documents_ext, " ")
  for (i=1; i<=length(documents_ext); i++) documents[documents_ext[i]] = "Documents"
  
  split("zip gz tar 7z rar bz2 apk dmg iso pack z phar xap tbz tgz zip~ gzs datagz memgz nupkg gzip cpgz", compressed_ext, " ")
  for (i=1; i<=length(compressed_ext); i++) compressed[compressed_ext[i]] = "Compressed"
  
  split("mp4 mp3 m4a mov avi wmv flv webm ogg wav 3gp aac ape flac m4r m4v mkv mpc mpeg mts opus ra ram wma rm aif dv flif m3u m3u8 mid mobi ogv tt8 wtv crw r3d dpx moi mot mrc mxf pmtiles", media_ext, " ")
  for (i=1; i<=length(media_ext); i++) media[media_ext[i]] = "Media"
  
  split("ttf otf woff woff2 eot afm pfa pfb pfm bcmap icc ufm dfont ttc glyphs", fonts_ext, " ")
  for (i=1; i<=length(fonts_ext); i++) fonts[fonts_ext[i]] = "Fonts"
  
  split("bak bin cer crt dat db dll exe jar key log p12 pem pfx sqlite tmp idx config suo asc iml template ini dist cnf cfg conf lnk ijmap pubkey example logs metadata seq leafdoc fixed cd csproj user sln test cache stub gdf toml rev aae ac ac1 access actrc afp afpa ahp all-contributorsrc am_on_github anaproj apache apache2 apikey apo app apt arcconfig arclint args article asl20 asx attribute authz babelsrc baseline bash_history basis blend bpe bsd bucket build-env builder-post-rsync-filters-post builder-rsync-filters build-excludes buildinfo buildpath cgm chk ci-ignore cirru clang-format-ignore clover clpprj cmd code codebeatignore codeclimate codegenconfig codepoints code-snippets code-workspace codoopts color com compressed con config,js container contributing cookie copy crdownload creq cs_cz csprj csr curly cursorrules custom cvsignore cw datamodel datatables-commit-sync datepicker de_de def default default-testing deployignore dev dfxp dia dirignore ditaa dkim docker dockerfile docs doctree don drawio dss dt dunitconfig-nightly dwt e ecrc edgerc efg1 efg2 eip ej elf empty emz en enc en_gb engine ension ent entrypoint en_us env_sample epp eqcss es_es ewkt excl fail fbmd ffs_db fi file-test fits fla flf fmt fontcustom-data fonts fr_fr frt fsproj ftpconfig fttb funnel fx geany generate geohash georss git gitadd git-blame-ignore-revs gitconfig github_changelog_generator gitignore 2 gitignore copy gitinit gitkeeep gitminify gitremote gitrepo gltfdata gnu gnumeric googlewebcomponents gp gpl gpl2 gplv2 gtikeep har hgkeep hhconfig hidden_file hiddenfile home hsdoc htacces htaccess-dev htaccess_logfolder htaccess_wpadmin html# htmllintrc http httpclient hu i18n icon in index input inv invalid-spaces io it_it jamignore jane jane-openapi keepme konfigignore kpf lang layout ld legacy lesser lfp lgpl libignore lic litespeed load logic login_throttled macos magic maintenance markdown mc mdlrc me mention-bot mmdb mo(1) must+be-escaped mz n2less ndocrc ne nextgenassistant_lock node-inspectorrc nodelete noencode no-execute npmpackagejsonlintignore offgitignore onetoc2 opp optimizations overrides p parcelrc pgsql pipe plg pl_pl pls plugin pol polymerelements ppx prettierrc,js pronamic-build-ignore ps pspimage pspz2 pt_br pt_pt public_key public_subkey python-version rd rdoc rels remarkrc resp return root_rules rpg rsync-filters-post-build rsync-filters-pre-build rsyncignore ru_ru s sample sassrc scs secret_key secret_subkey smoketestcredentials snag spmignore sq3 sqlserver sr src styl stylelintrc sublime-settings t test-fail tex textclipping theme tm_properties tweetcache ucsm-form-box input unknownextension user_id v validationengine-uk ve version versions vulnerable w32 webcomponents wfm3_admin_alert_content wfm3_scan_data wie-old wie_old worker worktree wrapped bk bkp db-journal der desktop directory dist-ignore distignore distigonre dmp dot dpc dr4 ds_store dump-autoload dunitconfig emptydir error exclude file foo fpf frame ftpquota gpg hidden hlp identifier ignore idea local lockb lp ls lst lucene mailmap mem meta ms mwb nd ndb new nff nfs nib nix nuspec odg old openapi-generator-ignore out p7s pbf pe pkg pld plex plist pmp pn ppj prc prefs priv project properties ps1 psmdcp psp pub puml puprc pxm reg rel rem revision rhino rhistory ring_trust riv sd ser serialized ses sfx sig sketch skin slk smbdeleteaaab5cb20 space srl ss3 stop_cvs_removing_temp suments swz _syncuser tag temp torrent touch trunk ubdata ufo unityweb unknown upload_rules url urls var vfb vfc vhd vis vpp vrd vrm vsidx wadcfg wie wl wlk wrl wsuo wsz afdesign afphoto avex-map fig glb gltf gpx graffle igc indd inx itc jpg_swbckp komodoproject lfs-assets-id lottie sch back fbmd.orig", other_ext, " ")
  for (i=1; i<=length(other_ext); i++) other[other_ext[i]] = "Other"
}
{
  # Extrai o nome do arquivo e sua extensão
  split($0, parts, "/")
  full_path = tolower(parts[length(parts)])
  if (match(full_path, /\.[^.]+$/)) {
    ext = substr(full_path, RSTART+1)
  } else {
    ext = ""
  }
  
  # Regras para categorização das extensões
  if (ext == "" || ext ~ /^[0-9]+$/ || ext ~ /^[0-9]+\.[0-9]+$/ || ext ~ /^[0-9]+\.[0-9]+\.[0-9]+$/) {
    print $0 > "Themes-File-Extension-Lists/all_no_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.nfs(\.[0-9]{8}\.[0-9]{4})?$/) {
    print $0 > "Themes-File-Extension-Lists/Other/all_nfs_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.goutputstream-[a-zA-Z0-9]{6}(-[a-zA-Z0-9]{6})?$/) {
    print $0 > "Themes-File-Extension-Lists/Other/all_goutputstream_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.attach_pid[0-9]+?$/) {
    print $0 > "Themes-File-Extension-Lists/Other/all_attach_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.lock~[a-f0-9]{40}$/) {
    print $0 > "Themes-File-Extension-Lists/Other/all_lock_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.png[-_a-zA-Z0-9~@#$%^&*()+={}\[\]|;:,<>?]+$/) {
    print $0 > "Themes-File-Extension-Lists/Images/all_png_extension_files_themes.txt"
    next
  }
  if (ext == "save") {
    print $0 > "Themes-File-Extension-Lists/Other/all_save_extension_files_themes.txt"
    next
  }
  if (ext == "import") {
    print $0 > "Themes-File-Extension-Lists/Other/all_import_extension_files_themes.txt"
    next
  }
  if (ext == "mine") {
    print $0 > "Themes-File-Extension-Lists/Other/all_mine_extension_files_themes.txt"
    next
  }
  if (ext == "invalid") {
    print $0 > "Themes-File-Extension-Lists/Other/all_invalid_extension_files_themes.txt"
    next
  }
  if (ext == "br") {
    print $0 > "Themes-File-Extension-Lists/Code/all_br_extension_files_themes.txt"
    next
  }
  if (ext == "demo") {
    print $0 > "Themes-File-Extension-Lists/Code/all_demo_extension_files_themes.txt"
    next
  }
  if (ext == "orig") {
    print $0 > "Themes-File-Extension-Lists/Other/all_orig_extension_files_themes.txt"
    next
  }
  if (ext == "flow") {
    print $0 > "Themes-File-Extension-Lists/Code/all_flow_extension_files_themes.txt"
    next
  }
  if (ext == "guess") {
    print $0 > "Themes-File-Extension-Lists/Other/all_guess_extension_files_themes.txt"
    next
  }
  if (ext == "patched") {
    print $0 > "Themes-File-Extension-Lists/Code/all_patched_extension_files_themes.txt"
    next
  }
  if (full_path ~ /\.vpp~[0-9]+$/) {
    print $0 > "Themes-File-Extension-Lists/Other/all_vpp_extension_files_themes.txt"
    next
  }
  if (ext == "zip~") {
    print $0 > "Themes-File-Extension-Lists/Compressed/all_zip_extension_files_themes.txt"
    next
  }
  if (ext in images) {
    print $0 > "Themes-File-Extension-Lists/Images/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in code) {
    print $0 > "Themes-File-Extension-Lists/Code/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in documents) {
    print $0 > "Themes-File-Extension-Lists/Documents/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in compressed) {
    print $0 > "Themes-File-Extension-Lists/Compressed/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in media) {
    print $0 > "Themes-File-Extension-Lists/Media/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in fonts) {
    print $0 > "Themes-File-Extension-Lists/Fonts/all_" ext "_extension_files_themes.txt"
    next
  }
  if (ext in other) {
    print $0 > "Themes-File-Extension-Lists/Other/all_" ext "_extension_files_themes.txt"
    next
  }
  print $0 > "Themes-File-Extension-Lists/Other/all_unknown_extension_files_themes.txt"
}' all_files_themes.txt