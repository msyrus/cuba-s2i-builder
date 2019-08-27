# s2i-cuba
FROM openshift/base-centos7

LABEL maintainer="Minhaz Ahmed Syrus <msyrus@gmail.com>"

ENV BUILDER_VERSION 1.0


LABEL io.k8s.description="Platform for building cuba uberJar" \
     io.k8s.display-name="builder cuba" \
     io.openshift.expose-services="8080:http" \
     io.openshift.tags="builder,cuba,gradle"

RUN yum install -y java-1.8.0-openjdk-devel unzip && yum clean all -y
ADD https://services.gradle.org/distributions/gradle-5.6-bin.zip /opt/gradle/gradle.zip
RUN unzip -d /opt/gradle /opt/gradle/gradle.zip \
     && rm /opt/gradle/gradle.zip

ENV PATH $PATH:/opt/gradle/gradle-5.6/bin

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
