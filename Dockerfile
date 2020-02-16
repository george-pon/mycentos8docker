FROM centos:centos8

ENV MYCENTOS8DOCKER_VERSION build-target
ENV MYCENTOS8DOCKER_VERSION latest
ENV MYCENTOS8DOCKER_VERSION stable
ENV MYCENTOS8DOCKER_IMAGE mycentos8docker


# install yamlsort see https://github.com/george-pon/yamlsort
ENV YAMLSORT_VERSION v0.1.19
RUN curl -fLO https://github.com/george-pon/yamlsort/releases/download/${YAMLSORT_VERSION}/linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz && \
    tar xzf linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz && \
    chmod +x linux_amd64_yamlsort && \
    mv linux_amd64_yamlsort /usr/bin/yamlsort && \
    rm linux_amd64_yamlsort_${YAMLSORT_VERSION}.tar.gz

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ADD bashrc /root/.bashrc
ADD bash_profile /root/.bash_profile
ADD emacsrc /root/.emacs
ADD vimrc /root/.vimrc
ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ENV HOME /root
ENV ENV $HOME/.bashrc

# add sudo user
# https://qiita.com/iganari/items/1d590e358a029a1776d6 Dockerコンテナ内にsudoユーザを追加する - Qiita
# ユーザー名 centos
# パスワード hogehoge
RUN groupadd -g 1000 centos && \
    useradd  -g      centos -G wheel -m -s /bin/bash centos && \
    echo 'centos:hogehoge' | chpasswd && \
    echo 'Defaults visiblepw'            >> /etc/sudoers && \
    echo 'centos ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# use normal user centos
# USER centos

CMD ["/usr/local/bin/docker-entrypoint.sh"]

