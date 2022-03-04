FROM openjdk:11-jdk-slim-bullseye

ARG version=
ARG joex_url=
ARG UNO_URL=https://raw.githubusercontent.com/unoconv/unoconv/0.9.0/unoconv
ARG TARGETPLATFORM

ENV JAVA_OPTS="-Xmx1536M"

RUN apt update && apt install -y --no-install-recommends \
    tzdata \
    bash \
    curl \
    ghostscript \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-osd \
    tesseract-ocr-deu \
    tesseract-ocr-fra \
    tesseract-ocr-ita \
    tesseract-ocr-spa \
    tesseract-ocr-por \
    tesseract-ocr-ces \
    tesseract-ocr-nld \
    tesseract-ocr-dan \
    tesseract-ocr-fin \
    tesseract-ocr-nor \
    tesseract-ocr-swe \
    tesseract-ocr-rus \
    tesseract-ocr-ron \
    tesseract-ocr-lav \
    tesseract-ocr-jpn \
    tesseract-ocr-heb \
    unpaper \
    wkhtmltopdf \
    libreoffice \
    fonts-dejavu \
    fonts-freefont-ttf \
    fonts-liberation \
    libxml2-dev \
    libxslt-dev \
    pngquant \
    zlib1g-dev \
    g++ \
    qpdf \
    python3-pip \
    python3-dev \
    libffi-dev\
    libqpdf-dev \
    libssl-dev \
    ocrmypdf
RUN pip3 install --upgrade pip \
  && pip3 install ocrmypdf \
  && curl -Ls $UNO_URL -o /usr/local/bin/unoconv \
  && chmod +x /usr/local/bin/unoconv 
#RUN apt purge curl libxml2-dev libxslt-dev zlib1g-dev g++ python3-dev python3-pip libffi-dev libqpdf-dev libssl-dev
#RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /opt
RUN wget ${joex_url:-https://github.com/eikek/docspell/releases/download/v$version/docspell-joex-$version.zip} && \
  unzip docspell-joex-*.zip && \
  rm docspell-joex-*.zip && \
  ln -snf docspell-joex-* docspell-joex && \
  rm docspell-joex/conf/docspell-joex.conf

# Using these data files for japanese, because they work better. See #973
RUN \
  wget https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn_vert.traineddata && \
  wget https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn.traineddata && \
  mv jpn*.traineddata /usr/share/tessdata

COPY joex-entrypoint.sh /opt/joex-entrypoint.sh

ENTRYPOINT ["/opt/joex-entrypoint.sh", "-J-XX:+UseG1GC"]
EXPOSE 7878

HEALTHCHECK --interval=1m --timeout=10s --retries=2 --start-period=30s \
  CMD wget --spider http://localhost:7878/api/info/version
