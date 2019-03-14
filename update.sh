#!/bin/bash

cd $(echo $0 | sed 's#/[^/]*$##')

dat=$(date +%y%m%d)

function update_file {
  url=$1
  room=$2
  fil=$3
  mot=$(echo $fil | sed 's/ .*$//')
  echo "Download «$fil» at $url..."
  last=$(ls pdfs/*$mot* | tail -1)
  new="pdfs/$room/$fil - $dat.pdf"
  wget -q "$url" -O "$new"
  if test -s "$new" && diff "$last" "$new" | grep . > /dev/null; then
    echo "  -> New version!"
  else
    rm -f "$new"
  fi
  echo
}

git pull > /tmp/load_documents_parl.tmp
update_file "http://www2.assemblee-nationale.fr/static/deontologue/12_XV_bureau_frais_mandat_061218.pdf" AN "Arrêté Bureau - Frais de mandat 12 XV" >> /tmp/load_documents_parl.tmp
# http://www2.assemblee-nationale.fr/static/arrete_Bureau_12_XV_consolide.pdf
# http://www2.assemblee-nationale.fr/static/12_XV_Bureau_frais%20de%20mandat.pdf
# http://www2.assemblee-nationale.fr/static/arrete_bureau_12_XV_291117.pdf
update_file "http://www2.assemblee-nationale.fr/static/comptes/RBCF.pdf" AN "Réglement budgétaire, comptable et financier" >> /tmp/load_documents_parl.tmp

if git status | grep "pdfs" > /dev/null; then
  cat /tmp/load_documents_parl.tmp
  git add pdfs/*/*$dat.pdf
  git commit -m "Update documents parlementaires - 20$dat"
  git push
fi
