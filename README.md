# OpenWrt Smaller Binaries

This repository provides slimmed-down builds of popular tools like Tailscale and Mihomo (Clash Meta) optimized for OpenWrt devices with limited storage.

## How to use the artifacts

1. Download the `artifact.tar.gz` from the GitHub Actions build.
2. Extract the archive on your local machine:
   ```sh
   tar xzf artifact.tar.gz
   cd artifact/
   ```
3. Deploy the binaries to your OpenWrt device using the included script:
   ```sh
   # Usage: ./deploy.sh <user@host>
   ./deploy.sh root@192.168.1.1
   ```
   *Note: The script uses `mv -f` to replace binaries even if they are currently running ("Text file busy" workaround). You may need to restart the services for changes to take effect.*

## Manual Build Reference

If you wish to build the binaries manually:

```sh
# Example for Tailscale
GOOS=linux GOARCH=arm64 go build -o tailscale.combined -tags ts_include_cli,ts_omit_aws,ts_omit_bird,ts_omit_tap,ts_omit_kube -ldflags="-s -w" ./cmd/tailscaled
upx --lzma --best tailscale.combined
```

## References

- [Small Tailscale Builds](https://tailscale.com/kb/1207/small-tailscale)
- [OpenWrt Tailscale Guide](https://openwrt.org/docs/guide-user/services/vpn/tailscale/start)
- [OpenClash Releases](https://github.com/vernesong/OpenClash/releases)