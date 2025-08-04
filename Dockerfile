# 第一阶段：构建环境
FROM ubuntu:24.04 AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential autoconf automake libtool pkg-config git \
    libupnp-dev libgstreamer1.0-dev gstreamer1.0-plugins-base

# 克隆并编译（使用浅层克隆减小体积）
RUN git clone --depth 1 https://github.com/hzeller/gmrender-resurrect.git

WORKDIR /gmrender-resurrect
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local
RUN make -j$(nproc) && make install
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 第二阶段：精简运行时环境
FROM ubuntu:24.04

# 仅安装运行时依赖
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libupnp17 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-alsa gstreamer1.0-libav && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 从构建阶段复制安装内容
COPY --from=builder /usr/local/bin/gmediarender /usr/local/bin/
COPY dlna-render.sh /

ENTRYPOINT [ "/dlna-render.sh" ]
