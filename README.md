# restaura_nginx
Esse script faz a verificação da situação do Nginx remoto utilizando o fping e depois curl, caso aponte falha no curl, 
faz a reinicialização do nginx e testa novamente.
Ele é importante pois o Nginx remoto roda sobre dynamic DNS e a cada troca de IP o Nginx local perde contato com o Nginx remoto.
