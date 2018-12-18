#"/bin/bash
EMAIL="seuemail@mail.com"
LOG="/var/log/nginx/nginxreload.log"
echo "`date +%d-%m-%Y' '%H:%M:%S` - Inicio do teste " >> $LOG
URL="xxxxxx.dynv6.net"
echo $URL >> $LOG
FPING=`fping6 $URL | grep -o 'is alive'`
echo $FPING >> $LOG
CURL=`curl -sSf 'http://'$URL':8080' |grep -o 'texto contido na página'`
echo $CURL >> $LOG
if [[ $FPING != 'is alive' ]]; then
	for (( i = 0; i < 5; i++ )); do
		if [[ $CURL != 'texto contido na página' ]]; then
			echo "Dentro do if teste CURL"
			/usr/sbin/service nginx restart
			echo "Reiniciando o nginx" >> $LOG
			watch -n 5
			CURL=`curl -sSf 'http://'$URL':8080' |grep -o 'texto contido na página'`
			if [[ $CURL == 'texto contido na página' ]]; then
				echo "`date +%d-%m-%Y' '%H:%M:%S` - Serviço Restaurado na tentativa `i`." >> $LOG
				i = 9;
			fi
		fi
		if [[ i -eq 5 ]]; then
			echo "`date +%d-%m-%Y' '%H:%M:%S` - Serviço Não Restaurado Erro não Esperado." >> $LOG
			echo "`date +%d-%m-%Y' '%H:%M:%S` - Serviço Não Restaurado Erro não Esperado." | mutt -s "Reinicialização do Nginx não funcionou" $EMAIL
		fi
	done
	echo "`date +%d-%m-%Y' '%H:%M:%S` - Falha na Internet do Servidor Nginx Local." >> $LOG
	echo "`date +%d-%m-%Y' '%H:%M:%S` - Falha na Internet do Servidor Nginx Local." | mutt -s "Falha na Internet do Servidor Nginx Local" $EMAIL
fi
echo "`date +%d-%m-%Y' '%H:%M:%S` - Termino do teste " >> $LOG
