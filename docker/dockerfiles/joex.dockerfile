FROM alpine:3.14

ARG version=
ARG joex_url=
ARG UNO_URL=https://raw.githubusercontent.com/unoconv/unoconv/0.9.0/unoconv
ARG TARGETPLATFORM
ARG FLAVOR

ENV JAVA_OPTS="-Xmx1536M"
ENV PATH="/opt/docspell-joex/bin:${PATH}" 

RUN JDKPKG="openjdk11"; \
    TESSERACTPKGS="tesseract-ocr tesseract-ocr-data-deu tesseract-ocr-data-fra tesseract-ocr-data-ita tesseract-ocr-data-spa tesseract-ocr-data-por tesseract-ocr-data-ces \
    tesseract-ocr-data-nld tesseract-ocr-data-dan tesseract-ocr-data-fin tesseract-ocr-data-nor tesseract-ocr-data-swe tesseract-ocr-data-rus tesseract-ocr-data-ron \
    tesseract-ocr-data-lav tesseract-ocr-data-jpn tesseract-ocr-data-heb" \
    if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then JDKPKG="openjdk8"; fi; \
    if [ "$FLAVOR" = "slim" ]; then TESSERACTPKGS="tesseract-ocr"; fi; \ 
    apk add --no-cache $JDKPKG \
    tzdata \
    bash \
    curl \
    ghostscript \
    $TESSERACTPKGS \
    unpaper \
    wkhtmltopdf \
    libreoffice \
    ttf-droid-nonlatin \
    ttf-droid \
    ttf-dejavu \
    ttf-freefont \
    ttf-liberation \
    libxml2-dev \
    libxslt-dev \
    pngquant \
    zlib-dev \
    g++ \
    qpdf \
    py3-pip \
    python3-dev \
    libffi-dev\
    qpdf-dev \
    openssl-dev \
    ocrmypdf \
  && pip3 install --upgrade pip \
  && pip3 install ocrmypdf \
  && curl -Ls $UNO_URL -o /usr/local/bin/unoconv \
  && chmod +x /usr/local/bin/unoconv \
  && apk del curl libxml2-dev libxslt-dev zlib-dev g++ python3-dev py3-pip libffi-dev qpdf-dev openssl-dev \
  && ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /opt
RUN wget ${joex_url:-https://github.com/eikek/docspell/releases/download/v$version/docspell-joex-$version.zip} && \
  unzip docspell-joex-*.zip && \
  rm docspell-joex-*.zip && \
  ln -snf docspell-joex-* docspell-joex && \
  rm docspell-joex/conf/docspell-joex.conf


RUN \
  if [ "$FLAVOR" = "slim" ]; then ln -s /opt/joex-ocrmypdf.sh /opt/docspell-joex/bin/ocrmypdf; else \ 
  wget https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn_vert.traineddata; \ 
  wget https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn.traineddata; \
  mv jpn*.traineddata /usr/share/tessdata; fi

COPY joex-entrypoint.sh /opt/joex-entrypoint.sh
COPY joex-ocrmypdf.sh /opt/joex-ocrmypdf.sh

ENTRYPOINT ["/opt/joex-entrypoint.sh", "-J-XX:+UseG1GC"]
EXPOSE 7878

HEALTHCHECK --interval=1m --timeout=10s --retries=2 --start-period=30s \
  CMD wget --spider http://localhost:7878/api/info/version
