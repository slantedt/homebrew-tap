cask "sigla" do
  version "1.0.0"
  sha256 "328b1fc103a11f9690348ebaab6779c8b92317b332294e42cdc8794ac9593b33"

  url "https://github.com/slantedt/sigla/releases/download/v#{version}/Sigla.zip"
  name "Sigla"
  desc "Markdown reader"
  homepage "https://github.com/slantedt/sigla"

  depends_on macos: :sonoma

  app "Sigla.app"
  # The mdv CLI is embedded in the app bundle: slantedt/markdownviewer's
  # build-release cp's it into Contents/MacOS/mdv and deep-signs it, so the
  # app's notarization ticket covers it. Expose it on $PATH via `binary`
  # (no postflight curl). `sigla` and `mdview` are aliases of the same binary —
  # mdv dispatches on argv[0] and treats `mdview` as the deprecated name.
  #
  # Requires a release built WITH the embedded CLI (v1.0.1+). Do not ship this
  # with a release whose Sigla.app lacks Contents/MacOS/mdv.
  binary "#{appdir}/Sigla.app/Contents/MacOS/mdv"
  binary "#{appdir}/Sigla.app/Contents/MacOS/mdv", target: "sigla"
  binary "#{appdir}/Sigla.app/Contents/MacOS/mdv", target: "mdview"

  preflight do
    # Transitional cleanup. Sigla <= 1.0.0 shipped mdv (and the sigla/mdview
    # aliases) as real files curl'd by the old cask's postflight. The binary
    # stanzas above link those names from the app bundle, but Homebrew won't
    # clobber a pre-existing non-managed file — it would skip linking and leave
    # the stale 1.0.0 mdv on PATH (which then loads the updated frameworks and
    # can break). Remove any leftover that isn't already our bundle symlink so
    # the links take effect. Safe to remove once users are off Sigla <= 1.0.0.
    %w[mdv sigla mdview].each do |name|
      link = Pathname.new("#{HOMEBREW_PREFIX}/bin/#{name}")
      present = link.exist? || link.symlink?
      next unless present
      next if link.symlink? && link.readlink.to_s.include?("Sigla.app/Contents/MacOS/mdv")

      link.delete
    end
  end

  zap trash: "~/Library/Preferences/com.slantedt.sigla.plist"
end
