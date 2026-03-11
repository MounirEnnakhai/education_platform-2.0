# ── Stage 1: build ───────────────────────────────────────────────────────────
FROM debian:bookworm-slim AS builder

ARG ZIG_VERSION=0.15.2
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl ca-certificates xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Download Zig 0.15.2 directly from ziglang.org
RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) ZIG_ARCH="x86_64-linux"  ;; \
        arm64) ZIG_ARCH="aarch64-linux" ;; \
        *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac; \
    curl -fsSL "https://ziglang.org/download/${ZIG_VERSION}/zig-${ZIG_ARCH}-${ZIG_VERSION}.tar.xz" \
        -o /tmp/zig.tar.xz; \
    tar -xJf /tmp/zig.tar.xz -C /usr/local; \
    mv "/usr/local/zig-${ZIG_ARCH}-${ZIG_VERSION}" /usr/local/zig; \
    rm /tmp/zig.tar.xz

ENV PATH="/usr/local/zig:${PATH}"
WORKDIR /app

# Cache deps — only re-runs when build.zig.zon changes
COPY build.zig build.zig.zon ./
RUN zig build --fetch

# Compile — only re-runs when src/ changes
COPY src/ ./src/
RUN zig build -Doptimize=ReleaseSafe

# ── Stage 2: runtime (~15MB image, no Zig toolchain) ─────────────────────────
FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/zig-out/bin/edu-platform /edu-platform

VOLUME ["/data"]
EXPOSE 8080

ENV DB_PATH=/data/edu_platform.db \
    HOST=0.0.0.0 \
    PORT=8080

ENTRYPOINT ["/edu-platform"]
