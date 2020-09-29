# MixMaster
Script Server

TENHA CERTEZA DE SEGUIR TODOS OS PASSOS

1. Clonar repositório para o servidor mixmaster *:
# git clone https://github.com/gsfcosta/MixMaster.git
2. Entrar na pasta:
# cd MixMaster
3. Dar permissão de execução para a pasta a subpastas:
# chmod +x ./* -R
4. Executar o script:
# ./install

#############################################################

Pacote:
    -   mixmaster manager: start - stop - restart server
        Utilização do manager:
        # mixmaster
    -   configure: para quem não possui os arquivos do servidor de mixmaster, irá configurar um novo servidor no local desejado (DISPONIVEL SOMENTE PARA OPÇÃO "1 SERVIDOR")
    -   mixmaster reconfigure: Reconfiguração de servidor já existente, para quem desejar atualizar o acesso ao banco de dados/ip do servidor (DISPONIVEL SOMENTE PARA OPÇÃO "1 SERVIDOR")
        Utilização do reconfigure: 
        # mixmaster_reconfigure

*Caso não tenha o git instalado no servidor, executar:
    #yum install git