cask "mddeck" do
  # `just release <v>` (run from the markdowndeck source repo) builds the signed
  # release and publishes MarkdownDeck.zip as an asset of the matching `v<version>`
  # release on the public dist repo slantedt/markdowndeck-dist, then `sed`s the
  # `version "…"` and `sha256 "…"` lines below to the real values. These are
  # quoted placeholders (not `:no_check`) so those sed substitutions match; until
  # the first release ships the url 404s, so the cask isn't installable yet.
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/slantedt/markdowndeck-dist/releases/download/v#{version}/MarkdownDeck.zip"
  name "MarkdownDeck"
  desc "Markdown-to-presentation viewer with PDF export"
  homepage "https://github.com/slantedt/markdowndeck-dist"

  depends_on macos: :sonoma

  app "MarkdownDeck.app"
  # The mddeck CLI is embedded inside the app bundle (see slantedt/markdowndeck
  # PR #8) so @executable_path/../Frameworks resolves to the bundled
  # MarkdownDeckKit.framework at runtime.
  binary "#{appdir}/MarkdownDeck.app/Contents/MacOS/mddeck"

  zap trash: "~/Library/Preferences/com.slantedt.markdowndeck.plist"
end
