class Hubstaff < Formula
  desc "Token-efficient CLI for the Hubstaff Public API v2"
  homepage "https://github.com/NetsoftHoldings/hubstaff-cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.5.0/hubstaff-aarch64-apple-darwin.tar.xz"
      sha256 "3b26ad5a00d98cd03a25363d9d04103365ecbf0a7688a7fdfbcbdad5044ffc6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.5.0/hubstaff-x86_64-apple-darwin.tar.xz"
      sha256 "17d0c21c5a9f2b35595e030483294384aae217db985e19636117d75bd7047909"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.5.0/hubstaff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b14e3d0d612c1707cbf5335bbb0e86dab66c894e82f49d55ce12a05125a90b69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NetsoftHoldings/hubstaff-cli/releases/download/v0.5.0/hubstaff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a15cbba3289dc52cf161142c7798e82d6a65a620a79243dfe7f22a9a0be7fe2b"
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
