# ============================================================================
FROM quay.io/podman/stable:v5.8.2 AS base


# ----------------------------------------------------------------------------
# Global environment:
ENV INSTALL_DIR=/usr/local/install


# ============================================================================
# Ref: https://github.com/GoogleContainerTools/container-structure-test/tags
ENV CST_VERSION=v1.22.1
ENV CST_URL=https://github.com/GoogleContainerTools/container-structure-test
ENV CST_INSTALL_DIR=${INSTALL_DIR}/container-structure-test-${CST_VERSION}

RUN mkdir -p ${CST_INSTALL_DIR}  && \
    curl  --fail  \
          --silent  \
          --show-error  \
          --location  \
          --remote-name  \
          --output-dir ${CST_INSTALL_DIR}  \
          ${CST_URL}/releases/download/${CST_VERSION}/container-structure-test-linux-amd64  && \
    chmod +rx ${CST_INSTALL_DIR}/container-structure-test-linux-amd64  && \
    ln -s  ${CST_INSTALL_DIR}/container-structure-test-linux-amd64 /usr/local/bin/container-structure-test


# ============================================================================
RUN dnf --quiet install --assumeyes jq  \
                                    skopeo  \
                                    xq


# ============================================================================
FROM base AS unittest

# This is the bare minimum to "fake" a unit-test, so that we can test our
# own unittest target:
ENTRYPOINT ["/usr/bin/touch"]
CMD ["/var/tmp/test-results.xml"]


# ============================================================================
FROM base AS final
