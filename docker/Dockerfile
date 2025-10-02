ARG ES_VERSION

FROM docker.elastic.co/elasticsearch/elasticsearch:${ES_VERSION:-9.1.4}

ENV ES_PLUGIN_CMD="/usr/share/elasticsearch/bin/elasticsearch-plugin"

RUN ES_PLUGINS=( \
      "analysis-kuromoji" \
      "analysis-nori" \
      "analysis-smartcn" \
      "analysis-icu" \
      "https://get.infini.cloud/elasticsearch/analysis-stconvert/${ES_VERSION:-9.1.4}" \
    ) && \
    for plugin in "${ES_PLUGINS[@]}"; do \
      if ! $ES_PLUGIN_CMD list | grep -q "$plugin"; then \
        echo "Installing $plugin ..."; \
        $ES_PLUGIN_CMD install --batch "$plugin"; \
      else \
        echo "$plugin already installed."; \
      fi; \
    done
