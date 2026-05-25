cask "sigla" do
  version "0.5.0"
  sha256 "41ae78ad120855cedae0e31192c81ecfd4722624d108fc05fcd60f05f2ef679a"

  url "https://github.com/slantedt/sigla/releases/download/v#{version}/Sigla.zip"
  name "Sigla"
  desc "Markdown reader for macOS"
  homepage "https://github.com/slantedt/sigla"

  depends_on macos: ">= :sonoma"

  app "Sigla.app"

  postflight do
    mdv_url = "https://github.com/slantedt/sigla/releases/download/v#{version}/mdv"
    mdv_path = "#{HOMEBREW_PREFIX}/bin/mdv"
    sigla_link = "#{HOMEBREW_PREFIX}/bin/sigla"
    mdview_link = "#{HOMEBREW_PREFIX}/bin/mdview"

    system_command "curl", args: ["-fsSL", "-o", mdv_path, mdv_url]
    system_command "chmod", args: ["+x", mdv_path]

    # Soft cut per cli.feature: one binary (mdv), two cask-installed symlinks.
    # The mdv binary detects argv[0] and prints a deprecation notice when
    # invoked as `mdview`.
    [sigla_link, mdview_link].each do |link|
      File.delete(link) if File.symlink?(link) || File.exist?(link)
    end
    File.symlink(mdv_path, sigla_link)
    File.symlink(mdv_path, mdview_link)

    # Re-register Sigla.app with LaunchServices so Spotlight, `open -a`, and
    # the Finder pick up this bundle rather than a stale prior install.
    system_command "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister",
                   args: ["-f", "/Applications/Sigla.app"]
  end

  uninstall_postflight do
    %w[mdv sigla mdview].each do |name|
      p = "#{HOMEBREW_PREFIX}/bin/#{name}"
      File.delete(p) if File.symlink?(p) || File.exist?(p)
    end
  end

  zap trash: [
    "~/Library/Preferences/com.slantedt.sigla.plist",
  ]
end
