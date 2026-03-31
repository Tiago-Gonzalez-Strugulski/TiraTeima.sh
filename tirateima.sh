#/bin/bash

# Script para Reiniciar o Servico AMKSServidorQWC ( Tira-Teima Antigo)
#
# o mesmo verifica o tamanho do arquivo /opt/QuickWay/ArquivoLog.txt que armazena os ip dos tira-teima, criando um
# novo e excluindo o antigo para liberar mais de 2GB de espaco em disco
#
# Criado por Tiago Shaolin Central de Serviç em 18/03/2019
# Alterado dia 13/04/2019
#date=`date "+%Y%m%d"`
temp=`date "+%d/%m/%Y %H:%M:%S"`

touch /opt/QuickWay/log.txt && chmod 770 /opt/QuickWay/log.txt

killall AMKSServidorQWC 2>> /dev/null

sleep 1

/opt/QuickWay/VerificaQuickWay.sh 2>>/tmp/QuickWay.log >>/tmp/QuickWay.log
echo " - Servico AMKSS Reiniciado $temp " >> /opt/QuickWay/log.txt

size=`du -hsb /opt/QuickWay/ArquivoLog.txt |awk {'print $1'} `

if [ "$size" -gt "1947400000" ];then

        tam=`du -h /opt/QuickWay/ArquivoLog.txt |awk {'print $1'}`

        echo " - ArquivoLog.txt Atingiu o Limite $tam em $temp " >> /opt/QuickWay/log.txt
        sleep 1
        mv /opt/QuickWay/ArquivoLog.txt /opt/QuickWay/ArquivoLog_old.txt
        touch /opt/QuickWay/ArquivoLog.txt && chmod 770 /opt/QuickWay/ArquivoLog.txt
        sleep 1
        tam=`du -h /opt/QuickWay/ArquivoLog.txt |awk {'print $1'}`
        echo " - ArquivoLog.txt Novo Com $tam em $temp " >> /opt/QuickWay/log.txt

        killall AMKSServidorQWC

        sleep 1
        /opt/QuickWay/VerificaQuickWay.sh 2>>/tmp/QuickWay.log >>/tmp/QuickWay.log

else

        tam=`du -h /opt/QuickWay/ArquivoLog.txt  |awk {'print $1'}`
        echo " - ArquivoLog.txt Abaixo Do Limite $tam em $temp " >> /opt/QuickWay/log.txt
fi

rm /opt/QuickWay/ArquivoLog_old.txt 2>/dev/null
