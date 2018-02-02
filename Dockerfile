ARG IMAGENAME=binary_go
ARG GO_REPO_PATH=/go/src/github.com/VirgilSecurity/virgil-services-api-gateway

FROM virgilsecurity/virgil-crypto-go-env as builder

ARG CGO_ENABLED=0
ARG GOOS=linux
ARG EXTRA_LDFLAGS=""
ARG BUILD_TAGS=""
ARG GO_REPO_PATH
ARG IMAGENAME

WORKDIR $GO_REPO_PATH

COPY virgil-services-api-gateway .

RUN echo ">>> Start binary building..."
RUN echo ">>> Getting go modules" && go get -v -d ./...
#RUN echo ">>> Running unit tests" && go testls tests/...  --tags=unit
#RUN echo ">>> Running functional tests" && go test tests/...  --tags=functional
RUN echo ">>> Building binary" && CGO_ENABLED=$CGO_ENABLED GOOS=$GOOS go build -v -a --ldflags "$EXTRA_LDFLAGS" --tags "$BUILD_TAGS" -o $IMAGENAME src/restd/main.go


FROM alpine:latest

ARG GIT_COMMIT=unkown
ARG GIT_BRANCH=unkown
ARG GO_REPO_PATH
ARG IMAGENAME

LABEL git-commit=$GIT_COMMIT
LABEL git-branch=$GIT_BRANCH

RUN apk add --update --no-cache ca-certificates
RUN rm -rvf /var/cache/*

RUN echo "Copy ${GO_REPO_PATH}/${IMAGENAME} as run_go"
COPY --from=builder $GO_REPO_PATH/$IMAGENAME run_go
ENV PORT 8080
EXPOSE 8080
ENTRYPOINT ["/run_go"]