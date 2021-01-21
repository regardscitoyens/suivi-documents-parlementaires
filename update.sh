#!/bin/bash

cd $(echo $0 | sed 's#/[^/]*$##')

dat=$(date +%y%m%d)

function update_file {
  url=$1
  room=$2
  fil=$3
  ext=$(echo $url | sed -r 's/^.*\.([a-z]{2,5})$/\1/')
  search=$(echo $fil | sed 's/ /\\ /g')
  echo "Download «$room/$fil.$ext» at $url..."
  last=$(ls pdfs/$room/"$fil "-*.$ext 2>/dev/null | tail -1)
  new="pdfs/$room/$fil - $dat.$ext"
  wget -q "$url" -O "$new"
  if [ -z "$last" ] || (test -s "$new" && diff "$last" "$new" | grep . > /dev/null); then
    echo "  -> New version!"
  else
    rm -f "$new"
  fi
  echo
}

git pull > /tmp/load_documents_parl.tmp

update_file "http://www.assemblee-nationale.fr/connaissance/reglement.pdf" AN "Réglement" >> /tmp/load_documents_parl.tmp

update_file "http://www.assemblee-nationale.fr/connaissance/igb_092018.pdf" AN "Instruction Générale du Bureau" >> /tmp/load_documents_parl.tmp

update_file "http://www2.assemblee-nationale.fr/static/comptes/RBCF.pdf" AN "Réglement budgétaire, comptable et financier" >> /tmp/load_documents_parl.tmp

update_file "http://www2.assemblee-nationale.fr/static/15/deontologue/arrete_bureau_12XV_221019.pdf" AN "Arrêté Bureau - Frais de mandat 12 XV" >> /tmp/load_documents_parl.tmp
# http://www2.assemblee-nationale.fr/static/15/deontologue/arrete_bureau_12XV_220519.pdf
# http://www2.assemblee-nationale.fr/static/deontologue/12_XV_bureau_fdm_consolide.pdf
# http://www2.assemblee-nationale.fr/static/deontologue/12_XV_bureau_frais_mandat_061218.pdf
# http://www2.assemblee-nationale.fr/static/arrete_Bureau_12_XV_consolide.pdf
# http://www2.assemblee-nationale.fr/static/12_XV_Bureau_frais%20de%20mandat.pdf
# http://www2.assemblee-nationale.fr/static/arrete_bureau_12_XV_291117.pdf

update_file "http://www2.assemblee-nationale.fr/static/deontologue/61_XV_bureau_040219.pdf" AN "Arrêté Bureau - Tirage au sort 61 XV" >> /tmp/load_documents_parl.tmp
# http://www2.assemblee-nationale.fr/static/15/deontologue/arrete_bureau_6115.pdf

update_file "http://www2.assemblee-nationale.fr/static/15/liste_preconisations.pdf" AN "Bureau - Préconisations ReformeAN 3" >> /tmp/load_documents_parl.tmp

update_file "http://www2.assemblee-nationale.fr/content/download/179918/1801507/version/1/file/code+de+déontologie_actualisé+suite+bureau+091019.pdf" AN "Code de déontologie" >> /tmp/load_documents_parl.tmp
#http://www2.assemblee-nationale.fr/content/download/25883/244571/version/5/file/code-deontologie.pdf

update_file "http://www2.assemblee-nationale.fr/content/download/183338/1837494/version/1/file/Liste+Voyages_publiee_121219.pdf" AN "Registre des voyages" >> /tmp/load_documents_parl.tmp

update_file "http://www2.assemblee-nationale.fr/content/download/310802/3015547/version/1/file/Liste+Dons+et+invitations_publi%C3%A9e_120620.pdf" AN "Registre des cadeaux" >> /tmp/load_documents_parl.tmp
# http://www2.assemblee-nationale.fr/content/download/183339/1837502/version/1/file/Liste+Dons+et+invitations_publiee_121219.pdf


#update_file "" AN "" >> /tmp/load_documents_parl.tmp


update_file "https://www.senat.fr/reglement/reglement_mono.html" Sénat "Réglement" >> /tmp/load_documents_parl.tmp

update_file "https://www.senat.fr/fileadmin/Fichiers/Images/sgp/Comite_de_deontologie/GUIDE_DEONTOLOGIE_SENATEUR_140119_BD.pdf" Sénat "Guide de déontologie" >> /tmp/load_documents_parl.tmp

update_file "https://www.senat.fr/fileadmin/Fichiers/Images/sgp/Declarations/Registre_des_deports.pdf" Sénat "Registre des déports" >> /tmp/load_documents_parl.tmp

update_file "http://www.senat.fr/data/registre_depots/Registre_des_deports.csv" Sénat "Registre des déports" >> /tmp/load_documents_parl.tmp

update_file "https://www.senat.fr/fileadmin/Fichiers/Images/sgp/Declarations/Classeur_Cadeaux_2018-2019.pdf" Sénat "Registre des cadeaux" >> /tmp/load_documents_parl.tmp

update_file "https://www.senat.fr/fileadmin/Fichiers/Images/sgp/Declarations/Liste_deplacements_organismes_exterieurs_en_ligne.pdf" Sénat "Registre des invitations" >> /tmp/load_documents_parl.tmp

update_file "https://www.senat.fr/fileadmin/Fichiers/Images/sgp/Liste_Declarations_Invit_Gpes_Interet.pdf" Sénat "Registre des invitations lobbies" >> /tmp/load_documents_parl.tmp

# https://www.senat.fr/role/nouveau_regime_frais_de_mandat.html
#    Arrêté du Bureau du Sénat n° 2017-272 et son annexe (référentiel des frais de mandat éligibles)
#    Arrêté de Questure n° 2017-1202
#    Avis du Comité de déontologie du Sénat n° CDP/2017-1
#    Guide pratique - Frais de mandat des sénateurs


#update_file "" Sénat "" >> /tmp/load_documents_parl.tmp


if git status | grep "pdfs" > /dev/null; then
  cat /tmp/load_documents_parl.tmp
  git add pdfs/*/*$dat.*
  git commit -m "Update documents parlementaires - 20$dat"
  git push
fi
