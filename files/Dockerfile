FROM ubuntu:latest

# Set the working directory to /home/lunaci
WORKDIR /home/lunaci

# Install any needed packages
RUN apt-get update && apt-get install -y \
	curl \
	git \
	lua5.1 \
	luarocks \
	cmake \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/LuaDist-core/bootstrap _luadist_bootstrap && \
	cd _luadist_bootstrap && \
	./bootstrap && \
	cd _install && \
	./bin/lua ./lib/lua/luadist.lua /home/lunaci/luadist install "lua 5.2.4-1" penlight lualogging

# Define environment variable
ENV HOME /home/lunaci

# Copy the current directory contents into the container at /home/lunaci
ADD . /home/lunaci

CMD ["./cronjob.sh"]

