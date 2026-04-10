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

  def post_install
    plugin_dir = Pathname.new(Dir.home)/"Library/Application Support/SwiftBar/Plugins"
    plugin_dir.mkpath

    # Clean old manager symlinks
    plugin_dir.children.select { |f| f.basename.to_s.start_with?("ai-manager.") }.each(&:delete)

    # Symlink manager plugin
    manager_src = libexec/"ai-manager.1h.py"
    manager_src.chmod(0755)
    (plugin_dir/"ai-manager.1h.py").make_symlink(manager_src)

    # Install SwiftBar if missing
    system "brew", "list", "--cask", "swiftbar" or
      system "brew", "install", "--cask", "swiftbar"

    # Configure and launch SwiftBar
    system "defaults", "write", "com.ameba.SwiftBar", "PluginDirectory", plugin_dir.to_s
    system "killall", "SwiftBar" if system("pgrep", "-q", "SwiftBar")
    sleep 1
    swiftbar_app = Dir["/opt/homebrew/Caskroom/swiftbar/*/SwiftBar.app",
                       "/Applications/SwiftBar.app"].first
    system "open", swiftbar_app if swiftbar_app
  end

  test do
    assert_match "ai-status-bar", shell_output("#{bin}/ai-status-bar help")
  end
end
