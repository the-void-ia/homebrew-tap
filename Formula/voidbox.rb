class Voidbox < Formula
  desc "Composable workflow sandbox with micro-VMs and native observability"
  homepage "https://github.com/the-void-ia/void-box"
  url "https://github.com/the-void-ia/void-box/releases/download/v0.1.2/voidbox-v0.1.2-darwin-aarch64.tar.gz"
  sha256 "decf029b30e0120d953fc9e5a6f1547f8c10452b14b2f5812298e45c7cc136e9"
  license "Apache-2.0"
  version "0.1.2"

  depends_on :macos

  def install
    bin.install "voidbox"
    (lib/"voidbox").install "vmlinux"
    (lib/"voidbox").install "initramfs.cpio.gz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voidbox version")
    assert_predicate lib/"voidbox/vmlinux", :exist?
    assert_predicate lib/"voidbox/initramfs.cpio.gz", :exist?
  end
end
