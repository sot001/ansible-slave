# pull base image
FROM jenkinsci/jnlp-slave:latest

USER root

RUN echo "===> Adding Ansible's prerequisites..."   && \
    DEBIAN_FRONTEND=noninteractive  \
    apt-get update -y            && \
        apt-get install --no-install-recommends -y -q  \
                build-essential                        \
                python-pip python-dev python-yaml      \
                libffi-dev libssl-dev                  \
                libxml2-dev libxslt1-dev zlib1g-dev    \
                git software-properties-common      && \
    pip install --upgrade wheel setuptools          && \
    pip install --upgrade pyyaml jinja2 pycrypto    && \
    DEBIAN_FRONTEND=noninteractive  \
    apt-add-repository ppa:ansible/ansible -y && \
    DEBIAN_FRONTEND=noninteractive  \
    apt-get install ansible -y -q

USER jenkins

ENV PATH        /opt/ansible/bin:$PATH
ENV PYTHONPATH  /opt/ansible/lib:$PYTHONPATH
ENV MANPATH     /opt/ansible/docs/man:$MANPATH


# default command: display Ansible version
#ENTRYPOINT [ "ansible-playbook", "--version" ]
ENTRYPOINT ["jenkins-slave"]
