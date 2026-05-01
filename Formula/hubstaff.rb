class Hubstaff < Formula
  desc "Token-efficient CLI for the Hubstaff Public API v2"
  homepage "https://github.com/NetsoftHoldings/hubstaff-cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.4.0/hubstaff-aarch64-apple-darwin.tar.xz"
      sha256 "5122365e1986518cc6ecfdd7b89b3519e6e5da568c0b29f2779ab4ba36c0bfce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.4.0/hubstaff-x86_64-apple-darwin.tar.xz"
      sha256 "b68697505b2722a405e2df67d58b6fc9e07ceeb7d95f6e35add80b52720eb83d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.4.0/hubstaff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28ac228c536d4324f00f28d01d2ef01db7fd959bf5face633c82d83d520d27f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.4.0/hubstaff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cbc7a77d571095a8dd3ebeed70ccdfe7898d5733057cca806187c7f165f87236"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "hubstaff" if OS.mac? && Hardware::CPU.arm?
    bin.install "hubstaff" if OS.mac? && Hardware::CPU.intel?
    bin.install "hubstaff" if OS.linux? && Hardware::CPU.arm?
    bin.install "hubstaff" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
