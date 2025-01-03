```sh
GOOS=linux GOARCH=arm64 go build -o tailscale.combined -tags ts_include_cli,ts_omit_aws,ts_omit_bird,ts_omit_tap,ts_omit_kube -ldflags="-s -w" ./cmd/tailscaled
```

- [https://tailscale.com/kb/1207/small-tailscale](https://tailscale.com/kb/1207/small-tailscale)
- [https://openwrt.org/docs/guide-user/services/vpn/tailscale/start](https://openwrt.org/docs/guide-user/services/vpn/tailscale/start)
