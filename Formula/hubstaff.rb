class Hubstaff < Formula
  desc "Token-efficient CLI for the Hubstaff Public API v2"
  homepage "https://github.com/NetsoftHoldings/hubstaff-cli"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.3.1/hubstaff-aarch64-apple-darwin.tar.xz"
      sha256 "7eaa635ed17dd599d0110217e90f9e852da56cd016817f75471ac981ecfea3fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.3.1/hubstaff-x86_64-apple-darwin.tar.xz"
      sha256 "d1e30c8f19d8336539fca7322549fe2c8d51b0ae46c4fbf75b244474503db60d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.3.1/hubstaff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e56ce9ec8ecdcebf5f119830d644eb257dbf7eee86a52a6f592e78229e2b6b94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.3.1/hubstaff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84f8b7c5d0c380e68dd8a694b9525308b267eedd74aba02c18ba61cd75639873"
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
