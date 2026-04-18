class Voidbox < Formula
  desc "Composable workflow sandbox with micro-VMs and native observability"
  homepage "https://github.com/the-void-ia/void-box"
  url "https://github.com/the-void-ia/void-box/releases/download/v0.2.0/voidbox-v0.2.0-darwin-aarch64.tar.gz"
  sha256 "9d34b6802d677ea26af41d9852526d8a771f7120a9d11ff53c168dd11a424348"
  license "Apache-2.0"
  version "0.2.0"

  depends_on :macos

  def install
    bin.install "voidbox"
    (lib/"voidbox").install "vmlinux"
    (lib/"voidbox").install "initramfs.cpio.gz"

    # Virtualization.framework requires this entitlement on the running process.
    entitlements = buildpath/"voidbox.entitlements"
    entitlements.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>com.apple.security.virtualization</key>
        <true/>
      </dict>
      </plist>
    XML
    system "/usr/bin/codesign", "--force", "--sign", "-", "--entitlements", entitlements, bin/"voidbox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voidbox version")
    assert_predicate lib/"voidbox/vmlinux", :exist?
    assert_predicate lib/"voidbox/initramfs.cpio.gz", :exist?
  end
end
