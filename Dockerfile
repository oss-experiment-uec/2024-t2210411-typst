FROM rust:bullseye

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone
RUN apt update && apt upgrade -y

COPY . /artifact
WORKDIR /artifact

RUN --mount=type=cache,target=/root/.cargo/git/db \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/registry/index \
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    cargo fetch


#  #
RUN apt-get install nano locales curl

# setting locale may be unnecessary #
# in my environment, the bash prompt is broken in the docker container # 
RUN echo "ja_JP UTF-8" > /etc/locale.gen
RUN locale-gen

