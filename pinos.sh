#!/bin/sh
#
# Gera tabela HTML de correspondência entre pinos de 2 dispositivos.
# Cada linha pode ter 3 campos, separados entre si por ponto-e-vírgula.
# Se o primeiro campo estiver vazio, a primeira célula da linha 
# anterior é expandida, indicando que o mesmo pino do dispositivo 1
# está conectado a mais de um pino do dispositivo 2.
#
# (c) Augusto Campos, 23.11.2015 - BR-Arduino.org, makerNews.info
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License.


par="$1"

[ ! -e "$par" ] && {
  echo "Erro: nao existe o arquivo '$par'"
  echo "Sintaxe: $0 arquivo"
  exit 5
}


awk -F ";" '

function limpa(texto) {
  gsub(/^[[:blank:]]*/,"",texto);
  gsub(/[[:blank:]]*$/,"",texto);
  return texto	
}

BEGIN {
	linha=0;
}

$1=="" && $2=="" && $3=="" {
  next
}

{
  f1[linha]=limpa($1)
  f2[linha]=limpa($2)
  f3[linha]=limpa($3)

  if (limpa($1)=="") {
    #print "span: "$2
    busca=linha-1
    while (f1[busca]=="") busca--
    span[busca]++
  }

  linha++

}

END {
    zebra=0
	#print "<body>"
	print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" 
	

	print "<style>"
	print "#pinostitle {font-weight: bold; font-size:12pt;}"    
	print ".pinostable { font-family: helvetica, arial, sans-serif; font-size: 12pt; border: 1px solid black;}"
	print ".pinostr { }"
	print "#pinostrclaro { background:#f2f2f2;}"
	print "#pinostrescuro { background:#e6e6e6;}"
	print ".pinostd1 {width:150px; text-align: center;}"
	print ".pinostd2 {width:150px; text-align: center; line-height: 15pt;}"
	print ".pinostd3 {width:150px; font-size: 10pt;}"
	print ".pinoscontent {vertical-align: middle;}"
	print "</style>"
	print "<table class=pinostable"modtable">"
	for (i=0;i<linha;i++) {
		if (f1[i]!="") zebra++
		modtr=""
		modtd1=""
		modtd2=""
		modtd3=""
		if (i==0) {
			modtr=" id=pinostitle"
			modtd3=" style=\"font-size:12pt;\""
		} else {
		  if (zebra%2) modtr=" id=pinostrclaro"
		  else modtr=" id=pinostrescuro"
		}	
	    if (span[i]>0) modtd1=" rowspan="span[i]+1

		print "	<tr class=pinostr"modtr">"
		if (f1[i]!="") {
			print "		<td class=pinostd1"modtd1"><div class=pinoscontent>"f1[i]"</div>"
		}	
		print "		<td class=pinostd2"modtd2"><div class=pinoscontent>"f2[i]"</div>"
		print "		<td class=pinostd3"modtd3"><div class=pinoscontent>"f3[i]"</div>"
	}
	print "</table>"
}

' "$par"
