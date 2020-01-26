###############################################################################################################
# Criar uma pasta chamada rootserver_backup
# mkdir rootserver_backup
# Obs:. Colocar o script no cron para atualizar automaticamente e transformar o script como executável chmod +x
###############################################################################################################

# !/bin/bash
INFO_DATA=`date +%Y-%m-%d`

## cria o arquivo rootserver.$INFO_DATA
touch /etc/bind/rootserver.$INFO_DATA

## pega a lista de rootservers e armazena no arquivo rootserver.$INFO_DATA
wget -O /etc/bind/rootserver.$INFO_DATA https://www.internic.net/domain/named.root --no-check-certificate

# instrução para atualizar o arquivo
ARQUIVO=$(stat -c%s "/etc/bind/rootserver.$INFO_DATA")
if [ $ARQUIVO -gt 0 ]; then
        ## cria um backup do db.root renomeando para db.root.$INFO_DATA
        mv /etc/bind/db.root /etc/bind/rootserver_backup/db.root.$INFO_DATA

        ## renomeia rootserver.$INFO_DATA para db.root
        mv /etc/bind/rootserver.$INFO_DATA /etc/bind/db.root

        ## reinicia o serviço
        systemctl restart bind9.service
else
        # remove arquivo vazio que foi criado
        rm /etc/bind/rootserver.$INFO_DATA

        # imprime na tela
        echo "Problema ao baixar os dados..."
fi 
