class AiStatusBar < Formula
  desc "AI service usage in your macOS menu bar via SwiftBar"
  homepage "https://github.com/longbui99/AIStatusBar"
  url "https://github.com/longbui99/AIStatusBar.git", branch: "main"
  version "0.1.0"
  license "GPL-3.0-only"

  depends_on :macos
  depends_on "python@3"

  def install
    libexec.install "bin", "providers", "utils", "config.json", "ai-manager.1h.py"
    bin.install_symlink libexec/"bin/ai-status-bar"
  end

  def caveats
    <<~EOS
      To complete setup, run:
        ai-status-bar activate

      This installs SwiftBar (if needed) and adds the manager to your menu bar.
    EOS
  end

  test do
    assert_match "ai-status-bar", shell_output("#{bin}/ai-status-bar help")
  end
end
