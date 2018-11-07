#!/bin/bash

cd $(echo $0 | sed 's#/[^/]*$##')

dat=$(date +%y%m%d)

function update_file {
  url=$1
  fil=$2
  mot=$(echo $fil | sed 's/ .*$//')
  echo "Download «$fil» at $url..."
  last=$(ls pdfs/*$mot* | tail -1)
  new="pdfs/$dat - AN - $fil.pdf"
  wget -q "$url" -O "$new"
  if test -s "$new" && diff "$last" "$new" | grep . > /dev/null; then
    echo "  -> New version!"
  else
    rm -f "$new"
  fi
  echo
}

git pull > /tmp/load_reglement_budgetaire_an.tmp
update_file "http://www2.assemblee-nationale.fr/static/12_XV_Bureau_frais%20de%20mandat.pdf" "Arrêté Bureau - Frais de mandat 12 XV" >> /tmp/load_reglement_budgetaire_an.tmp
update_file "http://www2.assemblee-nationale.fr/static/comptes/RBCF.pdf" "Réglement budgétaire, comptable et financier" >> /tmp/load_reglement_budgetaire_an.tmp

if git status | grep "pdfs" > /dev/null; then
  cat /tmp/load_reglement_budgetaire_an.tmp
  git add pdfs/$dat*
  git commit -m "Update documents budgétaires et financiers AN - 20$dat"
  git push
fi