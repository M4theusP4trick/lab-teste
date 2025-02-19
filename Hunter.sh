
#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e  "\033[1;31m TracerHunter-Forensic Collector. \033[0m"
    exit 1
fi

#Criação de Diretório para coleta
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

#Mensagem de Início
echo -e "\033[1;35m Coletando arquivos do sistema...\033[0m"

#Coleta de Informações do Sistema
echo -e "\033[1;95m Listando informações sobre disco e partições...\033[0m"
lsblk > disk_info.txt

#Coleta de  Conexões de rede
echo -e "\033[0;95m Coletando informações de rede...\033[0m"
ss -tunap > active_connections.txt
netstat -tuln > open_ports.txt
echo "informações  de rede salvas em active_connections.txt e open_ports.txt."

#Coleta de processos
echo -e "\033[0;95m Coletando lista de processos...\033[0m"
ps aux > process.list.txt
echo "Lista de processos salva em process_list.txt."

#Coleta de registros do Sistema
echo -e "\033[0;95m Coletando logs do sistema...\033[0m"
cp /var/log/syslog "$COLLECTED_DIR/SYSLOG.LOG"
cp /var/log/auth.log "$COLLECTED_DIR/auth.log"
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log"

echo -e "Logs do sistema copiados para $COLLECTED_DIR."

#Coleta de arquivos de configuração
echo -e "\033[1;95m Coletando arquivos de configuração...\033[0m"
cp -r /etc "$COLLECTED_DIR/etc_backup"

ls -la > "$COLLECTED_DIR/root_dir_list.txt"

#Compactação e Nomeação do arquivo de Saída

HOSTNAME=$(hostname)
DATAHORA=$(date +"%Y%m%d_%H%M%S")
NOME_ARQUIVO="TracerHunter_${HOSTNAME}_${DATAHORA}.tar.gz"

tar -czf $NOME_ARQUIVO $COLLECTED_DIR

echo -e "Arquivo compactado criado: $NOME_ARQUIVO"
