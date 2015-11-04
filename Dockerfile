FROM debian:wheezy

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 apache2 \
 beanstalkd \
 gcc \
 git \
 gunicorn \
 libapache2-mod-proxy-html \
 libevent-dev \
 libmysqlclient-dev \
 libxml2-dev \
 libxslt-dev \
 memcached \
 mysql-client \
 mysql-server \
 python \
 python-dev \
 python-pip \
 tinymce \
 vim \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/leopoul/ncclient.git && \
    cd ncclient && \
    python setup.py install
RUN git clone https://github.com/karlnewell/nxpy.git && \
    cd nxpy && \
    python setup.py install
RUN cd /srv && \
    git clone https://github.com/grnet/flowspy.git && \
    cd flowspy/flowspy && \
    cp urls.py.dist urls.py
RUN pip install -r /srv/flowspy/requirements.txt
RUN pip install mysql-python smartencoding
RUN sed -i 's/from django.forms.util import smart_unicode/from django.utils.encoding import smart_unicode/' /usr/local/lib/python2.7/dist-packages/tinymce/widgets.py
RUN sed -i 's/#START/START/' /etc/default/beanstalkd 
RUN mkdir /var/log/fod && chown www-data:www-data /var/log/fod
COPY gunicorn.fod /etc/gunicorn.d/fod
COPY default.celeryd /etc/default/celeryd
COPY apache2.fod /etc/apache2/sites-available/fod
COPY flowspy.settings.py /srv/flowspy/flowspy/settings.py
RUN a2enmod rewrite && \
    a2enmod proxy && \
    a2enmod ssl && \
    a2enmod proxy_http && \
    a2dissite default && \
    a2ensite fod
EXPOSE 80
CMD ["/bin/bash"]

