# phpmanual/pt-br

[![](https://imagelayers.io/badge/phpmanual/pt-br:latest.svg)](https://imagelayers.io/?images=phpmanual/pt-br:latest 'Get your own badge on imagelayers.io')

```
docker pull phpmanual/pt-br
```

## Como usar

Abra dois terminais, apontando para a mesma pasta: onde você armazenará os arquivos da tradução.

### Criando o primeiro ambiente

Em um dos dois terminais, rode o seguinte comando:

    docker run --rm \
        --name phpmanual \
        -v $(pwd):/volume \
        -p 4000:4000 \
        phpmanual/pt-br

Será iniciado um container, e sua pasta local terá uma cópia sincronizada dos arquivos referentes a tradução. Além disso, será ligado o servidor web com o resultado da última compilação.

Esse é o resultado padrão da execução:
- container up
- rsync repos container -> volume/host
- web server on

Para verificar o resultado da compilação no seu navegador, é só acessar http://docker.local:4000 (ou o IP do seu Docker host/Docker Machine, sempre nessa porta 4000).

Nesse terminal, será mostrado o log de acessos do servidor web.

### Testando suas alterações, recompilando o ambiente

Enquanto esse primeiro container estiver sendo executado, basta rodar o seguinte comando para recompilar com suas alterações da seguinte forma:

    docker exec -it phpmanual \
        1-build.sh

Esse comando faz a recompilação baseada apenas nos seus arquivos locais (volume) sem fazer uma sincronização antes.

Se aquele seu primeiro container não estiver mais rodando, mas você já tiver os arquivos dos repositórios em sua pasta local, o caminho é o seguinte:

    docker run --rm \
        --name phpmanual \
        -v $(pwd):/volume \
        -p 4000:4000 \
        phpmanual/pt-br
        build

