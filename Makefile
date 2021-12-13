VERSION = 0.36
GO_FMT = gofmt -s -w -l .
GO_XC = goxc -os="linux" -bc="linux,amd64,arm" -tasks-="rmbin"

GOXC_FILE = .goxc.local.json

all: package

compile:
	GOOS=linux GOARCH=amd64 go build -o docker-volume-netshare-amd64
	GOOS=linux GOARCH=arm64 go build -o docker-volume-netshare-arm64

package: deps compile
	rm docker-volume-netshare_0.35_amd64.deb
	fpm -s dir -t deb -n docker-volume-netshare -a amd64 -v 0.35 \
      docker-volume-netshare-amd64=/usr/bin/docker-volume-netshare \
      support/sysvinit-debian/=/
	fpm -s dir -t deb -n docker-volume-netshare -a arm64 -v 0.35 \
		docker-volume-netshare-arm64=/usr/bin/docker-volume-netshare \
		support/sysvinit-debian/=/

deps:
	go mod tidy 

format:
	$(GO_FMT)

bintray:
	$(GO_XC) bintray

github:
	$(GO_XC) publish-github

clean:
	rm docker-volume-netshare-amd64
	rm docker-volume-netshare-arm64
	rm docker-volume-netshare_0.35_amd64.deb
	rm docker-volume-netshare_0.35_arm64.deb
