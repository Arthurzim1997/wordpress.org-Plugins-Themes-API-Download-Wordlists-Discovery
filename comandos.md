# pegar o diretorio raiz de themas e plugins
grep "^wp-content/themes/[^/]\+/$" directories_themes.txt > root_directory_themes.txt
# arquivos .htaccess somente encontrado em plugins
grep -i "\.htaccess$" files_plugins.txt > htaccess_files_plugins.txt
---------------------------------------------------------------------
####  ####
# pegar qualquer readme apos a ultima / themas e plugins
grep -i "[^/]*readme[^/]*$" files_plugins.txt > readme_files_plugins.txt
# arquivos de configuração de themas e plugins
grep -i "[^/]*\(config\|settings\|init\|setup\|options\|bootstrap\|core\|defaults\|env\|load\|main\|params\|start\)[^/]*$" files_plugins.txt > config_files_plugins.txt
# arquivos de licensa de themas e plugins
grep -i "[^/]*\(license\|licence\|COPYING\|gpl\|lgpl\|agpl\|mit\|bsd\|apache\|terms\|eula\|copyright\|disclaimer\)[^/]*$" all_files_plugins.txt > all_license_files_plugins.txt
# arquivos de backup/banco de dados de themas e plugins
grep -i "[^/]*\(backup\|bak\|sql\|db\|dump\|archive\|zip\|tar\|gz\|bz2\|rar\|old\|temp\)[^/]*$" all_files_plugins.txt > all_backup_db_files_plugins.txt
# arquivos de log de themas e plugins
grep -i "[^/]*\(log\|logs\|error\|access\|debug\|trace\|info\|audit\|activity\|event\|history\|report\)[^/]*$" all_files_plugins.txt | grep -iv "\.\(png\|jpg\|jpeg\|gif\|bmp\|webp\|svg\)[^/]*$" | grep -iv "\.htaccess$" | grep -iv "[^/]*\<blog\>[^/]*$" | grep -iv "[^/]*\<logo\>[^/]*$" > all_log_files_plugins.txt
# arquivos de install/setup de themas e plugins
grep -i "[^/]*\(install\|setup\|installer\|activate\|init\|configure\|config\|start\|upgrade\|migrate\|provision\)[^/]*$" all_files_plugins.txt | grep -iv "\.\(png\|jpg\|jpeg\|gif\|bmp\|webp\|svg\)[^/]*$" | grep -iv "\.htaccess$" | grep -iv "[^/]*\<blog\>[^/]*$" | grep -iv "[^/]*\<logo\>[^/]*$" | grep -iv "[^/]*\<definition\>[^/]*$" > all_install_setup_files_plugins.txt
----------------------------------------------------------------------
# pegar qualquer nome depois do ultimo . apos a ultima /
awk -F'/' '{split(tolower($NF), a, "\\."); if (length(a) > 1) {print a[length(a)]}}' all_files_plugins.txt | sort | uniq > extensions_list.txt

